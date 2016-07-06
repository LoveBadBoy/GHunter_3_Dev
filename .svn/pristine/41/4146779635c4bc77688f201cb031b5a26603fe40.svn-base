//
//  ghuntermyCollectionViewController.h
//  ghunter
//
//  Created by chensonglu on 14-5-16.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "PullTableView.h"
#import "ghuntertaskViewController.h"
#import "QRadioButton.h"

@interface ghuntermyCollectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,UIActionSheetDelegate>{
    PullTableView *mycollectionTable;
    PullTableView *myCollectionSkill;
    QRadioButton *taskRadio;
    QRadioButton *skillRadio;
    UIScrollView *_scrollView;
    NSInteger page;
    NSMutableArray *collectionArray;
    NSMutableArray *collectionSkillArray;
}
@property (nonatomic,copy)NSString *type;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;
@end
