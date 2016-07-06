//
//  ghunterNoticeViewController.h
//  ghunter
//
//  Created by chensonglu on 14-5-23.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "PullTableView.h"
#import "QRadioButton.h"
#import "ghuntertaskViewController.h"
#import "ghunterWebViewController.h"
#import "ghunterChatViewController.h"
#import "JSBadgeView.h"
#import "ghunterUserCenterViewController.h"
#import "APService.h"
#import "OHAttributedLabel.h"
#import "ghunterLoginViewController.h"
#import "SIAlertView.h"
#import "ghuntersettingsViewController.h"

@interface ghunterNoticeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,QRadioButtonDelegate,UIActionSheetDelegate,GHResetPagesDelegate>{
    PullTableView *noticeTableview;
    PullTableView *messageTableView;
    NSInteger taskpage;
    NSInteger messagepage;
    // QRadioButton *taskRadio;
    // QRadioButton *messageRadio;
    NSMutableArray *taskArray;
    NSMutableArray *messageArray;
        
    NSUInteger delete_task_num;
    NSUInteger delete_message_num;
    
    // UIImageView *taskbadgeBG;
    // UIImageView *messagebadgeBG;
    
    UIActionSheet *taskAction;
    UIActionSheet *messageAction;
    UIActionSheet *cleanAction;
    SIAlertView* noticeAlertView;
    
    // headerView
    UILabel *msgLabel;
    UILabel *noticeLabel;
    UILabel *msgCountLabel;
    UILabel *noticeCountLabel;
    // 选中颜色
    UIColor *selectedColor;
    UIColor *defaultColor;
    
    UIView *headerView;
}
@property (strong, nonatomic) IBOutlet UILabel *line;
@property (nonatomic, retain)NSDictionary *push;
@property (nonatomic)NSString* type;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) UIView *unloginView;

//- (void)animateWithSender:(UIButton *)sender Completion:(void (^)())completion;
@end
