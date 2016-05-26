//
//  AppState.h
//  AirAppStaff
//
//  Created by Daniel on 26/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppState : NSObject
+ (AppState *)sharedInstance;

@property (nonatomic) BOOL signedIn;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSURL *photoUrl;


@end
