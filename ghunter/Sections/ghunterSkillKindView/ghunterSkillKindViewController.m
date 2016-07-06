//
//  ghunterSkillKindViewController.m
//  ghunter
//
//  Created by imgondar on 15/1/30.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import "ghunterSkillKindViewController.h"

@interface ghunterSkillKindViewController ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
- (IBAction)backBtn:(UIButton *)sender;
@property(strong,nonatomic)NSMutableArray* skillKind;

@end

@implementation ghunterSkillKindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.cornerRadius = 8.0;
    self.skillKind=[[NSMutableArray alloc] init];
    
    [ghunterRequester postwithDelegate:self withUrl:URL_GET_SKILL_CATALOG withUserInfo:REQUEST_FOR_SKILL_CATALOG withDictionary:nil];
}

-(void)btnClick:(UIButton*)sender
{
    NSInteger labelTag=sender.tag + 10;
    UILabel* label=(UILabel*)[self.contentView viewWithTag:labelTag];
    NSString* sid;
    for(NSUInteger i=0;i<8;i++)
    {
        NSDictionary* skillDic=_skillKind[i];
        if([[skillDic objectForKey:@"title"]isEqualToString:label.text])
        {
            sid = [skillDic objectForKey:@"sid"];
        }
    }
    
    NSMutableDictionary *addSkillCat = [[NSMutableDictionary alloc] init];
    [addSkillCat setObject:label.text forKey:@"skillName"];
    [addSkillCat setObject:sid forKey:@"sid"];
    
    NSNotification *notification = [NSNotification notificationWithName:GHUNTERADDSKILLCAT object:addSkillCat userInfo:nil];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ASIHttprequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_SKILL_CATALOG]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            self.skillKind=[dic objectForKey:@"skills"];
            
            
            for(NSUInteger i=0;i<8;i++)
            {
                NSDictionary* skillDic=_skillKind[i];
                UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
                NSString* imageName=[NSString stringWithFormat:@"skill_classify_%zd",i+1];
                [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                UILabel* label=[[UILabel alloc] init];
                label.textAlignment=NSTextAlignmentCenter;
                if(i<4)
                {
                    [btn setFrame:CGRectMake(18+i*75, 18, 40, 40)];
                    label.frame=CGRectMake(18+i*75, 61, 40, 16);
                }
                else
                {
                    [btn setFrame:CGRectMake(18+(i-4)*75, 85, 40, 40)];
                    label.frame=CGRectMake(18+(i-4)*75, 128, 40, 16);
                }
                label.text=[skillDic objectForKey:@"title"];
                label.tintColor=[UIColor blackColor];
                label.font=[UIFont systemFontOfSize:10];
                
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag=10+i;
                label.tag=20+i;
                [self.contentView addSubview:btn];
                [self.contentView addSubview:label];
            }
        } else {
            [ghunterRequester noMsg];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
