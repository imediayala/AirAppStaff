//
//  LoginAuthViewController.m
//  AirAppStaff
//
//  Created by Daniel on 17/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "LoginAuthViewController.h"
#import <Firebase/Firebase.h>
@import Firebase;
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

- (void)viewDidAppear:(BOOL)animated {
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user) {
//        [self signedIn:user];
    }
}

- (IBAction)signedIn:(id)sender {
    // Sign In with credentials.
    NSString *email = loginTextField.text;
    NSString *password = passwordTextField.text;
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             if (error) {
                                 NSLog(@"%@", error.localizedDescription);
                                 return;
                             }
                             
                             // Ejecuta delegado
                                                          AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                                                          appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                             
                              NSLog(@"Succed!");
//                             [self signedIn:user];
                         }];
}

- (IBAction)didTapSignUp:(id)sender {
    NSString *email = loginTextField.text;
    NSString *password = loginTextField.text;
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                 if (error) {
                                     NSLog(@"%@", error.localizedDescription);
                                     return;
                                 }
                                 [self setDisplayName:user];
                             }];
}

- (void)setDisplayName:(FIRUser *)user {
    FIRUserProfileChangeRequest *changeRequest =
    [user profileChangeRequest];
    // Use first part of email as the default display name
    changeRequest.displayName = [[user.email componentsSeparatedByString:@"@"] objectAtIndex:0];
    [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
//        [self signedIn:[FIRAuth auth].currentUser];
    }];
}

- (IBAction)didRequestPasswordReset:(id)sender {
    UIAlertController *prompt =
    [UIAlertController alertControllerWithTitle:nil
                                        message:@"Email:"
                                 preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *weakPrompt = prompt;
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   UIAlertController *strongPrompt = weakPrompt;
                                   NSString *userInput = strongPrompt.textFields[0].text;
                                   if (!userInput.length)
                                   {
                                       return;
                                   }
                                   [[FIRAuth auth] sendPasswordResetWithEmail:userInput
                                                                   completion:^(NSError * _Nullable error) {
                                                                       if (error) {
                                                                           NSLog(@"%@", error.localizedDescription);
                                                                           return;
                                                                       }
                                                                   }];
                                   
                               }];
    [prompt addTextFieldWithConfigurationHandler:nil];
    [prompt addAction:okAction];
    [self presentViewController:prompt animated:YES completion:nil];
}

//- (void)signedIn:(FIRUser *)user {
//    [MeasurementHelper sendLoginEvent];
//    
//    [AppState sharedInstance].displayName = user.displayName.length > 0 ? user.displayName : user.email;
//    [AppState sharedInstance].photoUrl = user.photoURL;
//    [AppState sharedInstance].signedIn = YES;
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationKeysSignedIn
//                                                        object:nil userInfo:nil];
//    [self performSegueWithIdentifier:SeguesSignInToFp sender:nil];
//}


//- (IBAction)sendLogin:(id)sender {
//    
//    
//    [[FIRAuth auth] signInWithEmail:loginTextField.text
//                           password:passwordTextField.text
//                         completion:^(FIRUser *user, NSError *error) {
//                             
//                             
//                             // ...
//                             // Ejecuta delegado
//                             AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
//                             appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
//                             
//                             NSLog(@"Succed!");
//                             
//                             }];
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//}
@end
