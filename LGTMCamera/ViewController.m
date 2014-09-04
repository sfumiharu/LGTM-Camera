//
//  ViewController.m
//  LGTMCamera
//
//  rated by fumiharu on 2014/05/17.
//  Copyright (c) 2014年 fumiharu. All rights reserved.
//

#import "ViewController.h"
#import "imageSearchViewController.h"
#import "UIKit+LGTMCameraAddition.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>

@interface ViewController (){
    CGFloat lgtmViewX;
    CGFloat lgtmViewY;
    CGFloat lgtmViewW;
    CGFloat lgtmViewH;
    CGFloat px;
    CGFloat py;
    CGFloat width, height;
    CGRect frame;

    UIButton *addLGTMBtn;
    UIButton *twitterBtn;
    UIButton *saveBtn;
    UIButton *retakeBtn;
    UIButton *takeBtn;
    UIButton *changeDeviceBtn;
    UIButton *changeFlashBtn;
    UIButton *menuBtn;
    UIButton *mailBtn;
    UIButton *camLibBtn;
    UIButton *imageSearchBtn;
    UILabel *retakeLbl;
    UILabel *menuLbl;
    NSArray *lgtmSelectionButtonList;
    NSArray *lgtmSelectionButtonName;
    CALayer *previewLayer;
    UIImage *mixed;
    UIImage *imag;
    UIScrollView *sv;
    UIDeviceOrientation deviceOrientation;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    MFMailComposeViewController *MCVC;
    AVCaptureDeviceInput *frontFacingCameraDeviceInput;
    AVCaptureDeviceInput *backFacingCameraDeviceInput;

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


-(NSURL *)camLibIcon{
    __block NSURL *url1;
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc]init];
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                       usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                           [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                           
                           NSUInteger index = [group numberOfAssets] - 1;
                           NSIndexSet *lastPhoto = [NSIndexSet indexSetWithIndex:index];
                           [group enumerateAssetsAtIndexes:lastPhoto
                                                   options:0
                                                usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                    NSLog(@"えらーだおｙ");
                                                    if (result) {
                                                        ALAssetRepresentation *representation = [result defaultRepresentation];
                                                        NSURL *url = [representation url];
                                                        //                                                        AVAsset *avAsset = [AVURLAsset URLAssetWithURL:url
                                                        //                                                                                               options:nil];
                                                        NSLog(@"url%@", url);
                                                        url1 = url;
                                                        NSLog(@"url11%@", url1);
                                                    }
                                                }];
                       } failureBlock:^(NSError *error) {
                           NSLog(@"エラー！");
                       }];
    NSLog(@"url1%@", url1);
    return url1;
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
    self.view.multipleTouchEnabled = YES;

    lgtmSelectionButtonList = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", nil];
    lgtmSelectionButtonName = [NSArray arrayWithObjects:@"LGTM0", @"LGTM1", @"LGTM3", @"LGTM4", @"LGTM5", nil];
    
    UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 50, 50)];
    vv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"assets-library://asset/asset.JPG?id=6A37CFE4-AEB0-44B9-A5EE-AFCAE3B6F204&ext=JPG"]]]];


    [_setImageView addSubview:vv];
//    [self camLibIcon];
    [self setFirstView];
    [self setupAVCapture];
    [self setCameraDeviceInput];
}

-(void)setFirstView{
    [_setImageView removeFromSuperview];
    _setImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_setImageView];
    NSLog(@"sel.w+%f,,,+%f", self.view.frame.size.width, self.view.frame.size.height);

    
    if ([self is4inch]) {
        takeTabView = [[UIView alloc]initWithFrame:CGRectMake(0, _setImageView.frame.size.height-90, _setImageView.frame.size.width, 90)];
        accessoriesTabView = [[UIView alloc]initWithFrame:CGRectMake(0, _setImageView.frame.size.height-140, _setImageView.frame.size.width, 50)];
    }else{
        takeTabView = [[UIView alloc]initWithFrame:CGRectMake(0, _setImageView.frame.size.height-80, _setImageView.frame.size.width, 80)];
        accessoriesTabView = [[UIView alloc]initWithFrame:CGRectMake(0, _setImageView.frame.size.height-130, _setImageView.frame.size.width, 50)];
    }
    
    takeTabView.backgroundColor = RGB(51, 51, 51);
    takeTabView.alpha = 0.5;
    [self.view addSubview:takeTabView];
    
    accessoriesTabView.backgroundColor = RGB(51, 51, 51);
    accessoriesTabView.alpha = 0.5;
    [self.view addSubview:accessoriesTabView];

    takeBtn = [self takeButton];
    takeBtn.center = CGPointMake(takeTabView.frame.size.width/2, takeTabView.frame.size.height/2);
    
    imageSearchBtn = [self imageSearchButton];
    imageSearchBtn.center = CGPointMake(takeTabView.frame.size.width/6, takeTabView.frame.size.height/2);
    
    camLibBtn = [self camLibraryButton];
    camLibBtn.center = CGPointMake(takeTabView.frame.size.width/1.2, takeTabView.frame.size.height/2);
    
    [takeTabView addSubview:imageSearchBtn];
    [takeTabView addSubview:takeBtn];
    [takeTabView addSubview:camLibBtn];

    
    changeDeviceBtn = [self switchingCameraButton];
    changeDeviceBtn.center = CGPointMake(accessoriesTabView.frame.size.width/1.2, accessoriesTabView.frame.size.height/2);
    [accessoriesTabView addSubview:changeDeviceBtn];
    
    changeFlashBtn = [self switchingFlashButton];
    changeFlashBtn.center = CGPointMake(accessoriesTabView.frame.size.width/2.4, accessoriesTabView.frame.size.height/2);
    [accessoriesTabView addSubview:changeFlashBtn];
    
}

#pragma mark Setting Of TabViews
-(void)takedTabView{
    [takeTabView removeFromSuperview];
    [accessoriesTabView removeFromSuperview];
//    takeTabView.center = CGPointMake(_setImageView.frame.size.width-(_setImageView.frame.size.width*2), _setImageView.frame.size.height - 40);
    
    if ([self is4inch]) {
        takedTabView = [[UIView alloc]initWithFrame:CGRectMake(0, _setImageView.frame.size.height-90, _setImageView.frame.size.width, 90)];
    }else{
        takedTabView = [[UIView alloc]initWithFrame:CGRectMake(0, _setImageView.frame.size.height-80, _setImageView.frame.size.width, 80)];
    }
    
    takedTabView.backgroundColor = RGB(51, 51, 51);
    takedTabView.alpha = 0.5;
    
//    takedTabView.center = CGPointMake(_setImageView.frame.size.width / 2, _setImageView.frame.size.height - 40);
    
    [self.view addSubview:takedTabView];
    
    addLGTMBtn = [self addLGTMButton];
    addLGTMBtn.center = CGPointMake(takeTabView.frame.size.width/1.2, takeTabView.frame.size.height/2);
    
    retakeBtn = [self retakeButton];
    retakeBtn.center = CGPointMake(takeTabView.frame.size.width/6, takeTabView.frame.size.height/2);
    
    menuBtn = [self menuButton];
    menuBtn.center = CGPointMake(takeTabView.frame.size.width/2, takeTabView.frame.size.height/2);
    
    retakeLbl = [self retakeLabel];
    retakeLbl.center = CGPointMake(takeTabView.frame.size.width/6, takeTabView.frame.size.height/1.1);
    
    menuLbl = [self menuLabel];
    menuLbl.center = CGPointMake(takeTabView.frame.size.width/2, takeTabView.frame.size.height/1.1);

    
    [takedTabView addSubview:menuBtn];
    [takedTabView addSubview:addLGTMBtn];
    [takedTabView addSubview:retakeBtn];
    [takedTabView addSubview:retakeLbl];
    [takedTabView addSubview:menuLbl];
}
-(void)backTabView{
    [self setFirstView];

    [takedTabView removeFromSuperview];
//    takedTabView.center = CGPointMake((_setImageView.frame.size.width * 3) / 2, _setImageView.frame.size.height - 40);
    
    [_lgtmView removeFromSuperview];
    [sv removeFromSuperview];
    [self uploadBaseViewFadeOut];
    
    _lgtmView = nil;
    sv = nil;
    _imageData = nil;
    
    [previewLayer addSublayer:captureVideoPreviewLayer];
    [self setupAVCapture];
//    [self.session startRunning];

}

#pragma mark Press Button Method
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

-(void)pressCamLibButton{
    UIImagePickerController *IPC = [[UIImagePickerController alloc]init];
    [IPC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [IPC setAllowsEditing:YES];
    [IPC setDelegate:self];
    [self presentViewController:IPC animated:YES completion:nil];
}

-(void)pressImageSearchButton{
    imageSearchViewController *vc = [[imageSearchViewController alloc]initWithNibName:@"imageSearchViewController" bundle:nil];
    vc.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

-(void)addLGTMSelectionView{
    if (sv || baseView) {
        return;
    }
    
    //    LGTM Selection ScrollView
    sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 250, 320)];
    sv.backgroundColor = RGB(51, 51, 51);
    sv.center = self.view.center;
    //    sv.contentSize = CGSizeMake(0, 1200);
    [self.view addSubview:sv];
    
    //    LGTM images Placement on ScrollView
    int y = 10;
    for (int i = 0; i < [lgtmSelectionButtonList count]; i ++) {
        UIButton *lgtmSelectionButton = [[UIButton alloc]initWithFrame:CGRectMake(sv.frame.origin.x/2, y, 200, 50)];
        [lgtmSelectionButton setBackgroundImage:[UIImage imageNamed:[lgtmSelectionButtonName objectAtIndex:i]] forState:UIControlStateNormal];
        [lgtmSelectionButton addTarget:self action:@selector(pressLGTMImage:) forControlEvents:UIControlEventTouchUpInside];
        lgtmSelectionButton.tag = i;
        [sv addSubview:lgtmSelectionButton];
        y = y +60;
    }
}

-(void)pressLGTMImage:(UIButton *)sender{
    [_lgtmView removeFromSuperview];
    _lgtmView = nil;
    
    UIImage *image = [UIImage imageNamed:[lgtmSelectionButtonName objectAtIndex:sender.tag]];
    _lgtmView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    _lgtmView.image = image;
    _lgtmView.center = CGPointMake(_setImageView.frame.size.width/2, _setImageView.frame.size.height/2);
    _lgtmView.contentMode = UIViewContentModeScaleAspectFill;
    
    [sv removeFromSuperview];
    sv = nil;
    [_setImageView addSubview:_lgtmView];
}

-(void)pressTakeButton{
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
         [_setImageView setImage:[UIImage imageWithData:_imageData]];
         frame.size.width = _setImageView.frame.size.width;
         frame.size.height = _setImageView.frame.size.height;
     }];
    [self takedTabView];
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

-(void)addUploadBaseViewFadeIn{
    if (baseView) {
        CGAffineTransform t = CGAffineTransformMakeRotation(0 * M_PI / 180);
        menuBtn.transform = t;
        [self uploadBaseViewFadeOut];
    }else{
        
        baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-90)];
        baseView.alpha = 0;
        baseView.backgroundColor = RGB(51, 51, 51);
        
        twitterBtn = [self twitterButton];
        twitterBtn.center = CGPointMake(baseView.frame.size.width/4.6, baseView.frame.size.height/2);
        
        saveBtn = [self saveButton];
        saveBtn.center = CGPointMake(baseView.frame.size.width/1.3, baseView.frame.size.height/2);
        
        //    mailBtn = [self mailButton];
        //    mailButton.center = CGPointMake(baseView.frame.size.width/1.2, baseView.frame.size.height/2);
        
        twitterBtn.alpha = 0;
        saveBtn.alpha = 0;
        //    mailBtn.alpha = 0;
        
        [self.view addSubview:baseView];
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

#pragma mark Orientation Method
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

- (void)setVideoOrientation{
    for(AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        if(connection.supportsVideoOrientation)
        {
            connection.videoOrientation = [self videoOrientation];
        }
    }
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
    
    twitterBtn.transform = t;
    saveBtn.transform = t;
    changeDeviceBtn.transform = t;
    menuBtn.transform = t;
    camLibBtn.transform = t;
    imageSearchBtn.transform = t;
    retakeLbl.transform = t;
    menuLbl.transform = t;
    
    [UIView commitAnimations];
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


#pragma mark Delegate Method
-(void)imageSearchViewDelegate:(id)im{
    [self takedTabView];
    [captureVideoPreviewLayer removeFromSuperlayer];
    
    imag = im;
    //    [_setImageView setImage:imag];
    frame = AVMakeRectWithAspectRatioInsideRect(imag.size, _setImageView.bounds);
    NSLog(@"setimage.w+%f,,,+%f", frame.size.width, frame.size.height);
    
    
    [_setImageView setFrame:CGRectMake(0, 0,  frame.size.width, frame.size.height)];
    [_setImageView setImage:imag];
    
    NSLog(@"setimage22.w+%f,,,+%f", frame.size.width, frame.size.height);
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    [self takedTabView];
    [captureVideoPreviewLayer removeFromSuperlayer];
    
    UIImage *IPCImage = [editingInfo objectForKey: UIImagePickerControllerOriginalImage];
    frame = AVMakeRectWithAspectRatioInsideRect(IPCImage.size, _setImageView.bounds);
    NSLog(@"setimage.w+%f,,,+%f", IPCImage.size.width, IPCImage.size.height);
    
    
    [_setImageView setFrame:CGRectMake(0, 0,  frame.size.width, frame.size.height)];
    [_setImageView setImage:IPCImage];
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:IPCImage];
    //    imageView.frame = CGRectMake(0,0,image.size.width,image.size.height);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
-(BOOL)is4inch{
    CGSize SS = [[UIScreen mainScreen]bounds].size;
    return SS.width == 320 && SS.height == 568;
}

-(void)swichingDevice{
//    [_session beginConfiguration];
//    [_session removeInput:fron]
}

-(void)GetImageFromCurrentImageContext{
    _shutter = [[UIImageView alloc]initWithImage:_setImageView.image];
    
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 2);
    UIGraphicsBeginImageContext(CGSizeMake(frame.size.width, frame.size.height));
    
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
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
            CGPoint p = [[touches anyObject]locationInView:_setImageView];
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
            CGPoint previous1 = [touch1 previousLocationInView:self.view];
            CGPoint previous2 = [touch2 previousLocationInView:self.view];
            CGPoint now1 = [touch1 locationInView:self.view];
            CGPoint now2 = [touch2 locationInView:self.view];
            
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
            _lgtmView.center = _setImageView.center;
        }
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
    captureVideoPreviewLayer.frame = _setImageView.frame;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self setVideoOrientation];
    
    //  Setting Layer in View
    previewLayer = _setImageView.layer;
    previewLayer.masksToBounds = YES;
    [previewLayer addSublayer:captureVideoPreviewLayer];
    
    //    Session Start
    [self.session startRunning];
}

#pragma mark
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//- (AVCaptureDevice *)frontFacingCameraIfAvailable
//{
//    //  look at all the video devices and get the first one that's on the front
//    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
//    AVCaptureDevice *captureDevice = nil;
//    for (AVCaptureDevice *device in videoDevices)
//    {
//        if (device.position == AVCaptureDevicePositionFront)
//        {
//            captureDevice = device;
//            break;
//        }
//    }
//    
//    //  couldn't find one on the front, so just get the default video device.
//    if ( ! captureDevice)
//    {
//        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    }
//    
//    return captureDevice;
//}


-(void)changeDevice{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
//    animation.repeatCount = 2;
//    animation.autoreverses = NO;
    CATransform3D transform = CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0);
    animation.toValue = [NSNumber valueWithCATransform3D:transform];
    
    [_setImageView.layer addAnimation:animation forKey:@"transform"];
    [takeTabView.layer addAnimation:animation forKey:@"transform"];
    [accessoriesTabView.layer addAnimation:animation forKey:@"transform"];

    
    [_session beginConfiguration];
    //初回設定
//    if([_session.inputs count] == 0){
//        [_session addInput:backFacingCameraDeviceInput];
        //2回目以降
//    }else{
    
        AVCaptureDeviceInput *deviceInput = (AVCaptureDeviceInput *)[_session.inputs objectAtIndex:0];
        AVCaptureDevice *device = deviceInput.device;
        AVCaptureDeviceInput *nextDeviceInput;
        if (device.position == AVCaptureDevicePositionBack) {
            nextDeviceInput = frontFacingCameraDeviceInput;
        }else{
            nextDeviceInput = backFacingCameraDeviceInput;
        }
        [_session removeInput:deviceInput];
        [_session addInput:nextDeviceInput];
    
    [_session commitConfiguration];
}

-(void)setCameraDeviceInput{
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            NSError *error = nil;
            if (device.position == AVCaptureDevicePositionBack) {
                backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            }else{
                frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            }
        }
    }
}

-(void)changeFlash{
    NSError *error;
    if([backFacingCameraDeviceInput.device lockForConfiguration:&error]){
        //Flashがついている場合
        if(backFacingCameraDeviceInput.device.flashActive){
            changeFlashBtn.layer.shadowOpacity = 0;

            backFacingCameraDeviceInput.device.flashMode = AVCaptureFlashModeOff;
            //Flashがついていない場合
        }else{
            changeFlashBtn.layer.shadowOffset = CGSizeMake(0, 0);
            changeFlashBtn.layer.shadowOpacity = 1;
            changeFlashBtn.layer.shadowColor = [UIColor whiteColor].CGColor;
            changeFlashBtn.layer.shadowRadius = 7;
            backFacingCameraDeviceInput.device.flashMode = AVCaptureFlashModeOn;
        }
        [backFacingCameraDeviceInput.device unlockForConfiguration];
        //エラーが発生した場合
        NSLog(@"おす");
    }else{
        NSLog(@"era-");
    }
}
@end
