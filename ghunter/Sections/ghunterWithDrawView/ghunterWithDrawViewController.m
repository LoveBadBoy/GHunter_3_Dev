//
//  ghunterWithDrawViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-25.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//提现

#import "ghunterWithDrawViewController.h"

@interface ghunterWithDrawViewController ()
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UITextField *withdraw;
@property (weak, nonatomic) IBOutlet UITextField *AliUsername;
@property (weak, nonatomic) IBOutlet UITextField *AliTrueName;
@property (weak, nonatomic) IBOutlet UIView *balanceView;
@property (weak, nonatomic) IBOutlet UIView *withdrawView;
@property (weak, nonatomic) IBOutlet UIView *aplipayView;
@end

@implementation ghunterWithDrawViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.balance setText:self.balanceStr];
    self.withdraw.delegate = self;
    self.AliUsername.delegate = self;
    self.AliTrueName.delegate = self;
    self.balanceView.clipsToBounds = YES;
    self.balanceView.layer.cornerRadius = Radius;
    self.withdrawView.clipsToBounds = YES;
    self.withdrawView.layer.cornerRadius = Radius;
    self.aplipayView.clipsToBounds = YES;
    self.aplipayView.layer.cornerRadius = Radius;
    [self.withdraw becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [ghunterRequester postwithDelegate:self withUrl:URL_GET_MY_ACCOUNT withUserInfo:REQUEST_FOR_MY_ACCOUNT withDictionary:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//http请求处理的代理方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_USER_ACCOUNT_WITHDRAW]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester showTip:@"提现申请已提交,请等待处理结果"];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_MY_ACCOUNT]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            account = [dic objectForKey:@"account"];
            [self.balance setText:[NSString stringWithFormat:@"￥%@",[account objectForKey:@"balance"]]];
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
    //    NSError *error = [request error];
//    NSLog(@"%@",error);

}

#pragma mark - UITextfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.withdraw) {
        if ([string isMatchedByRegex:@"^[0-9]$"]) {
            if (range.location == 0 && [string isEqualToString:@"0"]) {
                return NO;
            } else {
                NSString *regex = @"^[1-9][0-9]*$";
                if([textField.text isMatchedByRegex:regex]) return YES;
            }
        } else if ([string isEqualToString:@""]){
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
    return YES;
}

#pragma mark - Custom Methods

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirm:(id)sender {
    if ([self.withdraw.text length] == 0) {
        [ghunterRequester showTip:@"请填写提现金额~"];
        return;
    }
    if ([self.withdraw.text integerValue] < 10 || [self.withdraw.text integerValue] > 10000) {
        [ghunterRequester showTip:@"提现金额必须在10 - 10000元之间~"];
        return;
    }
    if([self.withdraw.text floatValue] > [[account objectForKey:@"balance"] floatValue]) {
        [ghunterRequester showTip:@"余额不足~"];
        return;
    }
    if ([self.AliTrueName.text length] == 0) {
        [ghunterRequester showTip:@"请填写真实姓名~"];
        return;
    }
    if ([self.AliUsername.text length] == 0) {
        [ghunterRequester showTip:@"请填写支付宝账户名~"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.withdraw.text forKey:@"amount"];
    [dic setObject:self.AliTrueName.text forKey:@"alipay_username"];
    [dic setObject:self.AliUsername.text forKey:@"alipay_account"];
    [ghunterRequester postwithDelegate:self withUrl:URL_USER_ACCOUNT_WITHDRAW withUserInfo:REQUEST_FOR_USER_ACCOUNT_WITHDRAW withDictionary:dic];
}
@end