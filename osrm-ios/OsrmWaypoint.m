//
//  TMWaypoint.m
//  osrm-ios
//
//  Created by Gabriele Della Casa Venturelli on 10/04/2017.
//  Copyright © 2017 twistedmirror. All rights reserved.
//

#import "OsrmWaypoint.h"

@implementation OsrmWaypoint

- (instancetype) initWithLocation:(CLLocation*)location {
    self = [super init];
    
    self.location = location.coordinate;
    self.locationAccuracy = location.horizontalAccuracy;
    self.heading = location.course;
    self.headingAccuracy = 45;
    
    return self;
}

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    
    self.location = coordinate;
    self.locationAccuracy = -1;
    self.heading = -1;
    self.headingAccuracy = 45;
    
    return self;
}

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D)coordinate
                           accuracy:(CLLocationAccuracy)accuracy
                            heading:(CLLocationDirection)heading {
    
    self = [super init];
    
    self.location = coordinate;
    self.locationAccuracy = accuracy;
    self.heading = heading;
    self.headingAccuracy = 45;
    
    return self;
}

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D)coordinate
                           accuracy:(CLLocationAccuracy)accuracy
                            heading:(CLLocationDirection)heading
                    headingAccuracy:(CLLocationDirection)headingAccuracy {
    
    self = [super init];
    
    self.location = coordinate;
    self.locationAccuracy = accuracy;
    self.heading = heading;
    self.headingAccuracy = headingAccuracy;
    
    return self;
}

@end
