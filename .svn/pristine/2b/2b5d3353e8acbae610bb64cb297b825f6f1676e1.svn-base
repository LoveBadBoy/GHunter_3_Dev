//
//  ghuntersettingsViewController.m
//  ghunter
//
//  Created by chensonglu on 14-3-11.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//设置页面

#import "ghuntersettingsViewController.h"
#import "ghunterLoginViewController.h"

@interface ghuntersettingsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UIView *webBG;
@property (nonatomic, retain) UIActionSheet *action;
@property (nonatomic,retain)UIActionSheet *cleanAction;
@property (nonatomic, assign) BOOL signInHere;
@property (strong, nonatomic) IBOutlet UIView *bg;
@property (strong, nonatomic) IBOutlet UIButton *btnbgg;

@end

@implementation ghuntersettingsViewController

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
    _btnbgg.backgroundColor =RGBCOLOR(246, 124, 71);
    // Do any additional setup after loading the view from its nib.
     _bg.backgroundColor = Nav_backgroud;
    
    CGRect settingViewFrame = self.settingView.frame;
    settingViewFrame.size.width = self.view.frame.size.width;
    self.settingView.frame = settingViewFrame;
    CGRect frame = self.scrollView.frame;
    frame.size.height = mainScreenheight - 44 -20;
    
    self.scrollView.frame = frame;
    self.scrollView.contentSize = self.settingView.frame.size;
    self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, mainScreenWidth, mainScreenheight - TAB_BAR_HEIGHT);
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,500);
    [self.scrollView addSubview:self.settingView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    if(!imgondar_islogin)
    {
        ghunterLoginViewController* login=[[ghunterLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        [login setCallBackBlock:^{
            self.tabBarController.selectedIndex = 0;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)about:(id)sender {
    ghunterAboutViewController *about = [[ghunterAboutViewController alloc] init];
    [self.navigationController pushViewController:about animated:YES];
}


- (IBAction)tradingRules:(id)sender {
    ghunterWebViewController *web = [[ghunterWebViewController alloc] init];
    web.webTitle = @"交易规则";
    web.urlPassed = TRADINGRULES;
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)frequentQuestion:(id)sender {
    ghunterWebViewController *web = [[ghunterWebViewController alloc] init];
    web.webTitle = @"常见问题";
    web.urlPassed = ABOUT_QUESTIONS;
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)agreement:(id)sender {
    ghunterWebViewController *web = [[ghunterWebViewController alloc] init];
    web.webTitle = @"用户协议";
    web.urlPassed = AGREEMENT;
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)help:(id)sender {
    ghunterWebViewController *web = [[ghunterWebViewController alloc] init];
    web.webTitle = @"限免公告";
    web.urlPassed = FREENOTICE;
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)clearCache:(id)sender {
    self.cleanAction = [[UIActionSheet alloc] initWithTitle:@"确定要清理缓存吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [self.cleanAction showInView:self.view];
}

- (IBAction)feedback:(id)sender {
    ghunterChatViewController *chat = [[ghunterChatViewController alloc] init];
    chat.sender_uid = @"1";
    chat.sender_username = @"赏金阿列";
    
    [chat setCallBackBlock:^{}];
    [self.navigationController pushViewController:chat animated:YES];
}

- (IBAction)logout:(id)sender {
    self.action = [[UIActionSheet alloc] initWithTitle:@"确定注销登录赏金猎人吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [self.action showInView:self.view];
}

//http请求处理的代理方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOGOUT]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"注销成功" waitUntilDone:false];
            [ghunterRequester clearProfile];
            
            double latitudeLocal = [[NSUserDefaults standardUserDefaults] doubleForKey:LATITUDE];
            double longitudeLocal = [[NSUserDefaults standardUserDefaults] doubleForKey:LONGITUDE];
            
            // 保存本地的经纬度，有利于用来请求数据等
            [ghunterRequester setUserInfoWithKey:LATITUDE withValue:[NSString stringWithFormat:@"%f",latitudeLocal]];
            [ghunterRequester setUserInfoWithKey:LONGITUDE withValue:[NSString stringWithFormat:@"%f",longitudeLocal]];
            
            // 注销后返回上一个页面
            [self.navigationController popViewControllerAnimated:YES];
            // 通知消息页面，清除数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
        }else if ([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络异常" waitUntilDone:false];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    if (iResCode == 0 && [timer isValid]) {
        
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark - UIActionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet == self.action) {
        if(buttonIndex == 0) {
            //退出登录
            [MobClick event:UMEVENT_LOGOUT];
            
            // 注销登录的时候，应该把客户端的PUSHID设置为logoutuser，否则如果程序没卸载，还是会收到消息推送
            timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(tagsUpload) userInfo:nil repeats:YES];
            [timer fire];
            
            //退出登录
            [ghunterRequester postwithDelegate:self withUrl:URL_LOGOUT withUserInfo:REQUEST_FOR_LOGOUT withDictionary:nil];
        }
    }
    if(actionSheet == self.cleanAction)
    {
        if(buttonIndex == 0) {
            [MobClick event:UMEVENT_CLEAR_CACHE];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachesDir = [paths objectAtIndex:0];
            NSString *cachesPath = [cachesDir stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
            NSString *cacheSize = [NSString stringWithFormat:@"%.1fM", [ghunterRequester folderSizeAtPath:cachesPath]];
            [ghunterRequester clearCache];
            [ghunterRequester showTip:[NSString stringWithFormat:@"共清理缓存%@",cacheSize]];
        }
    }
}

// 注销登录的时候，极光推送设置标签不一样
- (void)tagsUpload {
    NSMutableSet* set=[[NSMutableSet alloc] init];
    // ios已被注销的客户端
    NSString *applogout = @"logoutuser";
    [set addObject:applogout];
    [APService setTags:set callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

@end