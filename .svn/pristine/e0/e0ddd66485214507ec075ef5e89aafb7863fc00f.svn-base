//
//  ghunterRegisterViewController.m
//  ghunter
//
//  Created by chensonglu on 14-3-8.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//注册页面-1

#import "ghunterRegisterOneViewController.h"

@interface ghunterRegisterOneViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *captcha;

@property (strong, nonatomic) IBOutlet UIButton *codebtn;
@property (strong, nonatomic) IBOutlet UIView *bg;

@property (strong, nonatomic) IBOutlet UIButton *nextbtn;


@property (strong, nonatomic) IBOutlet UIView *navbg;
@property (weak, nonatomic) IBOutlet UITextField *password_one;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeField;
@property (weak, nonatomic) IBOutlet UIButton *l_timeButton;
@property (weak, nonatomic) IBOutlet UILabel *agreement;
@property (strong, nonatomic) IBOutlet UILabel *invitecode;
@property (strong, nonatomic) NSString *inviteStr;


@property (strong, nonatomic) IBOutlet UIButton *btnadada;





@end

@implementation ghunterRegisterOneViewController

#pragma mark - UIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _lab.textColor = RGBCOLOR(99, 99, 99);
    self.view.backgroundColor = RGBCOLOR(238, 238, 238);
    _nextbtn.backgroundColor = RGBCOLOR(246, 124, 71);
    // Do any additional setup after loading the view from its nib.]
    _bg.backgroundColor = Nav_backgroud;
    _btnadada.backgroundColor = RGBCOLOR(246, 124, 71);
    _navbg.backgroundColor = Nav_backgroud;
    self.phoneNum.delegate = self;
    self.captcha.delegate = self;
    self.password_one.delegate = self;
    self.inviteCodeField.delegate = self;
    self.inviteStr = @"";
    
    _codebtn.backgroundColor = Nav_backgroud;
    [_codebtn.layer setMasksToBounds:YES];
    [_codebtn.layer setCornerRadius:5.0];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"注册即表示同意《用户使用协议》"];
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 8)];
    self.agreement.font = [UIFont systemFontOfSize:11];
    self.agreement.attributedText = content;
    self.inviteCodeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    NSMutableAttributedString *invite = [[NSMutableAttributedString alloc] initWithString:@"邀请码"];
    [invite addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 3)];
    
    self.invitecode.font = [UIFont systemFontOfSize:14];
    self.invitecode.attributedText = invite;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (IBAction)agreementShow:(id)sender {
    ghunterWebViewController *web = [[ghunterWebViewController alloc] init];
    web.webTitle = @"用户协议";
    web.urlPassed = AGREEMENT;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)cancel:(id)sender {
    [inputAlertView dismissAnimated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getCaptcha:(id)sender {
    
    [self.phoneNum endEditing:YES];
    if ([self.phoneNum.text length] == 0) {
        [ghunterRequester showTip:@"手机号不能为空"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.phoneNum.text forKey:@"phone"];
    [ghunterRequester postwithDelegate:self withUrl:URL_GETCAPTCHA withUserInfo:REQUEST_FOR_CAPTCHA withDictionary:dic];
}

- (IBAction)next:(id)sender {
    [self.phoneNum endEditing:YES];
    [self.captcha endEditing:YES];
    [self.password_one endEditing:YES];
    [self.inviteCodeField endEditing:YES];
    if ([self.phoneNum.text length] == 0) {
        

        [ghunterRequester showTip:@"手机号不能为空"];
        return;
    }
    if([self.captcha.text length] == 0){
        [ghunterRequester showTip:@"验证码不能为空"];
        return;
    }
    if([self.password_one.text length] == 0){
        [ghunterRequester showTip:@"请输入密码"];
        return;
    }
    if([self.inviteCodeField.text length]>0){
        if ([self isNumText:self.inviteCodeField.text]) {
            self.inviteStr = self.inviteCodeField.text;
        }else{
            [ghunterRequester showTip:@"邀请码只能是数字"];
            return;
        }
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.phoneNum.text forKey:@"phone"];
    [dic setObject:self.captcha.text forKey:@"captcha"];
    
    [ghunterRequester postwithDelegate:self withUrl:URL_CHECK_CAPTCHA withUserInfo:REQUEST_FOR_CHECK_CAPTCHA withDictionary:dic];
}

//是否是纯数字
- (BOOL)isNumText:(NSString *)str{
    NSScanner* scan = [NSScanner scannerWithString:str];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - ASIHttpRequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_CAPTCHA]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            __block NSInteger timeout=60; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        CGRect buttonFrame = CGRectMake(self.view.frame.size.width - 30 - 75, self.l_timeButton.frame.origin.y, 75, 25);
                        [self.l_timeButton setFrame:buttonFrame];
                        [self.l_timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                        self.l_timeButton.userInteractionEnabled = YES;
                    });
                }else{
                    //            NSInteger minutes = timeout / 60;
                    NSInteger seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2zd", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        CGRect buttonFrame = CGRectMake(self.view.frame.size.width - 30 -130, self.l_timeButton.frame.origin.y, 90, 25);
                        [self.l_timeButton setFrame:buttonFrame];
                        [self.l_timeButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                        self.l_timeButton.userInteractionEnabled = NO;
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);

        }else if ([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
        }else{
            [ghunterRequester noMsg];
        }
    }else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_CHECK_CAPTCHA]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            ghunterRegisterTwoViewController *ghunterRegisterTwoView = [[ghunterRegisterTwoViewController alloc] init];
            ghunterRegisterTwoView.phone = self.phoneNum.text;
            ghunterRegisterTwoView.password = self.password_one.text;
            ghunterRegisterTwoView.invitecode = self.inviteStr;
            [self.navigationController pushViewController:ghunterRegisterTwoView animated:YES];
        }else if ([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
            
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
}

#pragma mark - UITextfiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //if ( [[AFNetworkTool getDeviceString] rangeOfString:@"iPhone5"].location!=NSNotFound || [[AFNetworkTool getDeviceString] rangeOfString:@"iPhone4"].location!=NSNotFound ) {
//    if (textField == self.inviteCodeField) {
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             CGRect frame = self.view.frame;
//                             frame.origin.y -= self.inviteCodeField.frame.size.height - 15;
//                             self.view.frame = frame;
//                             
//                         } completion:^(BOOL finished) {
//                             
//                         }];
        //}
    //}
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //if ( [[AFNetworkTool getDeviceString] rangeOfString:@"iPhone5"].location!=NSNotFound || [[AFNetworkTool getDeviceString] rangeOfString:@"iPhone4"].location!=NSNotFound ) {
//    if (textField == self.inviteCodeField) {
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             CGRect frame = self.view.frame;
//                             frame.origin.y += self.inviteCodeField.frame.size.height + 15;
//                             self.view.frame = frame;
//                         } completion:^(BOOL finished) {
//                             
//                         }];
//        }
    //}
}
#pragma mark - UITextviewDelegate
- (BOOL)textView:(UITextView *)textviewhere shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
        if([text isEqualToString:@"\n"]){
            if ([[textviewhere text] length] == 0) {
                [textviewhere resignFirstResponder];
                return NO;
            } else {
                [textviewhere resignFirstResponder];
                return NO;
            }
        }
    return YES;
}
@end
