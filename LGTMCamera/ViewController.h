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
#import "imageSearchDetailViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ViewController : UIViewController
<
AVCaptureVideoDataOutputSampleBufferDelegate,
MFMailComposeViewControllerDelegate,
NSURLAuthenticationChallengeSender,
NSURLConnectionDelegate,
imageSearchDetailViewControllerDelegate
>

- (void)takePhoto;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil img:(UIImage *)im;
@end
