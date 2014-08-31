//
//  MapViewController.m
//  Reel
//
//  Created by Jason Arias on 7/29/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ReelMapViewController.h"

@interface ReelMapViewController () <MKMapViewDelegate>

    @property (strong, nonatomic) MKMapView *mapView;
    @property (strong, nonatomic) UIButton *addButton;
    @property (strong, nonatomic) UITextField *header;

@end

@implementation ReelMapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // Create and add a mapView as a subview of the main view
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    // Create a frame and label for the "Add" button
    CGRect buttonFrame = CGRectMake(0,
                                    self.view.bounds.size.height - 2*44,
                                    self.view.bounds.size.width,
                                    44);
    
    NSString *buttonText = NSLocalizedString(@"Here!", nil);
    
    self.addButton = [[UIButton alloc] initWithFrame:buttonFrame];
    self.addButton.backgroundColor = [UIColor grayColor];
    self.addButton.alpha = 0.8;
    [self.addButton setTitle:buttonText
                    forState:UIControlStateNormal];
    [self.addButton addTarget:self
                       action:@selector(addButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
}

- (void)addButtonPressed
{
    NSLog(@"You pressed the 'Here' button!");
}


@end
