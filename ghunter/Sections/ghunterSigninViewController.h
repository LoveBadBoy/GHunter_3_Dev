//
//  ghunter123ViewController.h
//  ghunter
//
//  Created by imgondar on 15/12/31.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "PullTableView.h"
#import "SIAlertView.h"
#import "ghunterRequester.h"
#import "AFNetworkTool.h"
#import "UMSocial.h"
#import "ProgressHUD.h"
#import "ghunterUserCenterViewController.h"

@interface ghunterSigninViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate>
{
    PullTableView *rankTableView;
    NSMutableArray *rankArray;
    SIAlertView *pictureAlert;
    SIAlertView *shareView;
    NSInteger page;

}

@property (strong, nonatomic) IBOutlet UILabel *rewardLabel;
@property (strong, nonatomic)  NSString *reward;

@property (strong, nonatomic) IBOutlet UILabel *daysLabel;
@property (strong, nonatomic)  NSString *days;

@property (strong, nonatomic) IBOutlet UILabel *estraLabel;
@property (strong, nonatomic)  NSString *estra;

@property (strong, nonatomic)  NSString *rank;
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;

@property (strong, nonatomic)  NSString *proportion;
@property (strong, nonatomic) IBOutlet UIView *footView;

@property (strong, nonatomic) IBOutlet UIButton *shareBtn;



@end
