//
//  TimeTableViewController.m
//  AirAppStaff
//
//  Created by Daniel on 13/06/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "TimeTableViewController.h"
#import "TimeTableViewCell.h"
#import "Empleado.h"
#import "Empleado.h"

@interface TimeTableViewController ()



@end


NSArray * timeNameArray;
@implementation TimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self nsurlSessionWebServices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) nsurlSessionWebServices{
    //
    //    // Session setup
        NSString *statusUrl = @"https://api.myjson.com/bins/wf1s";
    
    
    //In case that im using Auth Validation for my api
    
//        NSString *token = tokenResponse;
//        NSString *authValue = [NSString stringWithFormat:@"Bearer %@",token];
    
//        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        sessionConfiguration.HTTPAdditionalHeaders = @{@"Authorization": authValue};
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
        [[session dataTaskWithURL:[NSURL URLWithString:statusUrl]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSLog(@"response ==> %@", response);
                    if (!error) {
                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                        if (httpResponse.statusCode == 200){
                            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil];
    
                            //NSLog(@"Heres the Json ==> %@", jsonData);
                            
                            NSArray *empleadosJson = [jsonData objectForKey:@"empleados"];
                            
                            NSMutableArray* empleados = [[NSMutableArray alloc] init];
                            
                            for (int i = 0; i<empleadosJson.count; i++) {
                                NSString *nombre = [[empleadosJson objectAtIndex:i] objectForKey:@"Nombre"];
                                
                                Empleado * employee = [[Empleado alloc] initWithName:nombre];
                                
                                [empleados addObject: employee];
                                
                                
                            }
                            
                            // Pass objects from array to empleados array
                            
                            _timeNameArray = empleados;
                            
                            // Very important!!! makes the app going trhu their thread life 
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.timeTableView reloadData];
                            });
                            
                        }
                    }else{
                        NSLog(@"Error %@", error);
                    }
                    
                    
                }] resume];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
   return  [_timeNameArray count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    static NSString *CellIdentifier = @"timecell";
    
    // Dequeue cell
    TimeTableViewCell *cell = (TimeTableViewCell*)[_timeTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //    }
    Empleado * empleado = [_timeNameArray objectAtIndex:indexPath.row];
    
    cell.employeeLabel.text = empleado.name;
    
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
