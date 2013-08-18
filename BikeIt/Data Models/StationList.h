//
//  StationList.h
//  BikeIt
//
//  Created by Kevin Li on 7/25/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataDownloader.h"
#import "SMXMLDocument.h"
#import "StationModel.h"
#import "NeighborhoodModel.h"
#import "MBProgressHUD.h"

@protocol StationListDelegate <NSObject>

- (void)receivedBikeData:(NSArray *)parsedArray;
- (void)bikeDataError;

@end

@protocol StationTrendDelegate <NSObject>

- (void)receivedTrendData:(NSArray *)parsedArray;
- (void)trendDataError;
- (void)trendUpdateRequired:(NSString *)message;


@end

@interface StationList : NSObject <DataDownloaderDelegate>

@property (nonatomic, strong) NSArray *stationList;
@property (nonatomic, strong) NSMutableDictionary *stationDictionary;
@property (nonatomic, strong) NSMutableArray *neighborhoodArray;
@property int generatedTimecode;
@property (nonatomic, strong) id <StationListDelegate> delegate;
@property (nonatomic, strong) id <StationTrendDelegate> trendDelegate;

- (void)loadBikeData: (UIView *)view;

- (void)loadTrendData: (UIView *)view;

@end
