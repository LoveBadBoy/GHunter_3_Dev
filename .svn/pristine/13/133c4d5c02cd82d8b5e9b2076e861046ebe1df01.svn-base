//
//  ghunterSkillReleaseViewController.h
//  ghunter
//
//  Created by imgondar on 15/1/23.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterAddGoldViewController.h"
#import "ghunterAddCatalogViewController.h"
#import "ZYQAssetPickerController.h"
#import "AOTag.h"
#import "ghunterRequester.h"
#import "ghuntertaskViewController.h"
#import "ghunterLoadingView.h"
#import "SIAlertView.h"
#import "SJAvatarBrowser.h"
#import "ImgScrollView.h"

@interface ghunterSkillReleaseViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ImgScrollViewDelegate,UIScrollViewDelegate>
{
    SIAlertView *ageAlert;
    SIAlertView *pictureAlert;
    SIAlertView *goldAlert;

    UIScrollView *myScrollView;
    NSInteger currentIndex;
    UIView *markView;
    UIView *scrollPanel;
    NSMutableArray* imgArray;
    ImgScrollView *lastImgScrollView;
    NSString * tmpBalanceStr;
    float keyBoardHeight;
    NSString * goldNumStr;
//    UIScrollView * backGScrollview;
}

@property(nonatomic,strong)NSDictionary* skillDic;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;

// 修改定向任务保存参数的dic
@property(nonatomic,strong)NSDictionary *task;

@end
