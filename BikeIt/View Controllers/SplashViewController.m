//
//  SplashViewController.m
//  BikeIt
//
//  Created by Kevin Li on 8/7/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController () {
    IBOutlet UIImageView *logo;
}

- (void)dismissSplash;

@end

@implementation SplashViewController

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
    // remove status bar
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    // start timer
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(dismissSplash) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSplash {
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self performSegueWithIdentifier:@"CloseSplash" sender:self];

}

@end
