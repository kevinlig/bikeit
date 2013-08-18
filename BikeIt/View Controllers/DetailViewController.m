//
//  DetailViewController.m
//  BikeIt
//
//  Created by Kevin Li on 8/4/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () {
    MBProgressHUD *HUD;
    NSMutableArray *stationArray;
    IBOutlet UIView *zeroView;
    IBOutlet UILabel *zeroLabel;
}

@property (nonatomic, strong) IBOutlet UILabel *neighborhoodNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *availabilityIcon;
@property (nonatomic, strong) IBOutlet UILabel *availabilityLabel;
@property (nonatomic, strong) IBOutlet UILabel *stationCount;
@property (nonatomic, strong) IBOutlet UIImageView *trendIcon;
@property (nonatomic, strong) IBOutlet UILabel *trendDescription;
@property (nonatomic, strong) IBOutlet UITableView *stationTable;

- (void)sortByDistance:(NSMutableArray *)array;
- (void)sortByName:(NSMutableArray *)array;

- (void)returnFromClose;

@end

@implementation DetailViewController

@synthesize neighborhoodNameLabel, availabilityIcon, availabilityLabel, stationCount, trendIcon, trendDescription, stationTable;
@synthesize neighborhoodData, showBikes, orderDistance, userLocation, stationDictionary, trendGeneratedTime;

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
    
    // set fonts
    [neighborhoodNameLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16.0]];
    [availabilityLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14.0]];
    [trendDescription setFont:[UIFont fontWithName:@"Lato-Regular" size:12.0]];
    [stationCount setFont:[UIFont fontWithName:@"Lato-Light" size:12.0]];
    [stationTable setSeparatorColor:[UIColor colorWithRed:(207.0f/255.0f) green:(207.0f/255.0f) blue:(207.0f/255.0f) alpha:1]];
    [zeroLabel setFont:[UIFont fontWithName:@"Lato-Light" size:16.0]];
    

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnFromClose) name:@"appReturn" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    // set content
    neighborhoodNameLabel.text = neighborhoodData.name;
    self.navigationItem.title = neighborhoodData.name;   

    NSString *displayAvailability;
    if (showBikes == 1) {
        displayAvailability = [NSString stringWithFormat:@"%@ bike availability",neighborhoodData.bikeAvailability];
    }
    else {
        displayAvailability = [NSString stringWithFormat:@"%@ dock availability",neighborhoodData.dockAvailability];
    }
    availabilityLabel.text = displayAvailability;
    
    NSString *availImage;
    if (showBikes == 1) {
        availImage = [NSString stringWithFormat:@"avail-%@",[neighborhoodData.bikeAvailability lowercaseString]];
    }
    else {
        availImage = [NSString stringWithFormat:@"avail-%@",[neighborhoodData.dockAvailability lowercaseString]];
    }
    availabilityIcon.image = [UIImage imageNamed:availImage];
    
    NSString *trendText;
    if (showBikes == 1) {
        trendText = [NSString stringWithFormat:@"Availability is %@",[neighborhoodData.bikeTrend lowercaseString]];
    }
    else {
        trendText = [NSString stringWithFormat:@"Availability is %@",[neighborhoodData.dockTrend lowercaseString]];
    }
    trendDescription.text = trendText;
    
    NSString *imageName;
    if (showBikes == 1) {
        imageName = [NSString stringWithFormat:@"bike_%i",neighborhoodData.bikeTrendIcon];
    }
    else {
        imageName = [NSString stringWithFormat:@"dock_%i",neighborhoodData.bikeTrendIcon];
    }
    trendIcon.image = [UIImage imageNamed:imageName];
    
    NSString *stationCountText;
    if ([neighborhoodData.stationArray count] != 1) {
        stationCountText = [NSString stringWithFormat:@"%i stations",[neighborhoodData.stationArray count]];
    }
    else {
        stationCountText = [NSString stringWithFormat:@"%i station",[neighborhoodData.stationArray count]];
    }
    stationCount.text = stationCountText;
    
    // populate station array
    stationArray = [NSMutableArray array];
    
    int errorCount = 0;

    for (int i = 0; i < [neighborhoodData.stationArray count]; i++) {
        NSString *stationId = [neighborhoodData.stationArray objectAtIndex:i];
        if ([stationDictionary objectForKey:stationId] != nil) {
            [stationArray addObject:[stationDictionary objectForKey:stationId]];
        }
        else {
            errorCount++;
        }
    }
    

    if (errorCount == 0) {
        if (zeroView.hidden == NO) {
            [zeroView setHidden:YES];
        }
                
        // order station by distance or name
        if (orderDistance == 1) {
            [self sortByDistance:stationArray];
        }
        else {
            [self sortByName:stationArray];
        }
    }
    else {
        neighborhoodData.stationArray = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // show error message
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.detailsLabelText = @"Station data could not be loaded.";
        [self.view addSubview:HUD];
        [HUD show:YES];
        [zeroView setHidden:NO];
        [HUD hide:YES afterDelay:3];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)returnFromClose {
    // go back to neighborhood list
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Sort array
- (void)sortByDistance: (NSMutableArray *)array {
    
    // sort the array by location
    CLLocation *compareUserLocation = [[CLLocation alloc]initWithLatitude:userLocation.latitude longitude:userLocation.longitude];
    [array sortUsingComparator:^NSComparisonResult(id item1, id item2) {
        
        CLLocation *location1 = [[CLLocation alloc]initWithLatitude:[(StationModel *)item1 latitude] longitude:[(StationModel *)item1 longitude]];
        CLLocation *location2 = [[CLLocation alloc]initWithLatitude:[(StationModel *)item2 latitude] longitude:[(StationModel *)item2 longitude]];
        
        CLLocationDistance distance1 = [location1 distanceFromLocation:compareUserLocation];
        CLLocationDistance distance2 = [location2 distanceFromLocation:compareUserLocation];
        
        // dealloc from memory
        location1 = nil;
        location2 = nil;
        
        return distance1 < distance2 ? NSOrderedAscending : distance1 > distance2 ? NSOrderedDescending : NSOrderedSame;
    }];
    
    compareUserLocation = nil;
    
    [stationTable reloadData];
}

- (void)sortByName: (NSMutableArray *)array {
       
    
    // sort the array by name
    [array sortUsingComparator:^NSComparisonResult(id item1, id item2) {
        
        NeighborhoodModel *firstItem = (NeighborhoodModel *)item1;
        NeighborhoodModel *secondItem = (NeighborhoodModel *)item2;
        
        NSComparisonResult compareResult = [firstItem.name compare:secondItem.name];
        
        return compareResult;
    }];
    
    [stationTable reloadData];
    
}


#pragma mark - Table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (neighborhoodData == nil || neighborhoodData.stationArray == nil) {
        return 0;
    }
    else {
        return [neighborhoodData.stationArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StationCell *cell = (StationCell *)[tableView dequeueReusableCellWithIdentifier:@"StationCell"];
    
    if (cell == nil) {
        cell = [[StationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NeighborCell"];
    }
    
    // get station data
    StationModel *stationItem = [stationArray objectAtIndex:[indexPath row]];
    // set availability text
    NSString *availabilityText;
    NSString *bikeNumberText;
    NSString *dockNumberText;
    if (stationItem.bikes != 1) {
        bikeNumberText = [NSString stringWithFormat:@"%i bikes",stationItem.bikes];
    }
    else {
        bikeNumberText = [NSString stringWithFormat:@"%i bike",stationItem.bikes];
    }
    if (stationItem.docks != 1) {
        dockNumberText = [NSString stringWithFormat:@"%i docks",stationItem.docks];
    }
    else {
        dockNumberText = [NSString stringWithFormat:@"%i dock",stationItem.docks];
    }
    if (showBikes == 1) {
        availabilityText = [NSString stringWithFormat:@"%@ / %@",bikeNumberText,dockNumberText];
    }
    else {
        availabilityText = [NSString stringWithFormat:@"%@ / %@",dockNumberText,bikeNumberText];
    }
    // set availability icon
    NSString *availIcon;
    if (showBikes == 1) {
        availIcon = [NSString stringWithFormat:@"avail-%@",[stationItem.bikeAvailability lowercaseString]];
    }
    else {
        availIcon = [NSString stringWithFormat:@"avail-%@",[stationItem.dockAvailability lowercaseString]];
    }
    // set trend icon
    NSString *trendIconName;
    if (showBikes == 1) {
        trendIconName = [NSString stringWithFormat:@"bike_%i",stationItem.bikeTrendIcon];
    }
    else {
        trendIconName = [NSString stringWithFormat:@"dock_%i",stationItem.bikeTrendIcon];
    }
    // set trend description
    NSString *trendText;
    if (showBikes == 1) {
        trendText = [NSString stringWithFormat:@"Availability is %@",[stationItem.bikeTrend lowercaseString]];
    }
    else {
        trendText = [NSString stringWithFormat:@"Availability is %@",[stationItem.dockTrend lowercaseString]];
    }
    // set prediction header block
    NSString *predictionHeaderText;
    // format time (10 minutes into future from time of JSON generation)
    NSDate *predictedTime = [NSDate dateWithTimeIntervalSince1970:(trendGeneratedTime + 600)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"h:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    predictionHeaderText = [NSString stringWithFormat:@"Predicted availability at %@:",[dateFormatter stringFromDate:predictedTime]];
    dateFormatter = nil;
    
    // set prediction text
    NSString *predictionText;
    NSString *predictBike;
    NSString *predictDock;
    int totalCapacity = stationItem.bikes + stationItem.docks;
    int futureBikes = stationItem.bikeForecast;
    int futureDocks = totalCapacity - (stationItem.bikeForecast);
    
    if (futureDocks < 0) {
        // negative dock, make zero
        futureBikes = futureBikes + abs(futureDocks);
        futureDocks = 0;
    }
    
    if (futureBikes != 1) {
        predictBike = [NSString stringWithFormat:@"%i bikes",futureBikes];
    }
    else {
        predictBike = [NSString stringWithFormat:@"%i bike",futureBikes];
    }
    if (futureDocks != 1) {
        predictDock = [NSString stringWithFormat:@"%i docks",futureDocks];
    }
    else {
        predictDock = [NSString stringWithFormat:@"%i dock",futureDocks];
    }
    if (showBikes == 1) {
        predictionText = [NSString stringWithFormat:@"%@ / %@",predictBike,predictDock];
    }
    else {
        predictionText = [NSString stringWithFormat:@"%@ / %@",predictDock,predictBike];
    }
    
    cell.nameLabel.text = stationItem.name;
    cell.availabilityLabel.text = availabilityText;
    cell.availabilityIcon.image = [UIImage imageNamed:availIcon];
    cell.trendIcon.image = [UIImage imageNamed:trendIconName];
    cell.trendDescription.text = trendText;
    cell.predictionHeader.text = predictionHeaderText;
    cell.predictionLabel.text = predictionText;
    
    [cell.nameLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14.0]];
    [cell.availabilityLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:13.0]];
    [cell.trendDescription setFont:[UIFont fontWithName:@"Lato-Regular" size:12.0]];
    [cell.predictionHeader setFont:[UIFont fontWithName:@"Lato-Bold" size:12.0]];
    [cell.predictionLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:12.0]];
    
    return cell;

}

#pragma mark - HUD delegate
- (void) hudWasHidden:(MBProgressHUD *)hud {
    [HUD removeFromSuperview];
	HUD = nil;
}


@end
