//
//  ghunterMyReleaseViewController.h
//  ghunter
//
//  Created by chensonglu on 14-5-21.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "PullTableView.h"
#import "ghuntertaskViewController.h"
#import "QRadioButton.h"
#import "Monitor.h"

@interface ghunterMyReleaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>{
    /*
    PullTableView *myreleaseTable;
    NSInteger page;
    NSMutableArray *releaseArray;
    NSString *releaseDescription;
     */
//    NSInteger page;
    
    PullTableView *biddingTableview;
    PullTableView *undoneTableView;
    PullTableView *doneTableView;
    
    // 增加 待接受
    PullTableView * undoneAcceptTableView;
    // 进行中
    PullTableView * doingTableView;
    // 已过期
    PullTableView * doneExpiredTableView;
    // 退款中
    PullTableView * doingRefundTableView;
    // 被拒绝
    PullTableView * refusedTableView;
    
    
    NSInteger biddingpage;
    NSInteger undonepage;
    NSInteger donepage;
    NSInteger doingpage;
    NSInteger undoneAcceptPage;
    NSInteger overDatePage;
    NSInteger doingRefundPage;
    NSInteger refusedPage;
    
    /*
    QRadioButton *biddingRadio;
    QRadioButton *undoneRadio;
    QRadioButton *doneRadio;
    
    //
    QRadioButton * undoneAcceptRadio;
    QRadioButton * doingRadio;
    QRadioButton * doneExpiredRadio;
    QRadioButton * doingRefundRadio;
    QRadioButton * beRejectedRadio;
    */
    
    NSMutableArray * biddingArray;
    NSMutableArray * undoneArray;
    NSMutableArray * doneArray;
    NSMutableArray * doingArray;
    NSMutableArray * doneExpiredArray;
    NSMutableArray * undoneAcceptArray;
    NSMutableArray * doingRefundArray;
    NSMutableArray * refusedArray;
    
    
    UIScrollView *scrollView;
    
    BOOL notfinishRequested;
    BOOL finishRequested;
    NSString *biddingDescription;
    NSString *undoneDescription;
    NSString *doneDescription;
    
    //
    NSString * doingDescription;
    NSString * undoneAcceptDescription;
    NSString * doneExpiredDescription;
    NSString * doingRefundDescription;
    NSString * beRejectedDescription;
    
    UILabel * lineOn;
    UILabel * numLabel;
    
    NSInteger waittingNum;
    NSInteger withDrawNum;
    NSInteger overDateNum;
    NSInteger doingNum;
    NSInteger bidNum;
    NSInteger refusedNum;
}

- (IBAction)back:(id)sender;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@end
