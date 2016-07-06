//
//  ghunterReleaseViewController.h
//  ghunter
//
//  Created by chensonglu on 14-4-15.
//  Copyright (c) 2014年 ghunter. All rights reserved.
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
#import "ghunteraddresViewController.h"
#import "ghunterMyFollowViewController.h"
#import "ghunterShareGoldsViewController.h"
#import "Header.h"

typedef void(^callBack)();

@interface ghunterReleaseViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ImgScrollViewDelegate,UIScrollViewDelegate> {
    SIAlertView *ageAlert;
    SIAlertView *pictureAlert;
    NSMutableArray *imgArray;
    UIScrollView *myScrollView;
    NSInteger currentIndex;
    UIView *markView;
    UIView *scrollPanel;
    ImgScrollView *lastImgScrollView;
    
//    UIScrollView * taskScrollview;
    
    CGFloat balanceInt;
    NSString * tmpBalanceStr;
    NSString * goldNumStr;
    
    
    NSString * qqZoneStr;
    NSString * wxCircleStr;
    NSString * qqFriendStr;
    NSString * wxFriendStr;
    NSString * weiboStr;
    NSString * totalNumStr;
}
@property (strong,nonatomic) NSString *strtext;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@property (copy, nonatomic)callBack callBackBlock;
@property(nonatomic,assign)BOOL releasingTask;
@property (strong, nonatomic) IBOutlet UILabel *lontion;

@property (strong, nonatomic) IBOutlet UILabel *isSetting;

@property (nonatomic) NSUInteger added_bounty;
@property (strong, nonatomic)  UILabel * balance;
@property (strong, nonatomic)  UITextField * gold;
@property (strong, nonatomic)  NSString *price;
@property (nonatomic) NSUInteger type;

@property (nonatomic, copy) NSString * qqZoneStr;
@property (nonatomic, copy) NSString * wxCircleStr;
@property (nonatomic, copy) NSString * qqFriendStr;
@property (nonatomic, copy) NSString * wxFriendStr;
@property (nonatomic, copy) NSString * weiboStr;
@property (nonatomic, copy) NSString * totalNumStr;

@end
