//
//  MapViewController.h
//  BikeIt
//
//  Created by Kevin Li on 7/25/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "StationList.h"
#import "BikeAnnotation.h"
#import "NavigationViewController.h"
#import "TrendsViewController.h"
#import "MBProgressHUD.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, MKAnnotation, StationListDelegate, MBProgressHUDDelegate>



@end
