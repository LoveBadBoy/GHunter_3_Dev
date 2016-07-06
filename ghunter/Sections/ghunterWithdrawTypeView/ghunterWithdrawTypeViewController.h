//
//  ghunterWithdrawTypeViewController.h
//  ghunter
//
//  Created by chensonglu on 14-8-14.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
#import "ghunterRequester.h"
#import "ghunterWithdrawReasonViewController.h"
#import "ghuntertaskViewController.h"

@interface ghunterWithdrawTypeViewController : UIViewController<UIActionSheetDelegate>
@property (nonatomic) NSInteger selectedReason;
@property (nonatomic,retain) NSString *tid;
@property (nonatomic,retain) NSString *bounty;
@end
