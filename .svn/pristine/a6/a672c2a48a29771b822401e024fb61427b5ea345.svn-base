//
//  ghunterHomeViewController.h
//  ghunter
//
//  Created by chensonglu on 1/Users/dudu/Desktop/陈松路/ghunter/ios/ghunter/ghunter/ghunterHomeViewController.h4-3-13.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "UMSocial.h"
#import "UIImageView+WebCache.h"
#import "PullTableView.h"
#import "ghunterActivityViewController.h"
#import "GifView.h"
#import "ghunterHunterCircleViewController.h"
#import "ghuntersearchViewController.h"
#import "SIAlertView.h"
#import "ghunterWebViewController.h"
#import "ghuntertaskViewController.h"
#import "ghunterUserCenterViewController.h"
#import "CycleScrollView.h"
#import "ghunterNearbyViewController.h"
#import "ghunterFindSkillViewController.h"
#import "ghunterFindTaskViewController.h"
#import "ghunterSigninViewController.h"
@interface ghunterDiscoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,UIScrollViewDelegate>{
    PullTableView *pullTable;
    //新增模块：找任务 找技能数组
    NSMutableArray *FindTaskArray;
    NSMutableArray *FindSkillArray;
    
    NSMutableArray *hotArray;
    NSMutableArray *intrestArray;
    // NSUInteger count;
    ghunterLoadingView *loadingView;
    GifView *activity_gif;
    SIAlertView *shareView;
    SIAlertView* signInView;
    NSTimer *timer;
    UIImageView *bgview;
    
    UIView * pageView;
    
    NSString *signText;
}

// + (UIColor *)getHexColor:(NSString *)hexColor;

@property (strong, nonatomic) IBOutlet UIButton *QRcode;

@end
