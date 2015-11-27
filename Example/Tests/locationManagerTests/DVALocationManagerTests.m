//
//  DVALocationManagerTests.m
//  DVAManagers
//
//  Created by Pablo Maria Romeu Guallart on 26/11/15.
//  Copyright © 2015 Pablo Romeu. All rights reserved.
//

@import XCTest;
#import <DVAManagers/DVALocationManager.h>

@interface DVALocationManagerTests : XCTestCase
@property (nonatomic,strong) DVALocationManager *manager;
@end

@implementation DVALocationManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _manager = [[DVALocationManager alloc] init];
    _manager.debug = YES;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBasicLocation {
    XCTestExpectation *location = [self expectationWithDescription:@"location"];
    [self.manager dva_requestLocation:^(NSArray<CLLocation *> *validLocations, NSError *error) {
        XCTAssert(!error, @"ERROR: Call failed: %@",error);
        XCTAssert([validLocations count]==1,@"ERROR: validLocations should contain 1 result, contains: %@",validLocations);
        XCTAssert([[validLocations firstObject] isKindOfClass:[CLLocation class]],@"ERROR: validLocations does not contain a valid location");
        [location fulfill];
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
