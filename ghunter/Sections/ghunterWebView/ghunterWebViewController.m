//
//  ghunterWebViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-26.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//  赏金猎人webView(未知)

#import "ghunterWebViewController.h"
#import "SIAlertView.h"
#import "ghuntertaskViewController.h"
#import "AFNetworkTool.h"
#import "ghunterUserCenterViewController.h"
#import "ghunterSkillViewController.h"
#import "UMSocialQQHandler.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"


@interface ghunterWebViewController (){
    BOOL _authenticated;
    NSURLConnection  *_urlConnection;
    NSURLRequest *_request;
}

@property(nonatomic,retain)UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@end

@implementation ghunterWebViewController

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
     _bg.backgroundColor = Nav_backgroud;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    // Do any additional setup after loading the view from its nib.
    [self.titleLabel setText:self.webTitle];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64)];
    self.webView.scalesPageToFit =YES;
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:self.urlPassed];
    _request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:_request];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
   //  NSLog(@"webViewDidStartLoad");
    [self.indicator startAnimating] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // NSLog(@"webViewDidFinishLoad");
    [self.indicator stopAnimating];
    [self.indicator setHidden:YES];
    [self.shareBtn setHidden:NO];
    [self.indicator removeFromSuperview];
    // 获取本网页的Title
    self.webTitle = [NSMutableString stringWithString:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    self.urlPassed = [NSMutableString stringWithString:webView.request.URL.absoluteString];
    
    [self.titleLabel setText:self.webTitle];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // [ghunterRequester showTip:@"加载网页失败"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSString* scheme = [[request URL] scheme];
    // NSLog(@"scheme = %@",scheme);
    // 判断是不是https
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!_authenticated) {
            _authenticated = NO;
            _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [_urlConnection start];
            return NO;
        }
    }
    return [self handleOpenUrl:[[request URL] absoluteString]];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    
    if ([challenge previousFailureCount] == 0)
    {
        _authenticated = YES;
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
        
    // remake a webview call now that authentication has passed ok.
    _authenticated = YES;
    [self.webView loadRequest:_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (IBAction)back:(id)sender {
    if (self.fromPush) {
        // 推送过来的任务
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)shareBtnClick:(id)sender {
    if (shareView != nil) {
        [shareView show];
        return;
    }
    
    shareView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"shareView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    
    CGRect width = taskFilter.frame;
    width.size.width = mainScreenWidth - 20;
    taskFilter.frame = width;
    
    taskFilter = [nibs objectAtIndex:0];
    [shareView setCornerRadius:8.0];
    CGRect taskfilterFrame = taskFilter.frame;
    taskfilterFrame.size.width = mainScreenWidth - 20;
    taskFilter.frame = taskfilterFrame;
    
    shareView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height - 10), taskfilterFrame.size.width, taskfilterFrame.size.height);
    shareView.showView = taskFilter;
    UIButton *weixincircle = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *weixinfried = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *weibo = (UIButton *)[taskFilter viewWithTag:3];
    UIButton *qzone = (UIButton*)[taskFilter viewWithTag:6];
    UIButton *qq = (UIButton*)[taskFilter viewWithTag:7];
    UIButton *copy = (UIButton *)[taskFilter viewWithTag:4];
    UIButton *cancel = (UIButton *)[taskFilter viewWithTag:5];
    [weixincircle addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [weixinfried addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [weibo addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [copy addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [qzone addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [qq addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    
    // 从浏览器打开
    UIButton *browser = (UIButton *)[taskFilter viewWithTag:8];
    UILabel *browserTitle = (UILabel *)[taskFilter viewWithTag:9];
    [browser setHidden:NO];
    [browserTitle setHidden:NO];
    [browser addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    
    shareView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    
    [shareView show];
}

// 分享：复制链接
-(void)shareToPlatforms:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    int code = [AFNetworkTool getHunterID:[[ghunterRequester getUserInfo:UID] intValue] :0];
    
    NSString *str1 = [self.urlPassed stringByReplacingOccurrencesOfString:@"?from=client" withString:@""];
    NSString *str2;
    if (![str1 containsString:@"code="]) {
        if ( [str1 containsString:@"?"] ) {
            str2 = [str1 stringByAppendingString:[NSString stringWithFormat:@"&code=%zd", code]];
        }else{
            str2  = [str1 stringByAppendingString:[NSString stringWithFormat:@"?code=%zd", code]];
        }
        self.urlPassed = [NSMutableString stringWithString:str2];
    }else{
        self.urlPassed = [NSMutableString stringWithString:str1];
    }
    
    // NSString *msgMatch = [NSString stringWithFormat:@"api_token=%@&api_session_id=.*&", API_TOKEN_NUM];
    // NSArray *msgResult = [self.urlPassed arrayOfCaptureComponentsMatchedByRegex:msgMatch];
    
    [shareView dismissAnimated:YES];
    
    if ( [btn tag] == 1 ) {
        // wxcircle
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:DEFAULT_SHARE_IMAGE];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.urlPassed;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.webTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:[ghunterRequester getUserInfo:UID] :SHARETYPE_WEBPAGE :self.urlPassed :SHAREPLATFORM_WXMOMENTS];
            }
        }];
    }else if([btn tag] == 2){
        // weixinfriend
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:DEFAULT_SHARE_IMAGE];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.urlPassed;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = APP_NAME;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.webTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:[ghunterRequester getUserInfo:UID] :SHARETYPE_WEBPAGE :self.urlPassed:SHAREPLATFORM_WECHAT];
            }
        }];
    }else if([btn tag] == 3){
        // weibo
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:@"http://imgondar.com/images/shareimg.png"];
        NSString *shareContent = [NSString stringWithFormat:@"琐事不愁，赚钱交友：%@；详情清猛戳这里→_→%@", self.webTitle, self.urlPassed];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:shareContent image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:[ghunterRequester getUserInfo:UID] :SHARETYPE_WEBPAGE :self.urlPassed:SHAREPLATFORM_SINAWEIBO];
            }
        }];
    }else if([btn tag] == 4){
        // copy
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        // 链接后加入邀请码，为了更好地统计链接分享情况
        [pasteboard setString:self.urlPassed];
        [ProgressHUD show:@"已复制到剪贴板"];
    }else if([btn tag] == 5){
        // cancel
    }else if([btn tag] == 6){
        // qzone
        if (![QQApiInterface isQQInstalled]) {
            [AFNetworkTool isInstallQQ];
            return;
        }

        [UMSocialData defaultData].extConfig.qzoneData.url = self.urlPassed;
        [UMSocialData defaultData].extConfig.qzoneData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:DEFAULT_SHARE_IMAGE];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.webTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:[ghunterRequester getUserInfo:UID] :SHARETYPE_WEBPAGE :self.urlPassed:SHAREPLATFORM_QZONE];
            }
        }];
    }else if([btn tag] == 7){
        // qq
        if (![QQApiInterface isQQInstalled]) {
            [AFNetworkTool isInstallQQ];
            return;
        }

        [UMSocialData defaultData].extConfig.qqData.url = self.urlPassed;
        [UMSocialData defaultData].extConfig.qqData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:DEFAULT_SHARE_IMAGE];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.webTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:[ghunterRequester getUserInfo:UID] :SHARETYPE_WEBPAGE :self.urlPassed:SHAREPLATFORM_QQ];
            }
        }];
    }else if([btn tag] == 8){
        // 从浏览器打开
        NSURL *url = [[NSURL alloc] initWithString:self.urlPassed];
        [[UIApplication sharedApplication] openURL:url];
    }
}


// 处理二维码扫描
-(BOOL)handleOpenUrl:(NSString *)qrstr{
    NSString *siteUrl = qrstr;
    NSRange range = [siteUrl rangeOfString:@"http://"];
    NSRange range02 = [siteUrl rangeOfString:@"https://"];
    if (range.length == 0 && range02.length == 0) {
        siteUrl = [NSString stringWithFormat:@"http://%@", siteUrl];
    }
    
    NSString *msgMatch = @"http:\\/\\/mob\\.imgondar\\.com\\/task\\/view\\?tid=(\\d+).*?";
    NSArray *msgResult = [siteUrl arrayOfCaptureComponentsMatchedByRegex:msgMatch];
    
    if ([msgResult count] == 1) {
        NSString *tid = [[msgResult objectAtIndex:0] objectAtIndex:1];
        ghuntertaskViewController *taskView = [[ghuntertaskViewController alloc] init];
        taskView.tid = tid;
        taskView.callBackBlock = ^{};
        [self.navigationController pushViewController:taskView animated:YES];
        return NO;
    }
    
    NSString *skillMatch = @"http:\\/\\/mob\\.imgondar\\.com\\/skillshow\\/view\\?id=(\\d+).*?";
    NSArray *skillResult = [siteUrl arrayOfCaptureComponentsMatchedByRegex:skillMatch];
    if ([skillResult count] == 1) {
        NSString *sid = [[skillResult objectAtIndex:0] objectAtIndex:1];
        ghunterSkillViewController *skillView = [[ghunterSkillViewController alloc] init];
        skillView.skillid = sid;
        skillView.callBackBlock = ^{};
        [self.navigationController pushViewController:skillView animated:YES];
        return NO;
    }
    
    NSString *userMatch = @"http:\\/\\/mob\\.imgondar\\.com\\/user\\/view\\?uid=(\\d+).*?";
    NSArray *userResult = [siteUrl arrayOfCaptureComponentsMatchedByRegex:userMatch];
    if ([userResult count] == 1) {
        NSString *uid = [[userResult objectAtIndex:0] objectAtIndex:1];
        ghunterUserCenterViewController *userView = [[ghunterUserCenterViewController alloc] init];
        userView.uid = uid;
        [self.navigationController pushViewController:userView animated:YES];
        return NO;
    }
    return YES;
}


@end
