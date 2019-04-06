//
//  NSDictionary+SingleLegRoute.m
//  pagani
//
//  Created by Gabriele Della Casa Venturelli on 15/04/2017.
//  Copyright © 2017 twistedmirror. All rights reserved.
//

#import "NSDictionary+SingleLegRoute.h"

@implementation NSDictionary (SingleLegRoute)

+ (NSDictionary*)routeJSONWithMergedLegs:(NSDictionary*)routeJSON {
    NSMutableDictionary* jsonData = [routeJSON mutableCopy];
    
    NSMutableDictionary* routeRaw = [jsonData[@"routes"][0] mutableCopy];
    NSArray* waypointsRaw = jsonData[@"waypoints"];
    
    NSMutableDictionary* firstLeg = [routeRaw[@"legs"][0] mutableCopy];
    float firstDistance = [firstLeg[@"distance"] doubleValue];
    float firstDuration = [firstLeg[@"duration"] doubleValue];
    NSMutableArray* firstSteps = [firstLeg[@"steps"] mutableCopy];
    NSString* firstSummary = firstLeg[@"summary"];
    
    // Merge legs
    NSArray* legs = routeRaw[@"legs"];
    
    // Set last step as not arriveif multiple legs
    if (legs.count > 1) {
        [firstSteps removeLastObject];
    }
    
    for (int i=1; i<legs.count; ++i) {
        NSDictionary* leg = legs[i];
        float distance = [leg[@"distance"] doubleValue];
        float duration = [leg[@"duration"] doubleValue];
        NSMutableArray* steps = [leg[@"steps"] mutableCopy];
        NSString* summary = leg[@"summary"];
        
        NSMutableDictionary* firstStep = [steps[0] mutableCopy];
        firstStep[@"type"] = @"continue";
        steps[0] = firstStep;
        
        // If not the last one
        if (i < legs.count-1) {
            [steps removeLastObject];
        }
        
        firstDistance += distance;
        firstDuration += duration;
        [firstSteps addObjectsFromArray:steps];
        firstSummary = [NSString stringWithFormat:@"%@, %@", firstSummary, summary];
    }
    
    firstLeg[@"distance"] = [NSNumber numberWithDouble:firstDistance];
    firstLeg[@"duration"] = [NSNumber numberWithDouble:firstDuration];
    firstLeg[@"steps"] = firstSteps;
    firstLeg[@"summary"] = firstSummary;
    
    routeRaw[@"legs"] = @[firstLeg];
    
    waypointsRaw = @[waypointsRaw[0], waypointsRaw[waypointsRaw.count-1]];
    
    jsonData[@"routes"] = @[routeRaw];
    jsonData[@"waypoints"] = waypointsRaw;
    
    return jsonData;
}

@end
