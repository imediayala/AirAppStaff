//
//  TimeTableViewController.m
//  AirAppStaff
//
//  Created by Daniel on 13/06/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "TimeTableViewController.h"
#import "TimeTableViewCell.h"
#import "TimeTableDataSource.h"

@interface TimeTableViewController ()



@end


NSArray * timeNameArray;
@implementation TimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
   return  [_timeNameArray count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    static NSString *CellIdentifier = @"post";
    
    // Dequeue cell
    TimeTableViewCell *cell = (TimeTableViewCell*)[_timeTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //    }
    return cell;

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
