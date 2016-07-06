//
//  ghunterRegisterThreeViewController.h
//  ghunter
//
//  Created by chensonglu on 14-3-9.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOTag.h"
#import "SkillTag.h"
#import "ghunterRequester.h"
#import "APService.h"
#import "ghunterLoadingView.h"

@interface ghunterRegisterThreeViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,AOTagDelegate,SkillTagDelegate,UIScrollViewDelegate>{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSArray *skillsArray;
    NSInteger currentPageIndex;
    //NSTimer *timer;
}
@property(nonatomic)NSInteger type;
@property(nonatomic,retain)NSMutableArray *tags;
@property(retain,nonatomic)NSString *phone;
@property(retain,nonatomic)NSString *password;
@property(nonatomic,retain)NSString *avatarStr;
@property(nonatomic,retain)NSString *hunterName;
@property(nonatomic,retain)NSString *birthday;
@property(nonatomic,retain)NSString *school;
@property(nonatomic,retain)NSString *school_name;
@property(nonatomic,retain)NSString *gender;
@property(nonatomic,retain)NSString *invitecode;
@property(nonatomic,retain)AOTagList *tagList;
@property(nonatomic,retain)NSMutableArray *randomTag;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;

// 是否微信注册
@property (assign, nonatomic)BOOL is_wxlogin;
@property (retain, nonatomic)NSMutableDictionary *wxDic;

- (void)showUserSkills;
@end
