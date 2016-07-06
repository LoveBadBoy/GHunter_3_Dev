//
//  ghunterFindViewController.h
//  ghunter
//
//  Created by chensonglu on 14-3-18.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "BMapKit.h"
#import "BMKMapView.h"
#import "PullTableView.h"
#import "ghuntertaskViewController.h"
#import "UIImageView+WebCache.h"
#import "QRadioButton.h"
#import "UMSocial.h"
#import "showTag.h"
#import "SIAlertView.h"
#import "ghunterUserCenterViewController.h"
#import "TQStarRatingView.h"
#import "THLabel.h"
#import "ghuntertaskViewController.h"
#import "AFNetworkTool.h"
#import "Monitor.h"
#import "SOLoopView.h"
#import "MJPhoto.h"
@interface ghunterNearbyViewController : UIViewController<BMKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,UIScrollViewDelegate,QRadioButtonDelegate,UIAlertViewDelegate>{
    PullTableView *findTaskTableView;
    PullTableView *findSkillTableView;
    NSInteger taskpage;
    NSInteger skillpage;
    QRadioButton *taskRadio;
    QRadioButton *skillRadio;
    UIScrollView *scrollView;
    BOOL skillSelected;
    SIAlertView *taskAlertView;
    SIAlertView *skillAlertView;
    NSMutableArray *chooseArray;
    //任务分类，技能分类
    NSArray *task_catalogs;
    NSArray *skill_catalogs;
    UITableView *listview;
    UIView *hearview;
    //    NSArray *Separatearr;
    UIButton *sortbtn;
    UIButton *filter;
    NSMutableArray *zongarr;
    NSMutableArray *zongimgarr;
    UIView *view;
    BOOL showList;
    BOOL showList2;
    UIImageView *duiimg;
    NSArray * skillarray;
    NSArray *Taskarray;
   
    CGSize contentSizeOne;
    CGSize contentSizeTo;

}
@property (assign,nonatomic) int genint;
@property (assign,nonatomic) NSInteger codeint;
@property (strong,nonatomic) NSString* zhistr;
@property (strong,nonatomic) NSString *strtit;
//@property (strong,nonatomic) DropDownListView *dropDown;
@property(nonatomic,retain)NSMutableArray *findtaskArray;
@property(nonatomic,retain)NSMutableArray *findskillArray;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@end
