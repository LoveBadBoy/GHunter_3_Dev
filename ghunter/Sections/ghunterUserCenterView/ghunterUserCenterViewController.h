//
//  ghunterUserCenterViewController.h
//  ghunter
//
//  Created by chensonglu on 14-8-18.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "ghunterRequester.h"
#import "TQStarRatingView.h"
#import "showTag.h"
#import "ghunterMyFollowViewController.h"
#import "SJAvatarBrowser.h"
#import "OHAttributedLabel.h"
#import "ghuntertaskViewController.h"
#import "ghunterChatViewController.h"
#import "SIAlertView.h"
#import "AFNetworkTool.h"
#import "ghunterUserEvaluationViewController.h"

@interface ghunterUserCenterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate> {
    SIAlertView *reportAlertView;
    SIAlertView *shareAlertView;
    UIView *textview;
    UITextField *textat;
    
    UILabel * lineOn;
    BOOL flag;
    UIImageView * industryImg;
    UILabel * jobLb;
}

@property (strong, nonatomic) IBOutlet UIView *navbg;
@property (strong, nonatomic) IBOutlet UIButton *followBtn;

@property(nonatomic,retain)NSString *uid;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@end