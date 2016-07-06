//
//  ghunterEvaluationViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-15.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//支付赏金

#import "ghunterEvaluationViewController.h"

@interface ghunterEvaluationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *descriptionText;
@property (weak, nonatomic) IBOutlet UIView *starBack;
@property (strong, nonatomic) IBOutlet UIImageView *starBackImg;
@property (strong, nonatomic) IBOutlet UIView *finishView;
@property (weak, nonatomic) IBOutlet UILabel *reward_gold;
//@property (weak, nonatomic) IBOutlet UILabel *hosting_gold;
@property (weak, nonatomic) IBOutlet UILabel *comment_title;
@property (nonatomic,retain) UIActionSheet *pay_comment;
@property (nonatomic,retain) UIActionSheet *comment;
@property (weak, nonatomic) IBOutlet UIButton *confirm;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *allEVa;
@property (strong, nonatomic) IBOutlet UILabel *attiEva;
@property (strong, nonatomic) IBOutlet UILabel *speedEva;
@property (strong, nonatomic) IBOutlet UILabel *quaEva;

@property (strong, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *GoldBackView;

@property (weak, nonatomic) IBOutlet UIImageView *iconBackView;

// 匿名评价的按钮
@property (weak, nonatomic) IBOutlet UISwitch *privateSwitch;
@property (weak, nonatomic) IBOutlet UILabel *privateLabel;

@property (strong, nonatomic) TQStarRatingView *allStar;
@property (strong, nonatomic) TQStarRatingView *attiStar;
@property (strong, nonatomic) TQStarRatingView *speedStar;
@property (strong, nonatomic) TQStarRatingView *quaStar;


@end

@implementation ghunterEvaluationViewController

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
    self.descriptionText.layer.cornerRadius = 6.0;
    self.descriptionText.delegate=self;
    self.starBack.backgroundColor = [UIColor whiteColor];
    self.GoldBackView.backgroundColor = [UIColor whiteColor];
    self.iconBackView.backgroundColor = [UIColor whiteColor];
    UIButton *cover = [[UIButton alloc] initWithFrame:self.allStar.frame];
    [self.starBack addSubview:cover];
    self.starBack.userInteractionEnabled=YES;
    
    self.allStar = [[TQStarRatingView alloc] initWithFrame:CGRectMake(self.allEVa.frame.origin.x+60 , self.allEVa.frame.origin.y, 110, 20) numberOfStar:5];
    self.allStar.delegate = self;
    [self.allStar setuserInteractionEnabled:YES];
    [self.starBack addSubview:self.allStar];
    
    self.attiStar = [[TQStarRatingView alloc] initWithFrame:CGRectMake(self.attiEva.frame.origin.x+60 , self.attiEva.frame.origin.y, 110, 20) numberOfStar:5];
    self.attiStar.delegate = self;
    [self.attiStar setuserInteractionEnabled:YES];
    [self.starBack addSubview:self.attiStar];
    
    self.speedStar = [[TQStarRatingView alloc] initWithFrame:CGRectMake(self.speedEva.frame.origin.x+60 , self.speedEva.frame.origin.y, 110, 20) numberOfStar:5];
    self.speedStar.delegate = self;
    [self.speedStar setuserInteractionEnabled:YES];
    [self.starBack addSubview:self.speedStar];
    
    self.quaStar = [[TQStarRatingView alloc] initWithFrame:CGRectMake(self.quaEva.frame.origin.x+60 , self.quaEva.frame.origin.y, 110, 20) numberOfStar:5];
    self.quaStar.delegate = self;
    [self.quaStar setuserInteractionEnabled:YES];
    [self.starBack addSubview:self.quaStar];
    
    [self.privateSwitch setOn:NO];
    self.isPrivate = @"0";
    
    //设置初始值为5星
    [self.allStar setScore:0];
    [self.attiStar setScore:0];
    [self.speedStar setScore:0];
    [self.quaStar setScore:0];
    
    NSInteger taskType = [[self.dic objectForKey:@"type"] integerValue];
    if (taskType==TASK_TYPE_NORMAL||taskType==TASK_TYPE_ORIENT_PUBLIC) {
        // 普通任务，和定向公开任务，没有私密评价
        if (self.type == 1) {
            self.quaStar.hidden = YES;
            self.quaEva.hidden = YES;
            CGRect frame1 = self.starBack.frame;
            frame1.size.height -= 30;
            self.starBack.frame = frame1;
            CGRect frame2 = self.finishView.frame;
            frame2.origin.y -= 30;
            self.finishView.frame = frame2;
            self.attiEva.text = @"诚信情况";
            self.speedEva.text = @"友好程度";
        }else{
            
        }
        // 隐藏匿名评价
        self.privateLabel.hidden = YES;
        self.privateSwitch.hidden = YES;
        
        CGRect frame = self.finishView.frame;
        frame.origin.y -= 30;
        self.finishView.frame = frame;
        
        CGRect frame3= self.starBack.frame;
        frame3.size.height -= 30;
        self.starBack.frame = frame3;
    }else{
        // 定向私密任务
        if (self.type==1) {
            self.quaStar.hidden = YES;
            self.quaEva.hidden = YES;
            CGRect frame1 = self.starBack.frame;
            frame1.size.height -= 30;
            self.starBack.frame = frame1;
            CGRect frame2 = self.finishView.frame;
            frame2.origin.y -= 30;
            self.finishView.frame = frame2;
            self.attiEva.text = @"诚信情况";
            self.speedEva.text = @"友好程度";
            
            // 隐藏匿名评价
            self.privateLabel.hidden = YES;
            self.privateSwitch.hidden = YES;
            
            CGRect frame = self.finishView.frame;
            frame.origin.y -= 30;
            self.finishView.frame = frame;
            
            CGRect frame3= self.starBack.frame;
            frame3.size.height -= 30;
            self.starBack.frame = frame3;
        }
    }
    
    [self.reward_gold setText:[NSString stringWithFormat:@"￥%@",[self.dic objectForKey:@"bounty"]]];
    
    if(self.type == 0){
        self.comment_title.text = @"评价并支付赏金";
        [_confirm setTitle:@"确认支付赏金" forState:UIControlStateNormal];
    }else if (self.type == 1){
        [_confirm setTitle:@"确认评价" forState:UIControlStateNormal];
        self.comment_title.text = @"评价任务主人";
    }
    self.confirm.clipsToBounds = YES;
//    self.confirm.layer.cornerRadius = Radius;

    self.avatar.clipsToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height / 2.0;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.user_avatar] placeholderImage:[UIImage imageNamed:@"avatar"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tap.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tap];
}

//点击空白处收起键盘
-(void)tap:(UITapGestureRecognizer*)sender
{
    [self.descriptionText resignFirstResponder];
}
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finish:(id)sender {
    if([self.descriptionText.text length] == 0){
        [ghunterRequester showTip:@"请输入评价描述"];
        return;
    }
    
    if(self.type == 0){
        // 默认评价星级为0，但是每一项都不能为0
        if ( self.allStar.score <= 0.0 || self.attiStar.score<=0.0 || self.quaStar.score<=0.0 || self.speedStar.score<=0.0 ) {
            [ghunterRequester showTip:@"评价星级不能为0"];
            return;
        }
        
        self.pay_comment = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"确定支付猎人并给Ta%.1f星级评价吗?", self.allStar.score] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [self.pay_comment showInView:self.view];
    }else if (self.type == 1){
        // 默认评价星级为0，但是每一项都不能为0
        // 猎人评价主人，只有三项
        if ( self.allStar.score <= 0.0 || self.attiStar.score<=0.0 || self.speedStar.score<=0.0 ) {
            [ghunterRequester showTip:@"评价星级不能为0"];
            return;
        }
        
        self.comment = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"确定给任务主人%.1f星级评价吗?",self.allStar.score] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [self.comment showInView:self.view];
    }
}

-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    if(view == self.allStar)
    {
        self.allStar.score = score*5;
    }
    if(view == self.attiStar)
    {
        self.attiStar.score = score*5;
    }
    if(view == self.speedStar)
    {
        self.speedStar.score = score*5;
    }
    if(view == self.quaStar)
    {
        self.quaStar.score = score*5;
    }
    
}
#pragma mark - ASIHttpRequest

- (void)startLoad{
    loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [loadingView startAnimition];
}

- (void)endLoad{
    [loadingView inValidate];
}

- (void)dealloc {
    loadingView = nil;
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_CONFIRM_PAYMENT]){
        [self endLoad];
        
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            NSNotification *notification = [[NSNotification alloc] initWithName:@"pay_comment" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            [self.navigationController popViewControllerAnimated:YES];
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_HUNTER_COMMENT]){
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            NSNotification *notification = [[NSNotification alloc] initWithName:@"pay_comment" object:nil userInfo:nil];
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
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络异常" waitUntilDone:false];
}

#pragma mark - UIActionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if(actionSheet == self.pay_comment){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:self.tid forKey:@"tid"];
            [dic setObject:[NSString stringWithFormat:@"%.1f",self.allStar.score] forKey:@"rating"];
            [dic setObject:[NSString stringWithFormat:@"%.1f",self.attiStar.score] forKey:@"attitude"];
            [dic setObject:[NSString stringWithFormat:@"%.1f",self.speedStar.score] forKey:@"speed"];
            [dic setObject:[NSString stringWithFormat:@"%.1f",self.quaStar.score] forKey:@"quality"];
            // 是否匿名评价
            [dic setObject:self.isPrivate forKey:@"isPrivate"];
            [dic setObject:self.descriptionText.text forKey:@"description"];
        
            
            [self startLoad];
            [ghunterRequester postwithDelegate:self withUrl:URL_CONFIRM_PAYMENT withUserInfo:REQUEST_FOR_CONFIRM_PAYMENT withDictionary:dic];
        }else if (actionSheet == self.comment){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:self.tid forKey:@"tid"];
            [dic setObject:[NSString stringWithFormat:@"%.1f",self.allStar.score] forKey:@"rating"];
            [dic setObject:[NSString stringWithFormat:@"%.1f",self.attiStar.score] forKey:@"honesty"];
            [dic setObject:[NSString stringWithFormat:@"%.1f",self.speedStar.score] forKey:@"friendly"];
            [dic setObject:self.descriptionText.text forKey:@"description"];
            
            [self startLoad];
            [ghunterRequester postwithDelegate:self withUrl:URL_HUNTER_COMMENT withUserInfo:REQUEST_FOR_HUNTER_COMMENT withDictionary:dic];
        }
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }else{
        [actionSheet dismissWithClickedButtonIndex:1 animated:YES];
    }
}

#pragma mark - UITextFielddelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.descriptionText resignFirstResponder];
    return YES;
}

// 是否匿名评价
- (IBAction)privateSwitch:(UISwitch *)sender {
    BOOL isButtonOn = [sender isOn];
    if (isButtonOn) {
        self.isPrivate = @"1";
    }else {
        self.isPrivate = @"0";
    }
     
}

@end
