//
//  ghunterRechargeViewController.h
//  ghunter
//
//  Created by chensonglu on 14-5-7.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import "UIKit/UIKit.h"
#import "AlipaySDK/AlipaySDK.h"
#import "RadioButton.h"
#import "ghunterRequester.h"
#import "RegexKitLite.h"
#import "Order.h"
#import "PartnerConfig.h"

#import "payRequsestHandler.h"
#import "WXApiObject.h"
#import "WXApi.h"

@interface ghunterRechargeViewController : UIViewController<RadioButtonDelegate,UITextFieldDelegate,WXApiDelegate>{
    // SEL _result;
    NSString *tradeNum;
    
    NSInteger _indexNum;
}

@property (strong, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
//-(void)paymentResult:(NSString *)result;

@end