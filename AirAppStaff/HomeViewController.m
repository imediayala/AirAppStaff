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
#import "AppState.h"
#import "Constants.h"
#import "MeasurementHelper.h"
#import "User.h"
#import "FTWCache.h"
#import "NSString+MD5.h"
#import "PreDetailViewController.h"

@import Firebase;

#define airAppNS @"https://airappstaff.firebaseio.com/user-posts/<user-id>/<unique-post-id>"

@interface HomeViewController (){

//    NSMutableArray<FIRDataSnapshot *> *messagesSearchArray;

    NSArray* messagesSearchArray;
    NSMutableArray* messagesOrderedArray;
    NSString * imagesString;
    NSDictionary<NSString *, NSString *> *imaggeGlobal;
    
    //    NSArray* sortedArray;
    
}
@property (nonatomic) BOOL newMessagesOnTop;
@end


@implementation HomeViewController


//- (IBAction)didSendMessage:(UIButton *)sender {
//    [self textFieldShouldReturn:_textField];
//}

- (IBAction)didPressCrash:(id)sender {
    assert(NO);
}

- (IBAction)didPressFreshConfig:(id)sender {
    [self fetchConfig];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /// TEXT FIELD DELEGATE
    
    [_textField setDelegate:self];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    
    _ref = [[FIRDatabase database] reference];
    _postRef = [_ref child:@"posts"];
    
//    _msglength = 100;
    _messages = [[NSMutableArray alloc] init];
    _imagges = [[NSMutableArray alloc] init];
    
    
    [self loadAd];
    [_clientTable registerClass:UITableViewCell.self forCellReuseIdentifier:@"tableViewCell"];
    [self fetchConfig];
//    [self reloadProfileImages];
    
    //Cell editing
    
    _clientTable.allowsMultipleSelectionDuringEditing = NO;
    
}


-(void) textFieldDidEndEditing:(UITextField *)textField{
    
    if (_textField.text.length > 1) {
        _sendButton.enabled = YES;
        
    }else{
        _sendButton.enabled = NO;
        
    }
}




- (void)loadAd {
}

- (void)fetchConfig {
}


/// Reload messages data


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string {
//    NSString *text = _textField.text;
//    if (!text) {
//        return YES;
//    }
//    long newLength = text.length + string.length - range.length;
//    return (newLength <= _msglength);
//}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    // Creating nav bar button item to post
    
    UIBarButtonItem * post = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target: self action:@selector(openPostCompleteView)];
    [[[self.navigationController navigationBar] topItem] setRightBarButtonItem:post];
    NSString* welcomeText = @"Crea una solicitud";
    
    if ((_textField.text = welcomeText)) {
        
        _sendButton.enabled = NO;
    }
    

    
    [_messages removeAllObjects];
    
    self.clientTable.estimatedRowHeight = 30.0; // for example. Set your average height
    self.clientTable.rowHeight = UITableViewAutomaticDimension;
    [self.clientTable reloadData];
    [self reloadMessages];
    
}


-(void) openPostCompleteView{
    
    
    [self performSegueWithIdentifier:@"postsegue" sender:nil];
    
    
    NSLog(@"opening");
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[[self.navigationController navigationBar] topItem] setRightBarButtonItem:nil];
    
    
    [_ref removeObserverWithHandle:_refHandle];
}



- (int) indexOfMessage:(FIRDataSnapshot *)snapshot {
    int index = 0;
    for (FIRDataSnapshot *comment in _messages) {
        if ([snapshot.key isEqualToString:comment.key]) {
            return index;
        }
        ++index;
    }
    return -1;
}



- (void) reloadMessages {
    
    [_clientTable reloadData];
    // Listen for new messages in the Firebase database
    _refHandle = [[_ref child:@"posts"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        
        // addObject does not contain an index and i need to specify index so i can order my array
        //[_messages addObject:snapshot];
        
        //[_clientTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messages.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
        
        // insertObject does cotain an index so i can specify where to place my new object into the array
        [_messages insertObject:snapshot atIndex:0];
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [_clientTable insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
}


- (void) reloadProfileImages {
    
    
    // Listen for new messages in the Firebase database
    _refHandleImage = [[_ref child:@"ProfileImages"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        
        
        // insertObject does cotain an index so i can specify where to place my new object into the array
        
        [_imagges insertObject:snapshot atIndex:0];
        NSDictionary<NSString *, NSString *> *imagge = snapshot.value;
        NSString *photoUrl =  [imagge valueForKey:@"photoUrl"];
        imagesString = photoUrl;
    }];
    
}

-(void) userImageString {
    
}

# pragma mark - TableView


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
        
        //// add code here for when you hit delete /////
        
        FIRDataSnapshot *msg = [_messages objectAtIndex:indexPath.row];
        
        [_messages removeObjectAtIndex:indexPath.row];
        
        
        [msg.ref removeValue];
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    };
    
    
    
}

// UITableViewDataSource protocol methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [messagesSearchArray count];
        
    } else {
        return [_messages count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cellHome";
    
    // Dequeue cell
    HomeTableViewCell *cell = (HomeTableViewCell*)[_clientTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
    
    // Unpack message from Firebase DataSnapshot
    
    
    
    FIRDataSnapshot *messageSnapshot = nil;
    
    
    // I need to get get an array from object fir datasnapshot
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        messageSnapshot = [messagesSearchArray objectAtIndex:indexPath.row];
    } else {
        messageSnapshot = [_messages objectAtIndex:indexPath.row];
        
    }
    
    //    FIRDataSnapshot *messageSnapshot = _messages[indexPath.row];
    
    NSMutableDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    
    
    [message setValue:imagesString forKey:@"photoUrl"];
    
    NSString *name = message[MessageFieldsname];
    NSString *text = message[MessageFieldstext];
    NSString *color = message[MessageFieldscolor];
    NSString *date = message[MessageFieldsdate];
//    NSString *photoUrl = imaggeGlobal[MessageFieldsphotoUrl];
    
    
    
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",  name];
    NSString *valueToSave = [NSString stringWithFormat:@"%@",  name];
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"preferenceName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    cell.solicitaLabel.text = [NSString stringWithFormat:@"%@",  text];
    cell.dateLabel.text =[NSString stringWithFormat:@"%@", date];
    cell.priorityIndicatorLabel.text = [NSString stringWithFormat:@"%@",  color];
    cell.userPictureImage.image = [UIImage imageNamed:@"hostess.png"];

    
    NSString *green = @"green";
    NSString *yellow = @"yellow";
    NSString *red = @"red";
    NSString *withoutPriority = @"sinPrioridad";
    
    if ([cell.priorityIndicatorLabel.text isEqualToString: green]) {
        cell.priorityIndicatorLabel.textColor = [UIColor greenColor];
        cell.priorityIndicatorLabel.text = @"Prioridad Normal";
        return cell;
    }
    
    else if ([cell.priorityIndicatorLabel.text isEqualToString: yellow]) {
        cell.priorityIndicatorLabel.textColor = [UIColor orangeColor];
        cell.priorityIndicatorLabel.text = @"Prioridad Media";
    }
    
    else if ([cell.priorityIndicatorLabel.text isEqualToString:red]) {
        cell.priorityIndicatorLabel.textColor = [UIColor redColor];
        cell.priorityIndicatorLabel.text = @"Prioridad Alta";
    }
    
    else if ([cell.priorityIndicatorLabel.text isEqualToString:withoutPriority]) {
        cell.priorityIndicatorLabel.textColor = [UIColor grayColor];
        cell.priorityIndicatorLabel.text = @"Sin Prioridad :(";
        
        
    }
//    //    NSString * URL;
//    //    NSURL *imageURL = [NSURL URLWithString:imagesString];
//    NSString *key = [imagesString MD5Hash];
//    NSData *data = [FTWCache objectForKey:key];
//    if (data) {
//        UIImage *image = [UIImage imageWithData:data];
//        cell.userPictureImage.image = image;
//        
//    } else {
//        cell.userPictureImage.image = [UIImage imageNamed:@"hostess.png"];
//        
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//        dispatch_async(queue, ^{
//            NSURL *url = [[NSURL alloc] initWithString:photoUrl];
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            UIImage *image = [UIImage imageWithData:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                cell.userPictureImage.image = image;
//                
//            });
//        });
//        
//        
//    }
    
    return cell;
    
}


//Search display controller filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    FIRDataSnapshot * messageSnapshot =  nil;
    NSIndexPath * indexPath;
    messageSnapshot = [_messages objectAtIndex:indexPath.row];
    
    
    
    
    
//    NSMutableDictionary<NSString *, NSString *> *message = messageSnapshot.value;
//    NSArray *newArray = [message valueForKey:@"body"];
    
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    messagesSearchArray = [messageSnapshot.value filteredArrayUsingPredicate:resultPredicate];
}




-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FIRDataSnapshot* articulo = [FIRDataSnapshot new];
    
    articulo= [_messages objectAtIndex:indexPath.row];
    
    
    [self performSegueWithIdentifier:@"showDetail" sender:articulo];
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{if ([[segue identifier] isEqualToString:@"showDetail"]){
    
    // Get reference to the destination view controller
    PreDetailViewController *vc = [segue destinationViewController];
    
    // Pass any objects to the view controller here, like...
    vc.details = (FIRDataSnapshot*)sender;
    
    
}
}


// UITextViewDelegate protocol methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    [self sendSolicitudButton:nil];
    
    return YES;
}



- (void)writeNewPost:(NSString *)userID username:(NSString *)username title:(NSString *)title body:(NSString *)body {
    // Create new post at /user-posts/$userid/$postid and at
    // /posts/$postid simultaneously
    // [START write_fan_out]
    NSString *key = [[_ref child:@"posts"] childByAutoId].key;
    NSDictionary *post = @{@"uid": userID,
                           @"author": username,
                           @"title": title,
                           @"body": body};
    
    
    NSDictionary *childUpdates = @{[@"/posts/" stringByAppendingString:key]: post,
                                   [NSString stringWithFormat:@"/user-posts/%@/%@/", userID, key]: post};
    [_ref updateChildValues:childUpdates];
    
    _textField.text = @"";
    [_textField resignFirstResponder];
    // [END write_fan_out]
    
}

- (IBAction)sendSolicitudButton:(id)sender {
    
    
    // [START single_value_read]
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[_ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        User *user = [[User alloc] initWithUsername:snapshot.value[@"username"]];
        
        
        
        [self writeNewPost:userID
                  username:user.username
                     title:_textField.text
                      body:_textField.text];
        
    }];
    
}

//Text field Return

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    if([string isEqualToString:@"\n"]) {
//        [_textField resignFirstResponder];
//        return NO;
//    }
//    return YES;
//
//
//
//}


- (void)sendMessage:(NSDictionary *)data {
    
}




# pragma mark - Image Picker

- (IBAction)didTapAddPhoto:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker animated:YES completion:NULL];
}

//- (void)imagePickerController:(UIImagePickerController *)picker
//didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//
//    NSURL *referenceUrl = info[UIImagePickerControllerReferenceURL];
//    PHFetchResult* assets = [PHAsset fetchAssetsWithALAssetURLs:@[referenceUrl] options:nil];
//    PHAsset *asset = [assets firstObject];
//    [asset requestContentEditingInputWithOptions:nil
//                               completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
//                                   NSURL *imageFile = contentEditingInput.fullSizeImageURL;
//                                   NSString *filePath = [NSString stringWithFormat:@"%@/%lld/%@", [FIRAuth auth].currentUser.uid, (long long)([[NSDate date] timeIntervalSince1970] * 1000.0), [referenceUrl lastPathComponent]];
//                               }
//     ];
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)signOut:(UIButton *)sender {
    [AppState sharedInstance].signedIn = false;
    [self performSegueWithIdentifier:SeguesToSignIn sender:nil];
}

- (void)showAlert:(NSString *)title message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:dismissAction];
        [self presentViewController:alert animated: true completion: nil];
    });
}

#pragma mark Cancel message


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
    
    
    
}




@end
