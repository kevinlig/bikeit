//
//  TrendsViewController.m
//  BikeIt
//
//  Created by Kevin Li on 7/25/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import "TrendsViewController.h"

@interface TrendsViewController () {
    MBProgressHUD *HUD;
    IBOutlet UIView *popoverView;
    IBOutlet UIImageView *popoverBackground;
    IBOutlet UILabel *popoverSortLabel;
    IBOutlet UILabel *popoverDataLabel;
    IBOutlet UIButton *popoverSortDistance;
    IBOutlet UIButton *popoverSortName;
    IBOutlet UIButton *popoverDataBikes;
    IBOutlet UIButton *popoverDataDocks;

    IBOutlet UIView *zeroView;
    IBOutlet UILabel *zeroLabel;
    
    int sortDistance;
    int dataBikes;
    int dontReload;
}

- (IBAction)closeTrends:(id)sender;
- (IBAction)displayOptions:(id)sender;

- (void) popoverPrepare;
- (void) togglePopoverButton:(UIButton *)button atSide:(NSString *)side toEnabled:(int)enabled;
- (IBAction)selectDistance:(id)sender;
- (IBAction)selectName:(id)sender;
- (IBAction)selectBikes:(id)sender;
- (IBAction)selectDocks:(id)sender;
- (void)sortByDistance;
- (void)sortByName;
- (void)pullRefresh:(UIRefreshControl *)sender;

- (void)returnFromClose;

@end

@implementation TrendsViewController

@synthesize trendTable, stationDataList, trendList, userLocation;

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
    [popoverView setHidden:YES];
    [trendTable setSeparatorColor:[UIColor colorWithRed:(207.0f/255.0f) green:(207.0f/255.0f) blue:(207.0f/255.0f) alpha:1]];
    stationDataList.trendDelegate = self;
    dontReload = 0;
    [zeroLabel setFont:[UIFont fontWithName:@"Lato-Light" size:16.0]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnFromClose) name:@"appReturn" object:nil];
    
    // pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(pullRefresh:) forControlEvents:UIControlEventValueChanged];
    [trendTable addSubview:refreshControl];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self popoverPrepare];
}

- (void)viewDidAppear:(BOOL)animated {
    if (dontReload != 1) {
        // load trend data
        [stationDataList loadTrendData:self.view];
    }
    else {
        dontReload = 0;
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // detect taps outside of popover view, close automatically
    // popover view fills screen, but is clear
    // if the popover view catches the touch, but it is outside the background frame area, close it
    if (popoverView.isHidden == NO) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:popoverBackground];
        if (!CGRectContainsPoint(popoverBackground.frame, touchPoint)) {
            // outside the background frame
            [UIView
             animateWithDuration:0.25
             delay:0.0
             options:UIViewAnimationOptionAllowUserInteraction
             animations:^{
                 popoverView.alpha = 0.0;
             }
             completion:^(BOOL finished){
                 [popoverView setHidden:YES];
             }];
        }
    }
}

- (IBAction)closeTrends:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)displayOptions:(id)sender {
    if (popoverView.isHidden == NO) {
        // view is displayed, hide it
        [UIView
         animateWithDuration:0.25
         delay:0.0
         options:UIViewAnimationOptionAllowUserInteraction
         animations:^{
             popoverView.alpha = 0.0;
         }
         completion:^(BOOL finished){
             [popoverView setHidden:YES];
         }];
        
    }
    else {
        // display it
         [popoverView setHidden:NO];
        [UIView
         animateWithDuration:0.25
         delay:0.0
         options:UIViewAnimationOptionAllowUserInteraction
         animations:^{
             popoverView.alpha = 1.0;
         }
         completion:nil];
    }
}

- (void)pullRefresh:(UIRefreshControl *)sender; {
    [stationDataList loadTrendData:self.view];
    [sender endRefreshing];
    
}

- (void)returnFromClose {
    // reload data
    [stationDataList loadTrendData:self.view];
}

#pragma mark - Popover methods

-(void)popoverPrepare {
    [popoverSortLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:12.0]];
    [popoverDataLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:12.0]];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"trendSort"]isEqualToString:@"name"]) {
        // user selected sort by name
        sortDistance = 0;
        [self togglePopoverButton:popoverSortDistance atSide:@"left" toEnabled:0];
        [self togglePopoverButton:popoverSortName atSide:@"right" toEnabled:1];
    }
    else {
        sortDistance = 1;
        [self togglePopoverButton:popoverSortDistance atSide:@"left" toEnabled:1];
        [self togglePopoverButton:popoverSortName atSide:@"right" toEnabled:0];
    }
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"trendData"]isEqualToString:@"docks"]) {
        dataBikes = 0;
        [self togglePopoverButton:popoverDataBikes atSide:@"left" toEnabled:0];
        [self togglePopoverButton:popoverDataDocks atSide:@"right" toEnabled:1];
    }
    else {
        dataBikes = 1;
        [self togglePopoverButton:popoverDataBikes atSide:@"left" toEnabled:1];
        [self togglePopoverButton:popoverDataDocks atSide:@"right" toEnabled:0];
    }
}

- (void) togglePopoverButton:(UIButton *)button atSide:(NSString *)side toEnabled:(int)enabled {
    NSMutableString *imageName = [NSMutableString stringWithString:@"seg-button-"];
    [imageName appendString:side];

    UIFont *buttonFont = [UIFont fontWithName:@"Lato-Regular" size:12.0];
    
    if (enabled == 1) {
        [imageName appendString:@"-sel"];
        buttonFont = [UIFont fontWithName:@"Lato-Bold" size:12.0];
    }

    // set the background image
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    
    [button.titleLabel setFont:buttonFont];
    


}
- (IBAction)selectDistance:(id)sender {
    [self togglePopoverButton:sender atSide:@"left" toEnabled:1];
    [self togglePopoverButton:popoverSortName atSide:@"right" toEnabled:0];
    [[NSUserDefaults standardUserDefaults]setObject:@"distance" forKey:@"trendSort"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    sortDistance = 1;
    
    [self sortByDistance];
}
- (IBAction)selectName:(id)sender {
    [self togglePopoverButton:sender atSide:@"right" toEnabled:1];
    [self togglePopoverButton:popoverSortDistance atSide:@"left" toEnabled:0];
    [[NSUserDefaults standardUserDefaults]setObject:@"name" forKey:@"trendSort"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    sortDistance = 0;
    
    [self sortByName];
}

- (IBAction)selectBikes:(id)sender {
    [self togglePopoverButton:sender atSide:@"left" toEnabled:1];
    [self togglePopoverButton:popoverDataDocks atSide:@"right" toEnabled:0];
    [[NSUserDefaults standardUserDefaults]setObject:@"bikes" forKey:@"trendData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    dataBikes = 1;
    
    [trendTable reloadData];
}

- (IBAction)selectDocks:(id)sender {
    [self togglePopoverButton:popoverDataBikes atSide:@"left" toEnabled:0];
    [self togglePopoverButton:sender atSide:@"right" toEnabled:1];
    [[NSUserDefaults standardUserDefaults]setObject:@"docks" forKey:@"trendData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    dataBikes = 0;
    
    [trendTable reloadData];
}

- (void)sortByDistance {
    // received the trend data
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:trendList];
    
    // sort the array by location
    CLLocation *compareUserLocation = [[CLLocation alloc]initWithLatitude:userLocation.latitude longitude:userLocation.longitude];
    [sortedArray sortUsingComparator:^NSComparisonResult(id item1, id item2) {
        
        CLLocation *location1 = [[CLLocation alloc]initWithLatitude:[(NeighborhoodModel *)item1 latitude] longitude:[(NeighborhoodModel *)item1 longitude]];
        CLLocation *location2 = [[CLLocation alloc]initWithLatitude:[(NeighborhoodModel *)item2 latitude] longitude:[(NeighborhoodModel *)item2 longitude]];
        
        CLLocationDistance distance1 = [location1 distanceFromLocation:compareUserLocation];
        CLLocationDistance distance2 = [location2 distanceFromLocation:compareUserLocation];
        
        // dealloc from memory
        location1 = nil;
        location2 = nil;
        
        return distance1 < distance2 ? NSOrderedAscending : distance1 > distance2 ? NSOrderedDescending : NSOrderedSame;
    }];
    
    compareUserLocation = nil;
    
    trendList = [NSArray arrayWithArray:sortedArray];
    
    [trendTable reloadData];
}

- (void)sortByName {
    
    // received the trend data
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:trendList];
    
    // sort the array by name
    [sortedArray sortUsingComparator:^NSComparisonResult(id item1, id item2) {
        
        NeighborhoodModel *firstItem = (NeighborhoodModel *)item1;
        NeighborhoodModel *secondItem = (NeighborhoodModel *)item2;
        
        NSComparisonResult compareResult = [firstItem.name compare:secondItem.name];
        
        return compareResult;
    }];
    
    trendList = [NSArray arrayWithArray:sortedArray];
    
    [trendTable reloadData];
    
}


#pragma mark - Trend delegates

- (void)receivedTrendData:(NSArray *)parsedArray {
    // received the trend data    
    trendList = [NSArray arrayWithArray:parsedArray];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"trendSort"]isEqualToString:@"name"]) {
        // sort by name
        [self sortByName];
        sortDistance = 0;
    }
    else {
        [self sortByDistance];
        sortDistance = 1;
    }
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (zeroView.hidden == NO) {
        [zeroView setHidden:YES];
    }

    
}

- (void)trendDataError {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // show error message
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.detailsLabelText = @"Trend data could not be loaded.";
    [self.view addSubview:HUD];
    [HUD show:YES];
    [zeroView setHidden:NO];
    [HUD hide:YES afterDelay:3];
}

- (void)trendUpdateRequired:(NSString *)message {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // show error message
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"warning"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.detailsLabelText = message;
    [self.view addSubview:HUD];
    [HUD show:YES];
    [zeroView setHidden:NO];
    [HUD hide:YES afterDelay:3];
}

#pragma mark - Table delgates
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (trendList == nil) {
        return 0;
    }
    else {

        return [trendList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NeighborhoodCell *cell = (NeighborhoodCell *)[tableView dequeueReusableCellWithIdentifier:@"NeighborCell"];
    
    if (cell == nil) {
        cell = [[NeighborhoodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NeighborCell"];
    }
    
    NeighborhoodModel *neighborItem = [trendList objectAtIndex:[indexPath row]];
    
    NSString *displayAvailability;
    if (dataBikes == 1) {
        displayAvailability = [NSString stringWithFormat:@"%@ bike",neighborItem.bikeAvailability];
    }
    else {
       displayAvailability = [NSString stringWithFormat:@"%@ dock",neighborItem.dockAvailability];
    }
    
    NSString *availImage;
    if (dataBikes == 1) {
        availImage = [NSString stringWithFormat:@"avail-%@",[neighborItem.bikeAvailability lowercaseString]];
    }
    else {
        availImage = [NSString stringWithFormat:@"avail-%@",[neighborItem.dockAvailability lowercaseString]];
    }
    
    NSString *trendDescription;
    if (dataBikes == 1) {
        trendDescription = [NSString stringWithFormat:@"Availability is %@",[neighborItem.bikeTrend lowercaseString]];
    }
    else {
        trendDescription = [NSString stringWithFormat:@"Availability is %@",[neighborItem.dockTrend lowercaseString]];
    }
    
    NSString *imageName;
    if (dataBikes == 1) {
        imageName = [NSString stringWithFormat:@"bike_%i",neighborItem.bikeTrendIcon];
    }
    else {
        imageName = [NSString stringWithFormat:@"dock_%i",neighborItem.bikeTrendIcon];        
    }
    
    NSString *stationCountText;
    if ([neighborItem.stationArray count] != 1) {
        stationCountText = [NSString stringWithFormat:@"%i stations",[neighborItem.stationArray count]];
    }
    else {
        stationCountText = [NSString stringWithFormat:@"%i station",[neighborItem.stationArray count]];
    }
    
    cell.name.text = neighborItem.name;
    cell.availability.text = [NSString stringWithFormat:@"%@ availability",displayAvailability];
    cell.availImage.image = [UIImage imageNamed:availImage];
    cell.trendText.text = trendDescription;
    cell.trendImage.image = [UIImage imageNamed:imageName];
    cell.stationCount.text = stationCountText;
    
    // style font
    [cell.name setFont:[UIFont fontWithName:@"Lato-Bold" size:16.0]];
    [cell.availability setFont:[UIFont fontWithName:@"Lato-Regular" size:14.0]];
    [cell.trendText setFont:[UIFont fontWithName:@"Lato-Regular" size:12.0]];
    [cell.stationCount setFont:[UIFont fontWithName:@"Lato-Light" size:12.0]];
        
    // set cell highlight
    UIView *highlightedView = [[UIView alloc]init];
    highlightedView.backgroundColor = [UIColor colorWithRed:(207.0f/255.0f) green:(207.0f/255.0f) blue:(207.0f/255.0f) alpha:1];
    cell.selectedBackgroundView = highlightedView;
   
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - HUD delegate
- (void) hudWasHidden:(MBProgressHUD *)hud {
    [HUD removeFromSuperview];
	HUD = nil;
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"StationDetail"]) {
        // don't reload when we return
        dontReload = 1;
               
        // pass over neighborhood details
        DetailViewController *detailView = (DetailViewController *)segue.destinationViewController;
        // get selected row data
        NeighborhoodModel *neighborItem = [trendList objectAtIndex:[[trendTable indexPathForSelectedRow]row]];
        // send data to new view
        detailView.neighborhoodData = neighborItem;
        detailView.showBikes = dataBikes;
        detailView.stationDictionary = stationDataList.stationDictionary;
        detailView.orderDistance = sortDistance;
        detailView.userLocation = userLocation;
        detailView.trendGeneratedTime = stationDataList.generatedTimecode;
    }
}

@end
