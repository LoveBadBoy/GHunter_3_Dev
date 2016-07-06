//
//  ghunterAccountHistoryViewController.h
//  ghunter
//
//  Created by chensonglu on 14-8-25.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "ghunterRequester.h"

@interface ghunterMyGoldViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate>{
    NSUInteger page;
    NSMutableArray *history;
}
@property(nonatomic)NSUInteger type;
@property(nonatomic,retain)PullTableView *table;
@end
