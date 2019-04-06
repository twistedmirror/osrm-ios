//
//  TMWaypoint.h
//  osrm-ios
//
//  Created by Gabriele Della Casa Venturelli on 10/04/2017.
//  Copyright © 2017 twistedmirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface OsrmWaypoint : NSObject

@property CLLocationCoordinate2D location;
@property CLLocationAccuracy locationAccuracy;
@property CLLocationDirection heading;
@property CLLocationDirection headingAccuracy;

- (instancetype) initWithLocation:(CLLocation*)location;

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D)coordinate;

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D)coordinate
                           accuracy:(CLLocationAccuracy)accuracy
                            heading:(CLLocationDirection)heading;

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D)coordinate
                           accuracy:(CLLocationAccuracy)accuracy
                            heading:(CLLocationDirection)heading
                    headingAccuracy:(CLLocationDirection)headingAccuracy;

@end
