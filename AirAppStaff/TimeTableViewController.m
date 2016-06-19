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
#import "TimeTableCollectionViewController.h"

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
                            
                            NSArray *empleadosJson = [jsonData valueForKey:@"empleados"];
                            
                            NSMutableArray* empleados = [[NSMutableArray alloc] init];
                            
                            for (int i = 0; i<empleadosJson.count; i++) {
                                NSString *nombre = [[empleadosJson objectAtIndex:i] objectForKey:@"Nombre"];
//                                NSString *dia1 = [[empleadosJson objectAtIndex:i] objectForKey:@"Dia1"];
//                                NSString *dia2 = [[empleadosJson objectAtIndex:i] objectForKey:@"Dia2"];

                                
                                Empleado * employee = [[Empleado alloc] initWithName:nombre];
                                [employee setWorkerDays:[[empleadosJson objectAtIndex:i] objectForKey:@"empleados"]];

                                [employee setDia1:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia1"]];
                                [employee setDia2:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia2"]];
                                 [employee setDia3:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia3"]];
                                 [employee setDia4:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia4"]];
                                 [employee setDia5:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia5"]];
                                 [employee setDia6:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia6"]];
                                 [employee setDia7:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia7"]];
                                 [employee setDia8:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia8"]];
                                 [employee setDia9:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia9"]];
                                 [employee setDia10:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia10"]];
                                 [employee setDia11:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia11"]];
                                 [employee setDia12:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia12"]];
                                 [employee setDia13:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia13"]];
                                 [employee setDia14:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia14"]];
                                 [employee setDia15:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia15"]];
                                 [employee setDia16:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia16"]];
                                 [employee setDia17:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia17"]];
                                 [employee setDia18:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia18"]];
                                 [employee setDia19:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia19"]];
                                 [employee setDia20:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia20"]];
                                 [employee setDia21:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia21"]];
                                 [employee setDia22:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia22"]];
                                 [employee setDia23:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia23"]];
                                 [employee setDia24:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia24"]];
                                 [employee setDia25:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia25"]];
                                 [employee setDia26:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia26"]];
                                 [employee setDia27:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia27"]];
                                 [employee setDia28:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia28"]];
                                 [employee setDia29:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia29"]];
                                 [employee setDia30:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia30"]];
                                 [employee setDia31:[[empleadosJson objectAtIndex:i] objectForKey:@"Dia31"]];
                                
                                
                                [empleados addObject: employee];

                                
                                
                                //mal porque lo estaba duplicando el objecto en array
                                
//                                Empleado * diaUno = [[Empleado alloc] initWithName:dia];
                                
                                //     [empleados addObject: diaUno];
}
                            
                            // Pass objects from array to empleados array
                            
                            _timeNameArray = empleados;
                            
                            // Very important!!! makes the app going trhu their thread life, since has a block to achieve the function this kind of bypass it to the normal thrad cycle
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.timeTableView reloadData];
                            });
                            
                        }
                    }else{
                        NSLog(@"Error %@", error);
                    }
                    
                    
                }] resume];
}




#pragma mark TableView Methods

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
//    cell.diaUnoLabel.text =empleado.dia1;
    
    return cell;

}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Empleado* articulo;
    
    articulo= [_timeNameArray objectAtIndex:indexPath.row];
    
    
    [self performSegueWithIdentifier:@"showtimeshift" sender:articulo];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{if ([[segue identifier] isEqualToString:@"showtimeshift"]){
    
    // Get reference to the destination view controller
    TimeTableCollectionViewController *vc = [segue destinationViewController];
    
    // Pass any objects to the view controller here, like...
    vc.empleado = (Empleado *)sender;
    
    
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
