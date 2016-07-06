//
//  ghunterRewardAndSelectViewController.h
//  ghunter
//
//  Created by ImGondar on 15/12/29.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "Header.h"
#import "ProgressHUD.h"
#import "ghunterLoadingView.h"
#import "AFNetworkTool.h"
//#import "ghunterRewa"
#import "UIImageView+WebCache.h"
#import "ghunterRequester.h"
#import "TQStarRatingView.h"

@interface ghunterRewardAndSelectViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, PullTableViewDelegate>
{
    PullTableView * rewardTableView;
    NSMutableArray * rewardMutArray;
    
//    UITableView * tv;
    TQStarRatingView * star;
    NSInteger page;
}
// 竞标人数
@property (strong, nonatomic) IBOutlet UILabel *bidNumLabel;
@property (nonatomic, copy) NSString * bidString;
@property (nonatomic, copy) NSString * tidString;

//中意
@property (strong, nonatomic) IBOutlet UIButton *joinBtn;


// 三角
@property (strong, nonatomic) IBOutlet UIImageView *rewardImg;

@property (nonatomic ,retain) ghunterLoadingView *loadingView;

@end
