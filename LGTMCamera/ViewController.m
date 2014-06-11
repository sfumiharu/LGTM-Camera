//
//  ViewController.m
//  LGTMCamera
//
//  Created by fumiharu on 2014/05/17.
//  Copyright (c) 2014年 fumiharu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    CGPoint pointt;
    NSInteger tagNo;
    UIDeviceOrientation deviceOrientation;
    NSUserDefaults *userDefaultPointX;
    NSUserDefaults *userDefaultPointY;
    UIButton *addLGTMBtn;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    CALayer *previewLayer;
}
@property(nonatomic, strong)AVCaptureDeviceInput *videoInput;
@property(nonatomic, strong)AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong)AVCaptureSession *session;
@property(nonatomic, strong)UIView *previewView;
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)NSData *imageData;
@property(nonatomic, strong)NSData *imageData2;
@property(nonatomic, strong)UIImageView *shutter;
@property(nonatomic, strong)UIImageView *lgtmView;
@property(nonatomic, strong)UIImage *uiimage;

//- (CGFloat)distanceWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{}
-(void)viewDidAppear:(BOOL)animated{
    //    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //    [nc addObserver:self selector:@selector(didChangedOrientation:)
    //               name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    //    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //    [nc removeObserver:self
    //                  name:UIDeviceOrientationDidChangeNotification object:nil];
    //    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    //   init/add preview
    self.previewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.previewView];
    
    //   Multi Touches
    self.previewView.multipleTouchEnabled = YES;
    
    //   add button
    addLGTMBtn = [self addLGTMButton];
    
    [self.view addSubview:addLGTMBtn];
    [self.view addSubview:[self saveButton]];
    [self.view addSubview:[self cameraRollButton]];
    [self.view addSubview:[self retakeButton]];
    [self.view addSubview:[self takeButton]];
    
    //   start taken
    [self setupAVCapture];
}

-(BOOL)shouldAutorotate{
    if (_imageData) {
        return NO;
    }
    deviceOrientation = [[UIDevice currentDevice] orientation];
    [self setupAVCapture];
    [self objectOrientation];
    return YES;
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
    

    for(AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        if(connection.supportsVideoOrientation)
        {
            connection.videoOrientation = [self videoOrientation];
            NSLog(@"麒+%d", connection.videoOrientation);
        }
    }


// レイヤーをViewに設定
    previewLayer = self.previewView.layer;
    previewLayer.masksToBounds = YES;
    [previewLayer addSublayer:captureVideoPreviewLayer];
    
    
    // セッション開始
    [self.session startRunning];
}

-(void)setVideoOrientation{
    for(AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        if(connection.supportsVideoOrientation)
        {
            connection.videoOrientation = [self videoOrientation];
            NSLog(@"麒+%d", connection.videoOrientation);
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
    
    //アニメーション付きでボタンを回転
    [UIView beginAnimations:@"device rotation" context:nil];
    [UIView setAnimationDuration:0.3];
    
//    _previewView.transform = t;
//    captureVideoPreviewLayer.transform = CATransform3DMakeAffineTransform(t);
    addLGTMBtn.transform = t;
    
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
         
         // 入力された画像データからJPEGフォーマットとしてデータを取得
         _imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                  
         [self.session stopRunning];
         self.previewView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData:_imageData]];
     }];
}
-(void)retakePhoto:(id)sender{
    [self.session startRunning];
    [_imageView removeFromSuperview];
    _imageData = nil;
}
-(void)addLGTMImage{
    UIImage *image = [UIImage imageNamed:@"LGTM.png"];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.previewView.center.x, self.previewView.center.y, _imageView.image.size.width/5, _imageView.image.size.height/5)];
    _imageView.image = image;
    _imageView.center = self.previewView.center;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;

    [self.previewView addSubview:_imageView];
}
-(void)assetLibrary{}
-(void)savePhoto:(id)sender{
    _shutter = [[UIImageView alloc]initWithImage:[UIImage imageWithData:_imageData]];
//    UIGraphicsBeginImageContext(_shutter.image.size);
    UIGraphicsBeginImageContext(CGSizeMake(_shutter.image.size.width, _shutter.image.size.height));
    CGFloat x = [userDefaultPointX floatForKey:@"x"];
    CGFloat y = [userDefaultPointX floatForKey:@"y"];
    
    CGRect rect = CGRectMake(0, 0, _shutter.image.size.width, _shutter.image.size.height);
    CGRect rect1 = CGRectMake(x, y*3.2, _imageView.image.size.width, _imageView.image.size.height);
    NSLog(@"おおお+%f+++%f", x, y);
    [_shutter.image drawInRect:rect];
    [_imageView.image drawInRect:rect1];
    
    // 現在のコンテキストのビットマップをUIImageとして取得
     UIImage *mixed = UIGraphicsGetImageFromCurrentImageContext();
    // コンテキストを閉じる
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(mixed, self, nil, nil);

    [self retakePhoto:nil];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //    moved LGTM images
    if ([touches count] == 1) {
        CGPoint p = [[touches anyObject]locationInView:self.previewView];
        _imageView.center = p;
        
        CGRect frame = [_imageView frame];
        CGPoint topLeft = CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame));
        [self saveLGTMPoint:topLeft.x xy:@"x"];
        [self saveLGTMPoint:topLeft.y xy:@"y"];
    }
}
-(void)saveLGTMPoint:(CGFloat)points xy:(NSString*)xy{
    userDefaultPointX = [NSUserDefaults standardUserDefaults];
    userDefaultPointY = [NSUserDefaults standardUserDefaults];
    
    if ([xy isEqualToString:@"x"]) {
        [userDefaultPointX setFloat:points forKey:@"x"];
        [userDefaultPointX synchronize];
    }
    [userDefaultPointY setFloat:points forKey:@"y"];
    [userDefaultPointY synchronize];
}
-(UIButton *)addLGTMButton{
    UIButton *addLGTMButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 350, 60, 60)];
    [addLGTMButton setBackgroundImage:[UIImage imageNamed:@"LGTM.png"] forState:UIControlStateNormal];
    [addLGTMButton addTarget:self action:@selector(addLGTMImage) forControlEvents:UIControlEventTouchUpInside];
    return addLGTMButton;
}
-(UIButton *)saveButton{
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2.35, self.view.bounds.size.height - 280, 60, 60)];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(savePhoto:) forControlEvents:UIControlEventTouchUpInside];
    return saveButton;
}
-(UIButton *)cameraRollButton{
    UIButton *cameraRollButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 210, 60, 60)];
    [cameraRollButton setBackgroundImage:[UIImage imageNamed:@"cameraroll.png"] forState:UIControlStateNormal];
    [cameraRollButton addTarget:self action:@selector(hoge:) forControlEvents:UIControlEventTouchUpInside];
    return cameraRollButton;
}
-(UIButton *)retakeButton{
    UIButton *retakeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2.35, self.view.bounds.size.height - 140, 60, 60)];
    [retakeButton setBackgroundImage:[UIImage imageNamed:@"retake.png"] forState:UIControlStateNormal];
    [retakeButton addTarget:self action:@selector(retakePhoto:) forControlEvents:UIControlEventTouchUpInside];
    return retakeButton;
}
-(UIButton *)takeButton{
    UIButton *takeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2.35, self.view.bounds.size.height - 70, 60, 60)];
    [takeButton setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [takeButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    return takeButton;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
