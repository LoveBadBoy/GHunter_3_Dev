//
//  ghunterUserEvaluationViewController.h
//  ghunter
//
//  Created by chensonglu on 14-8-22.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "PullTableView.h"
#import "ghunterUserCenterViewController.h"
#import "TQStarRatingView.h"
#import "ghuntertaskViewController.h"

@interface ghunterUserEvaluationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate>{
    NSUInteger page;
    NSMutableDictionary *user;
    NSMutableArray *evaluations;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// 根据UID获取评价
@property(nonatomic,retain)NSString *uid;
@property(strong,nonatomic)NSString* type;
@property(nonatomic,retain)PullTableView *table;
@end
