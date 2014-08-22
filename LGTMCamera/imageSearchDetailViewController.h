//
//  imageSearchDetailViewController.h
//  LGTMCamera
//
//  Created by fumiharu on 2014/06/26.
//  Copyright (c) 2014年 fumiharu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ISDVCDelegate <NSObject>
- (void)ISDVCMethod:(UIImage *)im;
@end

@interface imageSearchDetailViewController : UIViewController
@property (weak, nonatomic) id<ISDVCDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *previewSearchImage;
- (void)pressSelectButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil img:(UIImage *)im;
@end