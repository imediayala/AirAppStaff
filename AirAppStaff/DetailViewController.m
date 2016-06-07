//
//  DetailViewController.m
//  AirAppStaff
//
//  Created by Daniel on 13/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTableViewCell.h"
#import "PostTableViewCell.h"

#import "Constants.h"
#import "AppState.h"


@import Firebase;

static const int kSectionSend = 2;
static const int kSectionComments = 1;
static const int kSectionPost = 0;


@interface DetailViewController ()


@end

@implementation DetailViewController
FIRDatabaseHandle _refHandle;

- (void)viewDidLoad {
    [super viewDidLoad];
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    self.postRef = [[ref child:@"posts"] child:_details.key];
    self.commentsRef = [[ref child:@"post-comments"] child:_details.key];
    self.comments = [[NSMutableArray alloc] init];
    self.post = [[Post alloc] init];
//    UINib *nib = [UINib nibWithNibName:@"PostTableViewCell" bundle:nil];
//    [_repliesTable registerNib:nib forCellReuseIdentifier:@"post"];
    
    
    
    _ref = [[FIRDatabase database] reference];
    
    NSString *text = _details.value[MessageFieldstext];
    
    self.detailLabel.text = text;
    NSLog(@"Your name is %@", text);
    
    // Do any additional setup after loading the view.
    
    _comments = [[NSMutableArray alloc] init];

}



- (void)viewWillAppear:(BOOL)animated {
    [self.comments removeAllObjects];
    
    [_repliesTable reloadData];
    // Listen for new messages in the Firebase database
//    _refHandle = [[_ref child:@"post-comments"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
//        [_comments addObject:snapshot];
//        [_repliesTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_comments.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
    
        
        //    // [START child_event_listener]
        //    // Listen for new comments in the Firebase database
            [_commentsRef
             observeEventType:FIRDataEventTypeChildAdded
             withBlock:^(FIRDataSnapshot *snapshot) {
                 [self.comments addObject:snapshot];
                 [_repliesTable insertRowsAtIndexPaths:@[
                                                          [NSIndexPath indexPathForRow:[self.comments count] - 1 inSection:0]
                                                          ]
                                       withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    
    
    
//    // [START child_event_listener]
//    // Listen for new comments in the Firebase database
//    [_commentsRef
//     observeEventType:FIRDataEventTypeChildAdded
//     withBlock:^(FIRDataSnapshot *snapshot) {
//         [self.comments addObject:snapshot];
//         [_repliesTable insertRowsAtIndexPaths:@[
//                                                  [NSIndexPath indexPathForRow:[self.comments count] - 1 inSection:0]
//                                                  ]
//                               withRowAnimation:UITableViewRowAnimationAutomatic];
//     }];
//    // Listen for deleted comments in the Firebase database
//    [_commentsRef
//     observeEventType:FIRDataEventTypeChildRemoved
//     withBlock:^(FIRDataSnapshot *snapshot) {
//         int index = [self indexOfMessage:snapshot];
//         [self.comments removeObjectAtIndex:index];
//         [_repliesTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
//                               withRowAnimation:UITableViewRowAnimationAutomatic];
//     }];
//    // [END child_event_listener]
//    
//    // [START post_value_event_listener]
//    _refHandle = [_postRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        NSDictionary *postDict = snapshot.value;
//        // [START_EXCLUDE]
//        [_post setValuesForKeysWithDictionary:postDict];
//        [_repliesTable reloadData];
//        self.navigationItem.title = _post.title;
//        // [END_EXCLUDE]
//    }];
//    // [END post_value_event_listener]
}

- (int) indexOfMessage:(FIRDataSnapshot *)snapshot {
    int index = 0;
    for (FIRDataSnapshot *comment in _comments) {
        if ([snapshot.key isEqualToString:comment.key]) {
            return index;
        }
        ++index;
    }
    return -1;
}




- (void)viewDidDisappear:(BOOL)animated {
    [self.postRef removeObserverWithHandle:_refHandle];
    [self.commentsRef removeAllObservers];
}




#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == kSectionPost || section == kSectionSend ) {
//        return 1;
//    } else if (section == kSectionComments) {
        return [_comments count];
//    }
//    NSAssert(NO, @"Unexpected section");
//    return 0;
}

- (IBAction)didTapSend:(id)sender {
    NSString *uid = [FIRAuth auth].currentUser.uid;
    [[[[FIRDatabase database].reference child:@"users"] child:uid]
     observeSingleEventOfType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
         NSDictionary *user = snapshot.value;
         NSString *username = user[@"username"];
         NSDictionary *comment = @{@"uid": uid,
                                   @"author": username,
                                   @"text": _replyTextField.text};
         [[_commentsRef childByAutoId] setValue:comment];
         _replyTextField.text = @"";
     }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"post";
    
    // Dequeue cell
    PostTableViewCell *cell = (PostTableViewCell*)[_repliesTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    if (indexPath.section == kSectionPost) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"post"];
//        PostTableViewCell *postcell = (PostTableViewCell *)cell;
//        postcell.authorLabel.text = _post.author;
////        postcell.postTitle.text = _post.title;
//        postcell.postBody.text = _post.body;
//        NSString *imageName = [_post.stars objectForKey:[self getUid]] ? @"ic_star" : @"ic_star_border";
//        [postcell.starButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//        postcell.numStarsLabel.text = [NSString stringWithFormat:@"%d", _post.starCount];
//        postcell.postKey = _postKey;
//        
//    }
//    
//    else if (indexPath.section == kSectionComments) {
        
    // Unpack message from Firebase DataSnapshot
    FIRDataSnapshot *messageSnapshot = _comments[indexPath.row];
    NSDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    NSString *name = message[MessageFieldsname];
    NSString *text = message[MessageFieldstextview];
    cell.authorLabel.text = [NSString stringWithFormat:@"%@", name];
    cell.postBody.text = [NSString stringWithFormat:@"%@", text];

//    } else if (indexPath.section == kSectionSend) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"send"];
//        _replyTextField = [(UITextField *) cell viewWithTag:7];
//    }
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == kSectionPost) {
//        return 160;
//    }
//    return 56;
//}

- (NSString *) getUid {
    return [FIRAuth auth].currentUser.uid;
}


@end
