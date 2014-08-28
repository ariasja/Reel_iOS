//
//  AddPostConfirmationViewController.m
//  Reel
//
//  Created by Jason Arias on 8/5/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "AddPostConfirmationViewController.h"

@interface AddPostConfirmationViewController ()

@property (strong, nonatomic) UIButton* shareButton;
@property (strong, nonatomic) UIButton* editButton;

@end

@implementation AddPostConfirmationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target: self
                                             action: @selector(cancelButtonPressed)];
    self.navigationItem.hidesBackButton = YES;
    
}

//cancelButtonPressed
- (void)cancelButtonPressed
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

///////////////////////// SHARE BUTTON /////////////////////////

//createShareButton
- (void) createShareButton
{
    CGRect shareFrame = CGRectMake(self.view.bounds.size.width/2,
                                    self.view.bounds.size.height - 2*44,
                                    self.view.bounds.size.width/2,
                                    44);
    self.shareButton = [[UIButton alloc] initWithFrame:shareFrame];
    self.shareButton.backgroundColor = [UIColor lightGrayColor];
    [self.shareButton setTitle:@"Share Video" forState:UIControlStateNormal];
    
    [self.shareButton addTarget:self
                         action:@selector(presentActivityViewController)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareButton];
}

//presentActivityViewController
- (void) presentActivityViewController
{
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc]
        initWithActivityItems:@[@"Post Video"]
        applicationActivities:nil];
    
    [activityViewController setExcludedActivityTypes:
            @[UIActivityTypeCopyToPasteboard, UIActivityTypePrint]];
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:nil];
}

///////////////////////// EDIT BUTTON /////////////////////////

//createEditButton
- (void) createEditButton
{
    CGRect editFrame = CGRectMake(0,
                                  self.view.bounds.size.height - 44,
                                  self.view.bounds.size.width/2,
                                  44);
    self.editButton = [[UIButton alloc] initWithFrame:editFrame];
    self.editButton.backgroundColor = [UIColor blackColor];
    [self.editButton setTitle:@"Edit Video" forState:UIControlStateNormal];
    [self.editButton addTarget:self
                        action:@selector(presentEditViewController)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editButton];

}

//presentEditViewController
- (void)presentEditViewController
{
    NSLog(@"You pressed the edit button!");
}


@end
