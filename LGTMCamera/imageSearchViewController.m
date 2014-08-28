//
//  imageSearchViewController.m
//  LGTMCamera
//
//  Created by fumiharu on 2014/06/24.
//  Copyright (c) 2014年 fumiharu. All rights reserved.
//

#import "imageSearchViewController.h"
#import "ViewController.h"
#import "imageSearchDetailViewController.h"
#import <AFHTTPRequestOperationManager.h>
#import <QuartzCore/QuartzCore.h>

@interface imageSearchViewController (){
    NSArray *d;
    NSArray *d_results;
    NSArray *results_MediaUrl;
    NSArray *MediaUrl;
    NSArray *results_Thumbnail;
    NSArray *Thumbnail_MediaUrl;
    NSArray *image_ContentType;
    int imageCount;
    UIScrollView *sv;
    NSMutableArray *imageArray;
}
@property (strong, nonatomic) IBOutlet UISearchBar *queryForm;
@end

@implementation imageSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil img:(UIImage *)im;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)ISDVCMethod:(id)im{
    [self.delegate ISVCDelegateMethod:im];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _queryForm.delegate = self;
    _queryForm.keyboardType = UIKeyboardTypeASCIICapable;
    [_queryForm becomeFirstResponder];
    self.navigationItem.title = @"search LGTM! Base Image";
    UIBarButtonItem *bb = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                       target:self action:@selector(pressCancelButton)];
    self.navigationItem.leftBarButtonItem = bb;
}

-(void)pressCancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *NGWord = @"!\"\\#$%&'()@[]{}|^~=;:_?<>,/-*.¥ ";
    for (int i=0; i<[NGWord length]; i++) {
        NSString *check = [NGWord substringWithRange:NSMakeRange(i, 1)];
        if ([text isEqual:check]) {
            return NO;
        }
    }
    return YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [sv removeFromSuperview];
    [self getJson];
}

-(void)getJson{
    [_queryForm resignFirstResponder];
    NSString *q = _queryForm.text;
    
    NSString *request = [NSString stringWithFormat:@"https://api.datamarket.azure.com/Bing/Search/v1/Image?Query='%@'&$format=json", q];
//    &ImageFilters='Size:Small'
//    &ContentType='image/jpeg'
//    &ContentType='image/png'
//    https://api.datamarket.azure.com/Bing/Search/v1/Image?Query=%27tokyo%27
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"Ozo8j/sSFbcW9lJNYCUJYdid0XzFKvpo0Y0mxiJL6yQ" password:@"Ozo8j/sSFbcW9lJNYCUJYdid0XzFKvpo0Y0mxiJL6yQ"];
    [manager GET:request
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id response) {
             [self parseJson:response];
//             NSLog(@"%@", response);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}
-(void)parseJson:(id)response{
    d = [response valueForKey:@"d"];
    d_results = [d valueForKey:@"results"];
    results_MediaUrl = [d_results valueForKey:@"MediaUrl"];
    MediaUrl = [results_MediaUrl objectAtIndex:0];
    
    results_Thumbnail = [d_results valueForKey:@"Thumbnail"];
    Thumbnail_MediaUrl = [results_Thumbnail valueForKey:@"MediaUrl"];
//    NSLog(@"iiiL+%d", [MediaUrl count]);
    NSLog(@"ooo+%@", [Thumbnail_MediaUrl objectAtIndex:0]);
    [self setImageView];
}

-(void)setImageView{
    [self setThumbnailBaseView];
    
    int imx = 10;
    int imy = 10;
    int count = 0;
    int x = 0;
    for (int i = 0; i < [Thumbnail_MediaUrl count]; i++) {
        int a = count * 100;
        int b = x * 100;
        

        UIButton *im = [[UIButton alloc]initWithFrame:CGRectMake(imx+a, imy+b, 90, 90)];
        [im setBackgroundColor:[UIColor grayColor]];
        im.imageView.contentMode = UIViewContentModeScaleAspectFill;
        im.layer.shadowOpacity = 0.6;
        im.layer.shadowOffset = CGSizeMake(1, 3);
        [im addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        
        dispatch_async(dispatch_get_global_queue(0, 0),^{
                [im setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[Thumbnail_MediaUrl objectAtIndex:i]]]] forState:UIControlStateNormal];
            dispatch_async(dispatch_get_main_queue(), ^{

            });
        });
                [sv addSubview:im];
        
        
        if (i > 0 && count != 0 && count%2 == 0) {
            x = x + 1;
            count = 0;
        }else{
            count++;
        } 

    }
}
-(void)pressButton:(UIButton *)sender{
    imageSearchDetailViewController *iii = [[imageSearchDetailViewController alloc]initWithNibName:@"imageSearchDetailViewController" bundle:nil img:sender.imageView.image];
    [iii.previewSearchImage setImage:sender.imageView.image];
    iii.delegate = self;
    [self.navigationController pushViewController:iii animated:YES];
}

-(void)setThumbnailBaseView{
    sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120)];
    sv.contentSize = CGSizeMake(0, [Thumbnail_MediaUrl count]/3*110);
    [self.view addSubview:sv];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
