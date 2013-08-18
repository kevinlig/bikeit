//
//  NeighborhoodCell.m
//  BikeIt
//
//  Created by Kevin Li on 7/29/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import "NeighborhoodCell.h"

@implementation NeighborhoodCell

@synthesize name, availability, availImage, trendText, trendImage, stationCount;

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
