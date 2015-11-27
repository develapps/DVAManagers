//
//  DVALocationManager.h
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import <CoreLocation/CoreLocation.h>
#import "NSError+DVALocationManager.h"

typedef void (^locationHandler)(NSArray <CLLocation *> *validLocations,NSError*error);
typedef void (^locationAuthHandler)(CLAuthorizationStatus status,NSError*error);
typedef void (^locationDistanceHandler)(CGFloat distance,NSError*error);


#pragma mark -
#pragma mark - Public Interface

/**
 This class provides a generalized location manager. 
 
 For GPX track testing: http://www.gpsvisualizer.com/draw/
 
 @warning do not forget to include the NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription . Info: https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/LocationAwarenessPG/CoreLocation/CoreLocation.html
 
 
 @since 1.0.0
 */
@interface DVALocationManager : NSObject

#pragma mark -
#pragma mark - shared Instance and auth

/**
 A shared instance for the location services
 
 @return a location manager
 
 @since 1.0.0
 */
+ (DVALocationManager *)sharedInstance;
/**
 Asks for the authorization if needed. 
 
 If you start a location method this is automatically called.
 
 @param authBlock a block to be executed with the acquired autorization
 
 @see dva_LocationAuthType
 @since 1.0.0
 */
- (void)dva_askForAuthorizationIfNeededWithAuthBlock:(locationAuthHandler)authBlock;

#pragma mark -
#pragma mark - properties

@property (nonatomic) BOOL debug;

/**
 The location accurancy. Defaults to kCLLocationAccuracyHundredMeters
 
 @since 1.0.0
 */
@property (nonatomic) CLLocationAccuracy dva_LocationAccurancy;
/**
 The location minimum distance for continuous location updates. Defaults to kCLDistanceFilterNone (measure in meters)
 
 @since 1.0.0
 */
@property (nonatomic) CLLocationDistance dva_LocationDistance;

/**
 Required auth type for the app. Defaults to kCLAuthorizationStatusAuthorizedWhenInUse
 
 @since 1.0.0
 */
@property (nonatomic) CLAuthorizationStatus dva_LocationAuthType;
/*!
 @author Pablo Romeu, 15-11-27 10:11:31
 
 Current authorization status
 
 @since 1.0.0
 */
@property (nonatomic) CLAuthorizationStatus dva_currentAuthStatus;

#pragma mark -
#pragma mark - basic location methods

/**
 This method returns a location and stops updating location.
 
 @param handler a completion handler with the location or the error

 @since 1.0.0
 */
- (void)dva_requestLocation:(locationHandler)handler;
/**
 This method returns a location.
 
 @param handler a completion handler with the location or the error
 @warning You are responsible of stoping the location updates. The manager will keep updating locations
 @since 1.0.0
 */
- (void)dva_startUpdatingLocation:(locationHandler)handler;
/**
 Stops updating the location
 
 @since 1.0.0
 */
- (void)dva_stopUpdatingLocation;

#pragma mark -
#pragma mark - Helpers

/*!
 @author Pablo Romeu, 15-11-27 10:11:35
 
 Asks for current location and returns a distance to the provided one
 
 @param location the provided location
 @param distance the distance
 
 @since 1.0.0
 */
-(void)dva_currentLocationDistanceTo:(CLLocation*)location completion:(locationDistanceHandler)distance;
@end
