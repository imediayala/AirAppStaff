//
//  DetailViewController.m
//  AirAppStaff
//
//  Created by Daniel on 13/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "DetailViewController.h"
#import "PostTableViewCell.h"

#import "Constants.h"
#import "AppState.h"


@import Firebase;

//static const int kSectionSend = 2;
//static const int kSectionComments = 1;
//static const int kSectionPost = 0;


@interface DetailViewController ()


@end



@implementation DetailViewController
FIRDatabaseHandle _refHandle;

@synthesize delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    self.postRef = [[ref child:@"posts"] child:_details.key];
    self.commentsRef = [[ref child:@"post-comments"] child:_details.key];
    self.aceptadosRef = [[ref child:@"usuario-okrequest"] child:_details.key];
    
    self.comments = [[NSMutableArray alloc] init];
    self.post = [[Post alloc] init];
    
    _repliesTable.allowsMultipleSelectionDuringEditing = NO;
    
    _ref = [[FIRDatabase database] reference];
    
    _comments = [[NSMutableArray alloc] init];

}
- (void)passDataBack
{
    [self.delegate dataFromController:@"data to pass back"];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [self.comments removeAllObjects];
    
    [_repliesTable reloadData];
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


// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}

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
    cell.authorImage.image = [UIImage imageNamed:@"hostess.png"];
    
    if (name >0) {
      
        [self passDataBack];
        
    }
    

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


- (IBAction)closeChat:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionButton:(id)sender {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alerta!"
                                          message:@"Estas seguro que aceptas el cambio con el usuario, no podras deshacer esta accion"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   
                                   NSString *valueToSave = [NSString stringWithFormat:@"%@",  _details.key];
                                   
                                   NSLog(@"%@", valueToSave);
                                   
                                   
                                   [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"aceptadoKey"];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   
                                   NSString *uid = [FIRAuth auth].currentUser.uid;
                                   [[[[FIRDatabase database].reference child:@"users"] child:uid]
                                    observeSingleEventOfType:FIRDataEventTypeValue
                                    withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                        NSDictionary *user = snapshot.value;
                                        NSString *username = user[@"username"];
                                        NSDictionary *comment = @{@"uid": uid,
                                                                  @"author": username,
                                                                  @"key": valueToSave,
                                                                  @"text": @"ok"};
                                        [[_aceptadosRef childByAutoId] setValue:comment];
                                    }];
                                   
                              
                                   
                                   
                                   
                                   

                              
                                   
                                   
                                   
                                   [self dismissViewControllerAnimated:YES completion:nil];

                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];


}
@end
