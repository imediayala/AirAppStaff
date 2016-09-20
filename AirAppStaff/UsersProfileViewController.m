//
//  UsersProfileViewController.m
//  AirAppStaff
//
//  Created by Daniel on 30/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "UsersProfileViewController.h"
#import "AppState.h"
#import "NSString+MD5.h"
#import "FTWCache.h"


@import Firebase;


@interface UsersProfileViewController (){
    
    NSString * imagesString;
}

@end

@implementation UsersProfileViewController


@synthesize userLabel;
@synthesize emailLabel;
@synthesize passwordLabel;
@synthesize phoneLabel;
@synthesize imageBox;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _ref = [[FIRDatabase database] reference];
    //Get the currently signed-in user
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil) {
            // User is signed in.
            
            

            [self requestProfileInfo];
            
            [self reloadProfileImages];
            
        } else {
            // No user is signed in.
        }
    }];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) requestProfileInfo{

    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil) {
        NSString *uid = user.uid;  // The user's ID, unique to the Firebase
        // project. Do NOT use this value to
        // authenticate with your backend server, if
        // you have one. Use
        // getTokenWithCompletion:completion: instead.
        
        self.emailLabel.text = user.email;
        NSString *userName = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"preferenceName"];
        
        self.userLabel.text = userName;
        
    } else {
        // No user is signed in.
    }

}

- (void) reloadProfileImages {
    
    
    // Listen for new messages in the Firebase database
    _refHandleImage = [[_ref child:@"ProfileImages"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        
        
        // insertObject does cotain an index so i can specify where to place my new object into the array
        
        
//        [_imagges insertObject:snapshot atIndex:0];
        
        NSDictionary<NSString *, NSString *> *imagge = snapshot.value;
        
        
        //        NSString *name = imagge[MessageFieldsname];
        
        NSString *photoUrl =  [imagge valueForKey:@"photoUrl"];
        
        imagesString = photoUrl;
        
        [self loadImageFromURL:imagesString];

        
        //
        //        NSString *userName = [[NSUserDefaults standardUserDefaults]
        //                              stringForKey:@"preferenceName"];
        //
        //
        //        if (userName == name) {
        //
        //
        //        }
        //        
        
        //        NSLog(@"%@",name);
        
        
//        imageBox.image = [UIImage imageNamed:  imagesString];
//        
//        if (imagesString) {
////            NSURL *url = [NSURL URLWithString:imagesString];
//            NSURL *url = [[NSURL alloc] initWithString:imagesString];
//
//            if (url) {
//                NSData *data = [NSData dataWithContentsOfURL:url];
//                if (data) {
//                   imageBox.image = [UIImage imageWithData:data];
//                }
//            }
//
//        
//        
//        
//        
//        
//        }
        
    }];
    
}

- (void) loadImageFromURL:(NSString*)URL {
    NSURL *imageURL = [NSURL URLWithString:imagesString];
    NSString *key = [URL MD5Hash];
    NSData *data = [FTWCache objectForKey:key];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        imageBox.image = image;
    } else {
        imageBox.image = [UIImage imageNamed:@"hostess.png"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            [FTWCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                imageBox.image = image;
            });
        });
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logOutButton:(id)sender {
    
    FIRAuth *firebaseAuth = [FIRAuth auth];
    NSError *signOutError;
    BOOL status = [firebaseAuth signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    
    [AppState sharedInstance].signedIn = false;
    [self performSegueWithIdentifier:@"SeguesToSignIn" sender:nil];
}
@end
