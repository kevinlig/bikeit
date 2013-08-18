//
//  NavigationViewController.m
//  BikeIt
//
//  Created by Kevin Li on 7/25/13.
//  Copyright (c) 2013 Kevin Li. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

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
    
    // style navbars
    UIImage *navBackground = [UIImage imageNamed:@"navbar"];
    [[UINavigationBar appearance] setBackgroundImage:navBackground forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *navTextSettings = @{UITextAttributeFont: [UIFont fontWithName:@"Lato-Light" size:22.0],UITextAttributeTextColor: [UIColor blackColor], UITextAttributeTextShadowColor: [UIColor clearColor], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero] };
    [[UINavigationBar appearance] setTitleTextAttributes:navTextSettings];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-3.0f forBarMetrics:UIBarMetricsDefault];
    
    // style buttons
    // bar button item
    NSDictionary *buttonTextSettings = @{
                                         UITextAttributeFont: [UIFont fontWithName:@"Lato-Regular" size:12.0],
                                         UITextAttributeTextColor: [UIColor blackColor],
                                         UITextAttributeTextShadowColor: [UIColor clearColor],
                                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]
                                         };
    [[UIBarButtonItem appearance] setTitleTextAttributes:buttonTextSettings forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:buttonTextSettings forState:UIControlStateHighlighted];
    UIImage *buttonBack = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [[UIBarButtonItem appearance] setBackgroundImage:buttonBack forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *buttonSelBack = [[UIImage imageNamed:@"button-sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [[UIBarButtonItem appearance] setBackgroundImage:buttonSelBack forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    // back button
    UIImage *backButtonBackground = [[UIImage imageNamed:@"back-button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 4)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *backButtonSelectedBackground = [[UIImage imageNamed:@"back-button-sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 4)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonSelectedBackground forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
