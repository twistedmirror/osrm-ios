//
//  OsrmManager.m
//  osrm-ios
//
//  Created by Gabriele Della Casa Venturelli on 09/04/2017.
//  Copyright © 2017 twistedmirror. All rights reserved.
//

#import "OsrmManager.h"
#import "NSDictionary+SingleLegRoute.h"

#include <osrm/route_parameters.hpp>
#include <osrm/engine_config.hpp>
#include <osrm/json_container.hpp>
#include <osrm/osrm.hpp>

#include "json-string-converter.h"

static NSMutableDictionary<NSString*, OsrmManager*>* managers;

@interface OsrmManager ()

@property(nonatomic) NSMutableArray<id<OsrmManagerDelegate>>* delegates;

@end

@implementation OsrmManager
{
    osrm::OSRM* engine;
}

+ (void)initialize {
    managers = [[NSMutableDictionary alloc] init];
}

+ (OsrmManager*)managerForMapData:(NSString*)filename {
    OsrmManager* manager = [managers objectForKey:filename];
    if (manager == nil) {
        manager = [[self alloc] init];
        
        std::string utf8_string = [filename UTF8String];
        
        osrm::EngineConfig config;
        config.algorithm = osrm::EngineConfig::Algorithm::MLD;
        config.storage_config = {utf8_string};
        config.use_shared_memory = false;
        
        manager->engine = new osrm::OSRM{config};
        [managers setObject:manager forKey:filename];
    }
    return manager;
}

+ (void)requestManagerForMapData:(NSString*)filename callbackHandler:(void(^)(OsrmManager* manager))handler {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OsrmManager* manager = [OsrmManager managerForMapData:filename];
        
        if (handler != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(manager);
            });
        }
    });
}

+ (void)requestManagerForMapData:(NSString*)filename delegate:(id<OsrmManagerDelegate>)delegate {
    
    typeof(delegate) __weak weakDelegate = delegate;
    
    [OsrmManager requestManagerForMapData:filename callbackHandler:^(OsrmManager *manager) {
        // Check if weak reference is still valid
        if (weakDelegate) {
            [manager addDelegate:weakDelegate];
            if ([weakDelegate respondsToSelector:@selector(osrmManagerInitializedManager:)]) {
                [weakDelegate osrmManagerInitializedManager:manager];
            }
        }
    }];
}

#pragma mark - Routing

- (NSDictionary*)getPathForWaypoints:(NSArray<OsrmWaypoint*>*)waypoints {
    // Route, Table, Nearest, Trip, Match

    osrm::RouteParameters params;
    params.steps = true;
    
    params.coordinates.reserve(waypoints.count);
    //params.radiuses.reserve(waypoints.count);
    params.bearings.reserve(waypoints.count);
    
    for (OsrmWaypoint* waypoint in waypoints) {
        double latitude = waypoint.location.latitude;
        double longitude = waypoint.location.longitude;
        double bearing = waypoint.heading;
        int bearingRange = waypoint.headingAccuracy;
        //double radius = waypoint.locationAccuracy;
        
        params.coordinates.push_back({osrm::util::FloatLongitude{longitude}, osrm::util::FloatLatitude{latitude}});
        
        /*if (radius > 0) {
            params.radiuses.push_back(radius);
        } else {
            params.radiuses.push_back(boost::none);
        }*/
        
        if (bearing > 0) {
            osrm::engine::Bearing osrmBearing;
            osrmBearing.bearing = (short)bearing;
            osrmBearing.range = (short)bearingRange;
            params.bearings.push_back(osrmBearing);
        } else {
            params.bearings.push_back(boost::none);
        }
    }
    
    params.overview = osrm::engine::api::RouteParameters::OverviewType::Full;
    
    osrm::json::Object result;
    engine->Route(params, result);
    
    std::string stringJson;
    osrm::util::json::convert(stringJson, result);
    
    NSString* dataString = [NSString stringWithCString:stringJson.c_str() encoding:NSUTF8StringEncoding];
    NSData* data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error != nil) {
        NSLog(@"Error in parsing osrm result.");
        return nil;
    }
    
    return jsonData;
}

- (NSDictionary*)getShortestPathFromWaypoint:(OsrmWaypoint*)start toPossibleDestinations:(NSArray<OsrmWaypoint*>*)destinations {
    
    NSDictionary* bestResult = nil;
    NSNumber* shortestDuration = nil;
    
    for (OsrmWaypoint* destination in destinations) {
        NSDictionary* result = [self getPathForWaypoints:@[start, destination]];
        
        if (!result[@"routes"] || ((NSArray*)result[@"routes"]).count == 0 || !result[@"routes"][0][@"duration"]) {
            continue;
        }
        
        NSNumber* duration = result[@"routes"][0][@"duration"];
        if (shortestDuration == nil || duration < shortestDuration) {
            bestResult = result;
            shortestDuration = duration;
        }
    }
    
    return bestResult;
}

#pragma mark - Delegate Management

- (void)addDelegate:(id<OsrmManagerDelegate>)delegate {
    [self.delegates addObject:delegate];
}

- (void)removeDelegate:(id<OsrmManagerDelegate>)delegate {
    [self.delegates removeObject:delegate];
}

@end
