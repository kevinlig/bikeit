//
//  NeighborhoodModel.h
//  BikeIt
//
//  Created by Kevin Li on 7/29/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeighborhoodModel : NSObject

@property (nonatomic, strong) NSString *name;
@property float latitude;
@property float longitude;
@property (nonatomic, strong) NSString *bikeAvailability;
@property (nonatomic, strong) NSString *bikeTrend;
@property int bikeTrendIcon;
@property (nonatomic, strong) NSString *dockAvailability;
@property (nonatomic, strong) NSString *dockTrend;
@property NSArray *stationArray;


@end
