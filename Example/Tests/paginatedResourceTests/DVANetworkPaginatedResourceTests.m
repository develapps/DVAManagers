//
//  DVAManagersTests.m
//  DVAManagersTests
//
//  Created by Pablo Romeu on 11/24/2015.
//  Copyright (c) 2015 Pablo Romeu. All rights reserved.
//

@import XCTest;
#import <DVANetworkTestStubs/XCTestCase+DVANetworkStub.h>
#import "TestsConstants.h"
#import <DVAManagers/DVANetworkPaginatedResource.h>

static NSString *const theUrl=@"http://www.google.es";
static NSString *const theEndPoint=@"/v1/fake";
static NSString *const theSecondPage=@"/v1/fake/?page=2";

@interface Tests : XCTestCase
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) DVANetworkPaginatedResource *paginatedResource;

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:theUrl] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    if (kStubsEnabled) [OHHTTPStubs removeAllStubs];
    [super tearDown];
}

- (void)testPagination
{
    if (kStubsEnabled) {
        NSDictionary *stubOptions = @{
                                 @(kDVANetworkStubConfiguratorValueDebug)       : @(kStubsEnabled),
                                 @(kDVANetworkStubConfiguratorValueEndpoint)    : theEndPoint,
                                 @(kDVANetworkStubConfiguratorValueType)        : @(kDVAStubGET),
                                 @(kDVANetworkStubConfiguratorValueJson)        : [DVANetworkStubConfigurator dva_readJsonFile:@"FirstPage"],

                                 };
        
        DVANetworkStubConfigurator *configurator = [DVANetworkStubConfigurator configuratorWithDictionary:stubOptions];
        NSDictionary *secondStubOptions = @{
                                      @(kDVANetworkStubConfiguratorValueDebug)       : @(kStubsEnabled),
                                      @(kDVANetworkStubConfiguratorValueEndpoint)    : theSecondPage,
                                      @(kDVANetworkStubConfiguratorValueType)        : @(kDVAStubGET),
                                      @(kDVANetworkStubConfiguratorValueJson)        : [DVANetworkStubConfigurator dva_readJsonFile:@"SecondPage"],
                                      
                                      };
        
        DVANetworkStubConfigurator *secondConfigurator = [DVANetworkStubConfigurator configuratorWithDictionary:secondStubOptions];
        [self dva_stubOperationWithOptionsArray:@[configurator,secondConfigurator]];

    }
    _paginatedResource = [[DVANetworkPaginatedResource alloc]  initWithApiProvider:self.manager
                                                                   itemsArrayBlock:^NSArray *(id jsonObject) {
                                                                       return jsonObject[@"results"];
                                                                   } itemsCountBlock:^NSInteger(id jsonObject) {
                                                                       return [jsonObject[@"count"] integerValue];

                                                                   } nextPageBlock:^NSString *(id jsonObject) {
                                                                       return jsonObject[@"next"];

                                                                   }];
    [_paginatedResource setNextURL:[theUrl stringByAppendingString:theEndPoint]];
    [_paginatedResource setDebug:YES];
    XCTestExpectation *expectation = [self expectationWithDescription:@"firstPage"];
    XCTestExpectation *secondExpectation = [self expectationWithDescription:@"secondPage"];

    [_paginatedResource nextBatch:^(BOOL fromCache, NSArray *items, NSInteger totalItemsCount, NSError *error) {
        XCTAssert([items count]==3,@"ERROR: Items count for first page should be 3 not %lu",(unsigned long)[items count]);
        XCTAssert(totalItemsCount==6,@"ERROR: Total count for first page should be 6 not %lu",(unsigned long)totalItemsCount);
        XCTAssert(error==nil,@"ERROR: This should not fail: %@",error);
        NSString *secondUrl =[theUrl stringByAppendingString:theSecondPage];
        XCTAssert([_paginatedResource.nextURL isEqualToString:secondUrl],@"ERROR: Next page should be %@ not %@",secondUrl,_paginatedResource.nextURL);
        [expectation fulfill];
        [_paginatedResource nextBatch:^(BOOL fromCache, NSArray *items, NSInteger totalItemsCount, NSError *error) {
            XCTAssert([items count]==3,@"ERROR: Items count for second page should be 3 not %lu",(unsigned long)[items count]);
            XCTAssert(totalItemsCount==6,@"ERROR: Total count for second page should be 6 not %lu",(unsigned long)totalItemsCount);
            XCTAssert(error==nil,@"ERROR: This should not fail: %@",error);
            XCTAssert([_paginatedResource.nextURL isEqual:[NSNull null]],@"ERROR: Next page should be NSNull not %@",_paginatedResource.nextURL);

            [secondExpectation fulfill];
        }];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

-(void)testPaginationWithCache{
    if (kStubsEnabled) {
        NSDictionary *stubOptions = @{
                                      @(kDVANetworkStubConfiguratorValueDebug)       : @(kStubsEnabled),
                                      @(kDVANetworkStubConfiguratorValueEndpoint)    : theEndPoint,
                                      @(kDVANetworkStubConfiguratorValueType)        : @(kDVAStubGET),
                                      @(kDVANetworkStubConfiguratorValueJson)        : [DVANetworkStubConfigurator dva_readJsonFile:@"FirstPage"],
                                      
                                      };
        
        DVANetworkStubConfigurator *configurator = [DVANetworkStubConfigurator configuratorWithDictionary:stubOptions];
        NSDictionary *secondStubOptions = @{
                                            @(kDVANetworkStubConfiguratorValueDebug)       : @(kStubsEnabled),
                                            @(kDVANetworkStubConfiguratorValueEndpoint)    : theSecondPage,
                                            @(kDVANetworkStubConfiguratorValueType)        : @(kDVAStubGET),
                                            @(kDVANetworkStubConfiguratorValueJson)        : [DVANetworkStubConfigurator dva_readJsonFile:@"SecondPage"],
                                            
                                            };
        
        DVANetworkStubConfigurator *secondConfigurator = [DVANetworkStubConfigurator configuratorWithDictionary:secondStubOptions];
        [self dva_stubOperationWithOptionsArray:@[configurator,secondConfigurator]];
        
    }
    _paginatedResource = [[DVANetworkPaginatedResource alloc]  initWithApiProvider:self.manager
                                                                   itemsArrayBlock:^NSArray *(id jsonObject) {
                                                                       return jsonObject[@"results"];
                                                                   } itemsCountBlock:^NSInteger(id jsonObject) {
                                                                       return [jsonObject[@"count"] integerValue];
                                                                       
                                                                   } nextPageBlock:^NSString *(id jsonObject) {
                                                                       return jsonObject[@"next"];
                                                                       
                                                                   }];
    [_paginatedResource setNextURL:[theUrl stringByAppendingString:theEndPoint]];
    [_paginatedResource setDebug:YES];
    [_paginatedResource setCache:[DVACache sharedInstance]];
    [[DVACache sharedInstance] removeAllDiskCachedData];
    [[DVACache sharedInstance] removeAllMemoryCachedData];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"firstPage"];
    XCTestExpectation *secondExpectation = [self expectationWithDescription:@"secondPage"];
    XCTestExpectation* thirdExpectation = [self expectationWithDescription:@"firstPageCached"];
    XCTestExpectation* fourthExpectation = [self expectationWithDescription:@"secondPageCached"];

    [_paginatedResource nextBatch:^(BOOL fromCache, NSArray *items, NSInteger totalItemsCount, NSError *error) {
        XCTAssert([items count]==3,@"ERROR: Items count for first page should be 3 not %lu",(unsigned long)[items count]);
        XCTAssert(totalItemsCount==6,@"ERROR: Total count for first page should be 6 not %lu",(unsigned long)totalItemsCount);
        XCTAssert(error==nil,@"ERROR: This should not fail: %@",error);
        XCTAssert(!fromCache,@"ERROR: This should not be cached: %i",fromCache);
        NSString *secondUrl =[theUrl stringByAppendingString:theSecondPage];
        XCTAssert([_paginatedResource.nextURL isEqualToString:secondUrl],@"ERROR: Next page should be %@ not %@",secondUrl,_paginatedResource.nextURL);
        [expectation fulfill];
        [_paginatedResource nextBatch:^(BOOL fromCache, NSArray *items, NSInteger totalItemsCount, NSError *error) {
            XCTAssert([items count]==3,@"ERROR: Items count for second page should be 3 not %lu",(unsigned long)[items count]);
            XCTAssert(totalItemsCount==6,@"ERROR: Total count for second page should be 6 not %lu",(unsigned long)totalItemsCount);
            XCTAssert(error==nil,@"ERROR: This should not fail: %@",error);
            XCTAssert([_paginatedResource.nextURL isEqual:[NSNull null]],@"ERROR: Next page should be NSNull not %@",_paginatedResource.nextURL);
            XCTAssert(!fromCache,@"ERROR: This should not be cached: %i",fromCache);
            
            [secondExpectation fulfill];
            
            _paginatedResource = [[DVANetworkPaginatedResource alloc]  initWithApiProvider:self.manager
                                                                           itemsArrayBlock:^NSArray *(id jsonObject) {
                                                                               return jsonObject[@"results"];
                                                                           } itemsCountBlock:^NSInteger(id jsonObject) {
                                                                               return [jsonObject[@"count"] integerValue];
                                                                               
                                                                           } nextPageBlock:^NSString *(id jsonObject) {
                                                                               return jsonObject[@"next"];
                                                                               
                                                                           }];
            [_paginatedResource setNextURL:[theUrl stringByAppendingString:theEndPoint]];
            [_paginatedResource setDebug:YES];
            [_paginatedResource setCache:[DVACache sharedInstance]];
            
            [_paginatedResource nextBatch:^(BOOL fromCache, NSArray *items, NSInteger totalItemsCount, NSError *error) {
                XCTAssert([items count]==3,@"ERROR: Items count for first page should be 3 not %lu",(unsigned long)[items count]);
                XCTAssert(totalItemsCount==6,@"ERROR: Total count for first page should be 6 not %lu",(unsigned long)totalItemsCount);
                XCTAssert(error==nil,@"ERROR: This should not fail: %@",error);
                NSString *secondUrl =[theUrl stringByAppendingString:theSecondPage];
                XCTAssert([_paginatedResource.nextURL isEqualToString:secondUrl],@"ERROR: Next page should be %@ not %@",secondUrl,_paginatedResource.nextURL);
                XCTAssert(fromCache,@"ERROR: This should be cached: %i",fromCache);
                [thirdExpectation fulfill];
                [_paginatedResource nextBatch:^(BOOL fromCache, NSArray *items, NSInteger totalItemsCount, NSError *error) {
                    XCTAssert([items count]==3,@"ERROR: Items count for second page should be 3 not %lu",(unsigned long)[items count]);
                    XCTAssert(totalItemsCount==6,@"ERROR: Total count for second page should be 6 not %lu",(unsigned long)totalItemsCount);
                    XCTAssert(error==nil,@"ERROR: This should not fail: %@",error);
                    XCTAssert([_paginatedResource.nextURL isEqual:[NSNull null]],@"ERROR: Next page should be NSNull not %@",_paginatedResource.nextURL);
                    XCTAssert(fromCache,@"ERROR: This should be cached: %i",fromCache);
                    
                    [fourthExpectation fulfill];
                }];
            }];
        }];
    }];
    
    
    
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}


@end

