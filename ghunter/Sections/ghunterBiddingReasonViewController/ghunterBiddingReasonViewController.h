//
//  ghunterBiddingReasonViewController.h
//  ghunter
//
//  Created by ImGondar on 15/12/28.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIAlertView.h"
#import "ImgScrollView.h"
#import "ZYQAssetPickerController.h"
#import "SJAvatarBrowser.h"
#import "AFNetworkTool.h"
#import "Header.h"
#import "ProgressHUD.h"
#import "ghunterRequester.h"
#import "ghunterLoadingView.h"


@interface ghunterBiddingReasonViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ImgScrollViewDelegate,UIScrollViewDelegate>
{
    SIAlertView *pictureAlert;
    NSMutableArray *imgArray;
    UIScrollView *myScrollView;
    UIView *scrollPanel;
    NSInteger currentIndex;
    ImgScrollView *lastImgScrollView;
    UIView *markView;
    NSMutableDictionary *task;
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
// 同步到任务秀
@property (strong, nonatomic) IBOutlet UIButton *skillShowBtn;
// 剩余
@property (strong, nonatomic) IBOutlet UILabel *textNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;

@property (strong, nonatomic) IBOutlet UIButton *determineBtn;

//TextView
@property (strong, nonatomic) IBOutlet UITextView *contentTV;
@property (strong, nonatomic) IBOutlet UILabel *textVLabel;

// 上传的图片
@property (strong, nonatomic) IBOutlet UIImageView *img0;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img3;

@property (nonatomic, strong) NSMutableArray *checkmarkImageViews;
@property (nonatomic, strong) NSMutableArray *selectedIndexes;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) NSString *tidStr;
@property (assign,nonatomic)NSString *isjoin;
@property (nonatomic, copy) NSString * flagStr;
@property (strong, nonatomic) IBOutlet UILabel *synchronizeLabel;

@property (nonatomic, strong) NSMutableDictionary * postDic;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;

@end
