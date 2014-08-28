//
//  MapViewController.m
//  Reel
//
//  Created by Jason Arias on 7/29/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "MapViewController.h"
#import "AddPostViewController.h"
#import "UIColor+ColorExtensions.h"

@interface MapViewController () <MKMapViewDelegate>

    @property (strong, nonatomic) MKMapView *mapView;
    @property (strong, nonatomic) UIButton *addButton;
    @property (strong, nonatomic) UITextField *header;

@end

@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create and add a mapView
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];

    
    //Set initial scope of map
    CLLocationDistance mapWidith = 16000;
    CLLocationDistance mapHeight = 16000;
    CLLocationCoordinate2D userLocation = self.mapView.userLocation.coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation, mapHeight , mapWidith);
    [self.mapView setRegion: region
                   animated:false];
    
    // Create a frame and label for the "Add" button
    CGRect buttonFrame = CGRectMake(0,
                                    self.view.bounds.size.height - 44,
                                    self.view.bounds.size.width,
                                    44);
    
    NSString *buttonText = NSLocalizedString(@"Here!", nil);
    
    self.addButton = [[UIButton alloc] initWithFrame:buttonFrame];
    self.addButton.backgroundColor = [UIColor tealColor];
    [self.addButton setTitle:buttonText
                    forState:UIControlStateNormal];
    [self.addButton addTarget:self
                       action:@selector(addButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
}

-(void) viewWillAppear:(BOOL)animated
{
    //hide Tab Bar
    self.tabBarController.tabBar.hidden = YES;
}

-(void) viewDidDisappear:(BOOL)animated
{
    //unhide Tab Bar
    self.tabBarController.tabBar.hidden = NO;
}

- (void)addButtonPressed
{
    AddPostViewController *addPostViewController = [[AddPostViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addPostViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}



@end
