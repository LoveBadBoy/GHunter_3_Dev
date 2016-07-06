//
//  ghunterMyGoldCoinShopViewController.m
//  ghunter
//
//  Created by imgondar on 15/11/10.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import "ghunterMyGoldCoinShopViewController.h"
#import "Header.h"
#import "CreditNavigationController.h"
#import "CreditWebViewController.h"
#import "CreditWebView.h"
#import "AFNetworkTool.h"
#import "ghunterWebViewController.h"
@interface ghunterMyGoldCoinShopViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong) NSDictionary *_loginData;
@end

@implementation ghunterMyGoldCoinShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLoad];
    [self getNavView];
    
   //添加分享按钮的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDuibaShareClick:) name:@"duiba-share-click" object:nil];
    //添加登录按钮的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDuibaLoginClick:) name:@"duiba-login-click" object:nil];
    /*
    CreditNavigationController *nav = [[CreditNavigationController alloc]initWithRootViewController:self];
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    window.rootViewController = nav;
    */
}

//登陆
-(void)onDuibaLoginClick:(NSNotification *)notif{
    [AFNetworkTool httpRequestWithUrl:URL_COINSHOP_LOGIN params:nil success:^(NSData *data) {
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            NSString *loginurl = [result objectForKey:@"url"];
            CreditWebViewController *web = [[CreditWebViewController alloc]initWithUrl:loginurl];
            //CreditNavigationController *nav = [[CreditNavigationController alloc]initWithRootViewController:[[ghunterMyGoldCoinShopViewController alloc]init]];
            //[nav setNavColorStyle:Nav_backgroud];
            [self presentViewController:web animated:YES completion:nil];
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
    } fail:^{
        [ProgressHUD show:ERROR];
    }];
}

//分享
-(void)onDuibaShareClick:(NSNotification *)notify{
    NSDictionary *dict=notify.userInfo;
    NSString *shareUrl=[dict objectForKey:@"shareUrl"];//分享url
    NSString *shareTitle=[dict objectForKey:@"shareTitle"];//标题
    [[NSUserDefaults standardUserDefaults]setObject:shareTitle forKey:@"NaviGation"];
    NSString *shareThumbnail=[dict objectForKey:@"shareThumbnail"];//缩略图
    NSString *shareSubTitle=[dict objectForKey:@"shareSubtitle"];//副标题
    
    NSString *message=@"";
    message=[message stringByAppendingFormat:@"分享地址:%@ \n 分享标题:%@ \n分享图:%@ \n分享副标题:%@",shareUrl,shareTitle,shareThumbnail,shareSubTitle];
    
    
//    UIAlertView *alertShare=[[UIAlertView alloc]initWithTitle:@"捕获到分享点击" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertShare show];
}

//导航条布局
-(void)getNavView
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navView.backgroundColor = Nav_backgroud;
    [self.view addSubview:navView];
    
    UIButton *backButt =[[UIButton alloc]initWithFrame:CGRectMake(1, 21, 40, 40)];
    [backButt addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButt setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [navView addSubview:backButt];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(110, 30, 100, 20)];
    label.textAlignment=NSTextAlignmentCenter;
    label.text = @"金币商城";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    [navView addSubview:label];
}

-(void)viewDidAppear:(BOOL)animated{
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars =NO;
    }
    if([self respondsToSelector:@selector(setModalPresentationCapturesStatusBarAppearance:)]){
        self.modalPresentationCapturesStatusBarAppearance =NO;
    }
    if([self respondsToSelector:@selector(navigationController)]){
        if([self.navigationController.navigationBar respondsToSelector:@selector(setTranslucent:)]){
            self.navigationController.navigationBar.translucent =NO;
        }
    }

}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
   UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    CreditNavigationController *nav = [[CreditNavigationController alloc]initWithRootViewController:[[ghunterMyGoldCoinShopViewController alloc]init] ];
    window.rootViewController =nav;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - Custom Methods

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
