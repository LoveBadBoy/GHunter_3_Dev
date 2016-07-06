//
//  ghunterMainViewController.h
//  ghunter
//
//  Created by chensonglu on 14-3-11.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "UIImageView+WebCache.h"
#import "ghuntersettingsViewController.h"
#import "ghunterUserInfoViewController.h"
#import "ghuntermyAccountViewController.h"
#import "ghunterMyTaskViewController.h"
#import "ghuntermyCollectionViewController.h"
#import "ghunterMyReleaseViewController.h"
#import "UIImageView+WebCache.h"
#import "TQStarRatingView.h"
#import "ghunterMyFollowViewController.h"
#import "ghunterAllEvaluationViewController.h"
#import "ghunterHunterCircleViewController.h"
#import "ghunterLevelViewController.h"
#import "ghunterNoticeViewController.h"
#import "ghunterMySkillViewController.h"
#import "JSBadgeView.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"


@interface ghunterMyViewController : UIViewController<UIScrollViewDelegate>
{
    JSBadgeView *circleBadge;
    JSBadgeView *noticeBadge;
    TQStarRatingView *star;
    // NSUInteger count;
    
    SIAlertView *shareAlertView;
    NSString *productShareUrl;
    NSString *productShareTitle;
    NSString *productShareSubTitle;
    NSString *productShareImg;
}
//实名
@property (weak, nonatomic) IBOutlet UILabel *Real;
//更多
@property (weak, nonatomic) IBOutlet UILabel *More;

@property (strong, nonatomic) IBOutlet UIImageView *certifyImg;

- (IBAction)IdentityBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *backGroundView;

//等级
@property (weak, nonatomic) IBOutlet UILabel *Grade;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) IBOutlet UILabel *yelltit;

@property (strong, nonatomic) IBOutlet UIImageView *notingicon;
@property (strong, nonatomic) IBOutlet UILabel *Golds;

@property (strong, nonatomic) IBOutlet UILabel *Balance;

@property (strong, nonatomic) IBOutlet UILabel *Number;

@property (strong, nonatomic) IBOutlet UIView *statview;
//更改后等级用图片表示
@property (strong, nonatomic) IBOutlet UIImageView *levelImgV;


// 待评价




@end
