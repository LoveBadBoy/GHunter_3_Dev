//
//  ghunterSkillReleaseViewController.m
//  ghunter
//
//  Created by imgondar on 15/1/23.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import "ghunterSkillReleaseViewController.h"
#import "SIAlertView.h"

@interface ghunterSkillReleaseViewController (){
    NSMutableDictionary *updateParamsDic;
    CGFloat balanceInt;

}
- (IBAction)cleanBtn:(UIButton *)sender;
- (IBAction)releaseBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *skillLabel;
@property (strong, nonatomic) IBOutlet UIImageView *circleImg;
@property (strong, nonatomic) IBOutlet UILabel *saleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UITextField *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UIView *skillInfo;
@property (strong, nonatomic) IBOutlet UILabel *addPicLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *setTimeImg;
@property (strong, nonatomic) IBOutlet UIImageView *addGoldImg;
@property (strong, nonatomic) IBOutlet UILabel *setTimeAfter;
@property (strong, nonatomic) IBOutlet UILabel *addGoldAfter;
@property (strong, nonatomic) IBOutlet UILabel *setTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addGoldLabel;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (retain, nonatomic) NSString *date;
@property (retain, nonatomic) UIAlertView *timeAlert;
@property (nonatomic, strong) NSMutableArray *checkmarkImageViews;
@property (nonatomic, strong) NSMutableArray *selectedIndexes;

- (IBAction)dateBtn:(UIButton *)sender;
- (IBAction)addGold:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *img0;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img3;

- (IBAction)secretSwitch:(UISwitch *)sender;
@property (strong, nonatomic) IBOutlet UILabel *secretLabel;
@property (strong, nonatomic) IBOutlet UIView *skillView;
@property (strong, nonatomic) IBOutlet UIView *bg;

@property (strong, nonatomic) IBOutlet UISwitch *switchSecret;

// 本页面标题
@property (strong, nonatomic) IBOutlet UILabel *pageTitle;
// 发布/提交 按钮
@property (strong, nonatomic) IBOutlet UILabel *submitLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomRelease;
@property (strong, nonatomic) IBOutlet UILabel *bottomShangjin;
@property (strong, nonatomic) IBOutlet UILabel *bottomTD;

// 第四行，任务状态：公开或者私密
@property (weak, nonatomic) IBOutlet UILabel *labelTaskStatus;

@property(nonatomic,retain)NSMutableArray *yearArray;
@property(nonatomic,retain)NSMutableArray *monthArray;
@property(nonatomic,retain)NSMutableArray *dayArray;
@property(nonatomic,retain)NSMutableArray *hourArray;
@property(nonatomic,retain)NSMutableArray *minuteArray;
@property(nonatomic,retain)NSArray *one2ten;
@property (strong, nonatomic) NSMutableDictionary *postDic;
// 发布
@property (strong, nonatomic) IBOutlet UIButton *releaseBtn;

// 背景滚动
@property (strong, nonatomic) IBOutlet UIScrollView *backGScrollView;
@property (strong, nonatomic)  UITextField *gold;
@property (strong, nonatomic)  UILabel *balance;
@property (strong, nonatomic)  NSString *price;
@property (nonatomic) NSUInteger added_bounty;
@property (nonatomic) NSUInteger type;

@property (strong, nonatomic) IBOutlet UILabel *addGoldNum;

@end

@implementation ghunterSkillReleaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect width = _releaseBtn.frame;
    width.size.width = mainScreenWidth-20;
    _releaseBtn.frame = width;
    
    CGRect skillinfowidth = _skillInfo.frame;
    skillinfowidth.size.width = mainScreenWidth;
    _skillInfo.frame = skillinfowidth;
    
    CGRect skillwidth = _skillView.frame;
    skillwidth.size.width = mainScreenWidth;
    _skillView.frame = skillwidth;
    
    CGRect contentviewwidth = _contentView.frame;
    contentviewwidth.size.width = mainScreenWidth;
    _contentView.frame = contentviewwidth;
    
    self.backGScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight)];
    self.backGScrollView.delegate = self;
    self.backGScrollView.showsHorizontalScrollIndicator = NO;
    self.backGScrollView.showsVerticalScrollIndicator = NO;
    self.backGScrollView.bounces = YES;
    self.backGScrollView.contentSize = CGSizeMake(0, mainScreenheight + 64);
    [self.view addSubview:self.backGScrollView];
    
     _bg.backgroundColor = Nav_backgroud;
    scrollPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    [self.view addSubview:scrollPanel];
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = mainScreenWidth;
    myScrollView.contentSize = contentSize;
    self.img0.userInteractionEnabled = YES;
    self.img0.clipsToBounds = YES;
    self.img0.contentMode = UIViewContentModeScaleAspectFill;
    self.img1.userInteractionEnabled = YES;
    self.img1.clipsToBounds = YES;
    self.img1.contentMode = UIViewContentModeScaleAspectFill;
    self.img2.userInteractionEnabled = YES;
    self.img2.clipsToBounds = YES;
    self.img2.contentMode = UIViewContentModeScaleAspectFill;
    self.img3.userInteractionEnabled = YES;
    self.img3.clipsToBounds = YES;
    self.img3.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img0_tap:)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img1_tap:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img2_tap:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img3_tap:)];
    [self.img0 addGestureRecognizer:tap0];
    [self.img1 addGestureRecognizer:tap1];
    [self.img2 addGestureRecognizer:tap2];
    [self.img3 addGestureRecognizer:tap3];
    imgArray = [[NSMutableArray alloc] initWithCapacity:4];
    [self showPicture];
    self.yearArray = [[NSMutableArray alloc] init];
    self.monthArray = [[NSMutableArray alloc] init];
    self.dayArray = [[NSMutableArray alloc] init];
    self.hourArray = [[NSMutableArray alloc] init];
    self.minuteArray = [[NSMutableArray alloc] init];
    _one2ten = [[NSArray alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09", nil];
    for (NSUInteger i = startYear; i<= endYear; i++) {
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
    self.contentTextView.delegate  = self;
    self.titleLabel.delegate = self;
    // 存放表单数据的dic
    self.postDic = [[NSMutableDictionary alloc] init];
//    self.contentView.clipsToBounds = YES;
//    self.contentView.layer.cornerRadius = Radius;
//    self.contentView.frame = CGRectMake(0, 10, mainScreenWidth, 40);
    [self.backGScrollView addSubview:self.contentView];
//    self.skillView.clipsToBounds=YES;
//    self.skillView.layer.cornerRadius=Radius;
//    self.skillView.frame = CGRectMake(0, 60, mainScreenWidth, 142);
    [self.backGScrollView addSubview:self.skillView];
//    self.skillInfo.clipsToBounds = YES;
//    self.skillInfo.layer.cornerRadius = Radius;
//    self.skillInfo.frame = CGRectMake(0, 212, mainScreenWidth, 157);
    [self.backGScrollView addSubview:self.skillInfo];
    
    [self.backGScrollView addSubview:self.bottomRelease];
    [self.backGScrollView addSubview:self.bottomShangjin];
    [self.backGScrollView addSubview:self.bottomTD];
    [self.backGScrollView addSubview:self.releaseBtn];
    /*
    if (self.task) {
        CGRect rectFrame = self.skillInfo.frame;
        rectFrame.size.height = rectFrame.size.height - 40;
        self.skillInfo.frame = rectFrame;
        CGRect switchFrame = self.switchSecret.frame;
        switchFrame.origin.y = switchFrame.origin.y - 40;
        self.switchSecret.frame = switchFrame;
        CGRect bottomReleaseFrame = self.bottomRelease.frame;
        bottomReleaseFrame.origin.y = bottomReleaseFrame.origin.y - 40;
        self.bottomRelease.frame = bottomReleaseFrame;
        CGRect rectShangjinFrame  =   self.bottomShangjin.frame;
        rectShangjinFrame.origin.y = rectShangjinFrame.origin.y - 40;
        self.bottomShangjin.frame = rectShangjinFrame;
        CGRect rectBorttonTdFrame = self.bottomTD.frame;
        rectBorttonTdFrame.origin.y = rectBorttonTdFrame.origin.y - 40;
        self.bottomTD.frame = rectBorttonTdFrame;
        
    }
    */
    
    
    // 初始情况下，默认为定向公开任务
    [self.postDic setObject:@"0" forKey:@"isprivate"];
    [self.switchSecret setSelected:YES];
    
    // 修改定向任务
    if ( self.task ) {
        self.pageTitle.text = @"修改任务";
        self.submitLabel.text = @"提交";
        
        _skillLabel.text = [self.skillDic objectForKey:@"skill"];
        _priceLabel.text = [NSString stringWithFormat:@"%@元/%@",[self.skillDic objectForKey:@"price"],[self.skillDic objectForKey:@"priceunit"]];
        
        [self.postDic setObject:[self.task objectForKey:@"tid"] forKey:@"tid"];
        [self.postDic setObject:[self.task objectForKey:@"bounty"] forKey:@"bounty"];
        [self.postDic setObject:[self.task objectForKey:@"description"] forKey:@"description"];
        [self.postDic setObject:[self.task objectForKey:@"trade_dateline"] forKey:@"trade_dateline"];
        [self.postDic setObject:[self.task objectForKey:@"title"] forKey:@"title"];
        
        if ( [[self.task objectForKey:@"type"] isEqualToString:@"2"] ) {
            [self.switchSecret setSelected:NO];
        }else{
            [self.switchSecret setSelected:YES];
        }
        
        _titleLabel.text=[NSString stringWithFormat:@"%@",[self.task objectForKey:@"title"]];
        _contentTextView.text = [self.task objectForKey:@"description"];
        _contentLabel.hidden = YES;
        
        self.setTimeLabel.hidden = YES;
        self.setTimeImg.hidden = YES;
        self.setTimeAfter.hidden = NO;
        _setTimeAfter.text = [self.task objectForKey:@"trade_dateline"];
        
        self.addGoldLabel.text=@"已添加赏金:";
        self.addGoldImg.hidden = YES;
        _addGoldAfter.text = [NSString stringWithFormat:@"￥%@",[self.task objectForKey:@"bounty"]];
        
        // 隐藏添加图片的那行
        
    }else{
        NSDictionary* skillDic = [self.skillDic objectForKey:@"info"];
        _skillLabel.text = [skillDic objectForKey:@"skill"];
        [self.postDic setObject:[skillDic objectForKey:@"sid"] forKey:@"showid"];
        // 初始情况下，默认为公开任务
        [self.postDic setObject:@"0" forKey:@"isprivate"];
        
        _titleLabel.text=[NSString stringWithFormat:@"我需要“%@”",_skillLabel.text];
        NSString* priceStr=[NSString stringWithFormat:@"%@元/%@",[skillDic objectForKey:@"price"],[skillDic objectForKey:@"priceunit"]];
        _priceLabel.text=priceStr;
        CGSize priceSize=[priceStr sizeWithFont:_priceLabel.font];
        CGRect frame1=_priceLabel.frame;
        frame1.size.width=priceSize.width;
        frame1.origin.x = mainScreenWidth - 10 -priceSize.width;
        _priceLabel.frame=frame1;
        CGRect frame2=_circleImg.frame;
        frame2.origin.x=frame1.origin.x-25;
        _circleImg.frame=frame2;
       self.saleLabel.frame = frame2;
    }
    
    /***************************** 监听 ******************************/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GHUNTERADDGOLD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGoldOK:) name:GHUNTERADDGOLD object:nil];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tap.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
    [self footview];
    
    balanceInt = 0;
    self.gold.delegate = self;
    [self.gold becomeFirstResponder];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyBoardHeight = keyboardRect.size.height;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}


-(void)footview
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [ghunterRequester postwithDelegate:self withUrl:URL_GET_MY_ACCOUNT withUserInfo:REQUEST_FOR_MY_ACCOUNT withDictionary:nil];
}

-(void)tap:(UITapGestureRecognizer*)sender
{
    [_contentTextView resignFirstResponder];
    [_titleLabel resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GHUNTERADDGOLD object:nil];
}
#pragma mark - ASIHttprequest
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
            tmpBalanceStr = balance;
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }
    
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_BUY_SKILL]){
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            [self clearConfirmed];
            [self.postDic removeAllObjects];
            ghuntertaskViewController *skill = [[ghuntertaskViewController alloc] init];
            skill.tid = [dic objectForKey:@"tid"];
            skill.callBackBlock = ^{
                [self.navigationController popViewControllerAnimated:NO];
            };
            [self.navigationController pushViewController:skill animated:YES];
        } else if([dic objectForKey:@"msg"]){
            [ProgressHUD show:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }else if([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_UPDATE_ORIENTTASK]){
        // 修改任务成功
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ProgressHUD show:[dic objectForKey:@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
            
            // 通知刷新任务详情页
            NSNotification *notification = [NSNotification notificationWithName:@"update_task_succeed" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
        } else if([dic objectForKey:@"msg"]){
            [ProgressHUD show:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self endLoad];

    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:HTTPREQUEST_ERROR waitUntilDone:false];
}
#pragma mark - Custom Methods

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
    self.loadingView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cleanBtn:(UIButton *)sender {
    if ( [[[self.contentTextView text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 ) {
        // 去掉空字符串后的任务详情不为空
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定取消本次技能购买吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [actionSheet showInView:self.view];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.task) {
        if (!updateParamsDic) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        if (buttonIndex == 0) {
            // 取消购买
            NSString *url = [NSString stringWithFormat:@"%@?tid=%@", URL_UPDATE_ORIENTTASK, [self.task objectForKey:@"tid"]];
            [self startLoad];
            [ghunterRequester postwithDelegate:self withUrl:url withUserInfo:REQUEST_FOR_UPDATE_ORIENTTASK withDictionary:updateParamsDic];
        }else if (buttonIndex == 1){
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
    }else{
        if (buttonIndex == 0) {
            // 取消购买
            [self.navigationController popViewControllerAnimated:YES];
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }else if (buttonIndex == 1){
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
    }
}

- (void)clearConfirmed{
    [self.titleLabel setText:@""];
    [self.contentTextView setText:@""];
    self.contentLabel.hidden = NO;
    self.setTimeLabel.hidden = NO;
    self.setTimeImg.hidden = NO;
    self.setTimeAfter.hidden = YES;
    self.addGoldLabel.hidden = NO;
    self.addGoldImg.hidden = NO;
    self.addGoldAfter.hidden = YES;
    self.addPicLabel.hidden = NO;
    [imgArray removeAllObjects];
    [self showPicture];
}

#pragma mark --- 发布 ---
// 发布任务
- (IBAction)releaseBtn:(UIButton *)sender {
    [self.titleLabel endEditing:YES];
    [self.contentTextView endEditing:YES];
    
    // stringByTrimmingCharactersInSet 用于去除空格
    if([[self.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        [ghunterRequester showTip:@"请设置任务标题"];
        return;
    }
    if([[self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0){
        [ghunterRequester showTip:@"请输入任务详情"];
        return;
    }
    if(![self.postDic objectForKey:@"bounty"]) {
        [ghunterRequester showTip:@"请输入任务赏金"];
        return;
    }
    if(![self.postDic objectForKey:@"trade_dateline"]) {
        [ghunterRequester showTip:@"请设置任务截止时间"];
        return;
    }
    
    [self.postDic setObject:self.titleLabel.text forKey:@"title"];
    [self.postDic setObject:self.contentTextView.text forKey:@"description"];
    [self.postDic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
    [self.postDic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
    
    if (self.task) {
        // 修改定向任务提交参数
        updateParamsDic = [[NSMutableDictionary alloc] init];
        
        BOOL isupdate = NO;
        if ( ![[self.postDic objectForKey:@"title"] isEqualToString:[self.task objectForKey:@"title"]] ) {
            [updateParamsDic setObject:[self.postDic objectForKey:@"title"] forKey:@"title"];
            
            isupdate = YES;
        }
        if ( ![[self.postDic objectForKey:@"description"] isEqualToString:[self.task objectForKey:@"titdescriptionle"]] ) {
            [updateParamsDic setObject:[self.postDic objectForKey:@"description"] forKey:@"description"];
            
            isupdate = YES;
        }
        if ( ![[self.postDic objectForKey:@"trade_dateline"] isEqualToString:[self.task objectForKey:@"trade_dateline"]] ) {
            [updateParamsDic setObject:[self.postDic objectForKey:@"trade_dateline"] forKey:@"trade_dateline"];
            
            isupdate = YES;
        }
        if ( ![[self.postDic objectForKey:@"bounty"] isEqualToString:[self.task objectForKey:@"bounty"]] ) {
            double add_bounty = [[self.postDic objectForKey:@"bounty"] doubleValue] - [[self.task objectForKey:@"bounty"] doubleValue];
            [updateParamsDic setObject:[NSString stringWithFormat:@"%f", add_bounty] forKey:@"added_bounty"];
            
            isupdate = YES;
        }
        if ( ![[self.postDic objectForKey:@"isprivate"] isEqualToString:[self.task objectForKey:@"isprivate"]] ) {
            [updateParamsDic setObject:[self.postDic objectForKey:@"isprivate"] forKey:@"isprivate"];
            
            isupdate = YES;
        }
        if (!isupdate) {
            [ProgressHUD show:@"没有任何修改"];
            return;
        }
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定修改任务吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [actionSheet showInView:self.view];
        // 修改定向任务结束
        return;
    }
    
    // 发布定向任务
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.postDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:jsonString forKey:@"task"];
    NSURL *url = [NSURL URLWithString:URL_BUY_SKILL];
    
    //创建http请求
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [request setRequestMethod:HTTP_METHOD_POST];
    [request setPostValue:API_TOKEN_NUM forKey:API_TOKEN];
    for (NSUInteger i = 0; i < [imgArray count]; i++) {
        NSData* imageData=UIImageJPEGRepresentation([imgArray objectAtIndex:i], 0.5);
        [request addData:imageData withFileName:[NSString stringWithFormat:@"photo%zd.jpg", i] andContentType:@"image/jpg" forKey:@"images[]"];
    }
    [request setPostValue:jsonString forKey:@"task"];
    if(imgondar_islogin) {
        [request setPostValue:[ghunterRequester getApi_session_id] forKey:@"api_session_id"];
    }
    //上传进度委托
    request.uploadProgressDelegate=self;
    request.showAccurateProgress=YES;
    [request setDelegate:self];
    request.userInfo = [NSDictionary dictionaryWithObject:REQUEST_FOR_BUY_SKILL forKey:REQUEST_TYPE];
    
    [self startLoad];
    [request startAsynchronous];
}
- (IBAction)dateBtn:(UIButton *)sender {
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
        self.timeAlert = [[UIAlertView alloc] initWithTitle:@"任务截止时间设置为1小时后到20天之内!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [ageAlert dismissAnimated:YES];
        [self performSelector:@selector(timerAlertShow) withObject:nil afterDelay:0.3];
    }
    else {
        [ageAlert dismissAnimated:YES];
        [self.setTimeAfter setText:self.date];
        [self.postDic setObject:self.date forKey:@"trade_dateline"];
    }
}
- (void)timerAlertShow {
    [self.timeAlert show];
}

- (IBAction)addGold:(UIButton *)sender {
    
    ghunterAddGoldViewController *ghunterAddGold = [[ghunterAddGoldViewController alloc] init];
    ghunterAddGold.added_bounty = 0;
    ghunterAddGold.type = 0;

    self.added_bounty = 0;
    self.type = 0;
    if (self.task) {
        // 修改定向任务
        self.price = [self.skillDic objectForKey:@"price"];
    }else{
        // 购买技能
        NSDictionary* skillDic = [self.skillDic objectForKey:@"info"];
        self.price = [skillDic objectForKey:@"price"];
    }
//    [self.navigationController pushViewController:ghunterAddGold animated:YES];
    
    
    [self popGoldView];
    
}

#pragma mark --- 添加赏金弹框
-(void)popGoldView
{
    pictureAlert = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"addGoldSkill" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter.backgroundColor = [UIColor yellowColor];
    taskFilter = [nibs objectAtIndex:0];
    
    CGSize width = CGSizeMake(self.view.frame.size.width,taskFilter.frame.size.height);
    CGRect  cellframe = taskFilter.frame;
    cellframe.size.width = width.width-20;
    taskFilter.frame = cellframe;
    
    CGRect taskfilterFrame = taskFilter.frame;
    
    pictureAlert.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height), taskfilterFrame.size.width, taskfilterFrame.size.height);
    pictureAlert.showView = taskFilter;
    
    UIButton *addGold = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *cancelGold = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *determine = (UIButton *)[taskFilter viewWithTag:3];
    UITextField * goldTF = (UITextField *)[taskFilter viewWithTag:7];
    UILabel * balanceLb = (UILabel *)[taskFilter viewWithTag:8];
    UIView * bgview = (UIView *)[taskFilter viewWithTag:15];
    
    
    
    
    if(self.price.length!=0)
    {
        NSString *str = [NSString stringWithFormat:@"赏金不能低于标价：%@元",self.price];
        goldTF.placeholder=str;
    }
    goldTF.keyboardType = UIKeyboardTypeNumberPad;
    goldTF.returnKeyType = UIReturnKeyDone;
    goldTF.delegate = self;
    goldTF.tag = 100;
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
    UITextField * goldTF = (UITextField *)[pictureAlert viewWithTag:100];
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
    }
    
    [pictureAlert dismissAnimated:YES];
}


- (void)addGoldOK:(NSNotification *)notification{
    NSDictionary *dic = (NSDictionary *)[notification object];
    self.addGoldLabel.text=@"已添加赏金:";
    self.addGoldImg.hidden = YES;
    NSString *gold = [dic objectForKey:@"gold"];
    self.addGoldAfter.hidden = NO;
    [self.addGoldAfter setText:[NSString stringWithFormat:@"￥%@",gold]];
    [self.postDic setObject:gold forKey:@"bounty"];
}

- (void)addPicture:(NSInteger)sender {
    [self.view endEditing:YES];
    if(sender == 0) {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = (4 - [imgArray count]);
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        [self presentViewController:picker animated:YES completion:NULL];
    } else if (sender == 1) {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setAllowsEditing:YES];
        [imgPicker setDelegate:self];
        [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
    }
}
- (void)showPicture {
    if([imgArray count] == 0) {
        [self.img0 setImage:[UIImage imageNamed:@"add_picture"]];
        self.img1.image = nil;
        self.img2.image = nil;
        self.img3.image = nil;
        self.addPicLabel.hidden = NO;
    } else if ([imgArray count] == 1) {
        [self.img0 setImage:(UIImage *)[imgArray objectAtIndex:0]];
        [self.img1 setImage:[UIImage imageNamed:@"add_picture"]];
        self.img2.image = nil;
        self.img3.image = nil;
    } else if ([imgArray count] == 2) {
        [self.img0 setImage:(UIImage *)[imgArray objectAtIndex:0]];
        [self.img1 setImage:(UIImage *)[imgArray objectAtIndex:1]];
        [self.img2 setImage:[UIImage imageNamed:@"add_picture"]];
        self.img3.image = nil;
    } else if ([imgArray count] == 3) {
        [self.img0 setImage:(UIImage *)[imgArray objectAtIndex:0]];
        [self.img1 setImage:(UIImage *)[imgArray objectAtIndex:1]];
        [self.img2 setImage:(UIImage *)[imgArray objectAtIndex:2]];
        [self.img3 setImage:[UIImage imageNamed:@"add_picture"]];
    } else if ([imgArray count] == 4) {
        [self.img0 setImage:(UIImage *)[imgArray objectAtIndex:0]];
        [self.img1 setImage:(UIImage *)[imgArray objectAtIndex:1]];
        [self.img2 setImage:(UIImage *)[imgArray objectAtIndex:2]];
        [self.img3 setImage:(UIImage *)[imgArray objectAtIndex:3]];
    }
}
- (void)setImages:(NSArray *)images;
{
    for (UIImageView *imageView in self.checkmarkImageViews) {
        [imageView removeFromSuperview];
    }
    self.selectedIndexes = [NSMutableArray array];
    for (NSUInteger i = 0; i < [imgArray count]; i++) {
        NSNumber *path = @(i);
        [self.selectedIndexes addObject:path];
    }
    self.checkmarkImageViews = [NSMutableArray array];
    for (NSUInteger i = 0;i < [imgArray count];i++) {
        UIImage *emptyCheckmark = [UIImage imageNamed:@"define_tag"];
        UIImageView *checkmarkView = [[UIImageView alloc] initWithImage:emptyCheckmark];
        checkmarkView.frame = CGRectMake((i + 1) * mainScreenWidth - 50, 40, 30, 30);
        [myScrollView addSubview:checkmarkView];
        UIButton *select = [[UIButton alloc] initWithFrame:CGRectMake(checkmarkView.frame.origin.x - 20, checkmarkView.frame.origin.y - 20, checkmarkView.frame.size.width + 40, checkmarkView.frame.size.height + 40)];
        [select addTarget:self action:@selector(imageViewTapped:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:select];
        [self.checkmarkImageViews addObject:checkmarkView];
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        //        [checkmarkView addGestureRecognizer:tap];
    }
}

- (void)imageViewTapped:(id)sender;
{
    NSUInteger index = [imgArray count] - 1 - currentIndex;
    NSNumber *path = @(index);
    if ([self.selectedIndexes containsObject:path]) {
        [self.selectedIndexes removeObject:path];
        UIImage *emptyCheckmark = [UIImage imageNamed:@"radio_normal"];
        UIImageView *checkmarkView = [self.checkmarkImageViews objectAtIndex:currentIndex];
        [checkmarkView setImage:emptyCheckmark];
        
    } else {
        [self.selectedIndexes addObject:path];
        UIImage *fullCheckmark = [UIImage imageNamed:@"define_tag"];
        UIImageView *checkmarkView = [self.checkmarkImageViews objectAtIndex:currentIndex];
        [checkmarkView setImage:fullCheckmark];
    }
}

- (void)img0_tap:(UITapGestureRecognizer *)sender {
    if([imgArray count] == 0) {
        [self showPictureSelection];
    } else {
        //        [SJAvatarBrowser showImage:self.img0];
        CGSize scrollSize = myScrollView.contentSize;
        scrollSize.width = mainScreenWidth * [imgArray count];
        myScrollView.contentSize = scrollSize;
        [self tappedWithObject:sender.view];
        [self setImages:imgArray];
    }
}

- (void)img1_tap:(UITapGestureRecognizer *)sender {
    if ([imgArray count] == 0) {
        return;
    } else if ([imgArray count] == 1) {
        [self showPictureSelection];
    } else {
        //        [SJAvatarBrowser showImage:self.img1];
        CGSize scrollSize = myScrollView.contentSize;
        scrollSize.width = mainScreenWidth * [imgArray count];
        myScrollView.contentSize = scrollSize;
        [self tappedWithObject:sender.view];
        [self setImages:imgArray];
    }
}

- (void)img2_tap:(UITapGestureRecognizer *)sender {
    if ([imgArray count] == 0 || [imgArray count] == 1) {
        return;
    } else if ([imgArray count] == 2) {
        [self showPictureSelection];
    } else {
        //        [SJAvatarBrowser showImage:self.img2];
        CGSize scrollSize = myScrollView.contentSize;
        scrollSize.width = mainScreenWidth * [imgArray count];
        myScrollView.contentSize = scrollSize;
        [self tappedWithObject:sender.view];
        [self setImages:imgArray];
    }
}

- (void)img3_tap:(UITapGestureRecognizer *)sender {
    if ([imgArray count] == 0 || [imgArray count] == 1 || [imgArray count] == 2) {
        return;
    } else if ([imgArray count] == 3) {
        [self showPictureSelection];
    } else {
        //        [SJAvatarBrowser showImage:self.img3];
        CGSize scrollSize = myScrollView.contentSize;
        scrollSize.width = mainScreenWidth * [imgArray count];
        myScrollView.contentSize = scrollSize;
        [self tappedWithObject:sender.view];
        [self setImages:imgArray];
    }
}
- (void)showPictureSelection {
    [self.view endEditing:YES];
    pictureAlert = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"pictureView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    [pictureAlert setCornerRadius:8.0];
    CGRect taskfilterFrame = taskFilter.frame;
    pictureAlert.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height - 10), taskfilterFrame.size.width, taskfilterFrame.size.height);
    pictureAlert.showView = taskFilter;
    UIButton *local = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *camera = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *cancel = (UIButton *)[taskFilter viewWithTag:3];
    [local addTarget:self action:@selector(local_pic) forControlEvents:UIControlEventTouchUpInside];
    [camera addTarget:self action:@selector(camera_pic) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(cancel_pic) forControlEvents:UIControlEventTouchUpInside];
    pictureAlert.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    [pictureAlert show];
}

- (void)local_pic {
    [self cancel_pic];
    [self addPicture:0];
}

- (void)camera_pic {
    [self cancel_pic];
    [self addPicture:1];
}

- (void)cancel_pic {
    [pictureAlert dismissAnimated:YES];
}
#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView == self.timeAlert) {
        if(buttonIndex == 1) {
            self.setTimeLabel.hidden = YES;
            self.setTimeImg.hidden = YES;
            self.setTimeAfter.hidden = NO;
            [self.setTimeAfter setText:self.date];
            [self.postDic setObject:self.date forKey:@"trade_dateline"];
            [ageAlert dismissAnimated:YES];
        } else if (buttonIndex == 0) {
            [ageAlert dismissAnimated:YES];
        }
    }
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            
            [pictureAlert dismissAnimated:YES];
            [self.gold endEditing:YES];
            ghunterRechargeViewController *ghunterRechargeView = [[ghunterRechargeViewController alloc] init];
            [self.navigationController pushViewController:ghunterRechargeView animated:YES];
        }
    }
}

#pragma mark - UITextview delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if(range.location > 200) return NO;
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(self.contentTextView.text.length != 0){
        self.contentLabel.hidden = YES;
    }else{
        self.contentLabel.hidden = NO;
    }
}
#pragma mark - UITextField delegate
//- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
//    
//    return YES;
//}

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
    goldNumStr = textField.text;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.tag == 7) {
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
    
    if (range.location > 20)
        return NO; // return NO to not change text
    
    return YES;
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
        default:
            break;
    }
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (NSInteger i = 0; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [imgArray addObject:tempImg];
    }
    [self showPicture];
    if([imgArray count] > 0) {
        self.addPicLabel.text=@"已添加图片:";
    }
}

#pragma mark - UIImagePicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [imgArray addObject:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self showPicture];
    if([imgArray count] > 0) {
        self.addPicLabel.text=@"已添加图片:";
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}
#pragma mark - custom method
- (void) addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (NSInteger i = (4 - [imgArray count]); i <= 3; i++)
    {
        if ((i + [imgArray count] - 4) == currentIndex)
        {
            continue;
        }
        UIImageView *tmpView = (UIImageView *)[self.view viewWithTag:(10 + i)];
        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
        
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){(i + [imgArray count] - 4) * myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image];
        [myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        [tmpImgScrollView setAnimationRect];
    }
}

- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}
#pragma mark - custom delegate
- (void) tappedWithObject:(id)sender
{
    NSNotification *notification = [NSNotification notificationWithName:@"hide_tab" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
    [self.view bringSubviewToFront:scrollPanel];
    [UIView animateWithDuration:0.5 animations:^{
        scrollPanel.alpha = 1.0;
    }];
    UIImageView *tmpView = sender;
    currentIndex = [imgArray count] - 1 + (tmpView.tag - 13);
    
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
    
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex*mainScreenWidth;
    myScrollView.contentOffset = contentOffset;
    //添加
    [self addSubImgView];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}

- (void) tapImageViewTappedWithObject:(id)sender
{
    
NSMutableArray *tmp = [imgArray mutableCopy];
    [imgArray removeAllObjects];
    for (NSInteger i = 0; i < [self.selectedIndexes count]; i++) {
        NSNumber *num = [self.selectedIndexes objectAtIndex:i];
        [imgArray addObject:[tmp objectAtIndex:[num integerValue]]];
    }
    [self showPicture];
    ImgScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
        
        // TODO 这里有Bug
        if (currentIndex>=0 && currentIndex<[imgArray count]) {
            UIImageView *checkmarkView = [self.checkmarkImageViews objectAtIndex:currentIndex];
            checkmarkView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
    }];
    
    NSNotification *notification = [NSNotification notificationWithName:@"show_tab" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
}

#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    //currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (scrollView.contentOffset.x == 0) {
        currentIndex = 0;
    }
    if (scrollView.contentOffset.x == scrollView.frame.size.width) {
        currentIndex = 1;
    }
    if (scrollView.contentOffset.x == scrollView.frame.size.width *2) {
        currentIndex = 2;
    }
    if (scrollView.contentOffset.x == scrollView.frame.size.width *3) {
        currentIndex = 3;
    }
   
}

- (IBAction)secretSwitch:(UISwitch *)sender {
    BOOL isButtonOn = [sender isOn];
    if (isButtonOn) {
        _secretLabel.text = @"3、当前状态为公开，发布后所有人可见";
        _labelTaskStatus.text = @"任务状态：公开";
        [self.postDic setObject:@"0" forKey:@"isprivate"];
    }else {
        _secretLabel.text = @"3、当前状态为私密，仅有您和技能主人可见";
        _labelTaskStatus.text = @"任务状态：私密";
        [self.postDic setObject:@"1" forKey:@"isprivate"];
    }
}
@end