//
//  EditUserTableViewController.m
//  AirAppStaff
//
//  Created by Daniel on 30/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "EditUserTableViewController.h"
#import "Constants.h"
#import "AppState.h"
@import Firebase;
@import Photos;




@interface EditUserTableViewController ()

@end

@implementation EditUserTableViewController

@synthesize userText;
@synthesize mailText;
@synthesize employeeText;
@synthesize phoneText;
@synthesize favoritosText;
@synthesize passText;
@synthesize imageBox;
@synthesize imageUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // self.navigationItem.leftBarButtonItem.title = @"Cancel";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    _ref = [[FIRDatabase database] reference];
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil) {
            
            // User is signed in.
            
            [self requestProfileInfo];
            
        } else{
            
            // No user is signed in.
        }
    }];
    
    
    [self requestProfileInfo];
    
    [self configureStorage];
}

- (void)configureStorage {
    self.storageRef = [[FIRStorage storage] referenceForURL:@"gs://airappstaff-v1.appspot.com"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) requestProfileInfo{
    
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil) {
        NSString *name = user.displayName;
        NSString *email = user.email;
        NSURL *photoUrl = user.photoURL;
//        NSString *uid = user.uid;
                                  // The user's ID, unique to the Firebase
                                  // project. Do NOT use this value to
                                 // authenticate with your backend server, if
                                // you have one. Use
                               // getTokenWithCompletion:completion: instead.
        
        self.mailText.text = email;
        self.userText.text = name;
        
        

        //NSString *formatToString = [photoUrl absoluteString];
        NSData *imageData = [NSData dataWithContentsOfURL:photoUrl];
        self.imageBox.image = [UIImage imageWithData:imageData];
//
    } else {
        
        // No user is signed in.
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// UITextViewDelegate protocol methods


- (void)sendMessage:(NSDictionary *)data {
    
    FIRUser *user = [FIRAuth auth].currentUser;

    
    
    
    NSMutableDictionary *mdata = [data mutableCopy];
    NSString *userName = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"preferenceName"];
    
    mdata[MessageFieldsname] = userName;
//    NSURL *photoUrl = AppState.sharedInstance.photoUrl;
//    if (photoUrl) {
//        mdata[MessageFieldsphotoUrl] = [photoUrl absoluteString];
//    }
    
    // Push data to Firebase Database
    [[[_ref child:@"ProfileImages"] childByAutoId] setValue:mdata];
    
}


- (IBAction)doneNavigationItem:(id)sender {
    
    
//    [self sendMessage:@{MessageFieldsphotoUrl: sender}];
    
//    [self updateUserProfile];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (IBAction)cancelNavigationItem:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"prueba"];
//    [self presentViewController:controller animated:YES completion:NULL];

}

# pragma mark - Image Picker


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    

    NSURL *referenceUrl = info[UIImagePickerControllerReferenceURL];
    PHFetchResult* assets = [PHAsset fetchAssetsWithALAssetURLs:@[referenceUrl] options:nil];
    PHAsset *asset = [assets firstObject];
    [asset requestContentEditingInputWithOptions:nil
                               completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                                   NSURL *imageFile = contentEditingInput.fullSizeImageURL;
                                   NSString *filePath = [NSString stringWithFormat:@"%@/%lld/%@", [FIRAuth auth].currentUser.uid, (long long)([[NSDate date] timeIntervalSince1970] * 1000.0), [referenceUrl lastPathComponent]];
                                   FIRStorageMetadata *metadata = [FIRStorageMetadata new];
                                   metadata.contentType = @"image/jpeg";
                                   [[_storageRef child:filePath]
                                    putFile:imageFile metadata:metadata
                                    completion:^(FIRStorageMetadata *metadata, NSError *error) {
                                        if (error) {
                                            NSLog(@"Error uploading: %@", error);
                                            return;
                                        }
                                        
                                        
                                        [self sendMessage:@{MessageFieldsphotoUrl:
                                                                metadata.downloadURL.absoluteString}];
                                    }
                                    ];
                               }];
    
    
    
    
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    self.imageBox.image = chosenImage;
//    
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    
//}

-(void)updateUserProfile{
    
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
    
    
    
    changeRequest.displayName =userText.text;
    changeRequest.photoURL =
    [NSURL URLWithString:imageUrl.absoluteString];
    [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
        if (error) {
            // An error happened.
        } else {
            // Profile updated.
        }
    }];

 

}



//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    
//    
//    NSURL* localUrl = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
//    imageUrl = localUrl;
//
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    self.imageBox.image = chosenImage;
//    
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//    
//}

- (IBAction)chooseImageButton:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)takePhotoButton:(id)sender {
    
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
@end
