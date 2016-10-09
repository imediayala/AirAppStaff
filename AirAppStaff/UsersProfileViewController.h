//
//  UsersProfileViewController.h
//  AirAppStaff
//
//  Created by Daniel on 30/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
@import Firebase;

@interface UsersProfileViewController : UIViewController{

    FIRDatabaseHandle _refHandleImage;


}
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageBox;
- (IBAction)logOutButton:(id)sender;

- (IBAction)editUserButton:(id)sender;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *imagges;


@end
