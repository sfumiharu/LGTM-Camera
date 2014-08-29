//
//  imageSearchViewController.h
//  LGTMCamera
//
//  Created by fumiharu on 2014/06/24.
//  Copyright (c) 2014年 fumiharu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageSearchDetailViewController.h"

@protocol ISVCDelegate <NSObject>
-(void)imageSearchViewDelegate:(UIImage *)im;
@end

@interface imageSearchViewController : UIViewController
<UISearchBarDelegate, ISDVCDelegate>
@property (assign, nonatomic)id<ISVCDelegate> delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil img:(UIImage *)im;
- (void)imaged:(UIImage *)im;
@end
