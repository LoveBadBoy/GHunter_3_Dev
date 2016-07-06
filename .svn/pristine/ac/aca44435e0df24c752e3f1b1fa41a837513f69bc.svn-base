//
//  ghunterModifyTaskViewController.h
//  ghunter
//
//  Created by chensonglu on 14-8-8.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterAddGoldViewController.h"
#import "SIAlertView.h"

@interface ghunterModifyTaskViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource> {
    NSInteger added_bounty;
    NSString * saveaddGold;
    SIAlertView *ageAlert;
    SIAlertView *pictureAlert;
    NSString * tmpBalanceStr;
    NSString * goldNumStr;
    CGFloat balanceInt;
    NSNotification *notification;

}

@property (strong, nonatomic) IBOutlet UITextField *taskTitle;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *addGoldAfter;
@property (strong, nonatomic) IBOutlet UILabel *setTimeAfter;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

@property (strong,nonatomic) NSString *tid;
@property (strong,nonatomic) NSString *titleStr;
@property (strong,nonatomic) NSString *descriptionStr;
@property (strong,nonatomic) NSString *goldNum;
@property (strong,nonatomic) NSString *dateline;
@property (strong, nonatomic)  NSString *price;
@property (strong, nonatomic)  UITextField * gold;
@property (nonatomic) NSUInteger type;
@property (nonatomic) NSUInteger add_bounty;
@property (strong, nonatomic)  UILabel * balance;




@end
