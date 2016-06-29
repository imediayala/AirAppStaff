//
//  ComposeMessage.m
//  AirAppStaff
//
//  Created by Daniel on 21/06/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "FireBaseApi.h"
#import "User.h"
@import Firebase;

@implementation FireBaseApi

//-(void)getSignedInUser{
//    
//
//    
//    // Reference for FiDataBase
//    
//    _ref = [[FIRDatabase database] reference];
//    
//    _postRef = [_ref child:@"posts"];
//
//    
//    
//    //Get the currently signed-in user
//    
//    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
//                                                    FIRUser *_Nullable user) {
//        if (user != nil) {
//            // User is signed in.
//            
//            NSLog(@"Yeiii");
//            
//            [self callUser];
//            
//        } else {
//            // No user is signed in.
//            
//            NSLog(@"Not Loged In");
//
//        }
//    }];
//    
//
//}




//-(void)callUser{
//    
//    
//    
//    FIRUser *user = [FIRAuth auth].currentUser;
//    
//    if (user != nil) {
//        NSString *name = user.displayName;
//        NSString *email = user.email;
//    
//        
////        NSString *uid = user.uid;  // The user's ID, unique to the Firebase
////     
////        
////        self.emailLabel.text = email;
////        self.userLabel.text = name;
// 
//        
//    } else {
//        // No user is signed in.
//    }
//    
//}

-(NSString *) getUserName {
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user != nil) {
        return user.displayName;
    } else {
        return nil;
    }
}
//
- (void)writeNewPost:(NSString *)userID username:(NSString *)username body:(NSString *)body color:(NSString*) color{
    // Create new post at /user-posts/$userid/$postid and at
    // /posts/$postid simultaneously
    // [START write_fan_out]
    NSString *key = [[_ref child:@"posts"] childByAutoId].key;
    NSDictionary *post = @{@"uid": userID,
                           @"author": username,
                           @"body": body,
                           @"color": color};
    
    
    
    NSDictionary *childUpdates = @{[@"/posts/" stringByAppendingString:key]: post,
                                   [NSString stringWithFormat:@"/user-posts/%@/%@/", userID, key]: post};
    //[_ref updateChildValues:childUpdates];
    
    [_ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if ([self delegate] != nil) {
            [[self delegate] solicitudResults:error == nil];
        }

    }];


//    // [END write_fan_out]
    
}



-(void)sendPost:(NSString *)msg colorId:(NSString *)color{
    
    // Reference for FiDataBase
    
    _ref = [[FIRDatabase database] reference];
    
    _postRef = [_ref child:@"posts"];
    

    
    // [START single_value_read]
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[_ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        User *user = [[User alloc] initWithUsername:snapshot.value[@"username"]];
        
        
        
        [self writeNewPost:userID
                  username:user.username
                  
                      body:msg
                     color:color];
        
    }];
    

    
    
}




@end
