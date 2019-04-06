//
//  OsrmManager.h
//  osrm-ios
//
//  Created by Gabriele Della Casa Venturelli on 09/04/2017.
//  Copyright © 2017 twistedmirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OsrmManagerDelegate.h"
#import "OsrmWaypoint.h"

@interface OsrmManager : NSObject

+ (OsrmManager*)managerForMapData:(NSString*)filename;
+ (void)requestManagerForMapData:(NSString*)filename delegate:(id)delegate;
+ (void)requestManagerForMapData:(NSString*)filename callbackHandler:(void(^)(OsrmManager* manager))handler;

- (NSDictionary*)getPathForWaypoints:(NSArray<OsrmWaypoint*>*)waypoints;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

@end
