//
//  ghunterMySkillViewController.h
//  ghunter
//
//  Created by chensonglu on 14-9-16.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "PullTableView.h"
#import "showTag.h"
#import "ghunterRegisterThreeViewController.h"

#import "SJAvatarBrowser.h"
#import "ghunterModifySkillViewController.h"
#import "SIAlertView.h"
#import "ghunterLoadingView.h"
#import "ghuntertaskViewController.h"
#import "ghunterReleaseSkillViewController.h"

@interface ghunterMySkillViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,toshowTagDelegate>{
    PullTableView *myskillTable;
    NSUInteger page;
    SIAlertView *operateAlert;
    NSDictionary* skillDic;
    NSMutableArray *mutablearr;
    UIButton *editbtn;
}

@property(nonatomic,retain)NSDictionary *dic;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@end
