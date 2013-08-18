//
//  BikeAnnotation.m
//  BikeIt
//
//  Created by Kevin Li on 7/26/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import "BikeAnnotation.h"

@interface BikeAnnotation ()

@end

@implementation BikeAnnotation

@synthesize title, subtitle, coordinate, percentAvailable, bikeLabel;

- (NSString *)imageName {
    // return an image name based on the current percent available
    int percentName = 100;
    
    if (percentAvailable >= 0.92f) {
        percentName = 100;
    }
    else if (percentAvailable >= 0.83f) {
        percentName = 87;
    }
    else if (percentAvailable >= 0.70f) {
        percentName = 75;
    }
    else if (percentAvailable >= 0.55f) {
        percentName = 63;
    }
    else if (percentAvailable >= 0.45f) {
        percentName = 50;
    }
    else if (percentAvailable >= 0.30f) {
        percentName = 37;
    }
    else if (percentAvailable >= 0.18f) {
        percentName = 25;
    }
    else if (percentAvailable >= 0.08f) {
        percentName = 13;
    }
    else {
        percentName = 0;
    }
    
    return [NSString stringWithFormat:@"annotation_%i",percentName];

}

@end
