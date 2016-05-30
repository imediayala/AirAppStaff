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

@import Firebase;




#define airAppNS @"https://airappstaff.firebaseio.com/user-posts/<user-id>/<unique-post-id>"

@interface HomeViewController (){
    
}
@property (nonatomic) BOOL newMessagesOnTop;
@end


@implementation HomeViewController


- (IBAction)didSendMessage:(UIButton *)sender {
    [self textFieldShouldReturn:_textField];
}

- (IBAction)didPressCrash:(id)sender {
    assert(NO);
}

- (IBAction)didPressFreshConfig:(id)sender {
    [self fetchConfig];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ref = [[FIRDatabase database] reference];
    
//    
//            [_clientTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messages.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
    
    
    //----
    //[self reloadMessages];
    //----
    
    _msglength = 10;
    _messages = [[NSMutableArray alloc] init];
    
    [self loadAd];
    [_clientTable registerClass:UITableViewCell.self forCellReuseIdentifier:@"tableViewCell"];
    [self fetchConfig];
    [self configureStorage];
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
    _refHandle = [[_ref child:@"messages"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        [_messages addObject:snapshot];
        [_clientTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messages.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string {
    NSString *text = _textField.text;
    if (!text) {
        return YES;
    }
    long newLength = text.length + string.length - range.length;
    return (newLength <= _msglength);
}

- (void)viewWillAppear:(BOOL)animated {
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

# pragma mark - TableView


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
    
    // Unpack message from Firebase DataSnapshot
    FIRDataSnapshot *messageSnapshot = _messages[indexPath.row];
    NSDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    NSString *name = message[MessageFieldsname];
    NSString *text = message[MessageFieldstext];
    cell.solicitaLabel.text = [NSString stringWithFormat:@"%@: %@", name, text];
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
    [self sendMessage:@{MessageFieldstext: _textField.text}];
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
    [[[_ref child:@"messages"] childByAutoId] setValue:mdata];
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

@end
