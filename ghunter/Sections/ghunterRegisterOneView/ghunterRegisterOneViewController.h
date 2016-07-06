//
//  ghunterRegisterViewController.h
//  ghunter
//
//  Created by chensonglu on 14-3-8.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "ghunterRegisterTwoViewController.h"
#import "ghunterWebViewController.h"
#import "SIAlertView.h"

@interface ghunterRegisterOneViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate> {
    SIAlertView *inputAlertView;
}

@end
