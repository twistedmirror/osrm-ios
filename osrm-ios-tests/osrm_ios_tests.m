//
//  osrm_ios_tests.m
//  osrm-ios-tests
//
//  Created by hardsetting on 02/07/2018.
//  Copyright © 2018 twistedmirror. All rights reserved.
//

@import Osrm;

#import <XCTest/XCTest.h>

@interface osrm_ios_tests : XCTestCase

@property OsrmManager* _manager;

@end

@implementation osrm_ios_tests

- (void)setUp {
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString* mapPath = [bundle pathForResource:@"sassuolo/sassuolo" ofType:@"osrm"];

    BOOL mapFilesExists = [[NSFileManager defaultManager] fileExistsAtPath:mapPath];
    XCTAssertTrue(mapFilesExists);
    
    self._manager = [OsrmManager managerForMapData:mapPath];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testNavigation {
    NSArray<OsrmWaypoint*>* waypoints = @[
                                        [[OsrmWaypoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(44.654061, 10.906722)],
                                        [[OsrmWaypoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(44.661341, 10.922864)]
                                        ];
    
    NSDictionary* path = [self._manager getPathForWaypoints:waypoints];
    
    XCTAssert([path[@"code"] isEqualToString:@"Ok"]);
    XCTAssertNotNil(path[@"waypoints"]);
    XCTAssertEqual([path[@"waypoints"] count], 2);
    
    NSDictionary* singleLegPath = [NSDictionary routeJSONWithMergedLegs:path];
    
    XCTAssertNotNil(singleLegPath);
}

@end
