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
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
ISVCDelegate
>
{
    UIView *baseView;
    UIView *takeTabView;
    UIView *takedTabView;
    UIView *accessoriesTabView;
}
@property (strong, nonatomic) UIImageView *setImageView;

- (void)pressTakeButton;
- (void)backTabView;
- (void)changeFlash;
- (void)changeDevice;
- (void)pressMailButton;
- (void)pressCamLibButton;
- (void)pressTwitterButton;
- (void)addLGTMSelectionView;
- (void)pressImageSearchButton;
- (void)addUploadBaseViewFadeIn;
- (void)pressSaveButton:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil img:(UIImage *)im;
@end
