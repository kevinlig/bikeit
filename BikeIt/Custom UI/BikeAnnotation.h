//
//  BikeAnnotation.h
//  BikeIt
//
//  Created by Kevin Li on 7/26/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface BikeAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property float percentAvailable;
@property int bikeLabel;

- (NSString *)imageName;

@end
