//
//  HomeViewController.h
//  AirAppStaff
//
//  Created by Daniel on 12/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "PostDataModel.h"

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

    IBOutlet UITableView *solicitudesTableView;
    
}

@property(strong, nonatomic) IBOutlet PostDataModel *ref;

@property (strong, nonatomic) IBOutlet UIButton *propertyButton;

@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) NSMutableArray* tableData;

- (IBAction)sendWriteRequest:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *inputSolicitudText;

@property (strong, nonatomic) IBOutlet UILabel *outputSolicitudLabel;

@end
