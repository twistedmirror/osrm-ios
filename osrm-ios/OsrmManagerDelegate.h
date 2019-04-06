//
//  OsrmManagerDelegate.h
//  osrm-ios
//
//  Created by Gabriele Della Casa Venturelli on 09/04/2017.
//  Copyright © 2017 twistedmirror. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OsrmManagerDelegate <NSObject>

@optional

- (void)osrmManagerInitializedManager:(id)manager;

@end
