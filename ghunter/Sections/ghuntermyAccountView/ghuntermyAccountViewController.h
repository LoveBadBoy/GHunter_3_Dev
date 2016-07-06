//
//  ghuntermyAccountViewController.h
//  ghunter
//
//  Created by chensonglu on 14-5-19.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "ghunterRechargeViewController.h"
#import "ghunterMyGoldViewController.h"
#import "ghunterWithDrawViewController.h"
#import "ghunterIdentityViewController.h"
#import "ghunterWebViewController.h"
#import "ghunterConvertGoldsViewController.h"
#import "CreditWebViewController.h"
#import "CreditNavigationController.h"

@interface ghuntermyAccountViewController : UIViewController

//金币余额
@property (strong, nonatomic) IBOutlet UILabel *balabnceGold;

// 金币商城
@property (strong, nonatomic) IBOutlet UIButton *goldCoin;

@property (strong, nonatomic) IBOutlet UIView *goldBalanceView;

@property (nonatomic, copy) NSString * balanceGoldNum;

@end
