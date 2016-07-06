//
//  ghunterzhiyeViewController.h
//  ghunter
//
//  Created by ImGondar on 15/9/28.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Monitor.h"
#import "DWTagList.h"

@interface ghunterzhiyeViewController : UIViewController<dangbuttondelegate,UITextFieldDelegate>
{
    NSArray *jobarr;
     DWTagList *tagList;
    NSMutableArray *arr;
    UITextField *textfild;
}

@property (strong,nonatomic) NSString *jobstr;
@property (assign,nonatomic) int jobid;
@property (strong,nonatomic) NSString *col;
@property (strong,nonatomic) NSString *wor;
@property (strong,nonatomic) NSString *strtext;

@property (strong, nonatomic) NSString *industry_new;
@property (strong, nonatomic) NSString *direction_new;
@property (strong, nonatomic) NSString *job_new;

@end
