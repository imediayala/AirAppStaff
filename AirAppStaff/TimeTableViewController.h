//
//  TimeTableViewController.h
//  AirAppStaff
//
//  Created by Daniel on 13/06/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTableViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *timeTableView;

@property (strong, nonatomic) NSArray* timeNameArray;

@end
