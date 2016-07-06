//
//  ghunterGetbackpwViewController.m
//  ghunter
//
//  Created by chensonglu on 14-3-11.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//找回密码

#import "ghunterGetbackpwOneViewController.h"

@interface ghunterGetbackpwOneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *captcha;
@property (weak, nonatomic) IBOutlet UIButton *l_timeButton;
@property (strong, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIButton *confirm;
@property (weak, nonatomic) IBOutlet UIView *modifYBG;
@end

@implementation ghunterGetbackpwOneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _bg.backgroundColor = Nav_backgroud;
    // Do any additional setup after loading the view from its nib.
    self.phone.delegate = self;
    self.captcha.delegate = self;
    self.confirm.clipsToBounds = YES;
    self.confirm.layer.cornerRadius = Radius;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getCaptcha:(id)sender {
    [self.phone endEditing:YES];
    if ([self.phone.text length] == 0) {
        [ghunterRequester showTip:@"手机号不能为空～"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.phone.text forKey:@"phone"];
    [ghunterRequester postwithDelegate:self withUrl:URL_FINDPASSWORD_GETCAPTCHA withUserInfo:REQUEST_FOR_FINDPASSWORD_CAPTCHA withDictionary:dic];
}

- (IBAction)checkCaptcha:(id)sender {
    [self.captcha endEditing:YES];
    if ([self.phone.text length] == 0) {
        [ghunterRequester showTip:@"手机号不能为空～"];
        return;
    }
    if([self.captcha.text length] == 0){
        [ghunterRequester showTip:@"验证码不能为空～"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.phone.text forKey:@"phone"];
    [dic setObject:self.captcha.text forKey:@"captcha"];
    [ghunterRequester postwithDelegate:self withUrl:URL_FINDPASSWORD_CHECK_CAPTCHA withUserInfo:REQUEST_FOR_FINDPASSWORD_CHECK_CAPTCHA withDictionary:dic];
}

//http请求处理的代理方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_FINDPASSWORD_CAPTCHA]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            __block NSInteger timeout=60; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        CGRect buttonFrame = CGRectMake(self.modifYBG.frame.size.width - 15 - 75, self.l_timeButton.frame.origin.y, 75, 25);
                        [self.l_timeButton setFrame:buttonFrame];
                        [self.l_timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                        [self.l_timeButton setBackgroundImage:[UIImage imageNamed:@"long_button_bg_normal"] forState:UIControlStateNormal];
                        self.l_timeButton.userInteractionEnabled = YES;
                    });
                }else{
                    //            NSInteger minutes = timeout / 60;
                    NSInteger seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        CGRect buttonFrame = CGRectMake(self.modifYBG.frame.size.width - 15 - 90, self.l_timeButton.frame.origin.y, 90, 25);
                        [self.l_timeButton setFrame:buttonFrame];
                        [self.l_timeButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                        [self.l_timeButton setBackgroundImage:[UIImage imageNamed:@"long_button_bg_selected"] forState:UIControlStateNormal];
                        self.l_timeButton.userInteractionEnabled = NO;
                        
                    });
                    timeout--;
                    
                }
            });
            dispatch_resume(_timer);
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_FINDPASSWORD_CHECK_CAPTCHA]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            ghunterGetbackpwTwoViewController *ghunterGetbackpwTwoView = [[ghunterGetbackpwTwoViewController alloc] init];
            ghunterGetbackpwTwoView.phone = self.phone.text;
            ghunterGetbackpwTwoView.captcha = self.captcha.text;
            [self.navigationController pushViewController:ghunterGetbackpwTwoView animated:YES];
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }
}
#pragma mark - ASIHttprequest
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络异常" waitUntilDone:false];
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
