//
//  ghunterAppDelegate.h
//  ghunter
//
//  Created by Wangmuxiong on 14-3-5.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "ghunterMyViewController.h"
#import "ghunterTabViewController.h"
#import "BMapKit.h"
#import "WZGuideViewController.h"
#import "APService.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "DataVerifier.h"
#import "ghunterReleaseViewController.h"
#import "ghunterLoadingView.h"
#import "UMSocialWechatHandler.h"
#import "ghunterNoticeViewController.h"
#import "ghunterNearbyViewController.h"
#import "ghuntertaskViewController.h"
#import "ghunterSkillViewController.h"
#import "Header.h"

#import "ghunterRechargeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, BMKLocationServiceDelegate,BMKGeneralDelegate,BMKGeoCodeSearchDelegate,UIAlertViewDelegate,UIActionSheetDelegate>{
    NSTimer *timer;
    
    BMKLocationService *mapLocation;
    BMKMapManager *_mapManager;
    
    NSString * numString;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UITabBarController *tabController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
