//
//  LoginAuthViewController.m
//  AirAppStaff
//
//  Created by Daniel on 17/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "LoginAuthViewController.h"
#import <Firebase/Firebase.h>
#import "AppDelegate.h"



@interface LoginAuthViewController ()

@end

@implementation LoginAuthViewController

@synthesize loginTextField;
@synthesize passwordTextField;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)listenForChanges{

    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://airappstaff.firebaseio.com"];
    
    [ref observeAuthEventWithBlock:^(FAuthData *authData) {
        if (authData) {
            // user authenticated
            NSLog(@"%@", authData);
        } else {
            // No user is signed in
        }
    }];


}

-(void)userAuthState{
    
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://<YOUR-FIREBASE-APP>.firebaseio.com"];
    
    if (ref.authData) {
        // user authenticated
        NSLog(@"%@", ref.authData);
    } else {
        // No user is signed in
    }




}







- (IBAction)sendLogin:(id)sender {
    
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://airappstaff.firebaseio.com"];

    
    [ref authUser:loginTextField.text password:passwordTextField.text
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    
    if (error) {
        
        NSLog(@"Error, Error, Error");
        // an error occurred while attempting login
    } else {
        
//        NSDictionary *newUser = @{
//                                  @"provider": authData.provider,
//                                  @"displayName": authData.providerData[@"displayName"]
//                                  };
//
//        
//        [[[ref childByAppendingPath:@"users"]
//          childByAppendingPath:authData.uid] setValue:newUser];
        
          NSLog(@"Succed, Succed, Succed");
        // user is logged in, check authData for data
        
       

        
        
        
        // Ejecuta delegado
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    }
}];
    
    
}
@end
