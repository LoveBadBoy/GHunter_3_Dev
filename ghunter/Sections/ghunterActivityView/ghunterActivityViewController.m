//
//  ghunterActivityViewController.m
//  ghunter
//
//  Created by chensonglu on 14-9-17.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//第三方分享

#import "ghunterActivityViewController.h"

@interface ghunterActivityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;
@property(nonatomic,retain)UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIView *bg;

@end

@implementation ghunterActivityViewController

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
    // Do any additional setup after loading the view from its nib.
    self.shareButton.hidden = YES;
    activity = [[NSDictionary alloc] init];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64)];
    self.webView.scalesPageToFit =YES;
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.webView];
    [ghunterRequester postwithDelegate:self withUrl:URL_GET_ACTIVITY withUserInfo:REQUEST_FOR_GET_ACTIVITY withDictionary:nil];
    [self.indicator startAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods
- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}
- (void)endLoad{
    [self.loadingView inValidate];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)share:(id)sender {
    shareAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"shareView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    [shareAlertView setCornerRadius:8.0];
    CGRect taskfilterFrame = taskFilter.frame;
    shareAlertView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height - 10), taskfilterFrame.size.width, taskfilterFrame.size.height);
    shareAlertView.showView = taskFilter;
    UIButton *weixincircle = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *weixinfried = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *weibo = (UIButton *)[taskFilter viewWithTag:3];
    UIButton *cancel = (UIButton *)[taskFilter viewWithTag:5];
    [weixincircle addTarget:self action:@selector(weixincircle:) forControlEvents:UIControlEventTouchUpInside];
    [weixinfried addTarget:self action:@selector(weixinfried:) forControlEvents:UIControlEventTouchUpInside];
    [weibo addTarget:self action:@selector(weibo:) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(sharecancel:) forControlEvents:UIControlEventTouchUpInside];
    shareAlertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    [shareAlertView show];
}

- (void)weixincircle:(id)sender {
    [shareAlertView dismissAnimated:YES];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                        [activity objectForKey:@"shareImage"]];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@?from=appclient",[activity objectForKey:@"siteurl"]];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[activity objectForKey:@"shareTitle"] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            [ghunterRequester showTip:@"分享成功"];
            [self startLoad];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[activity objectForKey:@"aid"] forKey:@"aid"];
            [dic setObject:@"iphone" forKey:@"platform"];
            [ghunterRequester postwithDelegate:self withUrl:URL_GET_ACTIVITY_REWARD withUserInfo:REQUEST_FOR_GET_ACTIVITY_REWARD withDictionary:dic];
        }
    }];
}

- (void)weixinfried:(id)sender {
    [shareAlertView dismissAnimated:YES];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                        [activity objectForKey:@"shareImage"]];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@?from=appclient",[activity objectForKey:@"siteurl"]];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [activity objectForKey:@"title"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[activity objectForKey:@"shareTitle"] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            [self startLoad];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[activity objectForKey:@"aid"] forKey:@"aid"];
            [dic setObject:@"iphone" forKey:@"platform"];
            [ghunterRequester postwithDelegate:self withUrl:URL_GET_ACTIVITY_REWARD withUserInfo:REQUEST_FOR_GET_ACTIVITY_REWARD withDictionary:dic];
        }
    }];
}

- (void)weibo:(id)sender {
    [shareAlertView dismissAnimated:YES];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                        [activity objectForKey:@"shareImage"]];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@ %@?from=appclient",[activity objectForKey:@"shareTitle"],[activity objectForKey:@"siteurl"]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [ghunterRequester showTip:@"分享成功"];
            [self startLoad];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[activity objectForKey:@"aid"] forKey:@"aid"];
            [dic setObject:@"iphone" forKey:@"platform"];
            [ghunterRequester postwithDelegate:self withUrl:URL_GET_ACTIVITY_REWARD withUserInfo:REQUEST_FOR_GET_ACTIVITY_REWARD withDictionary:dic];
        }
    }];
}


- (void)sharecancel:(id)sender {
    [shareAlertView dismissAnimated:YES];
}

#pragma mark - UIWebView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
   
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self.indicator stopAnimating];
    [self.indicator setHidden:YES];
    [self.indicator removeFromSuperview];
    self.shareButton.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [ghunterRequester showTip:@"活动加载失败"];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_GET_ACTIVITY]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            activity = [dic objectForKey:@"activity"];
            [self.activityTitle setText:[activity objectForKey:@"title"]];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?from=appclient",[activity objectForKey:@"siteurl"]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_GET_ACTIVITY_REWARD]){
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            NSNotification *notification = [NSNotification notificationWithName:@"refresh_unread" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self endLoad];
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络异常" waitUntilDone:false];
    //    NSError *error = [request error];

}

@end
