//
//  ghunterModifyTaskViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-8.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//赏金任务

#import "ghunterModifyTaskViewController.h"

@interface ghunterModifyTaskViewController ()
@property(strong,nonatomic) NSMutableDictionary *dic;
@property (weak, nonatomic) IBOutlet UIView *taskContentBG;
@property (weak, nonatomic) IBOutlet UIView *taskModifyBG;
@property (retain, nonatomic) UIAlertView *timeAlert;
@property (retain, nonatomic) NSString *date;
@property(nonatomic,retain)UIPickerView *pickerView;
@property(nonatomic,retain)NSArray *one2ten;
@property(nonatomic,retain)NSMutableArray *yearArray;
@property(nonatomic,retain)NSMutableArray *monthArray;
@property(nonatomic,retain)NSMutableArray *dayArray;
@property(nonatomic,retain)NSMutableArray *hourArray;
@property(nonatomic,retain)NSMutableArray *minuteArray;

@property (strong, nonatomic) IBOutlet UIView *bg;



@end

@implementation ghunterModifyTaskViewController

#pragma mark - UIViewController
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
    self.yearArray = [[NSMutableArray alloc] init];
    self.monthArray = [[NSMutableArray alloc] init];
    self.dayArray = [[NSMutableArray alloc] init];
    self.hourArray = [[NSMutableArray alloc] init];
    self.minuteArray = [[NSMutableArray alloc] init];
    _one2ten = [[NSArray alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09", nil];
    for (NSInteger i = startYear; i<= endYear; i++) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    [self.monthArray addObjectsFromArray:_one2ten];
    for (NSUInteger i = 10; i <= 12;i++) {
        [self.monthArray addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    [self.dayArray addObjectsFromArray:_one2ten];
    for (NSUInteger i = 10; i <= 31; i++) {
        [self.dayArray addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    [self.hourArray addObject:@"00"];
    [self.hourArray addObjectsFromArray:_one2ten];
    for (NSUInteger i = 10; i <= 23; i++) {
        [self.hourArray addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    [self.minuteArray addObject:@"00"];
    [self.minuteArray addObjectsFromArray:_one2ten];
    for (NSUInteger i = 10; i <= 59; i++) {
        [self.minuteArray addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    added_bounty = 0;
    _taskContentBG.clipsToBounds = YES;
//    _taskContentBG.layer.cornerRadius = Radius;
    _taskModifyBG.clipsToBounds = YES;
//    _taskModifyBG.layer.cornerRadius = Radius;
    self.taskTitle.delegate = self;
    self.descriptionText.delegate = self;
    self.taskTitle.text = self.titleStr;
    self.descriptionText.text = self.descriptionStr;
    self.addGoldAfter.text = [NSString stringWithFormat:@"￥%@",self.goldNum];
    saveaddGold = [NSString stringWithFormat:@"%@",self.goldNum];
    self.setTimeAfter.text = self.dateline;
    self.descriptionLabel.hidden = YES;
    
    /***************************** 监听 ******************************/
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"modify_gold" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGoldOK:) name:@"modify_gold" object:nil];
    
    [self footview];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods
- (IBAction)setBounty {
//    ghunterAddGoldViewController *ghunterAddGold = [[ghunterAddGoldViewController alloc] init];
//    ghunterAddGold.added_bounty = [self.goldNum integerValue];
//    ghunterAddGold.type = 1;
//    [self.navigationController pushViewController:ghunterAddGold animated:YES];
    ghunterAddGoldViewController *ghunterAddGold = [[ghunterAddGoldViewController alloc] init];
    ghunterAddGold.added_bounty = 0;
    ghunterAddGold.type = 0;
    //    [self.navigationController pushViewController:ghunterAddGold animated:YES];
    
    [self popGoldView];
}
#pragma mark --- 创建底部解析数据弹框
-(void)footview
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [ghunterRequester postwithDelegate:self withUrl:URL_GET_MY_ACCOUNT withUserInfo:REQUEST_FOR_MY_ACCOUNT withDictionary:nil];
}

// 底部弹框
-(void)popGoldView
{
    pictureAlert = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"addGoldSkill" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter.backgroundColor = [UIColor yellowColor];
    taskFilter = [nibs objectAtIndex:0];
    CGRect taskfilterFrame = taskFilter.frame;
    pictureAlert.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height), taskfilterFrame.size.width, taskfilterFrame.size.height);
    pictureAlert.showView = taskFilter;
    
    UIButton *addGold = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *cancelGold = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *determine = (UIButton *)[taskFilter viewWithTag:3];
    UITextField * goldTF = (UITextField *)[taskFilter viewWithTag:7];
    UILabel * balanceLb = (UILabel *)[taskFilter viewWithTag:8];
    if(self.price.length!=0)
    {
        NSString *str = [NSString stringWithFormat:@"赏金不能低于标价：%@元",self.price];
        goldTF.placeholder=str;
    }
    goldTF.keyboardType = UIKeyboardTypeNumberPad;
    goldTF.returnKeyType = UIReturnKeyDone;
    goldTF.delegate = self;
    goldTF.tag = 101;
    [balanceLb setText:[NSString stringWithFormat:@"￥%@",tmpBalanceStr]];
    balanceLb.textColor = [UIColor orangeColor];
    [addGold addTarget:self action:@selector(addGold_pic) forControlEvents:UIControlEventTouchUpInside];
    [cancelGold addTarget:self action:@selector(cancelGold_pic) forControlEvents:UIControlEventTouchUpInside];
    [determine addTarget:self action:@selector(determine_pic) forControlEvents:UIControlEventTouchUpInside];
    
    pictureAlert.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    [pictureAlert show];
}


//重置按钮调用事件
-(void)addGold_pic
{
    [pictureAlert dismissAnimated:YES];
    
    [self.gold endEditing:YES];
    ghunterRechargeViewController *ghunterRechargeView = [[ghunterRechargeViewController alloc] init];
    [self.navigationController pushViewController:ghunterRechargeView animated:YES];
}
//取消按钮调用事件
-(void)cancelGold_pic
{
    [pictureAlert dismissAnimated:YES];
    
}
//确定按钮调用事件
-(void)determine_pic
{
    UITextField * goldTF = (UITextField *)[pictureAlert viewWithTag:101];
    goldNumStr = goldTF.text;
    
    if([goldNumStr length] == 0){
        [ghunterRequester showTip:@"请填写赏金~"];
        return;
    }
    if([goldNumStr integerValue]<self.price.integerValue)
    {
        NSString* str=[NSString stringWithFormat:@"任务赏金不能低于技能标价：%@元",self.price];
        [ghunterRequester showTip:str];
        return;
    }
    if([goldNumStr integerValue] > balanceInt){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的金库余额不足，请先充值" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        alert.tag = 100;
        [alert show];
        return;
    }
    else{
        NSMutableDictionary *addGoldDic = [[NSMutableDictionary alloc] init];
        [addGoldDic setObject:goldNumStr forKey:@"gold"];
        if(self.type == 0) {
            NSNotification *notification = [NSNotification notificationWithName:GHUNTERADDGOLD object:addGoldDic userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
        } else if(self.type == 1) {
            NSNotification *notification = [NSNotification notificationWithName:@"modify_gold" object:addGoldDic userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
        }
        //        [self.navigationController popViewControllerAnimated:YES];
        self.addGoldAfter.text = goldNumStr;
//        self.addGoldAfter.text = [NSString stringWithFormat:@"¥%@", goldNumStr];
        [pictureAlert dismissAnimated:YES];
    }
}


- (IBAction)setTime:(id)sender {
    ageAlert = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth - 20, 200)];
    CGRect bgFrame = bg.frame;
    UIView *bgImg = [[UIView alloc] initWithFrame:bgFrame];
    bgImg.backgroundColor = [UIColor whiteColor];
    bgImg.alpha = 0.7;
    bgImg.clipsToBounds = YES;
    bgImg.layer.cornerRadius = Radius;
    _pickerView= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, mainScreenWidth - 20, 160)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    NSInteger year = [[ghunterRequester setNowTimeShow:0] integerValue];
    NSInteger month = [[ghunterRequester setNowTimeShow:1] integerValue];
    NSInteger day = [[ghunterRequester setNowTimeShow:2] integerValue];
    NSInteger hour = [[ghunterRequester setNowTimeShow:3] integerValue];
    NSInteger minute = [[ghunterRequester setNowTimeShow:4] integerValue];
    [_pickerView selectRow:(year - startYear) inComponent:0 animated:YES];
    [_pickerView selectRow:(month - 1) inComponent:1 animated:YES];
    [_pickerView selectRow:(day - 1) inComponent:2 animated:YES];
    [_pickerView selectRow:hour inComponent:3 animated:YES];
    [_pickerView selectRow:minute inComponent:4 animated:YES];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0] forState:UIControlStateNormal];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(bg.frame.size.width - 50,0 ,50 ,40)];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0] forState:UIControlStateNormal];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, bg.frame.size.width, 0.5)];
    [line setBackgroundColor:[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0]];
    [bg addSubview:bgImg];
    [bg addSubview:leftButton];
    [bg addSubview:rightButton];
    [bg addSubview:line];
    [bg addSubview:_pickerView];
    ageAlert.containerFrame = CGRectMake((mainScreenWidth - bgFrame.size.width) / 2.0, mainScreenheight - bgFrame.size.height - 10, bgFrame.size.width, bgFrame.size.height);
    ageAlert.showView = bg;
    ageAlert.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    ageAlert.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [ageAlert show];
}

- (void)cancel{
    [ageAlert dismissAnimated:YES];
}

- (void)confirm{
    NSUInteger yearSelected = [self.pickerView selectedRowInComponent:0];
    NSUInteger monthSelected = [self.pickerView selectedRowInComponent:1];
    NSUInteger daySelected = [self.pickerView selectedRowInComponent:2];
    NSUInteger hourSelected = [self.pickerView selectedRowInComponent:3];
    NSUInteger minuteSelected = [self.pickerView selectedRowInComponent:4];
    NSString *year = [self.yearArray objectAtIndex:yearSelected];
    NSString *month = [self.monthArray objectAtIndex:monthSelected];
    NSString *day = [self.dayArray objectAtIndex:daySelected];
    NSString *hour = [self.hourArray objectAtIndex:hourSelected];
    NSString *minute = [self.minuteArray objectAtIndex:minuteSelected];
    self.date = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
    double timeDiff = [ghunterRequester gettimeIntervalToFuture:[NSString stringWithFormat:@"%@:00",self.date]];
    if (timeDiff < ONE_HOUR || timeDiff > 20 * ONE_DAY) {
        self.timeAlert = [[UIAlertView alloc] initWithTitle:@"任务完成时间只能设置为1小时到20天之内!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [ageAlert dismissAnimated:YES];
        [self performSelector:@selector(timerAlertShow) withObject:nil afterDelay:0.3];
    } else {
        //        self.timeAlert = [[UIAlertView alloc] initWithTitle:@"若完成时间5天后尚未支付,系统会自动支付赏金给猎人,此期间内您均可申请退款." message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //        修改bug 修改时间后时间框不消失的问题  ——BY杨达
        [ageAlert dismissAnimated:YES];
        //        [self performSelector:@selector(timerAlertShow) withObject:nil afterDelay:0.3];
        
        [self.setTimeAfter setText:self.date];
    }
}

- (void)timerAlertShow {
    [self.timeAlert show];
}

- (void)addGoldOK:(NSNotification *)notification{
    NSDictionary *dic = (NSDictionary *)[notification object];
    NSString *gold = [dic objectForKey:@"gold"];
    added_bounty = [gold integerValue] - [self.goldNum integerValue];
    [self.addGoldAfter setText:[NSString stringWithFormat:@"￥%@",gold]];
}

- (IBAction)finish {
    // 修改与2015-02-17日By汪小熊，添加修改任务时对任务标题和任务描述的约束
    [self.taskTitle endEditing:YES];
    [self.descriptionText endEditing:YES];
    if([self.taskTitle.text length]<5||[self.taskTitle.text length]>20)
    {
        [ghunterRequester showTip:@"任务标题为5-20字之间"];
        return;
    }
    if([self.descriptionText.text length] == 0){
        [ghunterRequester showTip:@"请填写任务详情"];
        return;
    }
    
    // 验证完成后，弹框询问用户是否确定提交修改任务
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定提交修改任务吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

// 点击弹框的确定取消按钮
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // 确定提交任务修改
        self.dic = [[NSMutableDictionary alloc] init];
        [self.dic setObject:self.tid forKey:@"tid"];
        [self.dic setObject:self.taskTitle.text forKey:@"title"];
        [self.dic setObject:self.descriptionText.text forKey:@"description"];
        if ([self.addGoldAfter.text integerValue] == 0) {
            added_bounty = [self.addGoldAfter.text integerValue];
        }else {
            added_bounty = [goldNumStr integerValue]-[saveaddGold integerValue];
        }
        NSString *bounty = [NSString stringWithFormat:@"%zd",added_bounty];
        [self.dic setObject:bounty forKey:@"added_bounty"];
        [self.dic setObject:self.setTimeAfter.text forKey:@"trade_dateline"];
        [ghunterRequester postwithDelegate:self withUrl:URL_EDIT_TASK withUserInfo:REQUEST_FOR_EDIT_TASK withDictionary:self.dic];
        
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else if (buttonIndex == 1){
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ASIHttpRequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    
    
    // 金币数据解析
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_MY_ACCOUNT]){
        
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            NSDictionary *account = [dic objectForKey:@"account"];
            NSString *balance = [account objectForKey:@"balance"];
            balanceInt = [balance floatValue] + self.add_bounty;
            [self.balance setText:[NSString stringWithFormat:@"￥%@",balance]];
            tmpBalanceStr = balance;
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }
    
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_EDIT_TASK]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester showTip:[dic objectForKey:@"msg"]];
            NSNotification *notification = [[NSNotification alloc] initWithName:GHUNTERMODIFY object:self.dic userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - UITextView Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    if(self.descriptionText.text.length != 0){
        self.descriptionLabel.hidden = YES;
    }else{
        self.descriptionLabel.hidden = NO;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UITextfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    pictureAlert.frame = CGRectMake(0, -278, mainScreenWidth, ScreenHeightFull);
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    pictureAlert.frame = [[UIScreen mainScreen] bounds];
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView == self.timeAlert) {
        if(buttonIndex == 1) {
            [self.setTimeAfter setText:self.date];
            [ageAlert dismissAnimated:YES];
        } else if (buttonIndex == 0) {
            [ageAlert dismissAnimated:YES];
        }
    }
}

#pragma mark - UIPickerView delegate datasource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 5;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat width = (mainScreenWidth - 20) / 6.0;
    switch (component) {
        case 0:
            return 2 * width - 30;
            break;
        case 1:
        case 2:
        case 3:
        case 4:
            return width;
            break;
        default:
            break;
    }
    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(component == 0){
        return [self.yearArray count];
    }else if (component == 1){
        return [self.monthArray count];
    }else if(component == 2){
        NSUInteger yearSelected = [pickerView selectedRowInComponent:0];
        NSUInteger monthSelected = [pickerView selectedRowInComponent:1];
        NSUInteger year = [[self.yearArray objectAtIndex:yearSelected] integerValue];
        NSUInteger month = [[self.monthArray objectAtIndex:monthSelected] integerValue];
        if(month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12){
            return 31;
        }else if(month == 4 || month == 6 || month == 9 || month == 11){
            return 30;
        }else{
            if(month == 2 && IS_LEAP_YEAR(year)){
                return 29;
            }else return 28;
        }
    }else if (component == 3){
        return [self.hourArray count];
    }else if (component == 4){
        return [self.minuteArray count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.yearArray objectAtIndex:row];
            break;
        case 1:
            return [self.monthArray objectAtIndex:row];
            break;
        case 2:
            return [self.dayArray objectAtIndex:row];
            break;
        case 3:
            return [self.hourArray objectAtIndex:row];
            break;
        case 4:
            return [self.minuteArray objectAtIndex:row];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            [pickerView reloadComponent:2];
            break;
        case 1:
            [pickerView reloadComponent:2];
            break;
        case 2:
            [pickerView reloadComponent:2];
            break;
        default:
            break;
    }
}

@end
