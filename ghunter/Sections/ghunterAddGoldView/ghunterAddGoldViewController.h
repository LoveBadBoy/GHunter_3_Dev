//
//  ghunterAddGoldViewController.h
//  ghunter
//
//  Created by chensonglu on 14-4-16.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "ghunterRechargeViewController.h"

@interface ghunterAddGoldViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    CGFloat balanceInt;
}
@property (nonatomic) NSUInteger added_bounty;
@property (nonatomic) NSUInteger type;
@property(nonatomic,strong) NSString* price;
@end
