//
//  AddPostTableViewController.m
//  Reel
//
//  Created by Jason Arias on 8/1/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "AddPostConfirmationViewController.h"
#import "AddPostViewController.h"
#import "MZFormSheetController.h"
#import "UIColor+ColorExtensions.h"
#import "ReelRailsAFNClient.h"
#import "UserSession.h"

#import <QuartzCore/QuartzCore.h>
#import <SVProgressHUD/SVProgressHUD.h>


@interface AddPostViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addPostButton;

@property (weak, nonatomic) IBOutlet UITextField *captionTextField;

@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UIButton *addToReelButton;
@property (strong, nonatomic) NSNumber *folderId;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;

@property (weak, nonatomic) IBOutlet UITableView *atTagTableView;
@property (weak, nonatomic) IBOutlet UITableView *hashTagTableView;
@property (weak, nonatomic) IBOutlet UIButton *atTagButton;
@property (weak, nonatomic) IBOutlet UIButton *hashTagButton;

@end


@implementation AddPostViewController{
    CLLocationManager *locationManager;
}
@synthesize folderId;

//viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD show];
    
    [_thumbnailImageView setImage:_thumbnailImage];
    _atTagButton.layer.cornerRadius = _atTagButton.layer.bounds.size.height/2;
    _hashTagButton.layer.cornerRadius = _hashTagButton.layer.bounds.size.height/2;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    [self formatAddToReelButton];
    [self formatTextField:_captionTextField];
    [self formatTextField:_atTagTextField];
    [self formatTextField:_hashTagTextField];
    
    [SVProgressHUD dismiss];
}

-(void)formatAddToReelButton
{
    [[_addToReelButton layer] setCornerRadius:14.0f];
}

-(void)formatTextField:(UITextField*)textField
{
    [textField.layer setCornerRadius:10.0f];
    [textField.layer setMasksToBounds:YES];
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
        if (_currentLocation != nil) {
            [[ReelRailsAFNClient sharedClient] createPostWithParameters:@{@"user_id":[[UserSession sharedSession] sessionActive]
                                                                          ? [[[UserSession sharedSession] userId] stringValue] : @"",
                                                                          @"caption":_captionTextField.text,
                                                                          @"hashTag":_hashTagTextField.text,
                                                                          @"atTag":_atTagTextField.text,
                                                                          @"geo_lat":[NSString stringWithFormat:@"%.8f", _currentLocation.coordinate.longitude],
                                                                          @"geo_long":[NSString stringWithFormat:@"%.8f", _currentLocation.coordinate.latitude],
                                                                          @"folder_id":folderId ? folderId : @""}
                                                        CompletionBlock:^(NSError *error) {
                                                            [SVProgressHUD dismiss];
                                                            [self clearTextFields];
                                                        }];
        }
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
    _currentLocation = locations[[locations count] -1];
    [locationManager stopUpdatingLocation];
    NSLog(@"didUpdateToLocation: %@", _currentLocation);
}
- (IBAction)atTagButtonTouchUpInside:(id)sender {
    //[self performSegueWithIdentifier:@"atTagSegue" sender:self];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"nav"];
    [self mz_presentFormSheetController:vc animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        //do sth
    }];
}
- (IBAction)hashTagButtonTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:@"hashTagSegue" sender:self];
}


-(IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder];
}

@end
