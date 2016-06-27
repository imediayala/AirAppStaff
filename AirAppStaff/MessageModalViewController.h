//
//  MessageModalViewController.h
//  AirAppStaff
//
//  Created by Daniel on 21/06/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FireBaseApi.h"

@interface MessageModalViewController : UIViewController<FireBaseApiDelegate>
- (IBAction)dismissViewCancelButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
- (IBAction)sendPost:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *solicitudTextField;


- (IBAction)activatesPriorityGreenButton:(id)sender;
- (IBAction)activatesPriorityYellowButton:(id)sender;
- (IBAction)activatesPriorityRedButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *priorityGreenButtonProperty;
@property (strong, nonatomic) IBOutlet UIButton *priorityYellowButtonProperty;
@property (strong, nonatomic) IBOutlet UIButton *priorityRedButtonProperty;

@property(nonatomic,strong) NSString* colorDefinedForPriority;




@end
