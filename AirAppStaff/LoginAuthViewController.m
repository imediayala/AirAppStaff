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




- (IBAction)sendLogin:(id)sender {
    
    
    [[FIRAuth auth] signInWithEmail:loginTextField.text
                           password:passwordTextField.text
                         completion:^(FIRUser *user, NSError *error) {
                             
                             
                             // ...
                             // Ejecuta delegado
                             AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                             appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                             
                             NSLog(@"Succed!");
                             
                             }];
    
    
    
    
    
    
    
    
    
    
}
@end
