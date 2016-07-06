//
//  ghunterFindTaskViewController.h
//  ghunter
//
//  Created by imgondar on 15/7/14.
//  Copyright (c) 2015年 ghunter. All rights reserved.
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

@interface ghunterFindTaskViewController : UIViewController<BMKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,UIScrollViewDelegate,QRadioButtonDelegate,UIAlertViewDelegate>{
    PullTableView *findTaskTableView;
//    PullTableView *findSkillTableView;
//    NSInteger taskpage;
    NSInteger skillpage;
    QRadioButton *taskRadio;
    QRadioButton *skillRadio;
    UIScrollView *scrollView;
    BOOL skillSelected;
    SIAlertView *taskAlertView;
    SIAlertView *skillAlertView;
    
    UILabel * tabbartxt;
    UIScrollView * topScrollView;
    UIButton * notSelectLb;
    
    UIScrollView * backScroll;
    UIButton * topBtn;
    UILabel * tmpLb;
    NSMutableArray * taskArray;
    NSMutableArray * moreDataArray;
    NSInteger tmpNum;
    NSInteger pagesAdd;
    
    BOOL flag;
}
//@property(nonatomic,retain)NSMutableArray *findtaskArray;
//@property(nonatomic,retain)NSMutableArray *findskillArray;
//@property(nonatomic, retain) NSMutableArray * 

@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@property (strong, nonatomic) UIWindow *window;


@property(nonatomic, retain) NSString *filter4task;
@property(nonatomic, retain) NSString *filter4skill;
@property(nonatomic, assign) NSInteger skillCid;
@property(nonatomic, assign) NSInteger taskCid;
@property (nonatomic, retain) NSString *nametitle;
@property(strong, nonatomic) UIView * redView;
@property(nonatomic, copy) NSString * arrCount;
@property(nonatomic, copy) NSString * currentPage;

@property(nonatomic, retain) NSMutableArray * cataArray;

@end