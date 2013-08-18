//
//  StationCell.h
//  BikeIt
//
//  Created by Kevin Li on 8/4/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *availabilityIcon;
@property (nonatomic, strong) IBOutlet UILabel *availabilityLabel;
@property (nonatomic, strong) IBOutlet UIImageView *trendIcon;
@property (nonatomic, strong) IBOutlet UILabel *trendDescription;
@property (nonatomic, strong) IBOutlet UILabel *predictionHeader;
@property (nonatomic, strong) IBOutlet UILabel *predictionLabel;

@end
