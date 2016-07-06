//
//  ghunterLoginViewController.h
//  ghunter
//
//  Created by Wangmuxiong on 14-3-6.
//  Copyright (c) 2014年 ghunter. Al/Users/dudu/Desktop/svn/ghunter/ios/ghunter/ghunter/ghunterTabViewController.hl rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "ghunterRegisterOneViewController.h"
#import "ghunterTabViewController.h"
#import "ghunterGetbackpwOneViewController.h"
#import "APService.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ghunterNearbyViewController.h"
#import "ghunterLoadingView.h"
#import "AFNetworkTool.h"

typedef void(^callBack)();

@interface ghunterLoginViewController : UIViewController<UITextFieldDelegate,MKMapViewDelegate> {
    // NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *passWd;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (copy, nonatomic) callBack callBackBlock;
@property(nonatomic,retain) ghunterLoadingView *loadingView;

- (IBAction)login:(id)sender;
- (IBAction)register:(id)sender;
- (IBAction)back:(id)sender;


@end
