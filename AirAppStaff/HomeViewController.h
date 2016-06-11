//
//  HomeViewController.h
//  AirAppStaff
//
//  Created by Daniel on 12/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
@import Firebase;



@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>{
    
    int _msglength;
    FIRDatabaseHandle _refHandle;
}




//
//@property (strong, nonatomic) IBOutlet UIButton *propertyButton;
//
//@property (nonatomic, strong) NSString* name;
//
//@property (nonatomic, strong) NSMutableArray* tableData;
//
//- (IBAction)sendWriteRequest:(id)sender;
//
//@property (strong, nonatomic) IBOutlet UITextField *inputSolicitudText;
//
//@property (strong, nonatomic) IBOutlet UILabel *outputSolicitudLabel;


- (FIRDatabaseReference *)refForIndex:(NSUInteger)index;

@property(nonatomic, weak) IBOutlet UITextField *textField;
@property(nonatomic, weak) IBOutlet UIButton *sendButton;
- (IBAction)sendSolicitudButton:(id)sender;

@property(nonatomic, weak) IBOutlet GADBannerView *banner;
@property(nonatomic, weak) IBOutlet UITableView *clientTable;

@property (strong, nonatomic) FIRDatabaseReference *postRef;




@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *messages;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (strong, nonatomic) FIRRemoteConfig *remoteConfig;

@end
