//
//  ghunteraddresViewController.m
//  ghunter
//
//  Created by ImGondar on 15/9/16.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import "ghunteraddresViewController.h"
#import "Header.h"
#import "Monitor.h"
@interface ghunteraddresViewController ()

@end

@implementation ghunteraddresViewController

-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.addresbg.backgroundColor =Nav_backgroud;
    self.view.backgroundColor = backgroud_Bg;
    _make.backgroundColor = RGBCOLOR(246, 124, 71);
    _text.borderStyle = UITextBorderStyleNone;
    _text.placeholder = @"请手动输入地区";
    _text.font = [UIFont fontWithName:@"Arial" size:15.0f];
    _text.clearButtonMode = UITextFieldViewModeAlways;
    _addres.text = [Monitor sharedInstance].addres;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(UIButton *)sender {
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_text.text,@"textOne",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"textss" object:nil userInfo:dict];
    //通过通知中心发送通知
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)popbtn:(UIButton *)sender {
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_text.text,@"textOne",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"textss" object:nil userInfo:dict];
    //通过通知中心发送通知

    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
