//
//  ViewController.h
//  LGTMCamera
//
//  Created by fumiharu on 2014/05/17.
//  Copyright (c) 2014年 fumiharu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureOutput.h>

@interface ViewController : UIViewController
<
AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureFileOutputRecordingDelegate
>

@end
