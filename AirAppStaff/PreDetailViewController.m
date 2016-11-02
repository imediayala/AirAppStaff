//
//  PreDetailViewController.m
//  AirAppStaff
//
//  Created by Daniel on 07/10/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "PreDetailViewController.h"
#import "Constants.h"
#import "DetailViewController.h"
#import "PostTableViewCell.h"
#import "User.h"
@import Firebase;


@interface PreDetailViewController (){
    
    NSString *chatStarted;


}



@end

@implementation PreDetailViewController                                                                                           

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil) {
            // User is signed in.
        
            
            
            
            
            NSLog(@"%@", user);
        } else {
            
            // No user is signed in.
            

        }
    }];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;

    
    
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    self.aceptadosRef = [[ref child:@"usuario-okrequest"] child:_details.key];
    self.userAcepptance = [[NSMutableArray alloc] init];
    self.post = [[Post alloc] init];
    
    _ref = [[FIRDatabase database] reference];
    
    _userAcepptance = [[NSMutableArray alloc] init];


    


    //detailBox

   _imageBox.image  = [UIImage imageNamed:@"hostess.png"];
    NSString *text = _details.value[MessageFieldstext];
    NSString *user = _details.value[MessageFieldsname];

    NSString *priority = _details.value[MessageFieldscolor];
    self.detailText.text = text;
    self.userLabel.text = user;
    
    
        NSLog(@"Your name is %@", user);
        NSLog(@"Your priority is %@", priority);
    
    
        NSString *green =@"green";
        NSString *yellow =@"yellow";
        NSString *red =@"red";
    
    
        if ([priority isEqualToString:red]) {
    
//            _detailPriorytyBackgrundColorImage.backgroundColor = [UIColor redColor];
            
            [_detailPriorytyBackgrundColorImage setImage:[UIImage imageNamed:@"Rectanglered"]];

    
        }else if ([priority isEqualToString:yellow]){
    
//            _detailPriorytyBackgrundColorImage.backgroundColor = [UIColor orangeColor];
            
            [_detailPriorytyBackgrundColorImage setImage:[UIImage imageNamed:@"Rectangleorange"]];

    
        }else if ([priority isEqualToString:green]){
    
//            _detailPriorytyBackgrundColorImage.backgroundColor = [UIColor greenColor];
            
            [_detailPriorytyBackgrundColorImage setImage:[UIImage imageNamed:@"Rectangleblue"]];

        
        }
    
    
            
    
    
    
}


-(void) requestProfileInfo{
    
    // [START single_value_read]
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[_ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        User *user = [[User alloc] initWithUsername:snapshot.value[@"username"]];
        
        // Get name from user signed in and the user from post
        // Then hide button if user name is equal and change text tittle
        
        NSString * userSignedIn = user.username;
        NSString * userNameFromDetail = _details.value[MessageFieldsname];
        
        if ( [userNameFromDetail isEqualToString:userSignedIn]) {
            _ConversationButton.hidden = YES;
            
        }else{
            
//            [_ConversationButton setTitle:@"Ver Chat" forState:UIControlStateNormal];        
        
        }
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void) getId: (NSString*) getid{
//    
//    FIRDataSnapshot* articulo = [FIRDataSnapshot new];
//    
//    articulo = _details.key;
//    
//    
//    [self performSegueWithIdentifier:@"showDetail" sender:articulo];
//
//
//}

-(void) viewWillAppear:(BOOL)animated{
    
    [self.userAcepptance removeAllObjects];
    
    [self requestProfileInfo];

    
    
    
    NSString * dataToPass = @"data to pass back";
    if ([chatStarted isEqualToString:dataToPass] ) {
        
        [_ConversationButton setTitle:@"Ir a chat" forState:UIControlStateNormal];
        
    }
    

    
//    [self.userOkRequestTable reloadData];

    [self reloadMessages];


}

- (void) reloadMessages {
    
    [_userOkRequestTable reloadData];

    
    //    // [START child_event_listener]
    //    // Listen for new comments in the Firebase database
    [_aceptadosRef
     observeEventType:FIRDataEventTypeChildAdded
     withBlock:^(FIRDataSnapshot *snapshot) {
         [_userAcepptance addObject:snapshot];
         [_userOkRequestTable insertRowsAtIndexPaths:@[
                                                 [NSIndexPath indexPathForRow:[self.userAcepptance count] - 1 inSection:0]
                                                 ]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
         
        
         
         NSString * value = [snapshot.value valueForKey:@"author"];
         
         NSLog(@"%@", value);
         
     }];

//    
//    
//    
//    
//    
//    // Listen for new messages in the Firebase database
//    _refHandle = [[_ref child:@"usuario-okrequest"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
//        
//        
//        // insertObject does cotain an index so i can specify where to place my new object into the array
//        [_userAcepptance addObject:snapshot];
//
        
        
//    }];
    

    
    
}

-(void) getUserName{
    
    [_userOkRequestTable reloadData];

    
    // [START single_value_read]
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[_ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        User *user = [[User alloc] initWithUsername:snapshot.value[@"username"]];
        self.userLabel.text = user.username;
        
            NSString *valueToSave = [NSString stringWithFormat:@"%@",  user];
            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"preferenceName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
    




}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
  return [_userAcepptance count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"okRequestCell";
    
    // Dequeue cell
    PostTableViewCell *cell = (PostTableViewCell*)[_userOkRequestTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    FIRUser *user = [FIRAuth auth].currentUser;
//    NSString *userName = [[NSUserDefaults standardUserDefaults]
//                          stringForKey:@"preferenceName"];


    NSString *userName = _details.value[MessageFieldsname];

    
    FIRDataSnapshot *messageSnapshot = _userAcepptance[indexPath.row];
    NSDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    NSString *name = message[MessageFieldsname];
    cell.authorLabel.text = [NSString stringWithFormat:@"%@", name];

    if ([[message valueForKey:@"author"] isEqualToString:userName] ) {
        
        self.navigationItem.rightBarButtonItem.enabled = YES;

        
        
        
    }else{
    
    
    
    }
    
    
    

//    NSString *text = message[MessageFieldstextview];
//    cell.postBody.text = [NSString stringWithFormat:@"%@", text];
//    cell.authorImage.image = [UIImage imageNamed:@"hostess.png"];
    //    } else if (indexPath.section == kSectionSend) {
    //        cell = [tableView dequeueReusableCellWithIdentifier:@"send"];
    //        _replyTextField = [(UITextField *) cell viewWithTag:7];
    //    }
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{if ([[segue identifier] isEqualToString:@"showDetailChat"]){
    
    

    
    // Get reference to the destination view controller
    
    UINavigationController *navController = [segue destinationViewController];
    DetailViewController *detailViewController = (DetailViewController  *)navController.topViewController;
    [detailViewController setDelegate:self];
    
    // Pass any objects to the view controller here, like...
    detailViewController.details = _details;
    
    
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

- (IBAction)actionCambiarTurnoButton:(id)sender {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Solicitud de cambio!"
                                          message:@"Atencion si pulsas ok el turno sera cambiado automaticamente"
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
                                   
//                                   NSString *valueToSave = [NSString stringWithFormat:@"%@",  _details.key];
//                                   
//                                   NSLog(@"%@", valueToSave);
//                                   
//                                   
//                                   [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"aceptadoKey"];
//                                   [[NSUserDefaults standardUserDefaults] synchronize];
////                                   
//                                   NSString *uid = [FIRAuth auth].currentUser.uid;
//                                   [[[[FIRDatabase database].reference child:@"users"] child:uid]
//                                    observeSingleEventOfType:FIRDataEventTypeValue
//                                    withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//                                        NSDictionary *user = snapshot.value;
//                                        NSString *username = user[@"username"];
//                                        NSDictionary *comment = @{@"uid": uid,
//                                                                  @"author": username,
//                                                                  @"key": valueToSave,
//                                                                  @"text": @"ok"};
//                                        [[_aceptadosRef childByAutoId] setValue:comment];
//                                    }];
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                                   
//                                   [self dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
}

- (void)dataFromController:(NSString *)data
{
    chatStarted = data;
    
    NSLog(@"%@", data);
}


@end
