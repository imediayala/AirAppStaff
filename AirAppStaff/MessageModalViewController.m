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
    //Inialiating
    
    controller = [[FireBaseApi alloc] init];
    [controller setDelegate:self];
    
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
    
    
    if (_colorDefinedForPriority == nil) {
        NSString *none = @"sinPrioridad";
        _colorDefinedForPriority = none;
    }
    
    
    [controller sendPost:_solicitudTextField.text colorId:_colorDefinedForPriority];
    
  
    

    
//    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)solicitudResults:(BOOL)succeced{
    
    
    if (succeced == YES ) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Ha ocurrido un error" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }


}


- (IBAction)activatesPriorityGreenButton:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (!button.selected) {
//        button.backgroundColor = [UIColor greenColor];
        button.selected = YES;
        
       
        _colorDefinedForPriority = @"green";
        
        
        _priorityYellowButtonProperty.hidden = YES;
        _priorityRedButtonProperty.hidden = YES;
        
        
    }
    else{
//        button.backgroundColor = [UIColor grayColor];
        button.selected = NO;
        
        _priorityYellowButtonProperty.hidden = NO;
        _priorityRedButtonProperty.hidden = NO;
    }
    
    

}

- (IBAction)activatesPriorityYellowButton:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (!button.selected) {
        //        button.backgroundColor = [UIColor greenColor];
        button.selected = YES;
        
        _colorDefinedForPriority = @"yellow";
        
        _priorityGreenButtonProperty.hidden = YES;
        _priorityRedButtonProperty.hidden = YES;
        
    }
    else{
        //        button.backgroundColor = [UIColor grayColor];
        button.selected = NO;
        
        _priorityGreenButtonProperty.hidden = NO;
        _priorityRedButtonProperty.hidden = NO;
    }
    
    

    
    
}

- (IBAction)activatesPriorityRedButton:(id)sender {
    
    
    UIButton *button = (UIButton *)sender;
    if (!button.selected) {
        //        button.backgroundColor = [UIColor greenColor];
        button.selected = YES;
        

        _colorDefinedForPriority = @"red";
        
        _priorityYellowButtonProperty.hidden = YES;
        _priorityGreenButtonProperty.hidden = YES;
        
      
    }
    else{
        
        button.selected = NO;
        
        _priorityYellowButtonProperty.hidden = NO;
        _priorityGreenButtonProperty.hidden = NO;
        
     
        
    }
    
    
    

}
@end
