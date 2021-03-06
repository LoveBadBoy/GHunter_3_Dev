//
//  ghunterFindSkillViewController.h
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
#import "UMSocial.h"
#import "showTag.h"
#import "SIAlertView.h"
#import "ghunterUserCenterViewController.h"
#import "TQStarRatingView.h"
//#import "THLabel.h"
#import "ghuntertaskViewController.h"
#import "AFNetworkTool.h"

@interface ghunterFindSkillViewController : UIViewController<BMKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>{
//    PullTableView *findTaskTableView;
    PullTableView *findSkillTableView;
    NSInteger taskpage;
    NSInteger skillpage;
    BOOL skillSelected;
    SIAlertView *taskAlertView;
    SIAlertView *skillAlertView;
    
    UIScrollView * skillTopScrollVIew;
    NSMutableArray * skillArray;
    UIButton * skillTopBtn;
    UILabel * skillLabel;
    UIButton * skillNotselectBtn;
    UIScrollView * skillBackScrollView;
    
    NSInteger skillTmpNum;
    NSInteger skillPagesAdd;
    NSMutableArray * skillMoreDataArr;
}
//@property(nonatomic,retain)NSMutableArray *findtaskArray;
//@property(nonatomic,retain)NSMutableArray *findskillArray;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@property(nonatomic, retain) NSString *filter4task;
@property(nonatomic, retain) NSString *filter4skill;
@property(nonatomic, assign) NSInteger skillCid;
@property(nonatomic, assign) NSInteger taskCid;
@property (nonatomic, retain) NSString *nametitle;

@property(nonatomic, strong) UIView * skillRedView;
@property(nonatomic, copy) NSString * skillArrCount;
@property(nonatomic, copy) NSString * skillCurrentPage;



@end
