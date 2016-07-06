//
//  ghunterzhiyeViewController.m
//  ghunter
//
//  Created by ImGondar on 15/9/28.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import "ghunterzhiyeViewController.h"
#import "Header.h"
#import "AFNetworkTool.h"
#import "ProgressHUD.h"
@interface ghunterzhiyeViewController ()

@end

@implementation ghunterzhiyeViewController
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    arr = [NSMutableArray array];
    [self JOBSdata];
   
    self.view.backgroundColor = RGBCOLOR(235, 235, 235);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    view.backgroundColor = Nav_backgroud;
    view.userInteractionEnabled = YES;
    [self.view addSubview:view];
    UIButton *backbtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 30, 45)];
    [backbtn setImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
    backbtn.backgroundColor = [UIColor clearColor];
    [backbtn addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:backbtn];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, mainScreenWidth, 30)];
    label.text = @"填写你的职业";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIView *bgview= [[UIView alloc]initWithFrame:CGRectMake(0, 74, mainScreenWidth, 40)];
    bgview.userInteractionEnabled = YES;
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    NSString *str = [NSString stringWithFormat:@"你已选择“%@”",self.jobstr];
    UILabel *jobname = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, mainScreenWidth-20, 25)];
    jobname.text =str;
    jobname.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:jobname];
    UILabel * colorlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
    colorlabel.backgroundColor = [Monitor colorWithHexString:self.col alpha:1.0f];
    colorlabel.text = self.wor;
    colorlabel.font = [UIFont systemFontOfSize:10];
    colorlabel.textColor = [UIColor whiteColor];
    colorlabel.textAlignment = NSTextAlignmentCenter;
    [bgview addSubview:colorlabel];
    
    UIButton *Gravity = [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth-70, 5, 60, 30)];
    [Gravity setTitle:@"重选" forState:(UIControlStateNormal)];
    [Gravity setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    Gravity.titleLabel.font = [UIFont systemFontOfSize:14];
    [Gravity addTarget:self action:@selector(gravity:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgview addSubview:Gravity];
    
    UIView *bg2view= [[UIView alloc]initWithFrame:CGRectMake(0, 124, mainScreenWidth, 65)];
    bg2view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg2view];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 40, 25)];
    lab.text =@"职业:";
    lab.font = [UIFont systemFontOfSize:14];
    [bg2view addSubview:lab];
    
    textfild = [[UITextField alloc]initWithFrame:CGRectMake(50, 5, mainScreenWidth-60, 30)];
    textfild.delegate = self;
    textfild.font = [UIFont systemFontOfSize:13];
    textfild.backgroundColor = [UIColor clearColor];
    [bg2view addSubview:textfild];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, mainScreenWidth, 0.5)];
    line.backgroundColor = backgroud_Bg;
    [bg2view addSubview:line];
    
    UILabel *animat = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 80, 25)];
    animat.text = @"选择你的职业";
    animat.textColor = [UIColor grayColor];
    animat.font = [UIFont systemFontOfSize:12];
    [bg2view addSubview:animat];
}

-(void)gravity:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cavbtn:(UIButton *)btn{
    if ( [[textfild text] length] <= 0 ) {
        [ProgressHUD show:@"请选择或者职业名称"];
        return;
    }
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:textfild.text, @"job", self.industry_new, @"industry", self.direction_new, @"direction", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //连续返回两级
    long index = [[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
}

-(void)JOBSdata
{
    NSString *urlstr = [NSString stringWithFormat:@"%@?jid=%d",URL_GET_TABBAR_JOBS,self.jobid];
    [AFNetworkTool httpRequestWithUrl:urlstr params:nil success:^(NSData *data) {
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         jobarr = [result objectForKey:@"jobs"];
            for (NSDictionary* object in jobarr) {
                
                [arr addObject:[object objectForKey:@"title"]];
            }
            
            tagList = [[DWTagList alloc] initWithFrame:CGRectMake(0, 124+65, mainScreenWidth, 60)];
            tagList.dangdele = self;
            [tagList setTags:arr];
            tagList.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:tagList];
            
            UIButton *cavbtn = [[UIButton alloc]initWithFrame:CGRectMake(20, tagList.totalHeight+20+tagList.frame.origin.y, mainScreenWidth-40, 35)];
            
            [cavbtn setTitle:@"保存" forState:(UIControlStateNormal)];
            [cavbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [cavbtn addTarget:self action:@selector(cavbtn:) forControlEvents:(UIControlEventTouchUpInside)];
            cavbtn.titleLabel.font = [UIFont systemFontOfSize:16];
            cavbtn.backgroundColor = RGBCOLOR(246, 124, 71);
            [self.view addSubview:cavbtn];
            
       }fail:^{
       [ProgressHUD show:HTTPREQUEST_ERROR];
        }];
}
-(void)back:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == textfild) {
        if (textField.text.length > 10){
           [ProgressHUD show:@"字数不能超过10！"];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [textfild resignFirstResponder];
}


-(void)dangbtn:(NSString *)text{
    textfild.text = text;

    Monitor *textrr = [Monitor sharedInstance];
    textrr.monstr = textfild.text;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
