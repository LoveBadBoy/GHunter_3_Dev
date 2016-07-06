
#import "ghunterReleaseViewController.h"
#import "ghunterTabViewController.h"

@interface ghunterReleaseViewController ()
@property (strong, nonatomic) IBOutlet UITextField *taskTitle;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (strong, nonatomic) NSMutableDictionary *postDic;
@property (strong, nonatomic) IBOutlet UILabel *addGoldLabel;
@property (strong, nonatomic) IBOutlet UIImageView *addGoldImg;
@property (strong, nonatomic) IBOutlet UILabel *addGoldAfter;

@property (strong, nonatomic) IBOutlet UILabel *addCatalogLabel;
@property (strong, nonatomic) IBOutlet UIImageView *addCatalogImg;
//@property (strong, nonatomic) IBOutlet UILabel *addCatalogNameAfter;
@property (strong, nonatomic) IBOutlet UILabel *addCatalogNameAfter;


@property (strong, nonatomic) IBOutlet UIImageView *addCatalogImgAfter;
@property (strong, nonatomic) IBOutlet UILabel *setTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *setTimeImg;
@property (strong, nonatomic) IBOutlet UILabel *setTimeAfter;
@property (weak, nonatomic) IBOutlet UIView *taskContent;
@property (weak, nonatomic) IBOutlet UIView *taskInfo;
@property (strong, nonatomic) IBOutlet UILabel *addPicLabel;
@property (retain, nonatomic) UIAlertView *timeAlert;
@property (retain, nonatomic) NSString *date;
@property(nonatomic,retain)UIPickerView *pickerView;
@property(nonatomic,retain)NSArray *one2ten;
@property(nonatomic,retain)NSMutableArray *yearArray;
@property(nonatomic,retain)NSMutableArray *monthArray;
@property(nonatomic,retain)NSMutableArray *dayArray;
@property(nonatomic,retain)NSMutableArray *hourArray;
@property(nonatomic,retain)NSMutableArray *minuteArray;
@property (strong, nonatomic) IBOutlet UIImageView *img0;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (nonatomic, strong) NSMutableArray *selectedIndexes;
@property (nonatomic, strong) NSMutableArray *checkmarkImageViews;
// @property(nonatomic,assign)BOOL releaseNow;

@property (strong, nonatomic) IBOutlet UIView *bg;


@property (weak, nonatomic) IBOutlet UIButton *releaseTask;

// @好友
- (IBAction)followHunterBtn:(id)sender;
// 分享赏金
- (IBAction)shareGold:(id)sender;


@end

@implementation ghunterReleaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)textss:(NSNotification *)text{
    self.strtext = text.userInfo[@"textOne"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textss:) name:@"textss" object:nil];
    
    _bg.backgroundColor = Nav_backgroud;
    _bg.frame = CGRectMake(0, 0, mainScreenWidth, 64);
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    // 背景
    UIScrollView * backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64)];
    [self.view addSubview:backScrollView];
    backScrollView.contentSize = CGSizeMake(0, backScrollView.bounds.size.height + 100);
//    backScrollView.bounces = YES;
//    backScrollView.delegate = self;
    backScrollView.delegate = self;
    backScrollView.backgroundColor = RGBCOLOR(235, 235, 235);
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.showsHorizontalScrollIndicator = NO;
    [backScrollView addSubview: self.taskInfo];
    [backScrollView addSubview:self.taskContent];
    [backScrollView addSubview:self.releaseTask];
    
    scrollPanel = [[UIView alloc] initWithFrame:self.view.bounds];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    [self.view addSubview:scrollPanel];

    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
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
    self.img0.contentMode = UIViewContentModeScaleToFill;
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
    self.descriptionText.delegate  = self;
    self.taskTitle.delegate = self;
    self.postDic = [[NSMutableDictionary alloc] init];
    self.taskContent.clipsToBounds = YES;
    
    self.taskContent.frame = CGRectMake(0, 10, mainScreenWidth, self.taskContent.frame.size.height);
    
    self.taskInfo.clipsToBounds = YES;
    self.taskInfo.frame = CGRectMake(0, self.taskContent.frame.origin.y + self.taskContent.frame.size.height + 10, mainScreenWidth, self.taskInfo.frame.size.height);
    

    self.addCatalogImgAfter.clipsToBounds = YES;
    self.addCatalogImgAfter.layer.cornerRadius = self.addCatalogImgAfter.frame.size.height/2.0;
    
    _releaseTask.frame = CGRectMake(10, self.taskInfo.frame.origin.y + self.taskInfo.frame.size.height + 10, mainScreenWidth - 20, _releaseTask.frame.size.height);

    
    
    
    // 默认7天后
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSInteger dis = 7; //前后的天数
    NSDate * nowDate = [NSDate date];
    NSDate *theDate;
    theDate = [nowDate initWithTimeIntervalSinceNow: +(ONE_DAY * dis)];
    NSString *dateString = [dateFormatter stringFromDate:theDate];
    
    [self.postDic setObject:dateString forKey:@"trade_dateline"];
    
    /***************************** 监听 ******************************/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GHUNTERADDGOLD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGoldOK:) name:GHUNTERADDGOLD object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GHUNTERADDCATALOG object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCatalogOK:) name:GHUNTERADDCATALOG object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tap.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tap];
    
    _releaseTask.layer.cornerRadius = 3;
    _releaseTask.alpha = 0.5;
    
    [self footview];
    balanceInt = 0;
    self.gold.delegate = self;
    [self.gold becomeFirstResponder];
    
    
   totalNumStr = [[NSString alloc] init];
   qqZoneStr = [[NSString alloc] init];
   wxCircleStr = [[NSString alloc] init];
   qqFriendStr = [[NSString alloc] init];
   wxFriendStr = [[NSString alloc] init];
   weiboStr = [[NSString alloc] init];
    // 通知
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlantForm:) name:@"PlantForm" object:nil];
}


-(void)tap:(UITapGestureRecognizer*)sender
{
    [_descriptionText resignFirstResponder];
    [_taskTitle resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    if (self.strtext==nil||[self.strtext isEqualToString:@""]) {
        self.lontion.text = [Monitor sharedInstance].addres;
        
    }else{
        self.lontion.text = self.strtext;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if(!imgondar_islogin) {
        
        [_releaseTask setUserInteractionEnabled:NO];
    }
    else {
        [_releaseTask setUserInteractionEnabled:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
//    if (self.releaseNow) {
//        [self callBackBlock]();
//    }
}

- (void)viewDidDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GHUNTERADDGOLD object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GHUNTERADDCATALOG object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PlantForm" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASIHttprequest
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
            balanceInt = [balance floatValue] + self.added_bounty;
            [self.balance setText:[NSString stringWithFormat:@"￥%@",balance]];
            tmpBalanceStr = balance;
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }

    
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_CREATE_TASK]){
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            [self clearConfirmed];
            [self.postDic removeAllObjects];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            // 发送通知，去任务详情页
            NSString *tid = [dic objectForKey:@"tid"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"taskPublishSucceed" object:tid];
        } else {
            [ghunterRequester noMsg];
        }
    }}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self endLoad];
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
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

// 返回按钮
- (IBAction)clear {
    // stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]
    NSUInteger titleLength = [[self.taskTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    NSUInteger desLength = [[self.descriptionText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if (titleLength > 0 || desLength > 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定取消发布任务吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [actionSheet showInView:self.view];
    }else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self clearConfirmed];
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else if (buttonIndex == 1){
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}
- (void)clearConfirmed{
    [self.taskTitle setText:@""];
    [self.descriptionText setText:@""];
    self.descriptionLabel.hidden = NO;
    self.setTimeLabel.hidden = NO;
    self.setTimeImg.hidden = NO;
    self.setTimeAfter.hidden = YES;
    self.addGoldLabel.hidden = NO;
    self.addGoldImg.hidden = NO;
    self.addGoldAfter.hidden = YES;
    self.addCatalogLabel.hidden = NO;
    self.addCatalogImg.hidden = NO;
    self.addCatalogImgAfter.hidden = YES;
    self.addCatalogNameAfter.hidden = YES;
    self.addPicLabel.hidden = NO;
    [imgArray removeAllObjects];
    [self showPicture];
}

#pragma mark --- 发布 ---
- (IBAction)next:(id)sender {
    [self.view endEditing:YES];
    
    NSUInteger titleLength = [[self.taskTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if(titleLength < 5 || titleLength>20)
    {
        [ghunterRequester showTip:@"任务标题在5-20字之间"];
        return;
    }
    NSUInteger desLength = [[self.descriptionText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if(desLength <= 0){
        [ghunterRequester showTip:@"请输入任务详情描述"];
        return;
    }
    if(![self.postDic objectForKey:@"bounty"]) {
        [ghunterRequester showTip:@"请设置任务赏金"];
        return;
    }
    if(![self.postDic objectForKey:@"cid"]) {
        [ghunterRequester showTip:@"请选择任务分类"];
        return;
    }
    
    [self startLoad];
    [self.postDic setObject:self.lontion.text forKey:@"location"];
    [self.postDic setObject:self.taskTitle.text forKey:@"title"];
    [self.postDic setObject:self.descriptionText.text forKey:@"description"];
    [self.postDic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
    [self.postDic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];

    // 添加分享平台参数
    NSMutableDictionary * plantFormDic = [[NSMutableDictionary alloc] init];
    
    [plantFormDic setObject:totalNumStr forKey:@"reward"];
    [plantFormDic setObject:wxCircleStr forKey:@"rw_wxmoments"];
    [plantFormDic setObject:wxFriendStr forKey:@"rw_wechat"];
    [plantFormDic setObject:qqFriendStr forKey:@"rw_qq"];
    [plantFormDic setObject:qqZoneStr forKey:@"rw_qzone"];
    [plantFormDic setObject:weiboStr forKey:@"rw_weibo"];
    //
    NSData * plantJsonData = [NSJSONSerialization dataWithJSONObject:plantFormDic
                                                             options:NSJSONWritingPrettyPrinted
                                                               error:nil];
    NSString * plantJsonString =  [[NSString alloc] initWithData:plantJsonData
                                                        encoding:NSUTF8StringEncoding];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.postDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:jsonString forKey:@"task"];
    [dic setObject:plantJsonString forKey:@"share"];
    NSURL *url = [NSURL URLWithString:URL_CREATE_TASK];
    //创建http请求
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [request setRequestMethod:HTTP_METHOD_POST];
    [request setPostValue:API_TOKEN_NUM forKey:API_TOKEN];
    for (NSUInteger i = 0; i < [imgArray count]; i++) {
        // NSData* imageData = UIImagePNGRepresentation([imgArray objectAtIndex:i]);
        NSData* imageData=UIImageJPEGRepresentation([imgArray objectAtIndex:i], 0.5);
        [request addData:imageData withFileName:[NSString stringWithFormat:@"photo%zd.jpg", i] andContentType:@"image/jpg" forKey:@"images[]"];
    }
    [request setPostValue:jsonString forKey:@"task"];
    [request setPostValue:plantJsonString forKey:@"share"];
    [request setPostValue:[ghunterRequester getApi_session_id] forKey:@"api_session_id"];
    
    //上传进度委托
    request.uploadProgressDelegate=self;
    request.showAccurateProgress=YES;
    [request setDelegate:self];
    request.userInfo = [NSDictionary dictionaryWithObject:REQUEST_FOR_CREATE_TASK forKey:REQUEST_TYPE];
    [request startAsynchronous];
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
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, mainScreenWidth - 20, 160)];
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

- (IBAction)address:(UIButton *)sender {
    ghunteraddresViewController *ttview = [ghunteraddresViewController new];
    [self.navigationController pushViewController:ttview animated:YES];
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
    double timeDiff = [ghunterRequester gettimeIntervalToFuture:[NSString stringWithFormat:@"%@:00", self.date]];
    if (timeDiff < ONE_HOUR || timeDiff > 20 * ONE_DAY) {
        self.timeAlert = [[UIAlertView alloc] initWithTitle:@"任务截止时间设置为1小时后到20天之内!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [ageAlert dismissAnimated:YES];
        [self performSelector:@selector(timerAlertShow) withObject:nil afterDelay:0.3];
    } else {
        self.setTimeImg.hidden = YES;
        self.setTimeAfter.hidden = NO;
        [self.setTimeAfter setText:self.date];
        [self.postDic setObject:self.date forKey:@"trade_dateline"];
        [ageAlert dismissAnimated:YES];
    }
}

- (void)timerAlertShow {
    [self.timeAlert show];
}

- (IBAction)addGold:(id)sender {
    ghunterAddGoldViewController *ghunterAddGold = [[ghunterAddGoldViewController alloc] init];
    ghunterAddGold.added_bounty = 0;
    ghunterAddGold.type = 0;
//    [self.navigationController pushViewController:ghunterAddGold animated:YES];
    
    [self popGoldView];
}

- (void)addGoldOK:(NSNotification *)notification{
    NSDictionary *dic = (NSDictionary *)[notification object];
    self.addGoldLabel.hidden = YES;
    self.addGoldImg.hidden = YES;
    NSString *gold = [dic objectForKey:@"gold"];
    self.addGoldAfter.hidden = NO;
    [self.addGoldAfter setText:[NSString stringWithFormat:@"￥%@",gold]];
    self.addGoldAfter.textAlignment = NSTextAlignmentRight;
    self.addGoldAfter.textColor = RGBA(60, 60, 87, 1);
    [self.postDic setObject:gold forKey:@"bounty"];
}

- (void)addPicture:(NSInteger)sender {
    if(sender == 0) {
        // 本地图片
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = (4 - [imgArray count]);
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = NO;
        picker.delegate = self;
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
        // 拍照上传
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
        self.addPicLabel.hidden = YES;
    } else if ([imgArray count] == 2) {
        [self.img0 setImage:(UIImage *)[imgArray objectAtIndex:0]];
        [self.img1 setImage:(UIImage *)[imgArray objectAtIndex:1]];
        [self.img2 setImage:[UIImage imageNamed:@"add_picture"]];
        self.img3.image = nil;
         self.addPicLabel.hidden = YES;
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
        self.addPicLabel.hidden = YES;
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


// 点击查看大图
- (void)pic_taped:(UITapGestureRecognizer *)sender {
    CGSize scrollSize = myScrollView.contentSize;
    scrollSize.width = mainScreenWidth * [imgArray count];
    myScrollView.contentSize = scrollSize;
    [self tappedWithObject:sender.view];
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

- (IBAction)addCatalog:(id)sender {
    ghunterAddCatalogViewController *ghunterAddCatalog = [[ghunterAddCatalogViewController alloc] init];
    [self.navigationController pushViewController:ghunterAddCatalog animated:YES];
}


- (void)addCatalogOK:(NSNotification *)notification{
    self.addCatalogLabel.hidden = YES;
    self.addCatalogImg.hidden = YES;
    
    NSDictionary *dic = (NSDictionary *)[notification object];
    NSString *cid = [dic objectForKey:@"cid"];
    NSString *title = [dic objectForKey:@"title"];
    NSString *fcid = [dic objectForKey:@"fcid"];
    NSString *imageName = [ghunterRequester getTaskCatalogImg:fcid];
    
    self.addCatalogImgAfter.hidden = NO;
    [self.addCatalogImgAfter setImage:[UIImage imageNamed:imageName]];
   
    self.addCatalogNameAfter.hidden = NO;
    
    [self.addCatalogNameAfter setText:title];
    self.addCatalogNameAfter.textAlignment = NSTextAlignmentRight;
    self.addCatalogNameAfter.textColor = RGBA(60, 60, 87, 1);
    [self.postDic setObject:cid forKey:@"cid"];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView == self.timeAlert) {
        if(buttonIndex == 1) {
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
    // 任务详情最大长度
    if(range.location > TASK_DESCRIPTION_MAX_LENGTH)
        return NO;
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(self.descriptionText.text.length != 0){
        self.descriptionLabel.hidden = YES;
        if(textView.text.length >= 15 && self.taskTitle.text.length >= 5){
            
            _releaseTask.alpha = 1;
        }
    }else{
        self.descriptionLabel.hidden = NO;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView.text.length >= 15 && self.taskTitle.text.length >= 5) {
        
        _releaseTask.alpha = 1;
    }else {
        
        _releaseTask.alpha = 0.5;
    }
    
}


#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    goldNumStr = textField.text;
    return YES;
}


// 键盘开始谈起
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    pictureAlert.frame = CGRectMake(0, - 226, mainScreenWidth, ScreenHeightFull);
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.tag == 101) {
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
    if (self.descriptionText.text.length >= 15 && textField.text.length >= 5) {
        
        _releaseTask.alpha = 1;
    }
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
            }else
                return 28;
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

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (NSUInteger i = 0; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [imgArray addObject:tempImg];
    }
    [self showPicture];
    if([imgArray count] > 0) {
//        self.addPicLabel.hidden = YES;
    }
}

#pragma mark - UIImagePicker delegate
// 成功获得相片还是视频后的回调 UIImagePickerController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // 手动保存拍照到本地
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [imgArray addObject:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self showPicture];
    if([imgArray count] > 0) {
        self.addPicLabel.hidden = YES;
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
    
    for (NSUInteger i = (4 - [imgArray count]); i <= 3; i++)
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
    // NSString *pressedText = [NSString stringWithFormat:@"Selected: %@", [self.selectedIndexes componentsJoinedByString:@", "]];
    // NSLog(@"pressedText:%@",pressedText);
    NSMutableArray *tmp = [imgArray mutableCopy];
    [imgArray removeAllObjects];
    for (NSUInteger i = 0; i < [self.selectedIndexes count]; i++) {
        NSNumber *num = [self.selectedIndexes objectAtIndex:i];
        [imgArray addObject:[tmp objectAtIndex:[num integerValue]]];
    }
    [self showPicture];
    ImgScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
        UIImageView *checkmarkView = [self.checkmarkImageViews objectAtIndex:currentIndex];
        checkmarkView.alpha = 0;
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
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
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
    NSArray * nibs = [[NSArray alloc] init];
   
    nibs = [[NSBundle mainBundle] loadNibNamed:@"addGoldSkill" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter.backgroundColor = [UIColor yellowColor];
    taskFilter = [nibs objectAtIndex:0];
    CGRect taskfilterFrame = taskFilter.frame;
    taskfilterFrame.size.width = mainScreenWidth - 20;
    taskFilter.frame = taskfilterFrame;
    
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
        [ghunterRequester showTip:@"请填写赏金"];
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
        self.addGoldAfter.text = goldNumStr;
        [pictureAlert dismissAnimated:YES];
    }
}

- (void)PlantForm:(NSNotification *) notify{
    
    self.isSetting.text = @"已设置";
    qqZoneStr = notify.userInfo[@"rw_qzone"];
    wxCircleStr = notify.userInfo[@"rw_wxmoments"];
    qqFriendStr = notify.userInfo[@"rw_qq"];
    wxFriendStr = notify.userInfo[@"weichat"];
    weiboStr = notify.userInfo[@"rw_weibo"];
    totalNumStr = notify.userInfo[@"totalNum"];
}

// @好友
- (IBAction)followHunterBtn:(id)sender {
    
    ghunterMyFollowViewController * myFollowVC = [[ghunterMyFollowViewController alloc] init];
    [self.navigationController pushViewController:myFollowVC animated:YES];
}

// 分享赏金
- (IBAction)shareGold:(id)sender {
    
    ghunterShareGoldsViewController * shareGoldsVC = [[ghunterShareGoldsViewController alloc] init];
    shareGoldsVC.totalString = totalNumStr;
    shareGoldsVC.qqZoneString = qqZoneStr;
    shareGoldsVC.qqFriendString = qqFriendStr;
    shareGoldsVC.wxCircleString = wxCircleStr;
    shareGoldsVC.wxFriendString = wxFriendStr;
    shareGoldsVC.weiboString = weiboStr;
    [self.navigationController pushViewController:shareGoldsVC animated:YES];
}




@end