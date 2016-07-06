//
//  ghunterCheckEvaluationViewController.h
//  ghunter
//
//  Created by imgondar on 15/3/30.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "SIAlertView.h"
#import "ghunterRequester.h"
#import "UMSocial.h"

@interface ghunterCheckEvaluationViewController : UIViewController
{
    SIAlertView *shareAlertView;
    NSDictionary *valDic;
    NSDictionary *taskDic;
}
@property(strong,nonatomic)NSString *tid;
@end
