//
//  ghunterMyFollowViewController.h
//  ghunter
//
//  Created by chensonglu on 14-8-22.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "ghunterRequester.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "TQStarRatingView.h"
#import "showTag.h"
#import "ghunterUserCenterViewController.h"

@interface ghunterMyFollowViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    NSMutableArray *dataArray;
    NSMutableArray *searchResults;
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    NSInteger page;
}
@property(nonatomic)NSInteger type;
@property(nonatomic, retain)NSString *uid;
@property(nonatomic,retain)PullTableView *table;

@property (nonatomic ,retain) ghunterLoadingView *loadingView;

@end
