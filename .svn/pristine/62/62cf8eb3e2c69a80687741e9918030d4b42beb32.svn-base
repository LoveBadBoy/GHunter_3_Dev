//
//  ghuntermytaskViewController.h
//  ghunter
//
//  Created by chensonglu on 14-5-19.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "PullTableView.h"
#import "QRadioButton.h"
#import "ghuntertaskViewController.h"
#import "Monitor.h"

@interface ghunterMyTaskViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,/*QRadioButtonDelegate,*/ UIScrollViewDelegate>{
    PullTableView *biddingTableview;
    PullTableView *undoneTableView;
    PullTableView *doneTableView;
    
    // 增加 待接受
    PullTableView * undoneAcceptTableView;
    // 进行中
    PullTableView * doingTableView;
    // 待评价
    PullTableView * undoneJudgeTableView;
    // 退款中
    PullTableView * doingRefundTableView;
    
    UIScrollView * dataScroll;
    UIScrollView * buttonScroll;
    
    NSInteger biddingpage;
    NSInteger undonepage;
    NSInteger donepage;
    NSInteger doingpage;
    NSInteger undoneAcceptPage;
    NSInteger undoneJudgePage;
    NSInteger doingRefundPage;

    NSMutableArray *biddingArray;
    NSMutableArray *undoneArray;
    NSMutableArray *doneArray;
    NSMutableArray * doingArray;
    NSMutableArray * undoneJudgeArray;
    NSMutableArray * undoneAcceptArray;
    NSMutableArray * doingRefundArray;
    
    BOOL notfinishRequested;
    BOOL finishRequested;
    NSString *biddingDescription;
    NSString *undoneDescription;
    NSString *doneDescription;
    
    //
    NSString * doingDescription;
    NSString * undoneAcceptDescription;
    NSString * undoneJudgeDescription;
    NSString * doingRefundDescription;
    
    UILabel * lineOn;
    
    UILabel * numLabel;
    NSInteger acceptNum;
    NSInteger withDrawNum;
    NSInteger valuateNum;
    NSInteger doingNum;
}

@property (nonatomic ,retain) ghunterLoadingView *loadingView;



@end
