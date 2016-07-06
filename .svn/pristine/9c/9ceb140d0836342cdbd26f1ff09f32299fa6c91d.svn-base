//
//  ghunterReleaseSkillViewController.h
//  ghunter
//
//  Created by imgondar on 15/1/28.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "Header.h"
#import "SkillTag.h"
#import "ZYQAssetPickerController.h"
#import "SIAlertView.h"
#import "ImgScrollView.h"
#import "ghunterAddCatalogViewController.h"
#import "ghuntertaskViewController.h"
#import "ghunterLoadingView.h"

typedef void(^callBack)();

@interface ghunterReleaseSkillViewController : UIViewController<SkillTagDelegate,UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,ImgScrollViewDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UITextViewDelegate, UIScrollViewDelegate>
{
    SIAlertView *pictureAlert;
    UIScrollView *myScrollView;
    NSInteger currentIndex;
    UIView *markView;
    UIView *scrollPanel;
    SIAlertView* unitAlert;
    UIScrollView * skillScrollView;
    UIView *PriceView;
    UIView *PriceBackView;
    
    UIView *ServiceView;
    UIImageView *imageOne;
    UIImageView *imageTwo;
    UIImageView *imageThree;
    UIImageView *imageFour;
    UIView *backView;
    NSString *ServiceNum;
    NSString *ServiceTimeNum;
    UITextField * goldTF;
}
@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@property(strong,nonatomic)NSMutableDictionary* skillDic;
@property (copy, nonatomic)callBack callBackBlock;
@property(nonatomic,assign)BOOL releasingSkill;
@end
