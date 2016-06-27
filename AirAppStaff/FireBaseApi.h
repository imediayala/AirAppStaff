//
//  ComposeMessage.h
//  AirAppStaff
//
//  Created by Daniel on 21/06/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;



// Protocol Name

@protocol FireBaseApiDelegate;


// Creating protocol delegate

@interface FireBaseApi : NSObject

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRDatabaseReference *postRef;


@property (nonatomic, weak) id <FireBaseApiDelegate> delegate;

-(NSString *) getUserName;
//
//-(void) getSignedInUser;
//
//-(void) callUser;
//
-(void)sendPost:(NSString *)msg colorId:(NSString*)color;




@end

// Protocol Declaration

@protocol FireBaseApiDelegate

-(void) solicitudResults: (BOOL) succeced;



@end
