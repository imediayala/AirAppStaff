//
//  DetailViewController.h
//  AirAppStaff
//
//  Created by Daniel on 13/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface DetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@property(strong, nonatomic) NSString *detailArray;

@property (strong, nonatomic) FIRDataSnapshot *details;



@end
