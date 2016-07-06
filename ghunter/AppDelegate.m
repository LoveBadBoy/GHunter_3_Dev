//
//  ghunterAppDelegate.m
//  ghunter
//
//  Created by Wangmuxiong on 14-3-5.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import "WXApi.h"
#import "Monitor.h"
#import "UMSocialQQHandler.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"

@interface AppDelegate (){
    NSInteger pushType;
    UINavigationController *navigationContrller;
}
@property(strong, nonatomic)CLGeocoder *geocoder;
@property(strong, nonatomic)BMKGeoCodeSearch *geosearch;

// 弹框
@property (nonatomic,retain)UIActionSheet *alertActionSheet;
@property(nonatomic,strong) NSString *pushTid;
@property(nonatomic,strong) NSString *pushSid;
@property(nonatomic,strong) NSString *pushUrl;

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark 友盟统计
- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    //    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    //    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)onlineConfigCallBack:(NSNotification *)note {

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    extern BOOL ghunter_appforeground;
    
    [self umengTrack];
    [MobClick event:UMEVENT_LAUNCH];
    // 设置图标的通知数目为0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定 generalDelegate参数onxGVFp6n0uDKiGCES0Bu1HW
    BOOL ret = [_mapManager start:@"onxGVFp6n0uDKiGCES0Bu1HW"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
    // 初始化BMKLocationService
    mapLocation = [[BMKLocationService alloc]init];
    mapLocation.delegate = self;
    // 启动LocationService
    [mapLocation startUserLocationService];
    
    _geosearch = [[BMKGeoCodeSearch alloc] init];
    _geosearch.delegate = self;
    _geocoder = [[CLGeocoder alloc] init];
    
    // UMSocial
    [UMSocialData setAppKey:UMKey];
    [UMSocialWechatHandler setWXAppId:WX_APPID appSecret:WX_APPSECRET url:URL_IMGONDAR];
    if([QQApiInterface isQQInstalled]){
        [UMSocialQQHandler setQQWithAppId:TX_APPID appKey:TX_APPSECRET url:URL_IMGONDAR];
    }
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    // categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    // [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // NSString* phoneModel = [[UIDevice currentDevice] model];
    
    self.tabController = [[ghunterTabViewController alloc] init];
    navigationContrller = [[UINavigationController alloc] initWithRootViewController:self.tabController];
    [navigationContrller setNavigationBarHidden:YES];
    self.window.rootViewController = navigationContrller;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //如果是第一次进入程序时，先进入引导页
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch7"]) {
        [WZGuideViewController show];
    }
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunch7"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunch7"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch7"];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:docDir]];
    
    // 如果是点击通知启动app则进入消息页面，否则进入附近页面
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        // 点击远程通知打开的App
        NSInteger type = [[remoteNotification objectForKey:@"type"] integerValue];
        if (type == 3 || type == 5 || type == 6 ) {
            pushType = 5;
        }else if(type == 8){
            pushType = 1;
            _pushTid = [remoteNotification objectForKey:@"tid"];
        }else if(type == 9){
            pushType = 2;
            _pushSid = [remoteNotification objectForKey:@"sid"];
        }else if(type == 1){
            pushType = 3;
            _pushUrl = _pushSid = [remoteNotification objectForKey:@"url"];;
        }else if(type == 7){
            pushType = 4;
        }else{
            pushType = 0;
        }
    }else {
        pushType = 0;
    }
    
    // app 在前台，并且激活，可以激活定时器
    ghunter_appforeground = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_timer" object:nil];
    
    // 发布技能成功后的通知，需要跳转到任务详情页
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setPushTags" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPushTags) name:@"setPushTags" object:nil];
    
    // 发布技能成功后的通知，需要跳转到任务详情页
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didModifyUserProfile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didModifyUserProfile:) name:@"didModifyUserProfile" object:nil];
    
    return YES;
}

-(void)didEnterApplication{
    if (pushType == 0) {
        // 开发的时候可以设置这里，方面调试
        self.tabController.selectedIndex = 0;
    }else if(pushType == 1){
        self.tabController.selectedIndex = 0;
    }else if(pushType == 2){
        self.tabController.selectedIndex = 0;
    }else if(pushType == 3){
        self.tabController.selectedIndex = 0;
    }else if(pushType == 4){
        // 发现页面的广告
        self.tabController.selectedIndex = 0;
    }else if(pushType == 5){
        // 消息页面
        self.tabController.selectedIndex = 2;
    }else{
        self.tabController.selectedIndex = 0;
    }
}

#pragma mark -SKIP backup
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
    }
    return success;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    [APService registerDeviceToken:deviceToken];
    [self setPushTags];
}

// 设置推送标签
-(void) setPushTags{
    if([[ghunterRequester getUserInfo:@"uid"] length] > 0) {
        timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(tagsUpload) userInfo:nil repeats:YES];
        [timer fire];
    }
}

// IOS8 设置推送方式
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
//    if (notificationSettings.types!=UIUserNotificationTypeNone) {
//        [self localNotification];
//    }
}

// 设置极光推送的标签
- (void)tagsUpload {
    NSString *gender = @"";
    if ([[ghunterRequester getUserInfo:@"sex"] isEqualToString:@"0"]) {
        gender = @"female";
    } else {
        // 1 是男性
        gender = @"male";
    }
    
    NSMutableSet* set=[[NSMutableSet alloc] init];
    [set addObject:[ghunterRequester getUserInfo:UID]];
    [set addObject:gender];
    [set addObject:[ghunterRequester getUserInfo:@"university_name"]];
    // ios应用版本
    [set addObject:VERSION_VALUE];
    
    // 把技能标签设置为推送标签
    NSString *str = [ghunterRequester getUserInfo:@"skills"];
    if ([str isKindOfClass:[NSArray class]]) {
        NSMutableArray* skillArr = (NSMutableArray*)[ghunterRequester getUserInfo:@"skills"];
        for(int i=0;i<skillArr.count;i++)
        {
            [set addObject:skillArr[i]];
        }
    }
    
    // 设置地理位置省市区为极光推送标签
    NSDictionary *loc = [[NSUserDefaults standardUserDefaults]objectForKey:@"locationInfo"];
    if (loc != nil) {
        if ([loc objectForKey:@"City"]) {
            [set addObject: [loc objectForKey:@"City"]];
        }
        if ([loc objectForKey:@"State"]) {
            [set addObject: [loc objectForKey:@"State"]];
        }
        if ([loc objectForKey:@"SubLocality"]) {
            [set addObject: [loc objectForKey:@"SubLocality"]];
        }
    }else{
        
    }
    
    [APService setTags:set callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    if (iResCode == 0 && [timer isValid]) {
        NSLog(@"注册极光推送成功 : %@", tags);
        [timer invalidate];
        timer = nil;
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    // 展示本地推送
    // [APService showLocalNotificationAtFront:notification identifierKey:@"1"];
    
    UINavigationController *navaigation = (UINavigationController *)self.window.rootViewController;
    NSDictionary *push = notification.userInfo;
    
    
    NSNumber *type = [push objectForKey:@"type"];
    int intType = type.intValue;
    
    if(intType==3||intType==5||intType==6)
    {
        self.tabController.selectedIndex = 2;
    }
    // 发现页面的banner广告
    if(intType == 7)
    {
        self.tabController.selectedIndex = 1;
    }
    if(intType==8)
    {
        // 推送任务
        ghuntertaskViewController* taskView=[[ghuntertaskViewController alloc] init];
        taskView.callBackBlock = ^{};
        taskView.fromPush = @"1";
        taskView.tid=[push objectForKey:@"tid"];
        [navaigation presentViewController:[[UINavigationController alloc] initWithRootViewController:taskView] animated:YES completion:nil];
    }
    if(intType==9)
    {
        // 推送技能
        ghunterSkillViewController* taskView=[[ghunterSkillViewController alloc] init];
        taskView.callBackBlock = ^{};
        taskView.skillid = [push objectForKey:@"sid"];
        taskView.fromPush = @"1";
        [navaigation presentViewController:[[UINavigationController alloc] initWithRootViewController:taskView] animated:YES completion:nil];
    }
    // 打开一个网址  url content
    if(intType == 1)
    {
        ghunterWebViewController* webView = [[ghunterWebViewController alloc] init];
        webView.urlPassed = [push objectForKey:@"url"];
        webView.webTitle = [NSMutableString stringWithString:APP_NAME];
        webView.fromPush = @"1";
        [navaigation presentViewController:[[UINavigationController alloc] initWithRootViewController:webView] animated:YES completion:nil];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    
    NSInteger type = [[userInfo objectForKey:@"type"] integerValue];
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        // 当应用未打开的时候，调用本地通知，会唤起：didReceiveLocalNotification 方法处理推送
        // int num = (int)(gunread_message + gunread_notice);
        [APService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:0.5]
                              alertBody:[userInfo objectForKey:@"content"]
                                  badge:0
                            alertAction:@"赏金猎人"
                          identifierKey:@"1"
                               userInfo:userInfo
                              soundName:nil];
    }else{
        // 应用是打开的时候
        if (type==5 && ghunter_onchatpage && ghunter_chatuid!=0) {
            // 如果是私信消息，就只更新
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:[userInfo objectForKey:@"mid"] forKey:@"mid"];
            [dic setValue:[userInfo objectForKey:@"from_uid"] forKey:@"from_uid"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"get_chat_message" object:dic];
        }else{
            if ( type == 5 ) {
                pushType = 5;
                // 刷新私信页面
                if ( messageRequested ) {
                    NSNotification *notification = [NSNotification notificationWithName:@"update_message_page" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
                }else{
                    gunread_message += 1;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
                }
            }else if( type == 3  ){
                pushType = 5;
                // 刷新通知页面
                if (noticeRequested) {
                    NSNotification *notification = [NSNotification notificationWithName:@"update_notice_page" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
                }else{
                    gunread_notice += 1;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
                }
            }else{
                // 其他推送，如：任务单个推送，技能单个推送，发现页面广告推送，通告推送
                // TODO 以后需要处理
                if (type == 8) {
                    self.pushTid = [userInfo objectForKey:@"tid"];
                    pushType = 1;
                    
                    self.alertActionSheet = [[UIActionSheet alloc] initWithTitle:@"您收到一条任务推送，前去看看吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"前去看看" otherButtonTitles:nil];
                    [self.alertActionSheet showInView:self.tabController.view];
                }else if(type == 9){
                    self.pushSid = [userInfo objectForKey:@"sid"];
                    pushType = 2;
                    
                    self.alertActionSheet = [[UIActionSheet alloc] initWithTitle:@"您收到一条技能推送，前去看看吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"前去看看" otherButtonTitles:nil];
                    [self.alertActionSheet showInView:self.tabController.view];
                }else if(type == 1){
                    self.pushUrl = [userInfo objectForKey:@"url"];
                    pushType = 3;
                    
                    self.alertActionSheet = [[UIActionSheet alloc] initWithTitle:@"您收到一条消息推送，前去看看吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"前去看看" otherButtonTitles:nil];
                    [self.alertActionSheet showInView:self.tabController.view];
                }else if(type == 4){
                    // 这里是推送猎人
                    
                }else if(type == 7){
                    // 发现页面的广告
                    pushType = 5;
                }
            }
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark - UIActionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet == self.alertActionSheet)
    {
        if(buttonIndex == 0) {
             UINavigationController *navaigation = (UINavigationController *)self.window.rootViewController;
            if (pushType == 1) {
                // task
                ghuntertaskViewController* taskView=[[ghuntertaskViewController alloc] init];
                taskView.callBackBlock = ^{};
                taskView.tid = self.pushTid ;
                [navaigation pushViewController:taskView animated:YES];
            }else if(pushType == 2){
                // skill
                ghunterSkillViewController* skillView=[[ghunterSkillViewController alloc] init];
                skillView.callBackBlock = ^{};
                skillView.skillid = self.pushSid;
                [navaigation pushViewController:skillView animated:YES];
            }else if(pushType == 3){
                ghunterWebViewController* webView=[[ghunterWebViewController alloc] init];
                webView.urlPassed = [NSMutableString stringWithString:self.pushUrl];
                webView.webTitle = [NSMutableString stringWithString:APP_NAME];
                [navaigation pushViewController:webView animated:YES];
            }
        }
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler {

}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

// 支付和统计回调
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@", resultDic);
                                         }];
        return YES;
    }else if([url.host isEqualToString:@"pay"]){
        // 微信支付
        ghunterRechargeViewController *rcv = [[ghunterRechargeViewController alloc] init];
        return [WXApi handleOpenURL:url delegate:rcv];
    }else {
        return  [UMSocialSnsService handleOpenURL:url];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    ghunter_appforeground = NO;
    
    // 设置app图标上的badge数量
    [UIApplication sharedApplication].applicationIconBadgeNumber = gunread_message + gunread_notice;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_timer" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = gunread_message + gunread_notice;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (ghunter_appforeground == NO) {
        ghunter_appforeground = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_timer" object:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ghunter" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ghunter.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

# pragma badidu location code
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"百度定位： didUpdateBMKUserLocation");
    static BOOL locateFlag = NO;
    
    if (locateFlag == YES) {
        // 防止多次定位产生
        return;
    }
    
    double latitude = userLocation.location.coordinate.latitude;
    double longitude = userLocation.location.coordinate.longitude;
    
    NSLog(@"定位成功： latitude = %lf, longitude = %lf", latitude, longitude);
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
        pt = (CLLocationCoordinate2D){latitude, longitude};
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
        [_geosearch reverseGeoCode:reverseGeocodeSearchOption];
    }else{
        // 反地理编码
        [self getAddressByLatitude:latitude longitude:longitude];
    }
    
    NSString *latitudeStr = [NSString stringWithFormat:@"%f",latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%f",longitude];
    
    [ghunterRequester setUserInfoWithKey:LATITUDE withValue:latitudeStr];
    [ghunterRequester setUserInfoWithKey:LONGITUDE withValue:longitudeStr];
    
    [self didEnterApplication];
    
    // 把经纬度等信息存放在本地
    [[NSUserDefaults standardUserDefaults] setDouble:latitude forKey:LATITUDE];
    [[NSUserDefaults standardUserDefaults] setDouble:longitude forKey:LONGITUDE];
    
    // TODO:push1
    if ([[ghunterRequester getUserInfo:UID] length] > 0) {
        NSLog(@"更新用户经纬度，和PUSHID，以及Device");
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:latitudeStr forKey:@"latitude"];
        [dic setObject:longitudeStr forKey:@"longitude"];
        [dic setObject:DEVICE forKey:@"device"];
        [dic setObject:[ghunterRequester getUserInfo:UID] forKey:@"pushid"];
        
        // 用通知的方式去修改资料
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didModifyUserProfile" object:dic];
    }
    [mapLocation stopUserLocationService];
}

// 更新用户的资料
-(void)didModifyUserProfile:(NSNotification*) notification{
    NSMutableDictionary *dict = [notification object];
    [AFNetworkTool httpPostWithUrl:URL_MODIFY_PROFILE andParameters:dict success:^(NSData *data) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ( [[json objectForKey:@"error"] integerValue] == 0 ) {
            NSLog(@"Appdelegate 修改个人资料成功");
        }else{
             NSLog(@"Appdelegate 修改个人资料失败 reaseon = %@", json);
        }
    } fail:^{
        NSLog(@"Appdelegate 修改个人资料，请求失败！！！");
    }];
}

// 根据经纬度获取地址
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        // 这个方法是异步的，当反地理编码获取成功之后，再设置极光推送标签
        
        NSString*string =[placemark.addressDictionary objectForKey:@"Name"];
        string = [string substringFromIndex:2];//截取下标7之后的字符串
        Monitor *adres = [Monitor sharedInstance];
        adres.addres = string;
        [[NSUserDefaults standardUserDefaults] setObject:placemark.addressDictionary forKey:@"locationInfo"];
    }];
}

// 反地址编码成功
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"onGetReverseGeoCodeResult");
    if (error == 0) {
        BMKAddressComponent *address = result.addressDetail;
        
        NSMutableDictionary *locationInfo = [[NSMutableDictionary alloc]init];
        [locationInfo setValue:address.city forKey:@"City"];
        [locationInfo setValue:address.district forKey:@"SubLocality"];
        [locationInfo setValue:address.province forKey:@"State"];
        
        // 把经纬度存放在本地
        [[NSUserDefaults standardUserDefaults] setDouble:result.location.latitude forKey:LATITUDE];
        [[NSUserDefaults standardUserDefaults] setDouble:result.location.longitude forKey:LONGITUDE];
        
        [[NSUserDefaults standardUserDefaults] setObject:locationInfo forKey:@"locationInfo"];
        
    }else{
        NSLog(@"反地理编码失败");
    }
}

#pragma mark - Baidu Map

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [ghunterRequester setUserInfoWithKey:LATITUDE withValue:LOC_DEFAULT_LATITUDE];
    [ghunterRequester setUserInfoWithKey:LONGITUDE withValue:LOC_DEFAULT_LONGITUDE];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法定位，请检查网络或到：设置->隐私->定位服务->赏金猎人，开启定位权限" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - ASIHttpRequest

-(void)dealloc{
    if (_geosearch != nil) {
        _geosearch = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setPushTags" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didModifyUserProfile" object:nil];
}

@end