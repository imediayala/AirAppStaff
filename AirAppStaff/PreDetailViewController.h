//
//  PreDetailViewController.h
//  AirAppStaff
//
//  Created by Daniel on 07/10/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "DetailViewController.h"

@import Firebase;



@interface PreDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, ChatDelegate>{
    
    FIRDatabaseHandle _refHandle;


}
@property (strong, nonatomic) Post *post;

@property (weak, nonatomic) IBOutlet UITableView *userOkRequestTable;
@property (strong, nonatomic) FIRDataSnapshot *details;
@property (strong, nonatomic) FIRDatabaseReference *postRef;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (weak, nonatomic) IBOutlet UIImageView *detailPriorytyBackgrundColorImage;

@property (weak, nonatomic) IBOutlet UIImageView *imageBox;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailText;


@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *userAcepptance;

@property (strong,nonatomic) FIRDatabaseReference * aceptadosRef;

- (IBAction)actionCambiarTurnoButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionProperty;
@property (weak, nonatomic) IBOutlet UIButton *ConversationButton;

@end
