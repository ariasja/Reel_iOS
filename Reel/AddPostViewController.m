//
//  AddPostTableViewController.m
//  Reel
//
//  Created by Jason Arias on 8/1/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "AddPostViewController.h"
#import "UIColor+ColorExtensions.h"
#import "AddPostConfirmationViewController.h"
#import "ReelRailsAFNClient.h"
#import "UserSession.h"

#import <QuartzCore/QuartzCore.h>
#import <SVProgressHUD/SVProgressHUD.h>


@interface AddPostViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addPostButton;

@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UITextField *hashTagTextField;
@property (weak, nonatomic) IBOutlet UITextField *atTagTextField;
@property (weak, nonatomic) IBOutlet UITextField *folderTextField;

@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UIButton *addToReelButton;

@end


@implementation AddPostViewController{
    CLLocationManager *locationManager;
}


//viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    [[_addToReelButton layer] setBorderWidth:1.2f];
    [[_addToReelButton layer] setBorderColor:[UIColor tealColor].CGColor];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(![[UserSession sharedSession] sessionActive]){
        [self performSegueWithIdentifier:@"LogInToPostSegue" sender:self];
    }
}

- (IBAction)addButtonTouchUpInside:(id)sender {
    [SVProgressHUD show];
    
    if([_locationSwitch isOn]){
        [locationManager requestWhenInUseAuthorization];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        
    }else{
        [[ReelRailsAFNClient sharedClient] createPostWithParameters:@{@"user_id":[[UserSession sharedSession] sessionActive]
                                                                      ? [[[UserSession sharedSession] userId] stringValue] : @"",
                                                                      @"caption":_captionTextField.text,
                                                                      @"hashTag":_hashTagTextField.text,
                                                                      @"atTag":_atTagTextField.text}
                                                    CompletionBlock:^(NSError *error) {
                                                        [SVProgressHUD dismiss];
                                                        [self clearTextFields];
                                                    }];
    }

}

-(void)clearTextFields{
    [_captionTextField setText:@""];
    [_hashTagTextField setText:@""];
    [_atTagTextField setText:@""];
    [_folderTextField setText:@""];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = locations[[locations count] -1];
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    NSString *longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    
    if (currentLocation != nil) {
    [[ReelRailsAFNClient sharedClient] createPostWithParameters:@{@"user_id":[[UserSession sharedSession] sessionActive]
                                                                  ? [[[UserSession sharedSession] userId] stringValue] : @"",
                                                                  @"caption":_captionTextField.text,
                                                                  @"hashTag":_hashTagTextField.text,
                                                                    @"atTag":_atTagTextField.text,
                                                                  @"geo_lat":longitude,
                                                                 @"geo_long":latitude}
                                                CompletionBlock:^(NSError *error) {
                                                    [SVProgressHUD dismiss];
                                                    [self clearTextFields];
                                                }];
    }else {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        //[locationManager stopUpdatingLocation];
    }
    [locationManager stopUpdatingLocation];
}


-(IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder];
}

@end
