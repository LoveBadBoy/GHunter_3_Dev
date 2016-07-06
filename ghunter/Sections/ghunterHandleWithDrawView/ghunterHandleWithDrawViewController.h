//
//  ghunterHandleWithDrawViewController.h
//  ghunter
//
//  Created by chensonglu on 14-8-14.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
#import "ghunterRequester.h"

@interface ghunterHandleWithDrawViewController : UIViewController<UIActionSheetDelegate>
@property(nonatomic, retain)NSDictionary *dic;
@property(nonatomic, retain)NSString *stage;
@property(nonatomic, retain)NSString *tid;
@property(nonatomic, retain)NSString *bounty;
@end
