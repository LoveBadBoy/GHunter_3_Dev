//
//  ghunterTabViewController.h
//  ghunter
//
//  Created by chensonglu on 14-3-13.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterTabView.h"
#import "ghunterMyViewController.h"
//#import "ghunterViewController.h"
#import "ghunterDiscoverViewController.h"
#import "ghunterNearbyViewController.h"
#import "ghunterReleaseViewController.h"
#import "ghunterLoginViewController.h"
#import "ghunterRequester.h"
#import "JSBadgeView.h"
#import "ghunterReleaseSkillViewController.h"
#import "SIAlertView.h"

typedef void(^refreshMsg)();

@interface ghunterTabViewController : UITabBarController<UIGestureRecognizerDelegate>{
    ghunterTabView *tab;
    NSTimer *timer;
    
    JSBadgeView *circleBadge;
    JSBadgeView *noticeBadge;
    JSBadgeView *activityBadge;
    
    SIAlertView* shareAlertView ;
}
@property (nonatomic, assign)BOOL didSelectItemOfTabBar;
@property (weak, nonatomic)UIView *badge2;

@property (copy, nonatomic) refreshMsg refreshMsgBlock;

@property(weak,nonatomic)UIView *badgeMineView;

@end
