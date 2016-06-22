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

@end
