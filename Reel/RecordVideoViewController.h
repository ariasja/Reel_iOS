//
//  RecordVideoViewController.h
//  Reel
//
//  Created by Jason Arias on 10/12/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "RecordVideoInput.h"
#import "RecordVideoOutput.h"
#import "RecordVideoSession.h"
#import <UIKit/UIKit.h>

#define CAPTURE_FRAMES_PER_SECOND		20


@interface RecordVideoViewController : UIViewController

@property(strong, nonatomic) RecordVideoSession *session;
@property(strong, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(strong, nonatomic) NSURL *saveLocationURL;
@property(strong, nonatomic) NSURL *croppedVideoURL;


@end
