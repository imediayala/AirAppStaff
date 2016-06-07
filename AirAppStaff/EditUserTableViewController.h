//
//  EditUserTableViewController.h
//  AirAppStaff
//
//  Created by Daniel on 30/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUserTableViewController : UITableViewController<UIImagePickerControllerDelegate>




@property (strong, nonatomic) IBOutlet UIImageView *imageBox;
- (IBAction)doneNavigationItem:(id)sender;
- (IBAction)cancelNavigationItem:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *userText;
@property (strong, nonatomic) IBOutlet UITextField *mailText;
@property (strong, nonatomic) IBOutlet UITextField *employeeText;
@property (strong, nonatomic) IBOutlet UITextField *phoneText;
@property (strong, nonatomic) IBOutlet UITextField *favoritosText;
@property (strong, nonatomic) IBOutlet UITextField *passText;


- (IBAction)chooseImageButton:(id)sender;

- (IBAction)takePhotoButton:(id)sender;


@end
