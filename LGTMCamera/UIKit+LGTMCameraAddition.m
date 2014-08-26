//
//  UIKit+LGTMCameraAddition.m
//  LGTMCamera
//
//  Created by fumiharu on 2014/08/26.
//  Copyright (c) 2014年 fumiharu. All rights reserved.
//

#import "UIKit+LGTMCameraAddition.h"
#import "ViewController.h"

@implementation UIViewController (LGTMCameraAddition)

-(UIButton *)twitterButton{
    UIButton *twitterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    [twitterButton setBackgroundImage:[UIImage imageNamed:@"1_twitter"] forState:UIControlStateNormal];
    [twitterButton addTarget:self action:@selector(pressTwitterButton) forControlEvents:UIControlEventTouchUpInside];
    return twitterButton;
}
-(UIButton *)mailButton{
    UIButton *mailButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    [mailButton setBackgroundImage:[UIImage imageNamed:@"1_mail"] forState:UIControlStateNormal];
    [mailButton addTarget:self action:@selector(pressMailButton) forControlEvents:UIControlEventTouchUpInside];
    return mailButton;
}

-(UIButton *)saveButton{
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"1_save"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(pressSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    return saveButton;
}

-(UIButton *)addLGTMButton{
    UIButton *addLGTMButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [addLGTMButton setBackgroundImage:[UIImage imageNamed:@"LGTM.png"] forState:UIControlStateNormal];
    [addLGTMButton addTarget:self action:@selector(addLGTMSelectionView) forControlEvents:UIControlEventTouchUpInside];
    return addLGTMButton;
}
-(UIButton *)menuButton{
    UIButton *menuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"1_menu"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(addUploadBaseViewFadeIn) forControlEvents:UIControlEventTouchUpInside];
    return menuButton;
}
-(UIButton *)retakeButton{
    UIButton *retakeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [retakeButton setBackgroundImage:[UIImage imageNamed:@"1_back"] forState:UIControlStateNormal];
    [retakeButton addTarget:self action:@selector(backTabView) forControlEvents:UIControlEventTouchUpInside];
    return retakeButton;
}
-(UIButton *)takeButton{
    UIButton *takeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [takeButton setBackgroundImage:[UIImage imageNamed:@"1_take"] forState:UIControlStateNormal];
    [takeButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    return takeButton;
}

-(UIButton *)imageSearchButton{
    UIButton *imageSearchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [imageSearchButton setBackgroundImage:[UIImage imageNamed:@"1_search"] forState:UIControlStateNormal];
    [imageSearchButton addTarget:self action:@selector(pressImageSearchButton) forControlEvents:UIControlEventTouchUpInside];
    return imageSearchButton;
}
-(UILabel *)retakeLabel{
    UILabel *retakeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 15)];
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
    menuLabel.backgroundColor = RGB(51, 51, 51);
    menuLabel.alpha = 0.8;
    menuLabel.textColor = [UIColor whiteColor];
    menuLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:13];
    menuLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
    menuLabel.text = @"save";
    return menuLabel;
}

@end
