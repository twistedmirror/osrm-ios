//
//  NSDictionary+SingleLegRoute.h
//  pagani
//
//  Created by Gabriele Della Casa Venturelli on 15/04/2017.
//  Copyright © 2017 twistedmirror. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SingleLegRoute)

+ (NSDictionary*)routeJSONWithMergedLegs:(NSDictionary*)routeJSON;

@end
