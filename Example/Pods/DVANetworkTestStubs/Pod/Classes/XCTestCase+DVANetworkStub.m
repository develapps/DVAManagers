//
//  XCTestCase+DVANetworkStub.m
//  AquaService
//
//  Created by Pablo Romeu on 11/6/15.
//  Copyright (c) 2015 Develapps. All rights reserved.
//

#import "XCTestCase+DVANetworkStub.h"


@implementation DVANetworkStubConfigurator

+(instancetype)configuratorWithDictionary:(NSDictionary *)dictionary{
    return [[DVANetworkStubConfigurator alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self) {
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            if (dictionary[@(kDVANetworkStubConfiguratorValueEndpoint)])
                _endpoint       = dictionary[@(kDVANetworkStubConfiguratorValueEndpoint)];
            if (dictionary[@(kDVANetworkStubConfiguratorValueStatuscode)])
                _statusCode     = [dictionary[@(kDVANetworkStubConfiguratorValueStatuscode)] unsignedIntegerValue];
            if (dictionary[@(kDVANetworkStubConfiguratorValueType)])
                _type           = [dictionary[@(kDVANetworkStubConfiguratorValueType)] unsignedIntegerValue];
            if (dictionary[@(kDVANetworkStubConfiguratorValueHeaders)])
                _headers        = dictionary[@(kDVANetworkStubConfiguratorValueHeaders)];
            if (dictionary[@(kDVANetworkStubConfiguratorValueRequestTime)])
                _requestTime    = [dictionary[@(kDVANetworkStubConfiguratorValueRequestTime)] doubleValue];
            if (dictionary[@(kDVANetworkStubConfiguratorValueResponseTime)])
                _responseTime   = [dictionary[@(kDVANetworkStubConfiguratorValueResponseTime)] doubleValue];
            if (dictionary[@(kDVANetworkStubConfiguratorValueJson)])
                _json           = dictionary[@(kDVANetworkStubConfiguratorValueJson)];
            if (dictionary[@(kDVANetworkStubConfiguratorValueReadFile)])
                _json           = [DVANetworkStubConfigurator dva_readJsonFile:dictionary[@(kDVANetworkStubConfiguratorValueReadFile)]];
            if (dictionary[@(kDVANetworkStubConfiguratorValueDebug)])
                _debug          = [dictionary[@(kDVANetworkStubConfiguratorValueDebug)] boolValue];

        }
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _statusCode     =   kDVAStubCodeOk;
        _type           =   kDVAStubGET;
        _headers        =   @{@"Content-Type":@"application/json"};
        _requestTime    =   0;
        _responseTime   =   OHHTTPStubsDownloadSpeedWifi;
        _json           =   @"{}";
        _debug          =   YES;
    }
    return self;
}

#pragma mark - utils

+(id)dva_readJsonFile:(NSString*)json inBundle:(NSBundle*)bundle{
    NSString *filePath = [bundle pathForResource:json ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    NSAssert(myJSON,@"ERROR: No JSON FILE %@.json",json);
    return [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];}

+(id)dva_readJsonFile:(NSString*)json{
    return [DVANetworkStubConfigurator dva_readJsonFile:json inBundle:[NSBundle mainBundle]];
}

@end


@implementation XCTestCase (DVANetworkStub)

#pragma mark - UTILS

-(NSString*)httpOp:(DVAStubOp)operation{
    switch (operation) {
        case kDVAStubGET:
            return @"GET";
            break;
        case kDVAStubPOST:
            return @"POST";
            break;
        case kDVAStubPUT:
            return @"PUT";
            break;
        case kDVAStubPOST_MULTIPART:
            return @"POST_MULTIPART";
        default:
            return nil;
            break;
    }
    return nil;
}

#pragma stubbing

-(id <OHHTTPStubsDescriptor>)stubEndpoint:(NSString*)endpoint
                                   withOp:(DVAStubOp)operation
                         withResponseJson:(id)responseJson
                            andStatusCode:(int)statusCode
                               andHeaders:(NSDictionary*)headers
                           andRequestTime:(NSTimeInterval)requestTime
                          andResponseTime:(NSTimeInterval)responseTime
{
    if ([endpoint length]>0) {
        NSURL*endpointUrl=[[[AFHTTPSessionManager manager] baseURL] URLByAppendingPathComponent:endpoint];
        NSString*stringEndPoint= [NSString stringWithFormat:@"%@",endpointUrl];
        
        if ([stringEndPoint  length]>0) {
            
            id <OHHTTPStubsDescriptor> stub=[OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {

                BOOL stub = NO;
                if ([request.HTTPMethod isEqualToString:[self httpOp:operation]]) {
                    NSString    *queryString=[request.URL absoluteString];
                    stub    =   [queryString rangeOfString:endpoint].location!=NSNotFound;
                }
                NSLog(@"TEST STUB: TESTING IF STUB REQUEST %@, result %i",request,stub);
                return stub;
                
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                // Stub it with our "responseFile.json" stub file
                OHHTTPStubsResponse*response=[OHHTTPStubsResponse responseWithJSONObject:responseJson
                                                                              statusCode:statusCode
                                                                                 headers:headers ];
                return [response requestTime:requestTime
                                responseTime:responseTime];
            }];
            
            stub.name=endpoint;
            return stub;
        }
        
    }
    return nil;
}

#pragma convenience methods

-(void)dva_stubOperationWithOptions:(DVANetworkStubConfigurator *)configuration{
    if (!configuration) configuration = [DVANetworkStubConfigurator new];
    [self dva_stubOperationWithOptionsArray:@[configuration]];
}

-(void)dva_stubOperationWithOptionsArray:(NSArray *)configurations{
    for (DVANetworkStubConfigurator*configurator in configurations) {
        id <OHHTTPStubsDescriptor> stub = [self dva_stubbingWithConfiguration:configurator];
        if (!stub) {
            XCTFail(@"TEST STUB: COULD NOT STUB OP %@ with %@",configurator.endpoint,configurator.json);
            return;
        }
        else{
            if (configurator.debug) NSLog(@"\r----\rTEST STUB: Added stub %@ for \r -op %@:%@\r -json %@\r -code %lu:%@ \r -headers %@ \r----\r",stub.name,configurator.endpoint,[self httpOp:configurator.type],configurator.json,(unsigned long)configurator.statusCode,[NSHTTPURLResponse localizedStringForStatusCode:configurator.statusCode],configurator.headers);
        }
    }
}

#pragma full stubbing Network


-(id<OHHTTPStubsDescriptor>)dva_stubbingWithConfiguration:(DVANetworkStubConfigurator*)configuration{
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        if (configuration.debug) NSLog(@"\r----\rTEST STUB:%@ stubbed by %@.\r----\r", request.URL, stub.name);
    }];
    
    id <OHHTTPStubsDescriptor>stub=[self stubEndpoint:configuration.endpoint
                                               withOp:configuration.type
                                     withResponseJson:configuration.json
                                        andStatusCode:configuration.statusCode
                                           andHeaders:configuration.headers
                                       andRequestTime:configuration.requestTime
                                      andResponseTime:configuration.responseTime];
    return stub;
}


@end
