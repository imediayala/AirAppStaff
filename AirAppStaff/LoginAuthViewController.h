//
//  LoginAuthViewController.h
//  AirAppStaff
//
//  Created by Daniel on 17/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginAuthViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *loginTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)didTapSignedIn:(id)sender;

@end
