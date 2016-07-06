//
//  ghunterChatViewController.h
//  ghunter
//
//  Created by chensonglu on 14-8-27.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "PullTableView.h"
#import "ghunterUserCenterViewController.h"
#import "ghunterWordChange.h"
#import "HPGrowingTextView.h"
#import "ZYQAssetPickerController.h"

@protocol textFieldProtocol <NSObject>

-(void)textInTextField:(NSString*)str1 appendStr:(NSString*)str2;

@end

typedef void(^callBack)();

@interface ghunterChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate,UITextViewDelegate,HPGrowingTextViewDelegate, UIGestureRecognizerDelegate,UIPickerViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UIActionSheetDelegate>{
    PullTableView *chatTable;
    NSInteger page;
}
@property(nonatomic,retain)NSString *sender_uid;
@property(nonatomic,retain)NSString *sender_username;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;

@property(nonatomic,retain)NSDictionary* userDic;

@property (copy, nonatomic)callBack callBackBlock;
@end
