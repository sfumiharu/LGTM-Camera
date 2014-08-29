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
#import "imageSearchViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ViewController : UIViewController
<
AVCaptureVideoDataOutputSampleBufferDelegate,
MFMailComposeViewControllerDelegate,
NSURLAuthenticationChallengeSender,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
NSURLConnectionDelegate,
ISDVCDelegate,
ISVCDelegate
>
{
    UIView *baseView;
    UIView *takeTabView;
    UIView *takedTabView;
}
@property (strong, nonatomic) UIView *previewView;
@property (strong, nonatomic) UIImageView *setImageView;
//@property (strong, nonatomic) UIImage *camLibIconImage;

- (void)takePhoto;
- (void)backTabView;
- (void)pressMailButton;
- (void)pressCamLibButton;
- (void)pressTwitterButton;
- (void)addLGTMSelectionView;
- (void)pressImageSearchButton;
- (void)addUploadBaseViewFadeIn;
- (void)pressSaveButton:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil img:(UIImage *)im;
@end
