//
//  TimeTableCollectionViewController.h
//  AirAppStaff
//
//  Created by Daniel on 15/06/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Empleado.h"

@interface TimeTableCollectionViewController : UICollectionViewController

@property (strong, nonatomic) Empleado * shifts;

@end
