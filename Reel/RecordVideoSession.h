//
//  RecordVideoViewController.h
//  Reel
//
//  Created by Jason Arias on 10/9/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <UIKit/UIKit.h>

@interface RecordVideoSession : AVCaptureSession

@property(strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property(strong, nonatomic) AVCaptureDeviceInput *audioInput;

@property(strong, nonatomic) AVCaptureMovieFileOutput *movieOutput;
@property(strong, nonatomic) AVCaptureVideoDataOutput *videoOutput;

@property(strong, nonatomic) AVCaptureDevice *videoDevice;
@property(strong, nonatomic) AVCaptureDevice *audioDevice;

-(void)startRecordingToFileWithURL:(NSURL *)movieURL;
-(void)stopRecording;

@end
