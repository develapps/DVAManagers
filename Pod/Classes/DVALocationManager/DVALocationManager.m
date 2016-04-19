//
//  DVALocationManager.m
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import "DVALocationManager.h"

#pragma mark -
#pragma mark - Private Interface

@interface DVALocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong)   CLLocationManager       *locationManager;
@property (nonatomic, copy)     locationHandler         completionBlock;
@property (nonatomic, copy)     locationAuthHandler     authCompletionBlock;

@end

#pragma mark -
#pragma mark - Implementation

@implementation DVALocationManager
@synthesize completionBlock     = _completionBlock;
@synthesize authCompletionBlock = _authCompletionBlock;

#pragma mark -
#pragma mark - Initializers

+ (DVALocationManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static DVALocationManager *_sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [DVALocationManager  new];
    });
    
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate           = self;
        self.locationManager.desiredAccuracy    = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter     = kCLDistanceFilterNone;
    }
    return self;
}


#pragma mark -
#pragma mark - Setters

-(void)setDva_LocationAccurancy:(CLLocationAccuracy)dva_LocationAccurancy{
    self.locationManager.desiredAccuracy = dva_LocationAccurancy;
}

-(void)setDva_LocationDistance:(CLLocationDistance)dva_LocationDistance{
    self.locationManager.distanceFilter = dva_LocationDistance;
}

-(void)setCompletionBlock:(locationHandler)completionBlock{
    __weak typeof(self) this = self;
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];

    _completionBlock = ^(NSArray <CLLocation *> *validLocations,NSError*error){
        __weak typeof(this) strongSelf = this;
        if (strongSelf.debug) NSLog(@"-- %s -- \n Calling completion block with locations %@ and error %@",__PRETTY_FUNCTION__,validLocations,error);
        if (completionBlock) completionBlock(validLocations,error);
    };
}

-(void)setAuthCompletionBlock:(locationAuthHandler)authCompletionBlock{
    __weak typeof(self) this = self;
    _authCompletionBlock = ^(CLAuthorizationStatus status,NSError*error){
        __weak typeof(this) strongSelf = this;
        if (strongSelf.debug) NSLog(@"-- %s -- \n Calling auth block with authorization %i and error %@",__PRETTY_FUNCTION__,status,error);
        if (authCompletionBlock) authCompletionBlock(status,error);
    };
}


#pragma mark -
#pragma mark - Getters

-(CLLocation*)dva_lastLocation{
    return [self.locationManager location];
}

-(locationAuthHandler)authCompletionBlock{
    if (_authCompletionBlock) return _authCompletionBlock;
    return ^(CLAuthorizationStatus status,NSError*error){
        if (_debug) NSLog(@"-- %s -- \n No auth block set and tried to auth with authorization %i and error %@",__PRETTY_FUNCTION__,status,error);
    };
}

-(locationHandler)completionBlock{
    if (_completionBlock) return _completionBlock;
    return ^(NSArray <CLLocation * >*validLocations,NSError*error){
        if (_debug) NSLog(@"-- %s -- \n No completion block set and tried to execute with locations %@ and error %@",__PRETTY_FUNCTION__,validLocations,error);
    };
}


-(CLAuthorizationStatus)dva_LocationAuthType{
    if (!_dva_LocationAuthType) {
        return kCLAuthorizationStatusAuthorizedWhenInUse;
    }
    return _dva_LocationAuthType;
}

-(CLAuthorizationStatus)dva_currentAuthStatus{
    return [CLLocationManager authorizationStatus];
}

#pragma mark -
#pragma mark - Locations

- (void)dva_askForAuthorizationIfNeededWithAuthBlock:(locationAuthHandler)authBlock{
    self.authCompletionBlock = authBlock;
    if (![CLLocationManager locationServicesEnabled]) {
        self.authCompletionBlock(kCLAuthorizationStatusNotDetermined,[NSError dva_locationErrorWithType:DVALocationManagerErrorLocationDisabled]);
    }
    else{
        switch ([self dva_currentAuthStatus]) {
            case kCLAuthorizationStatusDenied:
            {
                self.authCompletionBlock(kCLAuthorizationStatusDenied,[NSError dva_locationErrorWithType:DVALocationManagerErrorLocationDenied]);
            }
                break;
            case kCLAuthorizationStatusRestricted:
            {
                self.authCompletionBlock(kCLAuthorizationStatusRestricted,[NSError dva_locationErrorWithType:DVALocationManagerErrorLocationRestricted]);
            }
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            {
                self.authCompletionBlock(kCLAuthorizationStatusAuthorizedAlways,nil);
            }
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            {
                self.authCompletionBlock(kCLAuthorizationStatusAuthorizedWhenInUse,nil);
            }
                break;

            case kCLAuthorizationStatusNotDetermined:
            {
                switch (self.dva_LocationAuthType) {
                    case kCLAuthorizationStatusAuthorizedAlways:
                        [self.locationManager requestAlwaysAuthorization];
                        break;
                    case kCLAuthorizationStatusAuthorizedWhenInUse:
                        [self.locationManager requestWhenInUseAuthorization];
                        break;
                        
                    default:
                        self.authCompletionBlock(kCLAuthorizationStatusNotDetermined,[NSError dva_locationErrorWithType:DVALocationManagerErrorAuthUnknown]);
                        break;
                }
            }
            default:
                break;
        }
    }
}


- (void)dva_requestLocation:(locationHandler)handler{
    self.completionBlock = handler;
    [self dva_askForAuthorizationIfNeededWithAuthBlock:^(CLAuthorizationStatus status, NSError *error) {
        if (error) { // Auth error
            self.completionBlock(nil,error);
        }
        else if ((self.dva_LocationAuthType==kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedAlways) ||
                 (self.dva_LocationAuthType==kCLAuthorizationStatusAuthorizedWhenInUse &&
                  (status != kCLAuthorizationStatusAuthorizedWhenInUse && status != kCLAuthorizationStatusAuthorizedAlways))
                 ) { // We could not authorize at our required type
            self.completionBlock(nil,[NSError dva_locationErrorWithType:DVALocationManagerErrorAuthBelowRequired
                                                        andData:@{kDVALocationManagerAuthStatusKey : @(status)}]);
        }
        else{ // Ok
            [self.locationManager requestLocation];
        }
    }];
}

- (void)dva_startUpdatingLocation:(locationHandler)handler {
    self.completionBlock = handler;
    [self dva_askForAuthorizationIfNeededWithAuthBlock:^(CLAuthorizationStatus status, NSError *error) {
        if (error) { // Auth error
            self.completionBlock(nil,error);
        }
        else if ((self.dva_LocationAuthType==kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedAlways) ||
                 (self.dva_LocationAuthType==kCLAuthorizationStatusAuthorizedWhenInUse && status != kCLAuthorizationStatusAuthorizedWhenInUse) ||
                 (self.dva_LocationAuthType==kCLAuthorizationStatusAuthorizedWhenInUse && status != kCLAuthorizationStatusAuthorizedAlways)
                 ) { // We could not authorize at our required type
            self.completionBlock(nil,[NSError dva_locationErrorWithType:DVALocationManagerErrorAuthBelowRequired
                                                        andData:@{kDVALocationManagerAuthStatusKey : @(status)}]);
        }
        else{ // Ok
            [self.locationManager startUpdatingLocation];
        }
    }];
}

- (void)dva_stopUpdatingLocation {
    self.completionBlock = nil;
    [self.locationManager stopUpdatingLocation];
}

-(void)dva_startRequestingSignificantLocationChanges:(locationHandler)handler{
    if (![CLLocationManager significantLocationChangeMonitoringAvailable]){
        handler(nil,[NSError dva_locationErrorWithType:DVALocationManagerErrorSignificantLocationChangesNotAvailable]);
        return;
    }
    self.completionBlock = handler;
    [self dva_askForAuthorizationIfNeededWithAuthBlock:^(CLAuthorizationStatus status, NSError *error) {
        if (error) { // Auth error
            self.completionBlock(nil,error);
        }
        else if (status < self.dva_LocationAuthType) { // We could not authorize at our required type
            self.completionBlock(nil,[NSError dva_locationErrorWithType:DVALocationManagerErrorAuthBelowRequired
                                                        andData:@{kDVALocationManagerAuthStatusKey : @(status)}]);
        }
        else{ // Ok
            [self.locationManager startMonitoringSignificantLocationChanges];
        }
    }];
}

-(void)dva_stopRequestingSignificantLocationChanges{
    self.completionBlock = nil;
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

#pragma mark -
#pragma mark - Helpers

-(CLLocationDistance)dva_currentLocationDistanceTo:(CLLocation *)location{
    return [self.dva_lastLocation distanceFromLocation:location];
}

#pragma mark -
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self dva_askForAuthorizationIfNeededWithAuthBlock:_authCompletionBlock];
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    self.completionBlock(locations,nil);
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    self.completionBlock(nil,error);
}

@end
