//
//  ghuntertaskwithKeyViewController.h
//  ghunter
//
//  Created by chensonglu on 14-3-25.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "PullTableView.h"
#import "ghuntertaskViewController.h"
#import "UIImageView+WebCache.h"
#import "SIAlertView.h"

@interface ghuntertaskwithKeyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>{
    PullTableView *findTableView;
    NSInteger page;
    NSUInteger middleSelected;
    BOOL middleOpen;
    NSArray *catalogs;
    NSDictionary *catalog;
    NSDictionary *parent;
    NSArray *childs;
    SIAlertView *taskAlertView;
}
@property (strong, nonatomic) IBOutlet UILabel *catalogName;
@property(nonatomic,retain)NSMutableArray *findArray;
@property(nonatomic,retain)NSString *catalogNum;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@end
