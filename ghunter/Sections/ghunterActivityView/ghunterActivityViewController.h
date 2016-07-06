//
//  ghunterActivityViewController.h
//  ghunter
//
//  Created by chensonglu on 14-9-17.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "SIAlertView.h"
#import "UMSocial.h"
#import "ghunterLoadingView.h"

@interface ghunterActivityViewController : UIViewController<UIWebViewDelegate> {
    SIAlertView *shareAlertView;
    NSDictionary *activity;
}
@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@end
