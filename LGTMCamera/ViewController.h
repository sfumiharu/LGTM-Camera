//
//  ViewController.h
//  LGTMCamera
//
//  Created by fumiharu on 2014/05/17.
//  Copyright (c) 2014年 fumiharu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Social/Social.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController : UIViewController
<
AVCaptureVideoDataOutputSampleBufferDelegate,
MFMailComposeViewControllerDelegate
>
@end
