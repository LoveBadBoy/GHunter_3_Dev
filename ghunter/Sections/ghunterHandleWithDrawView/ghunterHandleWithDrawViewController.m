//
//  ghunterHandleWithDrawViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-14.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//处理退款

#import "ghunterHandleWithDrawViewController.h"

@interface ghunterHandleWithDrawViewController ()
@property (weak, nonatomic) IBOutlet RadioButton *agree2withdraw;
@property (weak, nonatomic) IBOutlet RadioButton *disagree2withdraw;
@property (weak, nonatomic) IBOutlet UILabel *withdraw_reason;
@property (weak, nonatomic) IBOutlet UILabel *withdraw_type;
@property (weak, nonatomic) IBOutlet UILabel *withdraw_rate;
@property (weak, nonatomic) IBOutlet UILabel *withdraw_money;
@property (weak, nonatomic) IBOutlet UIButton *confirm;
@property (weak, nonatomic) IBOutlet UIButton *realConfirm;
@property (nonatomic) NSInteger result;
@property (retain, nonatomic) UIActionSheet *action;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *disAgreeLabel;

@property (strong, nonatomic) IBOutlet UIView *bg;

@property (strong, nonatomic) IBOutlet UIView *infoBackView;

@property (strong, nonatomic) IBOutlet UIView *withdrawView;

@end

@implementation ghunterHandleWithDrawViewController

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
    // Do any additional setup after loading the view from its nib.
     _bg.backgroundColor = Nav_backgroud;
    self.result = 0;
    self.agree2withdraw.groupId = @"handleWithdraw group";
    self.agree2withdraw.index = 1;
    [self.agree2withdraw defaultInitWithnormalImage:[UIImage imageNamed:@"radio_normal"] withClickedImage:[UIImage imageNamed:@"define_tag"] isLeft:YES size:CGSizeMake(self.agree2withdraw.frame.size.width, self.agree2withdraw.frame.size.height) padding:5.0];
    
    self.disagree2withdraw.groupId = @"handleWithdraw group";
    self.disagree2withdraw.index = 2;
    [self.disagree2withdraw defaultInitWithnormalImage:[UIImage imageNamed:@"radio_normal"] withClickedImage:[UIImage imageNamed:@"define_tag"] isLeft:YES size:CGSizeMake(self.disagree2withdraw.frame.size.width, self.disagree2withdraw.frame.size.height)padding:5.0];
    [RadioButton addObserverForGroupId:@"handleWithdraw group" observer:self];
    
    if([self.stage isEqualToString:@"disagree"]){
        [self.disagree2withdraw setChecked:YES];
        [self.agree2withdraw setUserInteractionEnabled:NO];
        [self.disagree2withdraw setUserInteractionEnabled:NO];
        [self.confirm setHidden:YES];
    }
    
    self.agreeLabel.frame = CGRectMake(self.agree2withdraw.frame.origin.x+25, self.agree2withdraw.frame.origin.y+6, 150, self.agreeLabel.frame.size.height);
    self.disAgreeLabel.frame = CGRectMake(self.disagree2withdraw.frame.origin.x+25, self.disagree2withdraw.frame.origin.y+6, 150, self.disAgreeLabel.frame.size.height);

    NSString *reason,*type;
    if([[self.dic objectForKey:@"reason"] isEqualToString:@"1"]){
        reason = reason1;
    }else if ([[self.dic objectForKey:@"reason"] isEqualToString:@"2"]){
        reason = reason2;
    }else{
        reason = reason3;
    }
    if([[self.dic objectForKey:@"type"] isEqualToString:@"1"]){
        type = @"部分退款";
    }else{
        type =@"全部退款";
    }
    NSUInteger master_rate,hunter_rate;
    master_rate = [[self.dic objectForKey:@"owner_rate"] integerValue];
    hunter_rate = [[self.dic objectForKey:@"hunter_rate"] integerValue];
    CGFloat master_withdraw, hunter_withdraw;
    NSInteger bounty = [self.bounty integerValue];
    master_withdraw = bounty * master_rate / 100.0;
    NSString *master_withdraw_str = [NSString stringWithFormat:@"%.1f",master_withdraw];
    hunter_withdraw = bounty - [master_withdraw_str floatValue];
    NSString *hunter_withdraw_str = [NSString stringWithFormat:@"%.1f",hunter_withdraw];
    [_withdraw_reason setText:reason];
    [_withdraw_type setText:type];
    [_withdraw_rate setText:[NSString stringWithFormat:@"主人%zd%%,猎人%zd%%",master_rate,hunter_rate]];
    [_withdraw_money setText:[NSString stringWithFormat:@"主人￥%@,猎人￥%@",master_withdraw_str,hunter_withdraw_str]];
    
    self.infoBackView.backgroundColor = [UIColor whiteColor];
    self.withdrawView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finish:(id)sender {
    if(self.result == 0) return;
    else if (self.result == 1){
        self.action = [[UIActionSheet alloc] initWithTitle:@"确定同意退款?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [self.action showInView:self.view];
    } else if (self.result == 2) {
        self.action = [[UIActionSheet alloc] initWithTitle:@"确定不同意退款?若不同意退款需要耐心等待任务主人处理,双方需要继续协商来完成退款流程." delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [self.action showInView:self.view];
    }
}

#pragma mark - RadioButton method
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    self.result = index;
}

#pragma mark - UIActionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [ghunterRequester getwithDelegate:self withUrl:URL_HUNTER_HANDLE_WITHDRAW withUserInfo:REQUEST_FOR_HANDLE_WITHDRAW withString:[NSString stringWithFormat:@"?%@=%@&%@=%zd",@"tid",self.tid,@"result",self.result]];
    } else if (buttonIndex == 1) {
        [self.action dismissWithClickedButtonIndex:1 animated:YES];
    }
}

#pragma mark - ASIhttpRequest

-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_HANDLE_WITHDRAW]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            NSNotification *notification = [[NSNotification alloc] initWithName:@"handle_withdraw" object:[NSString stringWithFormat:@"%zd",self.result] userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            [self.navigationController popViewControllerAnimated:YES];
        }else if([dic objectForKey:@"msg"]){
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
@end
