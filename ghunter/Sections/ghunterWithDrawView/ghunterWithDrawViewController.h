//
//  ghunterWithDrawViewController.h
//  ghunter
//
//  Created by chensonglu on 14-8-25.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "RegexKitLite.h"

@interface ghunterWithDrawViewController : UIViewController<UITextFieldDelegate> {
    NSDictionary *account;
}
@property(nonatomic,retain)NSString *balanceStr;
@end
