//
//  DetailViewController.h
//  AirAppStaff
//
//  Created by Daniel on 13/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Firebase;

@interface DetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>{
    
       FIRDatabaseHandle _refHandle;

}
@property (strong, nonatomic) IBOutlet UITextView *detailLabel;

@property(strong, nonatomic) NSString *detailArray;

@property (strong, nonatomic) FIRDataSnapshot *details;


- (IBAction)closeChat:(id)sender;

- (IBAction)actionButton:(id)sender;


@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) FIRDatabaseReference *postRef;
@property (strong, nonatomic) FIRDatabaseReference *commentsRef;
@property (strong,nonatomic) FIRDatabaseReference * aceptadosRef;

// Table view replies config


@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *comments;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *userAcepptance;


@property (strong, nonatomic) NSString *postKey;



@property (strong, nonatomic) IBOutlet UIImageView *detailPriorytyBackgrundColorImage;


@property (strong, nonatomic) IBOutlet UITableView *repliesTable;
@property(nonatomic, weak) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UITextField *replyTextField;

@end
