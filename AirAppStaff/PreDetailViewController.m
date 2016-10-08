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

@interface PreDetailViewController ()

@end

@implementation PreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    self.aceptadosRef = [[ref child:@"usuario-okrequest"] child:_details.key];
    self.userAcepptance = [[NSMutableArray alloc] init];
    [self.userOkRequestTable reloadData];




    
    NSString *text = _details.value[MessageFieldstext];
    NSString *priority = _details.value[MessageFieldscolor];
    
    
    self.detailText.text = text;
    
            NSString *aceptadoSolicitudkey = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"aceptadokey"];
    
    
//    if (aceptadoSolicitudkey) {
//        <#statements#>
//    }
    
    
    
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
    
    [self.userOkRequestTable reloadData];

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

    FIRDataSnapshot *messageSnapshot = _userAcepptance[indexPath.row];
    NSDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    NSString *name = message[MessageFieldsname];
    cell.authorLabel.text = [NSString stringWithFormat:@"%@", name];

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

//    DetailViewController *vc = [segue destinationViewController];
    
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

@end
