//
//  ViewController.m
//  LGTMCamera
//
//  Created by fumiharu on 2014/05/17.
//  Copyright (c) 2014年 fumiharu. All rights reserved.
//

#import "ViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ViewController (){
    CGFloat lgtmViewX;
    CGFloat lgtmViewY;
    CGFloat lgtmViewW;
    CGFloat lgtmViewH;
    UIButton *addLGTMBtn;
    UIButton *saveBtn;
    UIButton *retakeBtn;
    UIButton *takeBtn;
    NSArray *lgtmSelectionButtonList;
    NSArray *lgtmSelectionButtonName;
    CALayer *previewLayer;
    UIScrollView *sv;
    UIDeviceOrientation deviceOrientation;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
}
@property(nonatomic, strong)AVCaptureDeviceInput *videoInput;
@property(nonatomic, strong)AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong)AVCaptureSession *session;
@property(nonatomic, strong)UIView *previewView;
@property(nonatomic, strong)NSData *imageData;
@property(nonatomic, strong)UIImageView *shutter;
@property(nonatomic, strong)UIImageView *lgtmView;
@end

@implementation ViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
//    LGTM images data
    lgtmSelectionButtonList = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", nil];
    lgtmSelectionButtonName = [NSArray arrayWithObjects:@"LGTM0", @"LGTM1", @"LGTM3", @"LGTM4", @"LGTM5", nil];
    
//   init/add preview
    self.previewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSLog(@"aa+%f++%f", self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.previewView];
    
//   Multi Touches
    self.previewView.multipleTouchEnabled = YES;
    
//   add button
    addLGTMBtn = [self addLGTMButton];
    saveBtn = [self saveButton];
    retakeBtn = [self retakeButton];
    takeBtn = [self takeButton];
    
    [self.view addSubview:addLGTMBtn];
    [self.view addSubview:retakeBtn];
    [self.view addSubview:takeBtn];
    [self.view addSubview:saveBtn];
    
//   start take
    [self setupAVCapture];
}

- (AVCaptureVideoOrientation)videoOrientation {
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            return AVCaptureVideoOrientationPortrait;
            break;
    }
}
-(void)setupAVCapture{
    NSError *error = nil;
    
// 入力と出力からキャプチャーセッションを作成
    self.session = [[AVCaptureSession alloc] init];
    
// 正面に配置されているカメラを取得
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
// カメラからの入力を作成し、セッションに追加
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
// 画像への出力を作成し、セッションに追加
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.session addOutput:self.stillImageOutput];
    
// キャプチャーセッションから入力のプレビュー表示を作成
    captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.frame = self.view.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;

    [self setVideoOrientation];

//  Setting Layer in View
    previewLayer = self.previewView.layer;
    previewLayer.masksToBounds = YES;
    [previewLayer addSublayer:captureVideoPreviewLayer];
    
//    Session Start
    [self.session startRunning];
}

-(void)setVideoOrientation{
    for(AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        if(connection.supportsVideoOrientation)
        {
            connection.videoOrientation = [self videoOrientation];
//            NSLog(@"麒+%d", connection.videoOrientation);
        }
    }
}

-(void)objectOrientation
{
    
    //使えない向きの時は処理しない
    if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown
        || deviceOrientation == UIDeviceOrientationFaceUp
        || deviceOrientation == UIDeviceOrientationFaceDown
        || deviceOrientation == UIDeviceOrientationUnknown)
    {
        return;
    }
    
    //向きに応じた角度を求める
    int angle = 0;
    if (deviceOrientation == UIDeviceOrientationPortrait)
    {
        angle = 0;
    }
    else if (deviceOrientation == UIDeviceOrientationLandscapeLeft)
    {
        angle = 90;
    }
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight)
    {
        angle = -90;
    }
    
    //回転させるためのアフィン変形を作成する
        CGAffineTransform t = CGAffineTransformMakeRotation(angle * M_PI / 180);

    //    Set Animation
    [UIView beginAnimations:@"device rotation" context:nil];
    [UIView setAnimationDuration:0.3];
    addLGTMBtn.transform = t;
    saveBtn.transform = t;
    retakeBtn.transform = t;
    takeBtn.transform = t;
    [UIView commitAnimations];
}



-(void)takePhoto:(id)sender{
    // ビデオ入力のAVCaptureConnectionを取得
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (videoConnection == nil) {
        return;
    }
    
    // ビデオ入力から画像を非同期で取得。ブロックで定義されている処理が呼び出され、画像データを引数から取得する
    [self.stillImageOutput
     captureStillImageAsynchronouslyFromConnection:videoConnection
     completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         if (imageDataSampleBuffer == NULL) {
             return;
         }
         
         AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
         NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
         [stillImageOutput setOutputSettings:outputSettings];
         
         
         // 入力された画像データからJPEGフォーマットとしてデータを取得
         _imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                  
         [self.session stopRunning];
         self.previewView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData:_imageData]];
         [self takeAnimation];
     }];
}
-(void)takeAnimation{
    [UIView beginAnimations:@"yo-" context:nil];
    [UIView animateWithDuration:2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGAffineTransform retake = CGAffineTransformMakeTranslation(80, 0);
                         retakeBtn.transform = retake;
                     }
                     completion:nil];
}

-(void)retakePhoto:(id)sender{
    [self.session startRunning];
    [_lgtmView removeFromSuperview];
    _imageData = nil;
}

-(void)addLGTMSelectionView{
    if (!_imageData) {
        return;
    }
    
//    LGTM Selection ScrollView
    sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 250, 320)];
    sv.backgroundColor = RGB(50, 50, 49);
    sv.center = self.previewView.center;
//    sv.contentSize = CGSizeMake(0, 1200);
    [self.previewView addSubview:sv];

//    LGTM images Placement on ScrollView
    int y = 10;
    for (int i = 0; i < [lgtmSelectionButtonList count]; i ++) {
        UIButton *lgtmSelectionButton = [[UIButton alloc]initWithFrame:CGRectMake(sv.frame.origin.x/2, y, 200, 50)];
        [lgtmSelectionButton setBackgroundImage:[UIImage imageNamed:[lgtmSelectionButtonName objectAtIndex:i]] forState:UIControlStateNormal];
        [lgtmSelectionButton addTarget:self action:@selector(addLGTMImage:) forControlEvents:UIControlEventTouchUpInside];
        lgtmSelectionButton.tag = i;
        [sv addSubview:lgtmSelectionButton];
        y = y +60;
    }
}

-(void)addLGTMImage:(UIButton *)sender{
    UIImage *image = [UIImage imageNamed:[lgtmSelectionButtonName objectAtIndex:sender.tag]];
    _lgtmView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    _lgtmView.image = image;
    _lgtmView.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    _lgtmView.contentMode = UIViewContentModeScaleAspectFill;
    [sv removeFromSuperview];
    [self.previewView addSubview:_lgtmView];
}

-(void)savePhoto:(id)sender{
    _shutter = [[UIImageView alloc]initWithImage:[UIImage imageWithData:_imageData]];
//    UIGraphicsBeginImageContext(_shutter.image.size);
    UIGraphicsBeginImageContextWithOptions(_shutter.frame.size, YES, 2);
    UIGraphicsBeginImageContext(CGSizeMake(_shutter.frame.size.width, _shutter.frame.size.height));
    
    CGRect rect = CGRectMake(0, 0, _shutter.frame.size.width, _shutter.frame.size.height);
    CGRect rect1 = CGRectMake(lgtmViewX*3.4, lgtmViewY*3.4, lgtmViewW, lgtmViewH);
    NSLog(@"savePhoto-x+%f+y+%f", lgtmViewX, lgtmViewY);
    [_shutter.image drawInRect:rect];
    [_lgtmView.image drawInRect:rect1];
    
    // 現在のコンテキストのビットマップをUIImageとして取得
     UIImage *mixed = UIGraphicsGetImageFromCurrentImageContext();
    // コンテキストを閉じる
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(mixed, self, nil, nil);

    [self retakePhoto:nil];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([touches count] == 1) {
        CGPoint p = [[touches anyObject]locationInView:self.previewView];
        _lgtmView.center = p;

        lgtmViewX = _lgtmView.frame.origin.x;
        lgtmViewY = _lgtmView.frame.origin.y;
        
        lgtmViewW = _lgtmView.frame.size.width * 3.4;
        lgtmViewH = _lgtmView.frame.size.height * 3.4;
    }
}

-(BOOL)shouldAutorotate{
    if (_imageData) {
        return NO;
    }
    
    deviceOrientation = [[UIDevice currentDevice] orientation];
    [self setVideoOrientation];
    [self objectOrientation];
    return YES;
}

-(UIButton *)addLGTMButton{
    UIButton *addLGTMButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 3.5, self.view.bounds.size.height - 160, 60, 60)];
    [addLGTMButton setBackgroundImage:[UIImage imageNamed:@"LGTM.png"] forState:UIControlStateNormal];
    [addLGTMButton addTarget:self action:@selector(addLGTMSelectionView) forControlEvents:UIControlEventTouchUpInside];
    return addLGTMButton;
}

-(UIButton *)saveButton{
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 6, self.view.bounds.size.height - 70, 60, 60)];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(savePhoto:) forControlEvents:UIControlEventTouchUpInside];
    return saveButton;
}

-(UIButton *)retakeButton{
    UIButton *retakeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2.35, self.view.bounds.size.height - 70, 60, 60)];
    [retakeButton setBackgroundImage:[UIImage imageNamed:@"retake.png"] forState:UIControlStateNormal];
    [retakeButton addTarget:self action:@selector(retakePhoto:) forControlEvents:UIControlEventTouchUpInside];
    return retakeButton;
}

-(UIButton *)takeButton{
    UIButton *takeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2.35, self.view.bounds.size.height - 70, 60, 60)];
    [takeButton setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [takeButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    return takeButton;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
