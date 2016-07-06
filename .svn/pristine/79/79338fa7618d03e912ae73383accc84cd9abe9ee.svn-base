//
//  ghunterLoginViewController.m
//  ghunter
//
//  Created by Wangmuxiong on 14-3-6.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//登陆

#import "ghunterLoginViewController.h"

@interface ghunterLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *login;
@property (weak, nonatomic) IBOutlet UILabel *getbackPassword;
@property (strong, nonatomic) IBOutlet UIImageView *imgondar;
@property (strong, nonatomic) IBOutlet UIView *navbg;

@property (strong, nonatomic) IBOutlet UIButton *regit;
@property(strong,nonatomic)CLGeocoder *geocoder;
@property (strong, nonatomic) IBOutlet UILabel *loginNavigationLabel;
@property(strong,nonatomic)NSMutableArray* locationArr;
@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet UILabel *login3Plant;
@end

@implementation ghunterLoginViewController

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
    self.regit.layer.borderWidth = 0.5f;
    self.view.backgroundColor = RGBCOLOR(238, 238, 238);
    self.regit.layer.borderColor = [Nav_backgroud CGColor];
    _navbg.backgroundColor =Nav_backgroud;
    _geocoder=[[CLGeocoder alloc]init];
    _locationArr=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    self.phoneNum.delegate = self;
    self.passWd.delegate = self;
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"找回密码"];
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 4)];
    self.getbackPassword.font = [UIFont systemFontOfSize:14];
    self.getbackPassword.attributedText = content;
    
    if([WXApi isWXAppInstalled]){
        
        [self.view addSubview:self.leftView];
        [self.view addSubview:self.login3Plant];
        [self.view addSubview:self.rightView];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth/2-65, 460, 130, 30)];
        [btn addTarget:self action:@selector(wxbtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setTitle:@"微信登录" forState:(UIControlStateNormal)];
        [btn setTitleColor:RGBCOLOR(107, 201, 85) forState:(UIControlStateNormal)];
        [btn.layer setBorderWidth:1.0];   //边框宽度
        [btn.layer setBorderColor:RGBCOLOR(107, 201, 85).CGColor];//边框颜色
        btn. contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        //  图标
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(6,17, 7, 10)];
        [btn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(1, 10, 1,10)];
        [self.view addSubview:btn];
    }else {
        self.leftView.alpha = 0;
        self.rightView.alpha = 0;
        self.login3Plant.alpha = 0;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    // 注册成功后跳转到本页面
    if (imgondar_islogin) {
        [self callBackBlock]();
        // 返回上一个页面
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 根据坐标取得地名
- (IBAction)login:(id)sender {
    [self.phoneNum endEditing:YES];
    [self.passWd endEditing:YES];
    if ([self.phoneNum.text length] == 0) {
        [ghunterRequester showTip:@"手机号不能为空"];
        return;
    }
    if ([self.passWd.text length] == 0) {
        [ghunterRequester showTip:@"密码不能为空"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.phoneNum.text forKey:@"phone"];
    [dic setObject:self.passWd.text forKey:@"password"];
    
    [self startLoad];
    [ghunterRequester postwithDelegate:self withUrl:URL_USER_LOGIN withUserInfo:REQUEST_FOR_LOGIN withDictionary:dic];
    [MobClick event:UMEVENT_LOGIN];
}

- (IBAction)register:(id)sender {
    ghunterRegisterOneViewController *ghunterRegisterOneView = [[ghunterRegisterOneViewController alloc] init];
    [self.navigationController pushViewController:ghunterRegisterOneView animated:YES];
}

- (IBAction)back:(id)sender {
    [self callBackBlock]();
    // 返回上一个页面
    [self dismissViewControllerAnimated:YES completion:nil];
    // [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)getBackPassword {
    ghunterGetbackpwOneViewController *ghunterGetbackpwOne = [[ghunterGetbackpwOneViewController alloc] init];
    [self.navigationController pushViewController:ghunterGetbackpwOne animated:YES];
}

#pragma mark - UITextfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - ASIHttprequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOGIN]){
        [self endLoad];
        if(responseCode == 200 && [error_number integerValue] == 0)
        {
            // 登录成功
            imgondar_islogin = YES;
            
            NSString *api_session_id = [dic objectForKey:API_SESSION_ID];
            NSDictionary *account = [dic objectForKey:@"account"];
            
            [ghunterRequester setApi_session_id:api_session_id];
            [ghunterRequester setUserInfoDic:account];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:@"latitude"];
            [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:@"longitude"];
            [dic setObject:[ghunterRequester getUserInfo:UID] forKey:@"pushid"];
            [dic setObject:DEVICE forKey:@"device"];
            
            // 用通知的方式去修改资料
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didModifyUserProfile" object:dic];
            
            // 设置极光推送标签
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setPushTags" object:nil];
            
            // 这里是为了登录之后让“我的页面”刷新
            NSNotification *notification = [NSNotification notificationWithName:@"userinfo_modify" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            
            // 登录成功，重新获取消息数目
            NSNotification *notify = [NSNotification notificationWithName:@"get_unread_count" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notify waitUntilDone:false];
            
            // [self.navigationController popToRootViewControllerAnimated:YES];
            
            // 返回上一级页面
            // 模态返回上一级页面
            [self dismissViewControllerAnimated:YES completion:nil];
            // [self.navigationController popViewControllerAnimated:YES];
            
            self.callBackBlock();
        }else if([dic objectForKey:@"msg"])
        {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else
        {
            [ghunterRequester noMsg];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self endLoad];
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:HTTPREQUEST_ERROR waitUntilDone:false];
}

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"请稍后..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}

// 微信登录
- (IBAction)wxbtn:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setObject:snsAccount.usid forKey:@"weixin_id"];
            [params setObject:snsAccount.accessToken forKey:@"access_token"];
            [params setObject:snsAccount.expirationDate forKey:@"expiresIn"];
            
            [AFNetworkTool httpPostWithUrl:URL_WEIXIN_AUTH andParameters:params success:^(NSData *data) {
                NSError *error;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                
                if ([[dic objectForKey:@"error"]integerValue] == 0) {
                    if ([dic objectForKey:@"new_user"] && [[dic objectForKey:@"new_user"] integerValue] == 1) {
                        // 新用户
                        //得到的数据在回调Block对象形参respone的data属性
                        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *response){
                            // NSLog(@"SnsInformation is %@",response.data);
                            NSMutableDictionary *wxDic = [[NSMutableDictionary alloc] initWithDictionary:response.data];
                            ghunterRegisterTwoViewController *grt = [[ghunterRegisterTwoViewController alloc] init];
                            grt.is_wxlogin = YES;
                            grt.wxDic = wxDic;
                            [self.navigationController pushViewController:grt animated:YES];
                        }];
                    }else{
                        if ([[dic objectForKey:@"error"] integerValue] == 1) {
                            [ProgressHUD show:[dic objectForKey:@"msg"]];
                            return;
                        }
                        // 已经注册过的用户，直接登录成功
                        // 登录成功
                        imgondar_islogin = YES;
                        
                        NSString *api_session_id = [dic objectForKey:API_SESSION_ID];
                        NSDictionary *account = [dic objectForKey:@"account"];
                        [ghunterRequester setApi_session_id:api_session_id];
                        [ghunterRequester setUserInfoDic:account];
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:@"latitude"];
                        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:@"longitude"];
                        [dic setObject:[ghunterRequester getUserInfo:UID] forKey:@"pushid"];
                        [dic setObject:DEVICE forKey:@"device"];
                        
                        // 用通知的方式去修改资料
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"didModifyUserProfile" object:dic];
                        
                         // 设置极光推送标签
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"setPushTags" object:nil];
                        
                        // 这里是为了登录之后让“我的页面”刷新
                        NSNotification *notification = [NSNotification notificationWithName:@"userinfo_modify" object:nil userInfo:nil];
                        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
                        
                        // 登录成功，重新获取消息数目
                        NSNotification *notify = [NSNotification notificationWithName:@"get_unread_count" object:nil userInfo:nil];
                        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notify waitUntilDone:false];
                        
                        // 模态返回上一级页面
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        self.callBackBlock();
                    }
                }
            } fail:^{
                [ProgressHUD show:HTTPREQUEST_ERROR];
            }];
        }
    });
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.phoneNum resignFirstResponder];
    [self.passWd resignFirstResponder];
}
@end
