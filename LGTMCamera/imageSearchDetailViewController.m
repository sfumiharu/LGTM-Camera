//
//  imageSearchDetailViewController.m
//  LGTMCamera
//
//  Created by fumiharu on 2014/06/26.
//  Copyright (c) 2014年 fumiharu. All rights reserved.
//

#import "imageSearchDetailViewController.h"
#import "imageSearchViewController.h"
#import "ViewController.h"

@interface imageSearchDetailViewController ()
{
    UIImage *image;
}
- (IBAction)pressOutButton:(id)sender;
@end

@implementation imageSearchDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil img:(UIImage *)im
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        image = im;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    v.viewDele = self;
    
    _previewSearchImage.backgroundColor = [UIColor grayColor];
    [_previewSearchImage setImage:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressSelectButton:(id)sender {
//    ViewController *vc = [[ViewController alloc]init];
//    [vc takePhoto];
//    [self.view.window addSubview:vc.view];
    [self dismissViewControllerAnimated:YES completion:nil];
    [_delegate takePhotos];
//    if ([_delegate respondsToSelector:@selector(takePhotos)]) {
//        NSLog(@"通った");
//        [self dismissViewControllerAnimated:YES completion:nil];

//    }else{
//        NSLog(@"通らない");
//    }
}

-(void)aaa{
    NSLog(@"aaa");
}
- (IBAction)pressOutButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
