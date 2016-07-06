//
//  ghunterWithdrawTypeViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-14.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//退款方式

#import "ghunterWithdrawTypeViewController.h"

@interface ghunterWithdrawTypeViewController ()
@property (weak, nonatomic) IBOutlet RadioButton *allWithDraw;
@property (weak, nonatomic) IBOutlet RadioButton *partWithDraw;
@property (weak, nonatomic) IBOutlet UIView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *declare;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *goldRate;
@property (weak, nonatomic) IBOutlet UILabel *hunterRate;
@property (nonatomic) NSInteger withDrawType;
@property (weak, nonatomic) IBOutlet UIView *withdrawType;
@property (weak, nonatomic) IBOutlet UIView *withdrawRate;
@property (strong, nonatomic) IBOutlet UIView *bg;

@property (strong, nonatomic) IBOutlet UIButton *withDrwaCommit;

@end

@implementation ghunterWithdrawTypeViewController

#pragma mark -UIViewController

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
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _bg.backgroundColor = Nav_backgroud;
    // Do any additional setup after loading the view from its nib.
    self.withDrawType = 2;
    _withdrawType.clipsToBounds = YES;
    _withdrawType.layer.cornerRadius = 4.0;
    _withdrawType.backgroundColor = [UIColor whiteColor];
    
    _withdrawRate.clipsToBounds = YES;
    _withdrawRate.layer.cornerRadius = 4.0;
    _withdrawRate.backgroundColor = [UIColor whiteColor];
    self.allWithDraw.groupId = @"withdrawType group";
    self.allWithDraw.index = 2;
    [self.allWithDraw defaultInitWithnormalImage:[UIImage imageNamed:@"radio_normal"] withClickedImage:[UIImage imageNamed:@"define_tag"] isLeft:YES size:CGSizeMake(self.allWithDraw.frame.size.width, self.allWithDraw.frame.size.height) padding:7.0];
    [self.allWithDraw setChecked:YES];
    self.allWithDraw.frame = CGRectMake(_withdrawType.frame.origin.x + 5, self.allWithDraw.frame.origin.y, self.allWithDraw.frame.size.width, self.allWithDraw.frame.size.height);
    
    self.partWithDraw.groupId = @"withdrawType group";
    self.partWithDraw.index = 1;
    [self.partWithDraw defaultInitWithnormalImage:[UIImage imageNamed:@"radio_normal"] withClickedImage:[UIImage imageNamed:@"define_tag"] isLeft:YES size:CGSizeMake(self.partWithDraw.frame.size.width, self.partWithDraw.frame.size.height)padding:7.0];
    self.partWithDraw.frame = CGRectMake(_withdrawType.frame.origin.x + 5, self.partWithDraw.frame.origin.y, self.partWithDraw.frame.size.width, self.partWithDraw.frame.size.height);
    
     [RadioButton addObserverForGroupId:@"withdrawType group" observer:self];
	self.slider.minimumValue = 0;
    self.slider.maximumValue = 100;
    self.slider.value = 50;
	[self.slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    self.rateView.hidden = YES;
    CGRect declareFrame = self.declare.frame;
    declareFrame.origin.y = self.withdrawType.frame.origin.y + self.withdrawType.frame.size.height + 10;
    self.declare.frame = declareFrame;
    
    CGRect commitBtnFrame = self.withDrwaCommit.frame;
    
    commitBtnFrame.origin.y = declareFrame.origin.y + declareFrame.size.height + 10;
    self.withDrwaCommit.frame = commitBtnFrame;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RadioButton method
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    self.withDrawType = index;
    CGRect btnFrame = self.withDrwaCommit.frame;

    if(self.withDrawType == 1){
        self.rateView.hidden = NO;
        CGRect declareFrame = self.declare.frame;
        declareFrame.origin.y = self.withdrawRate.frame.origin.y + self.withdrawRate.frame.size.height + 10;
        self.declare.frame = declareFrame;
        
        btnFrame.origin.y = declareFrame.origin.y + declareFrame.size.height;
        self.withDrwaCommit.frame = btnFrame;
    }else if (self.withDrawType == 2){
        self.rateView.hidden = YES;
        CGRect declareFrame = self.declare.frame;
        declareFrame.origin.y = self.withdrawType.frame.origin.y + self.withdrawType.frame.size.height + 10;
        self.declare.frame = declareFrame;
        
        btnFrame.origin.y = declareFrame.origin.y + declareFrame.size.height;
        self.withDrwaCommit.frame = btnFrame;
    }
}

#pragma mark - Custom Methods

- (void)updateValue:(UISlider *)sender{
    NSInteger f = (NSInteger)[sender value];
    [self.goldRate setText:[NSString stringWithFormat:@"%zd%%",f]];
    [self.hunterRate setText:[NSString stringWithFormat:@"%zd%%",100 - f]];
}

- (IBAction)goldAddRate:(id)sender {
    self.slider.value--;
    if([self.slider value] < 0) self.slider.value = 0;
    [self updateValue:self.slider];
}

- (IBAction)hunterAddRate:(id)sender {
    self.slider.value++;
    if([self.slider value] > 100.0) self.slider.value = 100.0;
    [self updateValue:self.slider];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finish:(id)sender {
    NSString *reason,*type;
    CGFloat master_withdraw,hunter_withdraw;
    NSInteger bounty = [self.bounty integerValue];
    master_withdraw = self.slider.value * bounty / 100.0;
    NSString *master_withdraw_str = [NSString stringWithFormat:@"%.1f",master_withdraw];
    hunter_withdraw = bounty - [master_withdraw_str floatValue];
    if(self.selectedReason == 1){
        reason = reason1;
    }else if (self.selectedReason == 2){
        reason = reason2;
    }else{
        reason = reason3;
    }
    if(self.withDrawType == 1){
        type = @"部分退款";
    }else{
        type =@"全部退款";
        master_withdraw = (CGFloat)bounty;
        hunter_withdraw = 0;
    }
    UIActionSheet *withdrawConfirm = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"退款理由:%@\n退款方式:%@\n退款结果:主人￥%.1f,猎人:￥%.1f",reason,type,master_withdraw,hunter_withdraw] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [withdrawConfirm showInView:self.view];
}

#pragma mark - UIActiosheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSString stringWithFormat:@"%zd",(NSInteger)[self.slider value]] forKey:@"owner_rate"];
        [dic setObject:[NSString stringWithFormat:@"%zd",100 - (NSInteger)[self.slider value]] forKey:@"hunter_rate"];
        [dic setObject:[NSString stringWithFormat:@"%zd",self.selectedReason] forKey:@"reason"];
        [dic setObject:[NSString stringWithFormat:@"%zd",self.withDrawType] forKey:@"withdraw_type"];
        [ghunterRequester postwithDelegate:self withUrl:[NSString stringWithFormat:@"%@?tid=%@",URL_BACK_DOING,self.tid] withUserInfo:REQUEST_FOR_BACK_DOING withDictionary:dic];
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }else{
        [actionSheet dismissWithClickedButtonIndex:1 animated:YES];
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
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_BACK_DOING]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            NSNotification *notification = [[NSNotification alloc] initWithName:@"back_doing" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[ghuntertaskViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    return;
                }
            }
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
