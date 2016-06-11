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

@import Firebase;



#define airAppNS @"https://airappstaff.firebaseio.com/user-posts/<user-id>/<unique-post-id>"

@interface HomeViewController (){
    
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
    
    
    
    _ref = [[FIRDatabase database] reference];
    
    _postRef = [_ref child:@"posts"];

    
    
//    
//            [_clientTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messages.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
    
    
    /// TEXT FIELD DELEGATE
    
    [_textField setDelegate:self];
    
    
    
        //----
    //[self reloadMessages];
    //----
    
    _msglength = 100;
    _messages = [[NSMutableArray alloc] init];
    
    [self loadAd];
    [_clientTable registerClass:UITableViewCell.self forCellReuseIdentifier:@"tableViewCell"];
    [self fetchConfig];
    [self configureStorage];
    
    
    //Cell editing
    
    _clientTable.allowsMultipleSelectionDuringEditing = NO;

}

//-(void) textFieldDidBeginEditing:(UITextField *)textField{
//    
//    if (_textField.text.length > 1) {
//        
//        _sendButton.enabled = YES;
//        
//    }else{
//        _sendButton.enabled = NO;
//        
//    }
//    
//}


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

- (void)configureStorage {
}

/// Reload messages data
- (void) reloadMessages {
    [_clientTable reloadData];
    // Listen for new messages in the Firebase database
    _refHandle = [[_ref child:@"posts"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        [_messages addObject:snapshot];
        [_clientTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messages.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
    }];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string {
//    NSString *text = _textField.text;
//    if (!text) {
//        return YES;
//    }
//    long newLength = text.length + string.length - range.length;
//    return (newLength <= _msglength);
//}

- (void)viewWillAppear:(BOOL)animated {
    
    NSString* welcomeText = @"Crea una solicitud";

    
    if ((_textField.text = welcomeText)) {
        _sendButton.enabled = NO;
    }
    

    
    [_messages removeAllObjects];
    [_clientTable reloadData];
    [self reloadMessages];


//    // Listen for new messages in the Firebase database
//    _refHandle = [[_ref child:@"messages"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
//        [_messages addObject:snapshot];
//        [_clientTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messages.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
//    }];
}

- (void)viewWillDisappear:(BOOL)animated {
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
    return [_messages count];
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
    FIRDataSnapshot *messageSnapshot = _messages[indexPath.row];
    NSDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    NSString *name = message[MessageFieldsname];
    NSString *text = message[MessageFieldstext];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",  name];
    cell.solicitaLabel.text = [NSString stringWithFormat:@"%@",  text];
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


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FIRDataSnapshot* articulo = [FIRDataSnapshot new];
    
    articulo= [_messages objectAtIndex:indexPath.row];
    
    
    [self performSegueWithIdentifier:@"showDetail" sender:articulo];
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{if ([[segue identifier] isEqualToString:@"showDetail"]){
    
        // Get reference to the destination view controller
        DetailViewController *vc = [segue destinationViewController];
        
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
    [self performSegueWithIdentifier:SeguesFpToSignIn sender:nil];
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
