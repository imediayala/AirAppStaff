//
//  HomeTableViewCell.h
//  AirAppStaff
//
//  Created by Daniel on 13/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextView *solicitaLabel;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *userPictureImage;

@property (strong, nonatomic) IBOutlet UIImageView *priorityColorIndicator;

@property (strong, nonatomic) IBOutlet UILabel *priorityIndicatorLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
