//
//  ghunterRegisterTwoViewController.h
//  ghunter
//
//  Created by chensonglu on 14-3-9.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "ghunterRegisterThreeViewController.h"
#import "RadioButton.h"
#import "SIAlertView.h"
#import "ghunterschoolViewController.h"
#import "Monitor.h"
@interface ghunterRegisterTwoViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource> {
    SIAlertView *ageAlert;
    SIAlertView *pictureAlert;
    //NSTimer *timer;
}
@property(nonatomic,retain)NSMutableArray *tags;
@property(retain,nonatomic)NSString *phone;
@property(retain,nonatomic)NSString *password;
@property(nonatomic,retain)NSString *avatarStr;
//@property(nonatomic,retain)NSString *hunterName;
//@property(nonatomic,retain)NSString *birthday;
//@property(nonatomic,retain)NSString *school;
@property(nonatomic,retain)NSString *school_name;
@property(nonatomic,retain)NSString *gender;
@property(nonatomic,retain)NSString *invitecode;
@property(nonatomic,retain)AOTagList *tagList;
@property(nonatomic,retain)NSMutableArray *randomTag;
 

// 是否微信注册
@property(assign,nonatomic)BOOL is_wxlogin;
@property(retain,nonatomic)NSMutableDictionary *wxDic;

@end
