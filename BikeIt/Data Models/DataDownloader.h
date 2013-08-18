//
//  DCDownloader.h
//  BikeIt
//
//  Created by Kevin Li on 7/25/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataDownloaderDelegate <NSObject>

- (void)receivedData:(NSData *)serverData;
- (void)fetchFailed;
- (void)trendFetchFailed;

- (void)receivedTrendData:(NSData *)serverData;

@end

@interface DataDownloader : NSObject

@property (nonatomic, strong) id <DataDownloaderDelegate> delegate;

- (void)downloadBikeData;
- (void)downloadTrendData;

@end

