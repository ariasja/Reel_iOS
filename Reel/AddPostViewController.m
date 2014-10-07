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

@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UIButton *addToReelButton;
@property (strong, nonatomic) NSNumber *folderId;


@end


@implementation AddPostViewController{
    CLLocationManager *locationManager;
}
@synthesize folderId;

//viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    [self formatAddToReelButton];
    [self formatTextField:_captionTextField];
    [self formatTextField:_atTagTextField];
    [self formatTextField:_hashTagTextField];
}

-(void)formatAddToReelButton
{
    [[_addToReelButton layer] setBorderWidth:1.2f];
    [[_addToReelButton layer] setBorderColor:[UIColor tealColor].CGColor];
    [[_addToReelButton layer] setCornerRadius:14.0f];
}

-(void)formatTextField:(UITextField*)textField
{
    [textField.layer setCornerRadius:10.0f];
    [textField.layer setMasksToBounds:YES];
    [textField.layer setBorderColor:[[UIColor tealColor]CGColor]];
    [textField.layer setBorderWidth:1.2f];
}

-(void)reformatAddToReelButtonForFolderWithTitle:(NSString*)title
                                        folderId:(NSNumber*)fId
{
    [_addToReelButton setTitle:title forState:UIControlStateNormal];
    [self setFolderId:fId];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(![[UserSession sharedSession] sessionActive]){
        [self performSegueWithIdentifier:@"LogInToPostSegue" sender:self];
    }
}

- (IBAction)addButtonTouchUpInside:(id)sender
{
    [SVProgressHUD show];
    
    if([_locationSwitch isOn]){
        [locationManager requestWhenInUseAuthorization];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        
    }else{
        [[ReelRailsAFNClient sharedClient] createPostWithParameters:@{@"user_id":[[[UserSession sharedSession] userId] stringValue],
                                                                      @"caption":_captionTextField.text,
                                                                      @"hashTag":_hashTagTextField.text,
                                                                      @"atTag":_atTagTextField.text,
                                                                      @"folder_id":folderId ? folderId : @""}
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
    [self reformatAddToReelButtonForFolderWithTitle:@" add to a reel >"
                                           folderId:nil];
    [_locationSwitch setOn:NO animated:YES];
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
    //Only need location once
    [locationManager stopUpdatingLocation];
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
                                                                 @"geo_long":latitude,
                                                                  @"folder_id":folderId ? folderId : @""}
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
}


-(IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder];
}

@end
