//
//  PreDetailViewController.h
//  AirAppStaff
//
//  Created by Daniel on 07/10/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@import Firebase;



@interface PreDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    FIRDatabaseHandle _refHandle;


}
@property (strong, nonatomic) Post *post;

@property (weak, nonatomic) IBOutlet UITableView *userOkRequestTable;
@property (strong, nonatomic) FIRDataSnapshot *details;
@property (strong, nonatomic) FIRDatabaseReference *postRef;
@property (strong, nonatomic) FIRDatabaseReference *ref;



@property (weak, nonatomic) IBOutlet UITextView *detailText;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *userAcepptance;

@property (strong,nonatomic) FIRDatabaseReference * aceptadosRef;


@end
