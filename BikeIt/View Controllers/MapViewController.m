//
//  MapViewController.m
//  BikeIt
//
//  Created by Kevin Li on 7/25/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () {
    MBProgressHUD *HUD;
    StationList *stationList;
    NSArray *stationData;
    int foundLocation;
    float oldLocLat;
    float oldLocLong;
}

@property (retain, nonatomic) IBOutlet MKMapView *stationMap;

- (void)zoomAndCenterMap;

- (void)addPins;

- (IBAction)refreshData:(id)sender;

- (void)returnFromClose;

@end

@implementation MapViewController

@synthesize stationMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // set an impossible coordinate for validation
    oldLocLat = 999;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnFromClose) name:@"appReturn" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    // zoom into location
    [self zoomAndCenterMap];
    
    // load data
    stationList = [[StationList alloc]init];
    stationList.delegate = self;
    [stationList loadBikeData:self.view];
    
}

- (void)returnFromClose {
    // reload data
    [self refreshData:nil];
}

#pragma mark - Map view methods
- (void)zoomAndCenterMap {
    // zoom and center the map on the user's current location
    CLLocationCoordinate2D centerLocation;
    if (self.stationMap.userLocation.location != nil) {
        // user has allowed the app access to their location
        centerLocation = self.stationMap.userLocation.location.coordinate;
    }
    else {
        // user didn't allow access, default to a location in the city (or location failed)
        centerLocation.longitude = -77.009098f;
        centerLocation.latitude = 38.889914f;
    }
    
    
    [self.stationMap setRegion:MKCoordinateRegionMake(centerLocation, MKCoordinateSpanMake(0.01f, 0.01f))];
}

- (void)addPins {
    // delete any pins that currently exist (except for the user's location indicator)
    NSMutableArray *removeArray = [NSMutableArray arrayWithArray:self.stationMap.annotations];
    [removeArray removeObject:self.stationMap.userLocation];
    [self.stationMap removeAnnotations:removeArray];

    // loop through station data and add pins
    for (int i = 0; i < [stationData count]; i++) {
        StationModel *stationItem = [stationData objectAtIndex:i];
        
        BikeAnnotation *stationPoint = [[BikeAnnotation alloc]init];
        stationPoint.coordinate = CLLocationCoordinate2DMake(stationItem.latitude, stationItem.longitude);
        stationPoint.title = stationItem.name;
        stationPoint.subtitle = [NSString stringWithFormat:@"Available bikes: %i   Available docks: %i",stationItem.bikes, stationItem.docks];
        stationPoint.percentAvailable = ((float)stationItem.bikes / (float)(stationItem.bikes + stationItem.docks));
        stationPoint.bikeLabel = stationItem.bikes;
                
        [self.stationMap addAnnotation:stationPoint];
    }
}

- (IBAction)refreshData:(id)sender {
    // refresh the data
    [self zoomAndCenterMap];
    [stationList loadBikeData:self.view];
}

// delegate method: zoom/center to user location
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    // check if a previous location was stored before
    // if so and minimal changes have occurred, don't reload
    
    if (oldLocLat != 999) {
        // a previous location exists
        CLLocation *oldLocation = [[CLLocation alloc]initWithLatitude:oldLocLat longitude:oldLocLong];
        CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        
        // only recenter if more than 200 m difference
        if ([oldLocation distanceFromLocation:newLocation] >= 200.0f) {
            [self zoomAndCenterMap];
            // save the new location
            
            oldLocLat = userLocation.coordinate.latitude;
            oldLocLong = userLocation.coordinate.longitude;
        }
        oldLocation = nil;
        newLocation = nil;
    }
    else {
        [self zoomAndCenterMap];
        // save the new location
        oldLocLat = userLocation.coordinate.latitude;
        oldLocLong = userLocation.coordinate.longitude;
    }
   
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[BikeAnnotation class]]) {
        BikeAnnotation *bikeAnnotationData = (BikeAnnotation *)annotation;
        MKAnnotationView *annotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"bikestation"];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"bikestation"];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            
            
            // add a label showing available bikes
            UILabel *bikeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 , 15, 15)];
            [bikeLabel setTextAlignment:NSTextAlignmentCenter];
            [bikeLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:12.0f]];
            [bikeLabel setTag:53];
            [annotationView addSubview:bikeLabel];
            
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.image = [UIImage imageNamed:[bikeAnnotationData imageName]];
        UILabel *bikeLabel = (UILabel *)[annotationView viewWithTag:53];
        [bikeLabel setText:[NSString stringWithFormat:@"%i",bikeAnnotationData.bikeLabel]];
        if (bikeAnnotationData.bikeLabel > 9) {
            // move the label over a bit little
            [bikeLabel setFrame:CGRectMake(9, 10 , 15, 15)];
        }
        
        return annotationView;
    }
    else {
        return nil;
    }
}


#pragma mark -
#pragma mark Station List delegate methods
- (void)receivedBikeData:(NSArray *)parsedArray {
    // received bike data
    stationData = [NSArray arrayWithArray:parsedArray];
    [self addPins];
}

- (void)bikeDataError {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // show error message
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.detailsLabelText = @"Station map data could not be loaded.";
    [self.view addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:3];

}

#pragma mark - HUD delegate
- (void) hudWasHidden:(MBProgressHUD *)hud {
    [HUD removeFromSuperview];
	HUD = nil;
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueToTrends"]) {
        // about to display trends
        // pass over station data
        // the destination view controller is actually the underlying navigation controller
        NavigationViewController *navController = (NavigationViewController *)segue.destinationViewController;
        // we need to access its top view controller to set the station list object
        [(TrendsViewController *)navController.topViewController setStationDataList:stationList];
        
        // also pass over user location
        CLLocationCoordinate2D currentLocation;
        if (self.stationMap.userLocation.location != nil) {
            currentLocation = self.stationMap.userLocation.location.coordinate;
        }
        else {
            // user didn't allow access, default to a location in the city (or location failed)
            currentLocation.longitude = -77.009098f;
            currentLocation.latitude = 38.889914f;
        }
        [(TrendsViewController *)navController.topViewController setUserLocation:currentLocation];
        
        // remove HUDs
        if ([MBProgressHUD HUDForView:self.view] != nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    }
}
@end

