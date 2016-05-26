//
//  DetailViewController.m
//  AirAppStaff
//
//  Created by Daniel on 13/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "DetailViewController.h"
#import "Constants.h"
@import Firebase;


@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize detailLabel;
@synthesize details;



- (void)viewDidLoad {
    [super viewDidLoad];
     NSString *text = details.value[MessageFieldstext];
    
    self.detailLabel.text = text;
    NSLog(@"Your name is %@", text);
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
