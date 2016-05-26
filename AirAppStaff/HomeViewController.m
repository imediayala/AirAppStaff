//
//  HomeViewController.m
//  AirAppStaff
//
//  Created by Daniel on 12/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "DetailViewController.h"
#import <Firebase/Firebase.h>
@import Firebase;


#define airAppNS @"https://airappstaff.firebaseio.com/user-posts/<user-id>/<unique-post-id>"

@interface HomeViewController (){
    
}
@property (nonatomic) BOOL newMessagesOnTop;
@end


@implementation HomeViewController

@synthesize inputSolicitudText;
@synthesize outputSolicitudLabel;
@synthesize tableData;
@synthesize newMessagesOnTop;
@synthesize propertyButton;
@synthesize ref;








- (void)viewDidLoad {
    [super viewDidLoad];
    
    ref = [[FIRDatabase database] reference];
    
//    _msglength = 10;
    tableData = [[NSMutableArray alloc] init];
    
//    [self loadAd];
//    [_clientTable registerClass:UITableViewCell.self forCellReuseIdentifier:@"tableViewCell"];
//    [self fetchConfig];
//    [self configureStorage];
}



- (void)viewWillAppear:(BOOL)animated {
//    [tableData removeAllObjects];
    // Listen for new messages in the Firebase database
//    _refHandle = [[ref child:@"messages"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
//        [tableData addObject:snapshot];
//        [solicitudesTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tableData.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
//    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nil; //no. of row you want
}


- (void)viewWillDisappear:(BOOL)animated {
//    [_ref removeObserverWithHandle:_refHandle];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Dequeue cell
    UITableViewCell *cell = [solicitudesTableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    
    // Unpack message from Firebase DataSnapshot
    FIRDataSnapshot *messageSnapshot = tableData[indexPath.row];
    NSDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    NSString *name = message[MessageFieldsname];
    NSString *text = message[MessageFieldstext];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", name, text];
    cell.imageView.image = [UIImage imageNamed: @"ic_account_circle"];
    NSString *photoUrl = message[MessageFieldsphotoUrl];
    if (photoUrl) {
        NSURL *url = [NSURL URLWithString:photoUrl];
        if (url) {
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data) {
                cell.imageView.image = [UIImage imageWithData:data];
            }
        }
    }
    
    return cell;
}

@end
