//
//  ghuntersettingsViewController.h
//  ghunter
//
//  Created by chensonglu on 14-3-11.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "ghunterFeedBackViewController.h"
#import "ghunterModifyPasswordViewController.h"
#import "WZGuideViewController.h"
#import "ghunterAboutViewController.h"
#import "ghunterWebViewController.h"
#import "ghunterNearbyViewController.h"

@protocol GHResetPagesDelegate <NSObject>
@required
- (void)resetPages;
@end

@interface ghuntersettingsViewController : UIViewController<UIActionSheetDelegate>{
    NSTimer *timer;
}
@property (nonatomic, retain) id<GHResetPagesDelegate> resetPageDelegate;
@end
