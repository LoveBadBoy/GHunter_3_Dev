//
//  ghunterGetbackTwoViewController.m
//  ghunter
//
//  Created by chensonglu on 14-3-11.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//找回密码-修改密码

#import "ghunterGetbackpwTwoViewController.h"

@interface ghunterGetbackpwTwoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmnewPassword;
@property (weak, nonatomic) IBOutlet UIButton *confirm_button;

@property (strong, nonatomic) IBOutlet UIView *bg;


@end

@implementation ghunterGetbackpwTwoViewController

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
    self.password.delegate = self;
    self.confirmnewPassword.delegate = self;
    self.confirm_button.clipsToBounds = YES;
    self.confirm_button.layer.cornerRadius = Radius;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checknewPassword:(id)sender {
    [self.password endEditing:YES];
    [self.confirmnewPassword endEditing:YES];
    if([self.password.text length] == 0){
        [ghunterRequester showTip:@"请输入密码~"];
        return;
    }
    if([self.confirmnewPassword.text length] == 0){
        [ghunterRequester showTip:@"请输入确认密码~"];
        return;
    }
    if(![self.password.text isEqualToString:self.confirmnewPassword.text]){
        [ghunterRequester showTip:@"两次密码不一致，请重新输入~"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.phone forKey:@"phone"];
    [dic setObject:self.captcha forKey:@"captcha"];
    [dic setObject:self.password.text forKey:@"password"];
    [ghunterRequester postwithDelegate:self withUrl:URL_RESET_PASSWORD withUserInfo:REQUEST_FOR_RESET_PASSWORD withDictionary:dic];
}
//http请求处理的代理方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_RESET_PASSWORD]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            NSString *errorMsg = [dic objectForKey:@"msg"];
            [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:errorMsg waitUntilDone:false];
            [self.navigationController popToViewController:[self.navigationController.viewControllers  objectAtIndex:1] animated:YES];
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络异常" waitUntilDone:false];

}

#pragma mark - UITextfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
