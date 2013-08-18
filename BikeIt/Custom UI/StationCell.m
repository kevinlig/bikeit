//
//  StationCell.m
//  BikeIt
//
//  Created by Kevin Li on 8/4/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import "StationCell.h"

@implementation StationCell

@synthesize nameLabel, availabilityIcon, availabilityLabel, trendIcon, trendDescription, predictionHeader, predictionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
