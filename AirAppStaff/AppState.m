//
//  AppState.m
//  AirAppStaff
//
//  Created by Daniel on 26/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "AppState.h"

@implementation AppState

+ (AppState *)sharedInstance {
    static AppState *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    return sharedMyInstance;
}

@end
