//
//  ViewController.m
//  LGTMCamera
//
//  rated by fumiharu on 2014/05/17.
//  Copyright (c) 2014年 fumiharu. All rights reserved.
//

#import "ViewController.h"
#import "imageSearchViewController.h"

@interface ViewController (){
    CGFloat lgtmViewX;
    CGFloat lgtmViewY;
    CGFloat lgtmViewW;
    CGFloat lgtmViewH;
    CGFloat px;
    CGFloat py;
    NSURLRequest *req;
    UIButton *addLGTMBtn;
    UIButton *twitterBtn;
    UIButton *saveBtn;
    UIButton *retakeBtn;
    UIButton *takeBtn;
    UIButton *menuBtn;
    UIButton *mailBtn;
    UIButton *imageSearchBtn;
    UILabel *retakeLbl;
    UILabel *menuLbl;
    NSArray *lgtmSelectionButtonList;
    NSArray *lgtmSelectionButtonName;
    CALayer *previewLayer;
    UIView *takeTabView;
    UIView *takedTabView;
    UIView *baseView;
    UIImage *mixed;
    UIImage *imag;
    UIScrollView *sv;
    UIDeviceOrientation deviceOrientation;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    MFMailComposeViewController *MCVC;
}
@property(nonatomic, strong)AVCaptureDeviceInput *videoInput;
@property(nonatomic, strong)AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong)AVCaptureSession *session;
@property(nonatomic, strong)UIView *previewView;
@property(nonatomic, strong)NSData *imageData;
@property(nonatomic, strong)UIImageView *shutter;
@property(nonatomic, strong)UIImageView *lgtmView;
- (CGFloat)distanceWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB;
@end

@implementation ViewController
-(void)aaa{
    NSLog(@"ああ");
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil img:(UIImage *)im;{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imag = im;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    imageSearchDetailViewController *d = [[imageSearchDetailViewController alloc]init];
    d.delegate = self;

    _previewView.multipleTouchEnabled = YES;

    lgtmSelectionButtonList = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", nil];
    lgtmSelectionButtonName = [NSArray arrayWithObjects:@"LGTM0", @"LGTM1", @"LGTM3", @"LGTM4", @"LGTM5", nil];
    
    _previewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_previewView];
    NSLog(@"sel.w+%f,,,+%f", self.view.frame.size.width, self.view.frame.size.height);

    
    [self addTakeButton];
    [self setupAVCapture];
}

-(void)takePhotos{
    UIImageView *i = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 380)];
    [i setImage:[UIImage imageNamed:@"0_check"]];
    i.backgroundColor = [UIColor redColor];
    [self.view addSubview:i];
}

-(void)takePhoto{
    // ビデオ入力のAVCaptureConnectionを取得
    AVCaptureConnection *videoConnection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection == nil) {
//        return;
    }
    // ビデオ入力から画像を非同期で取得。ブロックで定義されている処理が呼び出され、画像データを引数から取得する
    [_stillImageOutput
     captureStillImageAsynchronouslyFromConnection:videoConnection
     completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         if (imageDataSampleBuffer == NULL) {
             return;
         }
         
         AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
         NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
         [stillImageOutput setOutputSettings:outputSettings];
         
         
         // 入力された画像データからJPEGフォーマットとしてデータを取得
         [_session stopRunning];
         _imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         _previewView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData:_imageData]];
     }];
    [self pushTabView];
}

-(void)pushTabView{
    takeTabView.center = CGPointMake(_previewView.frame.size.width-(_previewView.frame.size.width*2), _previewView.frame.size.height - 40);
    
//    takedTabView = [[UIView alloc]initWithFrame:CGRectMake(_previewView.frame.size.width, _previewView.frame.size.height-80, _previewView.frame.size.width, 80)];
    
    if ([self is4inch]) {
        takedTabView = [[UIView alloc]initWithFrame:CGRectMake(0, _previewView.frame.size.height, _previewView.frame.size.width, 90)];
    }else{
        takedTabView = [[UIView alloc]initWithFrame:CGRectMake(0, _previewView.frame.size.height-80, _previewView.frame.size.width, 80)];
    }
    
    takedTabView.backgroundColor = RGB(51, 51, 51);
    takedTabView.alpha = 0.5;
//    takedTabView.center = CGPointMake(_previewView.frame.size.width / 2, _previewView.frame.size.height - 40);
    [self.view addSubview:takedTabView];
    
    addLGTMBtn = [self addLGTMButton];
    retakeBtn = [self retakeButton];
    menuBtn = [self menuButton];
    retakeLbl = [self retakeLabel];
    menuLbl = [self menuLabel];
    
    [takedTabView addSubview:menuBtn];
    [takedTabView addSubview:addLGTMBtn];
    [takedTabView addSubview:retakeBtn];
    [takedTabView addSubview:retakeLbl];
    [takedTabView addSubview:menuLbl];
}
-(void)backTabView{
    if ([self is4inch]) {
        takeTabView.center = CGPointMake(_previewView.frame.size.width / 2, _previewView.frame.size.height+45);
    }else{
        takeTabView.center = CGPointMake(_previewView.frame.size.width / 2, _previewView.frame.size.height-40);
    }
    takedTabView.center = CGPointMake((_previewView.frame.size.width * 3) / 2, _previewView.frame.size.height - 40);
    [_lgtmView removeFromSuperview];
    [sv removeFromSuperview];
    [self uploadBaseViewFadeOut];
    _lgtmView = nil;
    sv = nil;
    _imageData = nil;
    [self.session startRunning];

}

-(void)addLGTMSelectionView{
    if (!_imageData || sv || baseView) {
        return;
    }
    
//    LGTM Selection ScrollView
    sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 250, 320)];
    sv.backgroundColor = RGB(51, 51, 51);
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
    [_lgtmView removeFromSuperview];
    _lgtmView = nil;
    UIImage *image = [UIImage imageNamed:[lgtmSelectionButtonName objectAtIndex:sender.tag]];
    _lgtmView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    _lgtmView.image = image;
    _lgtmView.center = CGPointMake(_previewView.frame.size.width/2, _previewView.frame.size.height/2);
    _lgtmView.contentMode = UIViewContentModeScaleAspectFill;
    [sv removeFromSuperview];
    sv = nil;
    [self.previewView addSubview:_lgtmView];
}
-(void)GetImageFromCurrentImageContext{
    _shutter = [[UIImageView alloc]initWithImage:[UIImage imageWithData:_imageData]];
    UIGraphicsBeginImageContextWithOptions(_previewView.frame.size, YES, 2);
    UIGraphicsBeginImageContext(CGSizeMake(_previewView.frame.size.width, _previewView.frame.size.height));
    
    CGRect rect = CGRectMake(0, 0, _previewView.frame.size.width, _previewView.frame.size.height);
    CGRect rect1 = CGRectMake(lgtmViewX,lgtmViewY, lgtmViewW, lgtmViewH);
    NSLog(@"savePhoto-x+%f+y+%f", lgtmViewX, lgtmViewY);
    [_shutter.image drawInRect:rect];
    [_lgtmView.image drawInRect:rect1];

    _lgtmView.center = CGPointMake(px, py);
    
    // 現在のコンテキストのビットマップをUIImageとして取得
     mixed = UIGraphicsGetImageFromCurrentImageContext();
    // コンテキストを閉じる
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(mixed, self, nil, nil);
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (baseView) {
        return;
    }else{
    if ([touches count] == 1) {
        CGPoint p = [[touches anyObject]locationInView:_previewView];
        _lgtmView.center = p;
        
        lgtmViewX = _lgtmView.frame.origin.x;
        lgtmViewY = _lgtmView.frame.origin.y;
        
        lgtmViewW = _lgtmView.frame.size.width;
        lgtmViewH = _lgtmView.frame.size.height;
    } else if ([touches count] == 2) {
        //2本指でタッチしている場合は、２点間の距離を計算
        NSArray *twoFingers = [touches allObjects];
        UITouch *touch1 = [twoFingers objectAtIndex:0];
        UITouch *touch2 = [twoFingers objectAtIndex:1];
        CGPoint previous1 = [touch1 previousLocationInView:self.previewView];
        CGPoint previous2 = [touch2 previousLocationInView:self.previewView];
        CGPoint now1 = [touch1 locationInView:self.previewView];
        CGPoint now2 = [touch2 locationInView:self.previewView];
        
        //現状の距離と、前回の距離を比較して距離が縮まったか離れたかを判別
        CGFloat previousDistance = [self distanceWithPointA:previous1 pointB:previous2];
        CGFloat distance = [self distanceWithPointA:now1 pointB:now2];
        
        CGFloat scale = 1.0;
        if (previousDistance > distance) {
            //距離が縮まったらならピンチイン
            scale -= ( previousDistance - distance ) / 300.0;
        } else if (distance > previousDistance) {
            // 距離が広がったならピンチアウト
            scale += ( distance - previousDistance ) / 300.0;
        }
        CGAffineTransform newTransform =
        CGAffineTransformScale(_lgtmView.transform, scale, scale);
        _lgtmView.transform = newTransform;
        _lgtmView.center = self.previewView.center;
        }
    }
}
- (CGFloat)distanceWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB
{
    CGFloat dx = fabs( pointB.x - pointA.x );
    CGFloat dy = fabs( pointB.y - pointA.y );
    return sqrt(dx * dx + dy * dy);
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
-(void)addUploadBaseViewFadeIn{
    if (baseView) {
        CGAffineTransform t = CGAffineTransformMakeRotation(0 * M_PI / 180);
        menuBtn.transform = t;
        [self uploadBaseViewFadeOut];
    }else{
    
    baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _previewView.frame.size.width, _previewView.frame.size.height)];
    baseView.alpha = 0;
    baseView.backgroundColor = RGB(51, 51, 51);

    twitterBtn = [self twitterButton];
    saveBtn = [self saveButton];
//    mailBtn = [self mailButton];
        
    twitterBtn.alpha = 0;
    saveBtn.alpha = 0;
//    mailBtn.alpha = 0;
        
    [_previewView addSubview:baseView];
    [baseView addSubview:twitterBtn];
    [baseView addSubview:saveBtn];
//    [baseView addSubview:mailBtn];
        
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];
    baseView.alpha = 0.9;
    twitterBtn.alpha = 1;
    saveBtn.alpha = 1;
//    mailBtn.alpha = 1;
    [UIView commitAnimations];
    
    CGAffineTransform t = CGAffineTransformMakeRotation(45 * M_PI / 180);
    menuBtn.transform = t;
    }
}

-(void)uploadBaseViewFadeOut{
    [UIView beginAnimations:@"fadeOut" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    baseView.alpha = 0;
    [baseView removeFromSuperview];
    baseView = nil;
    [UIView commitAnimations];
}


-(void)addTakeButton{
    if ([self is4inch]) {
        takeTabView = [[UIView alloc]initWithFrame:CGRectMake(0, _previewView.frame.size.height, _previewView.frame.size.width, 90)];
    }else{
        takeTabView = [[UIView alloc]initWithFrame:CGRectMake(0, _previewView.frame.size.height-80, _previewView.frame.size.width, 80)];
    }
    takeTabView.backgroundColor = RGB(51, 51, 51);
    takeTabView.alpha = 0.5;
    [self.view addSubview:takeTabView];
    
    takeBtn = [self takeButton];
    imageSearchBtn = [self imageSearchButton];
    
//    [takeTabView addSubview:imageSearchBtn];
    [takeTabView addSubview:takeBtn];
}


-(void)pressTwitterButton{
    [self GetImageFromCurrentImageContext];
    SLComposeViewController *tw = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tw setInitialText:@"LGTM!"];
    [tw addImage:mixed];
    [self presentViewController:tw animated:YES completion:nil];
    [self backTabView];
}
-(void)pressSaveButton:(id)sender{
    [self GetImageFromCurrentImageContext];
    [self backTabView];
}
-(void)pressMailButton{
    MCVC = [[MFMailComposeViewController alloc]init];
    MCVC.mailComposeDelegate = self;
    [MCVC setSubject:@"LGTM! for LGTMcamera"];
    
    [self GetImageFromCurrentImageContext];
    NSData *data = [[NSData alloc]initWithData:UIImageJPEGRepresentation(mixed, 1)];
    [MCVC addAttachmentData:data mimeType:@"image/jpeg" fileName:@"LGTM!image"];
    [MCVC setMessageBody:@"LGTM!" isHTML:NO];
    [self presentViewController:MCVC animated:NO completion:nil];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MFMailComposeResultSent:
            [self dismissViewControllerAnimated:YES completion:nil];
            [self backTabView];
            break;
        default:
            break;
    }
}
-(UIButton *)twitterButton{
    UIButton *twitterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    twitterButton.center = CGPointMake(baseView.frame.size.width/4.6, baseView.frame.size.height/2);
    [twitterButton setBackgroundImage:[UIImage imageNamed:@"1_twitter"] forState:UIControlStateNormal];
    [twitterButton addTarget:self action:@selector(pressTwitterButton) forControlEvents:UIControlEventTouchUpInside];
    return twitterButton;
}
-(UIButton *)mailButton{
    UIButton *mailButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    mailButton.center = CGPointMake(baseView.frame.size.width/1.2, baseView.frame.size.height/2);
    [mailButton setBackgroundImage:[UIImage imageNamed:@"1_mail"] forState:UIControlStateNormal];
    [mailButton addTarget:self action:@selector(pressMailButton) forControlEvents:UIControlEventTouchUpInside];
    return mailButton;
}

-(UIButton *)saveButton{
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    saveButton.center = CGPointMake(baseView.frame.size.width/1.3, baseView.frame.size.height/2);
    [saveButton setBackgroundImage:[UIImage imageNamed:@"1_save"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(pressSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    return saveButton;
}

-(UIButton *)addLGTMButton{
    UIButton *addLGTMButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    addLGTMButton.center = CGPointMake(takeTabView.frame.size.width/1.2, takeTabView.frame.size.height/2);
    [addLGTMButton setBackgroundImage:[UIImage imageNamed:@"LGTM.png"] forState:UIControlStateNormal];
    [addLGTMButton addTarget:self action:@selector(addLGTMSelectionView) forControlEvents:UIControlEventTouchUpInside];
    return addLGTMButton;
}
-(UIButton *)menuButton{
    UIButton *menuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    menuButton.center = CGPointMake(takeTabView.frame.size.width/2, takeTabView.frame.size.height/2);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"1_menu"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(addUploadBaseViewFadeIn) forControlEvents:UIControlEventTouchUpInside];
    return menuButton;
}
-(UIButton *)retakeButton{
    UIButton *retakeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    retakeButton.center = CGPointMake(takeTabView.frame.size.width/6, takeTabView.frame.size.height/2);
    [retakeButton setBackgroundImage:[UIImage imageNamed:@"1_back"] forState:UIControlStateNormal];
    [retakeButton addTarget:self action:@selector(backTabView) forControlEvents:UIControlEventTouchUpInside];
    return retakeButton;
}
-(UIButton *)takeButton{
    UIButton *takeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    takeButton.center = CGPointMake(takeTabView.frame.size.width/2, takeTabView.frame.size.height/2);
    [takeButton setBackgroundImage:[UIImage imageNamed:@"1_take"] forState:UIControlStateNormal];
    [takeButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    return takeButton;
}
-(void)pressImageSearchButton{
    imageSearchViewController *vc = [[imageSearchViewController alloc]initWithNibName:@"imageSearchViewController" bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}
-(UIButton *)imageSearchButton{
    UIButton *imageSearchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageSearchButton.center = CGPointMake(takeTabView.frame.size.width/4, takeTabView.frame.size.height/2);
    [imageSearchButton setBackgroundImage:[UIImage imageNamed:@"1_search"] forState:UIControlStateNormal];
    [imageSearchButton addTarget:self action:@selector(pressImageSearchButton) forControlEvents:UIControlEventTouchUpInside];
    return imageSearchButton;
}
-(UILabel *)retakeLabel{
    UILabel *retakeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 15)];
    retakeLabel.center = CGPointMake(takeTabView.frame.size.width/6, takeTabView.frame.size.height/1.1);
    retakeLabel.backgroundColor = RGB(51, 51, 51);
    retakeLabel.alpha = 0.8;
    retakeLabel.textColor = [UIColor whiteColor];
    retakeLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:13];
    retakeLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
    retakeLabel.text = @"retake";
    return retakeLabel;
}

-(UILabel *)menuLabel{
    UILabel *menuLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 15)];
    menuLabel.center = CGPointMake(takeTabView.frame.size.width/2, takeTabView.frame.size.height/1.1);
    menuLabel.backgroundColor = RGB(51, 51, 51);
    menuLabel.alpha = 0.8;
    menuLabel.textColor = [UIColor whiteColor];
    menuLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:13];
    menuLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
    menuLabel.text = @"save";
    return menuLabel;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
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
- (void)setupAVCapture{
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
    captureVideoPreviewLayer.frame = _previewView.frame;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self setVideoOrientation];
    
    //  Setting Layer in View
    previewLayer = self.previewView.layer;
    previewLayer.masksToBounds = YES;    
    [previewLayer addSublayer:captureVideoPreviewLayer];
    
    //    Session Start
    [self.session startRunning];
}
- (void)setVideoOrientation{
    for(AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        if(connection.supportsVideoOrientation)
        {
            connection.videoOrientation = [self videoOrientation];
            //            NSLog(@"麒+%d", connection.videoOrientation);
        }
    }
}

-(BOOL)is4inch{
    CGSize SS = [[UIScreen mainScreen]bounds].size;
    return SS.width == 320 && SS.height == 568;
}

- (void)objectOrientation{
    
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
    retakeBtn.transform = t;
    takeBtn.transform = t;
    [UIView commitAnimations];
}
@end
