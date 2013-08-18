//
//  StationModel.h
//  BikeIt
//
//  Created by Kevin Li on 7/25/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationModel : NSObject

@property int stationId;
@property (nonatomic, strong) NSString *name;
@property float latitude;
@property float longitude;
@property int bikes;
@property int docks;
@property (nonatomic, strong) NSString *bikeAvailability;
@property (nonatomic, strong) NSString *bikeTrend;
@property int bikeTrendIcon;
@property int bikeForecast;
@property (nonatomic, strong) NSString *dockAvailability;
@property (nonatomic, strong) NSString *dockTrend;

@end
