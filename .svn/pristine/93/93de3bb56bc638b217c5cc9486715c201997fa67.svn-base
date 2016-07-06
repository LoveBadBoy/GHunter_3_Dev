//
//  ghunterModifyPasswordViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-13.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//修改密码

#import "ghunterModifyPasswordViewController.h"

@interface ghunterModifyPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordNow;
@property (weak, nonatomic) IBOutlet UITextField *passwordNew;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirm;
@property (strong, nonatomic) IBOutlet UIView *bg;

@end

@implementation ghunterModifyPasswordViewController

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _bg.backgroundColor = Nav_backgroud;
    self.passwordNow.delegate = self;
    self.passwordNew.delegate = self;
    self.passwordConfirm.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirm:(id)sender {
    if([self.passwordNow.text length] == 0){
        [ghunterRequester showTip:@"请填写当前密码"];
        return;
    }
    if([self.passwordNew.text length] == 0){
        [ghunterRequester showTip:@"请填写新密码"];
        return;
    }
    if([self.passwordConfirm.text length] == 0){
        [ghunterRequester showTip:@"请填写确认密码"];
        return;
    }
    if(![self.passwordNew.text isEqualToString:self.passwordConfirm.text]){
        [ghunterRequester showTip:@"两次密码填写不一致"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[ghunterRequester getUserInfo:PHONE] forKey:PHONE];
    [dic setObject:self.passwordNew.text forKey:PASSWORD];
    [dic setObject:self.passwordNow.text forKey:@"oldpwd"];
    
    [ghunterRequester postwithDelegate:self withUrl:URL_MODIFY_PASSWORD withUserInfo:REQUEST_FOR_MODIFY_PASSWORD withDictionary:dic];
}

#pragma mark - ASIHttpRequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_MODIFY_PASSWORD]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester showTip:[dic objectForKey:@"msg"]];
            [ghunterRequester clearProfile];
            
            double latitudeLocal = [[NSUserDefaults standardUserDefaults] doubleForKey:LATITUDE];
            double longitudeLocal = [[NSUserDefaults standardUserDefaults] doubleForKey:LONGITUDE];
            // 保存本地的经纬度，有利于用来请求数据等
            [ghunterRequester setUserInfoWithKey:LATITUDE withValue:[NSString stringWithFormat:@"%f",latitudeLocal]];
            [ghunterRequester setUserInfoWithKey:LONGITUDE withValue:[NSString stringWithFormat:@"%f",longitudeLocal]];
            
            // 注销后返回上一个页面
            [self.navigationController popViewControllerAnimated:YES];
            
            // 通知消息页面，清楚数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyPasswdOK" object:nil];
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


#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
