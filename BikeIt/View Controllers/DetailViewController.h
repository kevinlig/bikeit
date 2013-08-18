//
//  DetailViewController.h
//  BikeIt
//
//  Created by Kevin Li on 8/4/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "StationCell.h"
#import "StationList.h"
#import "MBProgressHUD.h"

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property int showBikes;
@property int orderDistance;
@property CLLocationCoordinate2D userLocation;
@property (nonatomic, strong) NeighborhoodModel *neighborhoodData;
@property (nonatomic, strong) NSDictionary *stationDictionary;
@property int trendGeneratedTime;

@end
