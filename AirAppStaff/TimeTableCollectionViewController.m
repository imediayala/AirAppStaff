//
//  TimeTableCollectionViewController.m
//  AirAppStaff
//
//  Created by Daniel on 15/06/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "TimeTableCollectionViewController.h"
#import "ShiftsCollectionViewCell.h"
#import "Empleado.h"


@interface TimeTableCollectionViewController ()

@end


@implementation TimeTableCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
//    [_shiftsArray  addObject:_shifts.dia];
    
    NSMutableArray* turnosArray = [[NSMutableArray alloc] init];

    
    // Fill my new Array with the objects from the data model
    
    
//    [turnosArray insertObject:_empleado.dia1 atIndex:0];
    
    [turnosArray addObject:_empleado.dia1];
    [turnosArray addObject:_empleado.dia2];
    [turnosArray addObject:_empleado.dia3];
    [turnosArray addObject:_empleado.dia4];
    [turnosArray addObject:_empleado.dia5];
    [turnosArray addObject:_empleado.dia6];
    [turnosArray addObject:_empleado.dia7];
    [turnosArray addObject:_empleado.dia8];
    [turnosArray addObject:_empleado.dia9];
    [turnosArray addObject:_empleado.dia10];
    [turnosArray addObject:_empleado.dia11];
    [turnosArray addObject:_empleado.dia12];
    [turnosArray addObject:_empleado.dia13];
    [turnosArray addObject:_empleado.dia14];
    [turnosArray addObject:_empleado.dia15];
    [turnosArray addObject:_empleado.dia16];
    [turnosArray addObject:_empleado.dia17];
    [turnosArray addObject:_empleado.dia18];
    [turnosArray addObject:_empleado.dia19];
    [turnosArray addObject:_empleado.dia20];
    [turnosArray addObject:_empleado.dia21];
    [turnosArray addObject:_empleado.dia22];
    [turnosArray addObject:_empleado.dia23];
    [turnosArray addObject:_empleado.dia24];
    [turnosArray addObject:_empleado.dia25];
    [turnosArray addObject:_empleado.dia26];
    [turnosArray addObject:_empleado.dia27];
    [turnosArray addObject:_empleado.dia28];
    [turnosArray addObject:_empleado.dia29];
    [turnosArray addObject:_empleado.dia30];
    [turnosArray addObject:_empleado.dia31];



    

//    [turnosArray insertObject:_shifts atIndex:2];
//    [turnosArray insertObject:_shifts atIndex:3];
//    [turnosArray insertObject:_shifts atIndex:4];
//    [turnosArray insertObject:_shifts atIndex:5];
//    [turnosArray insertObject:_shifts atIndex:6];
//    [turnosArray insertObject:_shifts atIndex:7];
//    [turnosArray insertObject:_shifts atIndex:8];
//    [turnosArray insertObject:_shifts atIndex:9];
//    [turnosArray insertObject:_shifts atIndex:10];
//    [turnosArray insertObject:_shifts atIndex:11];
//    [turnosArray insertObject:_shifts atIndex:12];
//    [turnosArray insertObject:_shifts atIndex:13];
//    [turnosArray insertObject:_shifts atIndex:14];
//    [turnosArray insertObject:_shifts atIndex:15];
//    [turnosArray insertObject:_shifts atIndex:16];
//    [turnosArray insertObject:_shifts atIndex:17];
//    [turnosArray insertObject:_shifts atIndex:18];
//    [turnosArray insertObject:_shifts atIndex:19];
//    [turnosArray insertObject:_shifts atIndex:20];
//    [turnosArray insertObject:_shifts atIndex:21];
//    [turnosArray insertObject:_shifts atIndex:22];
//    [turnosArray insertObject:_shifts atIndex:23];
//    [turnosArray insertObject:_shifts atIndex:24];
//    [turnosArray insertObject:_shifts atIndex:25];
//    [turnosArray insertObject:_shifts atIndex:26];
//    [turnosArray insertObject:_shifts atIndex:27];
//    [turnosArray insertObject:_shifts atIndex:28];
//    [turnosArray insertObject:_shifts atIndex:29];
//    [turnosArray insertObject:_shifts atIndex:30];
//    [turnosArray insertObject:_shifts atIndex:31];
//    [turnosArray insertObject:_shifts atIndex:32];


    

  
    _shiftsArray= turnosArray;
    

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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_shiftsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    ShiftsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainCell"forIndexPath:indexPath];
    

    
//    worker = [_ objectAtIndex:indexPath.row];
    
//    turnosArray = [[NSMutableArray alloc] init];

//
//    NSString *animal = [_shiftsArray objectAtIndex:indexPath.row];
//
//    
//    cell.diaUnoLabel.text = animal;
//    cell.diaDosLabel.text = worker.dia2;
    
    
    cell.turnoLabel.text = _shiftsArray[indexPath.row];
    
    cell.diaLabel.text = [NSString stringWithFormat:@"Día %ld", indexPath.row +1];

//
//    if (indexPath.row< _shiftsArray.count) {
//        cell.diaUnoLabel.text = group.dia1;
//        cell.diaDosLabel.text = group.dia2;
//
//
//    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
