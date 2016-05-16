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

#define airAppNS @"https://airappstaff.firebaseio.com"

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








- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize array that will store chat messages.
    self.tableData = [[NSMutableArray alloc] init];
    
    
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:airAppNS];
    
    // Pick a random number between 1-1000 for our username.
    self.name = [NSString stringWithFormat:@"Guest%d", arc4random() % 1000];
    [propertyButton setTitle:self.name forState:UIControlStateNormal];
    

    
    // Decide whether or not to reverse the messages
    newMessagesOnTop = YES;
    
    // This allows us to check if these were messages already stored on the server
    // when we booted up (YES) or if they are new messages since we've started the app.
    // This is so that we can batch together the initial messages' reloadData for a perf gain.
    __block BOOL initialAdds = YES;
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        if (newMessagesOnTop) {
            [self.tableData insertObject:snapshot.value atIndex:0];
        } else {
            [self.tableData addObject:snapshot.value];
        }
        
        // Reload the table view so the new message will show up.
        if (!initialAdds) {
            [solicitudesTableView reloadData];
        }
    }];
    
    // Value event fires right after we get the events already stored in the Firebase repo.
    // We've gotten the initial messages stored on the server, and we want to run reloadData on the batch.
    // Also set initialAdds=NO so that we'll reload after each additional childAdded event.
    [self.firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
        [solicitudesTableView reloadData];
        initialAdds = NO;
    }];

    
    
    
    
    
    
//    tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fireBaseWriteRequest{
    
    
    

// Create a reference to a Firebase database URL
Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://airappstaff.firebaseio.com"];
// Write data to Firebase
[myRootRef setValue:@"Do you have data? You'll love Firebase."];
    
    
}

- (IBAction)sendWriteRequest:(id)sender {
    
    NSString *fireBaseSolicitud = inputSolicitudText.text;
    
    // Create a reference to a Firebase database URL
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:airAppNS];
    
    
    // Write data to Firebase
    [myRootRef setValue:fireBaseSolicitud];
    
    
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
        
        
        outputSolicitudLabel.text = snapshot.value;
        
        [solicitudesTableView reloadData];

    }];
    
//    NSLog(fireBaseSolicitud);
    
}œ

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
