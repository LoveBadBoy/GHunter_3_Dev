//
//  ghunterModifySkillViewController.h
//  ghunter
//
//  Created by chensonglu on 14-10-2.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOTag.h"
#import "SkillTag.h"
#import "ghunterRequester.h"

@interface ghunterModifySkillViewController : UIViewController <AOTagDelegate,SkillTagDelegate,UIScrollViewDelegate> {
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSArray *skillsArray;
    NSInteger currentPageIndex;
}
@property(nonatomic)NSInteger type;
@property(nonatomic,retain)NSMutableArray *tags;
@property(retain,nonatomic)NSString *phone;
@property(retain,nonatomic)NSString *password;
@property(nonatomic,retain)NSString *avatarStr;
@property(nonatomic,retain)NSString *hunterName;
@property(nonatomic,retain)NSString *birthday;
@property(nonatomic,retain)NSString *school;
@property(nonatomic,retain)NSString *gender;
@property(nonatomic,retain)AOTagList *tagList;
@property(nonatomic,retain)NSMutableArray *randomTag;
- (void)showUserSkills;
@end
