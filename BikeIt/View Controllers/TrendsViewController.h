//
//  TrendsViewController.h
//  BikeIt
//
//  Created by Kevin Li on 7/25/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "StationList.h"
#import "NeighborhoodCell.h"
#import "DetailViewController.h"
#import "MBProgressHUD.h"

@interface TrendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, StationTrendDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) IBOutlet UITableView *trendTable;
@property (nonatomic, strong) StationList *stationDataList;
@property (nonatomic, strong) NSArray *trendList;
@property CLLocationCoordinate2D userLocation;

@end
