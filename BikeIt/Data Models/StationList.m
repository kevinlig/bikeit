//
//  StationList.m
//  BikeIt
//
//  Created by Kevin Li on 7/25/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import "StationList.h"


@interface StationList () {
    SMXMLDocument *xmlDocument;
    
}

@property (nonatomic, strong) NSMutableArray *stationArray;
@property (nonatomic, strong) UIView *masterView;

- (void)beginDownload;
- (void)beginTrendDownload;
- (void)appUpdate:(NSString *)message;


@end

@implementation StationList

@synthesize stationList, stationDictionary, stationArray, neighborhoodArray, generatedTimecode, masterView, delegate, trendDelegate;

- (id)init {
    // create objects
    return self;
}

- (void)beginDownload {
    DataDownloader *downloader = [[DataDownloader alloc]init];
    downloader.delegate = self;
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [downloader downloadBikeData];
}

- (void)beginTrendDownload {
    DataDownloader *downloader = [[DataDownloader alloc]init];
    downloader.delegate = self;
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [downloader downloadTrendData];
}

- (void)loadBikeData: (UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    masterView = view;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self beginDownload];
    });
}

- (void)loadTrendData: (UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    masterView = view;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self beginTrendDownload];
    });
}


#pragma mark - Data Download delegates

- (void)receivedData:(NSData *)serverData {
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [MBProgressHUD hideHUDForView:masterView animated:YES];
    // receive server data
    // parse it
    NSError *error;
    xmlDocument = [SMXMLDocument documentWithData:serverData error:&error];
    if (error != nil) {
        // an error has occurred
        [self fetchFailed];
        return;
    }

    
    stationArray = [NSMutableArray array];
    // we need to create a dictionary so we can get a specific station later on just via the ID number
    // station ID numbers are non-consecutive with skips, so an array index may result in an unnecessarily large
    // array
    stationDictionary = [NSMutableDictionary dictionary];
    
    SMXMLElement *stationParent = xmlDocument.root;
    // loop through parent to get all stations
    for (SMXMLElement *station in [stationParent childrenNamed:@"station"]) {
        
        // create a temporary instance of the data model
        StationModel *tempModel = [[StationModel alloc]init];
        
        // populate the data model
        [tempModel setBikes:[[station valueWithPath:@"nbBikes"]intValue]];
        [tempModel setDocks:[[station valueWithPath:@"nbEmptyDocks"]intValue]];
        [tempModel setLatitude:[[station valueWithPath:@"lat"]floatValue]];
        [tempModel setLongitude:[[station valueWithPath:@"long"]floatValue]];
        [tempModel setName:[station valueWithPath:@"name"]];
        [tempModel setStationId:[[station valueWithPath:@"id"]intValue]];
        
        // add data model to array
        [stationArray addObject:tempModel];
        
        // add data model to dictionary
        [stationDictionary setObject:tempModel forKey:[station valueWithPath:@"id"]];
        
        // we're done with the temporary instance, remove it from memory
        tempModel = nil;
    }
    
    // we're done, pass it back to delegate
    [delegate receivedBikeData:(NSArray *)stationArray];
    stationList = [NSArray arrayWithArray:stationArray];
    
    
}

- (void)receivedTrendData:(NSData *)serverData {
    // received the JSON data

    // parse it
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:serverData options:NSJSONReadingAllowFragments error:&error];
    if (error != nil) {
        [self fetchFailed];
        return;
    }
    
    neighborhoodArray = [NSMutableArray array];
    //NSLog(@"%@",[jsonDictionary objectForKey:@"generated"]);
    // check if API has changed
    if ([jsonDictionary objectForKey:@"deprecated"] != nil) {
        // if the JSON reports it is deprecated, force the user to upgrade their app
        // most likely URL or JSON structure has changed, so app would crash otherwise
        [self appUpdate:[jsonDictionary objectForKey:@"deprecated"]];
        return;
    }
    
    generatedTimecode = [[jsonDictionary objectForKey:@"time"]intValue];
    
    NSArray *neighborhoods = (NSArray *)[jsonDictionary objectForKey:@"neighborhoods"];
    // loop through neighborhoods
    for (NSDictionary *neighborhood in neighborhoods) {
        
        // create a temporary instance of the data model
        NeighborhoodModel *tempModel = [[NeighborhoodModel alloc]init];

        // populate the model
        [tempModel setName:[neighborhood objectForKey:@"name"]];
        [tempModel setLatitude:[[neighborhood objectForKey:@"latitude"]floatValue]];
        [tempModel setLongitude:[[neighborhood objectForKey:@"longitude"]floatValue]];
        
        NSDictionary *bikeTextBlock = [neighborhood objectForKey:@"bikeText"];
        [tempModel setBikeAvailability:[bikeTextBlock objectForKey:@"availability"]];
        [tempModel setBikeTrend:[bikeTextBlock objectForKey:@"trend"]];
        [tempModel setBikeTrendIcon:[[bikeTextBlock objectForKey:@"programmaticReference"]intValue]];
        
        bikeTextBlock = nil;
        
        NSDictionary *dockTextBlock = [neighborhood objectForKey:@"dockText"];
        [tempModel setDockAvailability:[dockTextBlock objectForKey:@"availability"]];
        [tempModel setDockTrend:[dockTextBlock objectForKey:@"trend"]];
        
        dockTextBlock = nil;
        
        // loop through station information
        NSMutableArray *stationIdArray = [NSMutableArray array];
        NSArray *stations = [neighborhood objectForKey:@"stations"];
        for (NSDictionary *stationItem in stations) {
            // add the station ID to the array of IDs
            [stationIdArray addObject:[stationItem objectForKey:@"id"]];
            
            // get the station data model from the station dictionary
            StationModel *stationModelObj = [stationDictionary objectForKey:[stationItem objectForKey:@"id"]];
            
            // parse the station trend data and add it to the data model
            NSDictionary *bikeTextBlock = [stationItem objectForKey:@"bikeText"];
            [stationModelObj setBikeAvailability:[bikeTextBlock objectForKey:@"availability"]];
            [stationModelObj setBikeTrend:[bikeTextBlock objectForKey:@"trend"]];
            [stationModelObj setBikeTrendIcon:[[bikeTextBlock objectForKey:@"programmaticReference"]intValue]];
            [stationModelObj setBikeForecast:[[bikeTextBlock objectForKey:@"forecast"]intValue]];
            
            bikeTextBlock = nil;
            
            NSDictionary *dockTextBlock = [stationItem objectForKey:@"dockText"];
            [stationModelObj setDockAvailability:[dockTextBlock objectForKey:@"availability"]];
            [stationModelObj setDockTrend:[dockTextBlock objectForKey:@"trend"]];
            
            dockTextBlock = nil;
            
            // save the model back into the station dictionary
            [stationDictionary setObject:stationModelObj forKey:[stationItem objectForKey:@"id"]];

        }
        
        // add the station ID array back into the data model
        [tempModel setStationArray:stationIdArray];
        
        // add data model to array
        [neighborhoodArray addObject:tempModel];
        
        // we're done with the temporary instance, remove it from memory
        tempModel = nil;
        
    }
    
    // hide HUDs - removed, need to wait for sorting to finish first
//    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
//    [MBProgressHUD hideHUDForView:masterView animated:YES];
    
    [trendDelegate receivedTrendData:neighborhoodArray];
    
    
}

- (void)fetchFailed {
    // tell delegate an error occurred
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [delegate bikeDataError];
}

- (void)trendFetchFailed {
    // tell delegate an error occurred
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [trendDelegate trendDataError];
}

- (void)appUpdate:(NSString *)message {
    // breaking changes have occurred in the API, require an app update
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [trendDelegate trendUpdateRequired:message];
}

@end
