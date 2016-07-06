//
//  ghunterTabViewController.m
//  ghunter
//
//  Created by chensonglu on 14-3-13.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//暂时未知

#import "ghunterTabViewController.h"
#import "GHTabBar.h"
#import "ghunterMyViewController.h"
#import "AFNetworkTool.h"
#import "ghunterSkillViewController.h"
@interface ghunterTabViewController () <UITabBarControllerDelegate>

@end

@implementation ghunterTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    extern NSInteger gunread_notice;
    extern NSInteger gunread_message;
    extern NSString *gunread_feedavatar;
    
    extern BOOL ghunter_onchatpage;
    extern NSInteger ghunter_chatuid;
    
    ghunter_onchatpage = NO;
    ghunter_chatuid = 0;
    
    // 标识全局app是否登录
    extern BOOL imgondar_islogin;
    
    self.didSelectItemOfTabBar = NO;
    self.tabBar.hidden = YES;
    [self createControllers];
    
    UIView *badge = [[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth / 5 * 2 - 20, 5, 6, 6)];
    [badge setBackgroundColor:[UIColor redColor]];
    [badge.layer setCornerRadius:badge.frame.size.width * 0.5];
    [badge setClipsToBounds:YES];
    [badge setHidden:YES];
    
    // 我的右下角，未登录的标识
    UIView *badge2 = [[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth / 5 * 5 - 30, 5, 6, 6)];
    [badge2 setBackgroundColor:[UIColor redColor]];
    [badge2.layer setCornerRadius:badge2.frame.size.width * 0.5];
    [badge2 setClipsToBounds:YES];
    badge.hidden = NO;
    _badgeMineView = badge2;
    [self.tabBar addSubview:_badgeMineView];

    // 判断用户是否已登录
    if ([ghunterRequester getApi_session_id].length != 0) {
        imgondar_islogin = YES;
    }
    if (imgondar_islogin) {
        [_badgeMineView setHidden:YES];
    }else{
        [_badgeMineView setHidden:NO];
    }
    
    // 注册“获取未读通知”的观察者，观察者为本身
    // 当收到推送的时候，可以适当选择重新获取“未读通知”
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"get_unread_count" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(get_unread_count) name:@"get_unread_count" object:nil];
    
    // 注册“更新未读消息数量UI”的观察者
    // 当其他页面处理了消息，gunread全局变量变化之后，可以通知观察者做相应动作
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"update_unread_ui" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadUI) name:@"update_unread_ui" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"show_tab" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show_tab) name:@"show_tab" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hide_tab" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide_tab) name:@"hide_tab" object:nil];
    
    // 注册获取消息轮询的观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"update_unread_timer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update_unread_timer) name:@"update_unread_timer" object:nil];
    
    // 注册发布任务成功后的通知，需要跳转到任务详情页
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"taskPublishSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewTaskDetail:) name:@"taskPublishSucceed" object:nil];
    
    // 发布技能成功后的通知，需要跳转到任务详情页
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"skillPublishSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewSkillshowDetail:) name:@"skillPublishSucceed" object:nil];
}

// 获取未读消息数目，包括公告，私信，通知
- (void)get_unread_count {
    if(imgondar_islogin) {
        [self didGetUnreadCount];
    }
}

// 重要接口：获取app未读消息数量
-(void)didGetUnreadCount{
    [AFNetworkTool httpRequestWithUrl:URL_GET_NOTICE_NUMBER params:nil success:^(NSData *data) {
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            NSInteger unread_notice = [[result objectForKey:@"unread_notice"] integerValue];
            NSInteger unread_message = [[result objectForKey:@"unread_message"] integerValue];
            
            if ( unread_message != gunread_message && messageRequested ) {
                // 刷新私信页面
                NSNotification *notification = [NSNotification notificationWithName:@"update_message_page" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            }
            if (unread_notice != gunread_notice && noticeRequested) {
                // 刷新通知页面
                NSNotification *notification = [NSNotification notificationWithName:@"update_notice_page" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            }
            
            gunread_notice = unread_notice;
            gunread_message = unread_message;
            gunread_feedavatar = [result objectForKey:@"unread_feed_avatar"];
            
            [self updateUnreadUI];
        }else{
            if ( [[result objectForKey:@"msg"] isEqualToString:@"未登录"] ) {
                imgondar_islogin = NO;
                [self update_logout];
            }else{
                [ProgressHUD show:[result objectForKey:@"msg"]];
            }
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
    }];
}

// 未读消息Timer  3分钟自动刷新一次消息数目
- (void)update_unread_timer{
    if ( ghunter_appforeground ) {
       
        timer = [NSTimer scheduledTimerWithTimeInterval:3*60 target:self selector:@selector(get_unread_count) userInfo:nil repeats:YES];
        [timer setFireDate:[NSDate date]];
    }else{
        
        [timer invalidate];
    }
}

-(void)createControllers
{
    NSArray* normalImageName=@[@"home_discover_icon_normal",@"home_nearby_icon_normal",@"home_notify_icon_normal",@"home_mine_icon_normal"];
    NSArray* selectImageName=@[@"home_discover_icon_pressed",@"home_nearby_icon_pressed",@"home_notify_icon_pressed",@"home_mine_icon_pressed"];
    NSArray* labelName=@[@"发现",@"附近",@"消息",@"我"];
    
    [self setOneViewController:[ghunterDiscoverViewController class] title:labelName[0] image:normalImageName[0] selectImage:selectImageName[0]];
//    [self setOneViewController:[ghunterViewController1 class] title:labelName[0] image:normalImageName[0] selectImage:selectImageName[0]];
    
    [self setOneViewController:[ghunterNearbyViewController class] title:labelName[1] image:normalImageName[1] selectImage:selectImageName[1]];
    [self setOneViewController:[ghunterNoticeViewController class] title:labelName[2] image:normalImageName[2]  selectImage:selectImageName[2]];
    [self setOneViewController:[ghunterMyViewController class] title:labelName[3] image:normalImageName[3] selectImage:selectImageName[3]];
    // self.viewControllers=@[vc1,vc2,vc3,vc4,vc5];
    
    //因为系统自带的TabBar 是不可写得 所以使用kvc 去解决
    [self setValue:[[GHTabBar alloc] init] forKeyPath:@"tabBar"];
    
    self.delegate = self;
}

- (UIViewController*)setOneViewController:(Class)className title :(NSString*)title image:(NSString *)image selectImage:(NSString*)selectImage{
    
    UIViewController *vc = [[className alloc] init];
    [self setOneViewClass:vc title:title image:image selectImage:selectImage];
    
    return vc;
}

- (void)setOneViewClass:(UIViewController*)vc title :(NSString*)title image:(NSString *)image selectImage:(NSString*)selectImage {
    vc.tabBarItem.title =  title;
//    vc.navigationItem.title = title;
    //vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
//    [vc.tabBarController.tabBar setFrame:CGRectMake(0, mainScreenheight - 44, mainScreenWidth, 44)];
//    //告诉图片不要去渲染
    
    // Tab标题栏的字号
    UIFont *font = [UIFont fontWithName:@"Arial-ItalicMT" size:10.0];
    [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:font,
                                            NSForegroundColorAttributeName:[UIColor orangeColor]} forState:UIControlStateSelected];
    [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:font} forState:UIControlStateNormal];
//
    UIImage *selectImage1 = [UIImage imageNamed: selectImage];
//
    vc.tabBarItem.selectedImage = [selectImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    if ([vc isEqual:[ghunterMyViewController class]]) {
//        vc.tabBarItem.title = title;
//        vc.tabBarIte
//    }
    //
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    //vc.navigationController.navigationBarHidden = YES;
    [vc.navigationController.navigationBar sendSubviewToBack:self.view];
    
    [self addChildViewController:nav];
}

#pragma mark - UITabBarControllerDelegate

// 只要点击了对应的tabbar就会调用
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
    if ([viewController isKindOfClass:[ghunterMyViewController class]]) {
        ghunterMyViewController *Vc = [[ghunterMyViewController alloc] init];
        [self.navigationController pushViewController:Vc animated:YES];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    // ghunterMyViewController *Vc = [[ghunterMyViewController alloc] init];
    self.didSelectItemOfTabBar = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)hide_tab {
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         tab.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)show_tab {
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         tab.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - ghuntetTab method

- (void)thirdBtnClicked:(UIButton*)sender
{
    
    shareAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"releaseView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    CGRect taskfilterFrame = taskFilter.frame;
    shareAlertView.containerFrame = CGRectMake(0,0, taskfilterFrame.size.width, taskfilterFrame.size.height);
    shareAlertView.showView = taskFilter;
    UIButton *task = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *skill = (UIButton *)[taskFilter viewWithTag:2];
    UIButton* cancel=(UIButton*)[taskFilter viewWithTag:5]; 
    [task addTarget:self action:@selector(task:) forControlEvents:UIControlEventTouchUpInside];
    [skill addTarget:self action:@selector(skill:) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(shareCancel:) forControlEvents:UIControlEventTouchUpInside];
    shareAlertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    
    [shareAlertView show];
}

// 发布任务
- (void)task:(id)sender {
    [shareAlertView dismissAnimated:YES];
    ghunterReleaseViewController *releaseTask = [[ghunterReleaseViewController alloc] init];
    releaseTask.releasingTask = YES;
    self.tabBarController.selectedIndex = 0;
    releaseTask.callBackBlock = ^{};
    [self.navigationController pushViewController:releaseTask animated:NO];
}

// 发布任务成功，通过通知回调，跳转到任务详情页去
- (void)viewTaskDetail:(NSNotification *)notifition{
    NSString *tid = [notifition object];
    
    ghuntertaskViewController *task = [[ghuntertaskViewController alloc] init];
    task.tid = tid;
    task.callBackBlock = ^{};
    // 友盟统计
    [MobClick event:UMEVENT_RELEASE_TASK];
    [MobClick event:UMEVENT_TASK_PUBLISH];
    [self.navigationController pushViewController:task animated:YES];
    
    // 发送通知，刷新任务页面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTask" object:nil];
}

- (void)skill:(id)sender {
    [shareAlertView dismissAnimated:YES];
    ghunterReleaseSkillViewController *releaseSkill = [[ghunterReleaseSkillViewController alloc] init];
    releaseSkill.releasingSkill = YES;
    self.tabBarController.selectedIndex = 0;
    releaseSkill.callBackBlock = ^{};
    [self.navigationController pushViewController:releaseSkill animated:NO];
}

// 发布技能成功，通过通知回调，跳转到技能详情页去
- (void)viewSkillshowDetail:(NSNotification *)notifition{
    NSString *sid = [notifition object];
    
    ghunterSkillViewController *skillshow = [[ghunterSkillViewController alloc] init];
    skillshow.skillid = sid;
    skillshow.callBackBlock = ^{};
    // 友盟统计
    // [MobClick event:UMEVENT_RELEASE_TASK];
    [MobClick event:UMEVENT_RELEASE_SKILL];
    [self.navigationController pushViewController:skillshow animated:YES];
    
    // 发送通知，刷新技能页面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSkill" object:nil];
}

- (void)shareCancel:(id)sender
{
    [shareAlertView dismissAnimated:YES];
}


// 这里相当于整个App的消息通知接受中心，接受消息数量之后进行全局UI的更改
// 更新未读消息的UI
-(void)updateUnreadUI{
    
    // 首先判断是否是登录用户
    if ( [ghunterRequester getApi_session_id].length == 0 ) {
        imgondar_islogin = NO;
        [self update_logout];
        return;
    }
    if ( [[ghunterRequester getApi_session_id] isEqualToString:@""] ) {
        imgondar_islogin = NO;
        [self update_logout];
      
        return;
    }
    // 去掉未登录的标识
    [_badgeMineView setHidden:YES];
    
    imgondar_islogin = YES;
    NSUInteger notice_num = gunread_notice + gunread_message;
    if ([gunread_feedavatar length] > 0) {
        // 猎友圈有动态【这里是设置发现页面图标的小红点是否显示】
        [_badgeMineView setHidden:NO];
    } else {
        [_badgeMineView setHidden:YES];
    }
    
    if (notice_num > 0) {
        
        if (notice_num>99) {
            [self.tabBar.items[2] setBadgeValue:[NSString stringWithFormat:@"99+"]];
        }else{
            [self.tabBar.items[2] setBadgeValue:[NSString stringWithFormat:@"%zd", notice_num]];
        }
    } else {
        [self.tabBar.items[2] setBadgeValue:nil];
    }
    // 更新消息页面的UI
    NSNotification *noticeNotification = [NSNotification notificationWithName:@"update_noticepage_unreadui" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:noticeNotification waitUntilDone:false];
}

// 如果用户未登录，则app的UI更新设置在这里处理
-(void)update_logout{
    // 更新已有的消息UI
    gunread_message = 0;
    gunread_notice = 0;
    gunread_feedavatar = @"";
    
    // 未登录的标识
    [self.tabBar.items[2] setBadgeValue:nil];
    // 未登录的小红点提示
    [_badgeMineView setHidden:NO];
    // 更新“发现”页面的未读消息UI
    NSNotification *myNotification = [NSNotification notificationWithName:@"update_huntercircle_ui" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:myNotification waitUntilDone:false];
}

@end
