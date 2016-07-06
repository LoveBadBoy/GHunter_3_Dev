//
//  ghunterAddGoldViewController.m
//  ghunter
//
//  Created by chensonglu on 14-4-16.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//添加赏金

#import "ghunterAddGoldViewController.h"

@interface ghunterAddGoldViewController ()
@property (strong, nonatomic) IBOutlet UITextField *gold;
@property (strong, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (strong, nonatomic) IBOutlet UIView *bg;

@end

@implementation ghunterAddGoldViewController

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
    if(self.price.length!=0)
    {
        _gold.placeholder=[NSString stringWithFormat:@"赏金不能低于标价：%@元",self.price];
    }
    
    // Do any additional setup after loading the view from its nib.
    balanceInt = 0;
    self.gold.delegate = self;
    [self.gold becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [ghunterRequester postwithDelegate:self withUrl:URL_GET_MY_ACCOUNT withUserInfo:REQUEST_FOR_MY_ACCOUNT withDictionary:nil];
}

//http请求处理的代理方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_MY_ACCOUNT]){
        
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            NSDictionary *account = [dic objectForKey:@"account"];
            NSString *balance = [account objectForKey:@"balance"];
            balanceInt = [balance floatValue] + self.added_bounty;
            [self.balance setText:[NSString stringWithFormat:@"￥%@",balance]];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finish:(id)sender {
    
    if([self.gold.text length] == 0){
        [ghunterRequester showTip:@"请填写赏金~"];
        return;
    }
    if([self.gold.text integerValue]<self.price.integerValue)
    {
        NSString* str=[NSString stringWithFormat:@"任务赏金不能低于技能标价：%@元",self.price];
        [ghunterRequester showTip:str];
        return;
    }
    if([self.gold.text integerValue] > balanceInt){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的金库余额不足，请先充值" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        [alert show];
    }
    else{
        NSMutableDictionary *addGoldDic = [[NSMutableDictionary alloc] init];
        [addGoldDic setObject:self.gold.text forKey:@"gold"];
        if(self.type == 0) {
            NSNotification *notification = [NSNotification notificationWithName:GHUNTERADDGOLD object:addGoldDic userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
        } else if(self.type == 1) {
            NSNotification *notification = [NSNotification notificationWithName:@"modify_gold" object:addGoldDic userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (buttonIndex == 1) {
        ghunterRechargeViewController *ghunterRechargeView = [[ghunterRechargeViewController alloc] init];
        [self.navigationController pushViewController:ghunterRechargeView animated:YES];
    }
}

- (IBAction)recharge:(id)sender {
    [self.gold endEditing:YES];
    ghunterRechargeViewController *ghunterRechargeView = [[ghunterRechargeViewController alloc] init];
    [self.navigationController pushViewController:ghunterRechargeView animated:YES];
}

#pragma mark - UITextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
    return YES;
}
@end
