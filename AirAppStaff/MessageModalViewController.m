//
//  MessageModalViewController.m
//  AirAppStaff
//
//  Created by Daniel on 21/06/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "MessageModalViewController.h"
#import "FireBaseApi.h"

@interface MessageModalViewController ()

@end

// Create an object of type FireBaseApi

FireBaseApi * controller;

@implementation MessageModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Use the FireBaseApi object "controller" so i can tell him to delegates on this class
    
    [controller setDelegate:self];
    
    
    //Inialiating
    
    controller = [[FireBaseApi alloc]init];
    
    //Refer to methods declare on the Api
    
    //[controller getSignedInUser];
    NSString *userName = controller.getUserName;
    if (userName != nil) {
        [self.userNameLabel setText:userName];
    }
    
//    _userNameLabel.text = self controller
    
    
    
    
    
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

- (IBAction)dismissViewCancelButton:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendPost:(id)sender {
    
    [controller sendPost:_solicitudTextField.text];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)solicitudResults:(BOOL)succeced{
    
    
    if (succeced != NO ) {
        
        NSLog(@"succeded");
    }


}
@end
