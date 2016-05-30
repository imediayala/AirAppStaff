//
//  UsersProfileViewController.m
//  AirAppStaff
//
//  Created by Daniel on 30/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "UsersProfileViewController.h"
@import Firebase;

@interface UsersProfileViewController ()


@end

@implementation UsersProfileViewController

@synthesize userLabel;
@synthesize emailLabel;
@synthesize passwordLabel;
@synthesize phoneLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //Get the currently signed-in user
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil) {
            // User is signed in.
            
                [self requestProfileInfo];
            
        } else {
            // No user is signed in.
        }
    }];
    
    [self requestProfileInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) requestProfileInfo{

    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil) {
        NSString *name = user.displayName;
        NSString *email = user.email;
        NSURL *photoUrl = user.photoURL;
        NSString *uid = user.uid;  // The user's ID, unique to the Firebase
        // project. Do NOT use this value to
        // authenticate with your backend server, if
        // you have one. Use
        // getTokenWithCompletion:completion: instead.
      
        self.emailLabel.text = email;
        self.userLabel.text = uid;
        
//        
//      self.lblCalories.text = [NSString stringWithFormat:@"%@", self.pickData[row]];
//        
        
    } else {
        // No user is signed in.
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
