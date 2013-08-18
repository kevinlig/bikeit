//
//  NeighborhoodCell.h
//  BikeIt
//
//  Created by Kevin Li on 7/29/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeighborhoodCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *availability;
@property (nonatomic, strong) IBOutlet UIImageView *availImage;
@property (nonatomic, strong) IBOutlet UILabel *trendText;
@property (nonatomic, strong) IBOutlet UIImageView *trendImage;
@property (nonatomic, strong) IBOutlet UILabel *stationCount;

@end
