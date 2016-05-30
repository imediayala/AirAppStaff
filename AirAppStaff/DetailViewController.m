//
//  DetailViewController.m
//  AirAppStaff
//
//  Created by Daniel on 13/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTableViewCell.h"

#import "Constants.h"
#import "AppState.h"


@import Firebase;


@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize detailLabel;
@synthesize details;




- (void)viewDidLoad {
    [super viewDidLoad];
    
        _ref = [[FIRDatabase database] reference];
    
     NSString *text = details.value[MessageFieldstext];
    
    self.detailLabel.text = text;
    NSLog(@"Your name is %@", text);
    
    // Do any additional setup after loading the view.
    
    _replymessages = [[NSMutableArray alloc] init];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [_replymessages removeAllObjects];
    // Listen for new messages in the Firebase database
    _refHandle = [[_ref child:@"messagesreplies"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        [_replymessages addObject:snapshot];
        [_repliesTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_replymessages.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// UITextViewDelegate protocol methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendReply:@{MessageFieldstext: _replyTextField.text}];
    textField.text = @"";
    return YES;
}

- (void)sendMessage:(NSDictionary *)data {
    
    
    NSMutableDictionary *mdata = [data mutableCopy];
    mdata[MessageFieldsname] = [AppState sharedInstance].displayName;
    NSURL *photoUrl = AppState.sharedInstance.photoUrl;
    if (photoUrl) {
        mdata[MessageFieldsphotoUrl] = [photoUrl absoluteString];
    }
    
    // Push data to Firebase Database
    [[[_ref child:@"messagesreplies"] childByAutoId] setValue:mdata];
}



- (IBAction)sendReply:(id)sender {
    
    [self textFieldShouldReturn:_replyTextField];
}

// UITableViewDataSource protocol methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_replymessages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Dequeue cell
    UITableViewCell *cell = [_repliesTable dequeueReusableCellWithIdentifier:@"repliesCell" forIndexPath:indexPath];
    
    // Unpack message from Firebase DataSnapshot
    FIRDataSnapshot *messageSnapshot = _replymessages[indexPath.row];
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
