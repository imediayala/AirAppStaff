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
@import Firebase;


#define airAppNS @"https://airappstaff.firebaseio.com/user-posts/<user-id>/<unique-post-id>"

@interface HomeViewController (){
    
}
@property (nonatomic) BOOL newMessagesOnTop;
@end


@implementation HomeViewController

@synthesize inputSolicitudText;
@synthesize outputSolicitudLabel;
@synthesize tableData;
@synthesize newMessagesOnTop;
@synthesize propertyButton;
@synthesize ref;








- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.ref = [[FIRDatabase database] reference];
    
    [self getUserState];
    
    
   
    // Do any additional setup after loading the view.
}

-(void) getUserState{

    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil) {
            // User is signed in.
            
            NSLog(@"user is signed in");
            
        } else {
            // No user is signed in.
            
            NSLog(@"user is not signed in");
        }
    }];



}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fireBaseWriteRequest{
    
    
    

}

- (IBAction)sendWriteRequest:(id)sender {
    
    
//    NSString *key = [[ref child:@"posts"] childByAutoId].key;
//    NSDictionary *post = @{@"uid": userID,
//                           @"author": username,
//                           @"title": title,
//                           @"body": body};
//    NSDictionary *childUpdates = @{[@"/posts/" stringByAppendingString:key]: post,
//                                   [NSString stringWithFormat:@"/user-posts/%@/%@/", userID, key]: post};
//    [_ref updateChildValues:childUpdates];
//    

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return [tableData count];
    
}

#pragma mark - TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [solicitudesTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
      
        NSIndexPath *indexPath = [solicitudesTableView indexPathForSelectedRow];
        DetailViewController *destViewController = segue.destinationViewController;
        destViewController.detailArray = [tableData objectAtIndex:indexPath.row];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    //    //perform segue
    
    
    [self performSegueWithIdentifier:@"showDetail" sender:tableData];
    
   
    
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
