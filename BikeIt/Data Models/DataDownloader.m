//
//  DCDownloader.m
//  BikeIt
//
//  Created by Kevin Li on 7/25/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import "DataDownloader.h"

@implementation DataDownloader

@synthesize delegate;

- (void)downloadBikeData {
    // download the Capital Bikeshare XML file
    NSURL *dataUrl = [NSURL URLWithString:@"http://capitalbikeshare.com/data/stations/bikeStations.xml"];


    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:dataUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *returnData, NSError *error) {
        if (returnData != nil && error == nil) {
            // success
            [delegate receivedData:returnData];
        }
        else {
            // failed
            [delegate fetchFailed];
        }
    }];
}

- (void)downloadTrendData {
    // download the trends JSON file
    NSURL *dataUrl = [NSURL URLWithString:@"[redacted]"];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:dataUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *returnData, NSError *error) {
        if (returnData != nil && error == nil) {
            // success
            [delegate receivedTrendData:returnData];
        }
        else {
            // failed
            [delegate trendFetchFailed];
        }
    }];
}


@end
