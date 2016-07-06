//
//  ghunterMyCouponViewController.h
//  ghunter
//
//  Created by ImGondar on 15/12/1.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "ghunterLoadingView.h"
#import "AFNetworkTool.h"
#import "Header.h"
#import "ProgressHUD.h"
@interface ghunterMyNotUseDiscountViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PullTableViewDelegate>


@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@property(nonatomic,copy)void(^blockImmediately) (NSString *);


@end
