//
//  TimeTableDataSource.m
//  AirAppStaff
//
//  Created by Daniel on 13/06/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "Empleado.h"

@implementation Empleado


- (instancetype)initWithName:(NSString *)aName{

    self = [super init];
    if (self) {
        self.name = aName;
    }
    return self;


}


@end
