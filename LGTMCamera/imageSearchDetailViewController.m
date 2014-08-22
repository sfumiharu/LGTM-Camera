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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _previewSearchImage.backgroundColor = [UIColor grayColor];
//    [_previewSearchImage setImage:image];
    
    UIImageView *preview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 380)];
    [preview setImage:image];
    [self.view addSubview:preview];
    
    UIButton *selectButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/1.6, self.view.frame.size.height-180, 100, 100)];
    [selectButton setBackgroundImage:[UIImage imageNamed:@"0_check"] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(pressSelectButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectButton];
    
    UIButton *outButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/7, self.view.frame.size.height-180, 100, 100)];
    [outButton setBackgroundImage:[UIImage imageNamed:@"0_batsu"] forState:UIControlStateNormal];
    [outButton addTarget:self action:@selector(pressOutButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pressSelectButton{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate ISDVCMethod:image];
}

- (void)pressOutButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
