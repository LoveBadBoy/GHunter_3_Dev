//
//  ghunterRegisterThreeViewController.m
//  ghunter
//
//  Created by chensonglu on 14-3-9.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//注册页面-3

#import "ghunterRegisterThreeViewController.h"

@interface ghunterRegisterThreeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bg;
@end

@implementation ghunterRegisterThreeViewController

#pragma mark - UIViewController

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
    // Do any additional setup after loading the view from its nib.
    self.randomTag = [[NSMutableArray alloc] initWithCapacity:10];
    self.tagList = [[AOTagList alloc] initWithFrame:CGRectMake(self.bg.frame.origin.x,
                                                               self.bg.frame.origin.y,
                                                               self.bg.frame.size.width,
                                                               305.0f)];
    self.tagList.backgroundColor = [UIColor clearColor];
    [self.tagList setDelegate:self];
    [self.view addSubview:self.tagList];
    
    NSString *skilltag_time = [ghunterRequester getCacheTimeWithKey:SKILL_TAG_TIME];
    if(!skilltag_time){
        [ghunterRequester getSkillTagWithDelegate:self];
    }else{
        if([ghunterRequester gettimeInterval:skilltag_time] > ONE_DAY){
            [ghunterRequester getSkillTagWithDelegate:self];
        }else{
            [self showSkillTag];
        }
    }
    [self showUserSkills];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}


- (void)showSkillTag{
    skillsArray = (NSArray *)[ghunterRequester getCacheContentWithKey:SKILL_TAG];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(self.bg.frame.origin.x, self.bg.frame.origin.y + self.bg.frame.size.height - 110, mainScreenWidth - 20, 100)];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake((mainScreenWidth - 20) * [skillsArray count], 100);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    for (NSInteger i = 0; i < [skillsArray count]; i++) {
        SkillTag *skillTag = [[SkillTag alloc] initWithFrame:CGRectMake((mainScreenWidth - 20) * i, 0, mainScreenWidth - 20, 100)];
        skillTag.backgroundColor = [UIColor clearColor];
        [skillTag setDelegate:self];
        [scrollView addSubview:skillTag];
        NSDictionary *skill = [skillsArray objectAtIndex:i];
        NSArray *child = [skill objectForKey:@"child"];
        [skillTag addTags:child];
    }
    
    [self.view addSubview:scrollView];
    
    CGFloat pageControlWidth=[skillsArray count]*10.0f+40.f;
    CGFloat pagecontrolHeight=20.0f;
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.view.frame.size.width-pageControlWidth)/2.0,scrollView.frame.origin.y - 15, pageControlWidth, pagecontrolHeight)];
    pageControl.currentPage=0;
    pageControl.numberOfPages=[skillsArray count];
    [self.view addSubview:pageControl];
}

- (IBAction)finish:(id)sender {
    if([self.tagList.tags count] == 1){
        [ghunterRequester showTip:@"至少添加一个技能标签"];
        return;
    }
    if ( [self.tagList.tags count] > 11) {
        [ghunterRequester showTip:@"最多添加10技能标签"];
        return;
    }
    if(self.type == 0){
        // 注册猎人
        [self startLoad];
        NSMutableArray *skillArray = [[NSMutableArray alloc] init];
        for (id tag in self.tagList.tags) {
            if([tag isKindOfClass:[AOTag class]]){
                [skillArray addObject:[tag tTitle]];
            }
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:skillArray
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.hunterName forKey:@"username"];
        if([self.gender isEqualToString:@"0"]){
            [dic setObject:@"1" forKey:@"sex"];
        }else{
            [dic setObject:@"0" forKey:@"sex"];
        }
        [dic setObject:self.birthday forKey:@"birthday"];
        // NSLog(@"birthday:%@",self.birthday);
        [dic setObject:self.school forKey:@"university_id"];
        [dic setObject:self.school_name forKey:@"university_name"];
        [dic setObject:self.avatarStr forKey:@"avatar"];
        [dic setObject:jsonString forKey:@"skills"];
        // 邀请码
        if([self.invitecode length]) {
            [dic setObject:self.invitecode forKey:@"invitecode"];
        }
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:@"latitude"];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:@"longitude"];
        
        NSString *url = URL_USER_REGISTER;
        if (self.is_wxlogin) {
            url = URL_WEIXIN_REGISTER;
            [dic setObject:[self.wxDic objectForKey:@"access_token"] forKey:@"access_token"];
            [dic setObject:[self.wxDic objectForKey:@"openid"] forKey:@"weixin_id"];
            [dic setObject:@"5000000" forKey:@"expiresIn"];
            
            [dic setObject:@"" forKey:@"phone"];
            [dic setObject:@""  forKey:@"password"];
        }else{
            // 不是微信注册，则需要提交手机号和密码
            [dic setObject:self.phone forKey:@"phone"];
            [dic setObject:self.password forKey:@"password"];
        }
        NSLog(@"params == %@", dic);
        [ghunterRequester postwithDelegate:self withUrl:url withUserInfo:REQUEST_FOR_REGISTER withDictionary:dic];
        // 友盟统计
        [MobClick event:UMEVENT_REGISTER];
    }else if (self.type == 1){
        NSMutableArray *skillArray = [[NSMutableArray alloc] init];
        for (id tag in self.tagList.tags) {
            if([tag isKindOfClass:[AOTag class]]){
                [skillArray addObject:[tag tTitle]];
            }
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:skillArray
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:jsonString forKey:@"skills"];
        
        [ghunterRequester postwithDelegate:self withUrl:URL_ADD_SKILLS withUserInfo:REQUEST_FOR_ADD_SKILLS withDictionary:dic];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showUserSkills{
    for (NSString *string in self.tags) {
        NSLog(@"string:%@",string);
        [self.tagList addTag:string];
    }
}

#pragma mark - ASIHttprequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSInteger responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_GET_SKILL_TAG]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester setCacheTime:[ghunterRequester getTimeNow] withKey:SKILL_TAG_TIME];
            [ghunterRequester setCacheContent:[dic objectForKey:@"skills"] withKey:SKILL_TAG];
            [self showSkillTag];
        }else if ([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }else
        if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REGISTER]){
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            // 登录成功了
            imgondar_islogin = YES;
            
            NSString *api_session_id = [dic objectForKey:API_SESSION_ID];
            NSDictionary *account = [dic objectForKey:@"account"];
            [ghunterRequester setApi_session_id:api_session_id];
            [ghunterRequester setUserInfoDic:account];
            [ghunterRequester setPassword:self.password];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSNotification *notification = [NSNotification notificationWithName:@"userinfo_modify" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            
            // 登录成功，重新获取消息数目
            NSNotification *notify = [NSNotification notificationWithName:@"get_unread_count" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notify waitUntilDone:false];
            
            NSString *gender;
            if ([[account objectForKey:@"sex"] isEqualToString:@"0"]) {
                gender = @"female";
            } else {
                gender = @"male";
            }
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            // 注册完不应该提交经纬度，因为这里是0
            // [dic setObject:[account objectForKey:LATITUDE] forKey:@"latitude"];
            // [dic setObject:[account objectForKey:LONGITUDE] forKey:@"longitude"];
            
            [dic setObject:[NSString stringWithFormat:@"iphone%@,%@",[ghunterRequester getUserInfo:UID],gender] forKey:@"pushid"];
           
            // 用通知的方式去修改资料
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didModifyUserProfile" object:dic];
            
             // 设置极光推送标签
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setPushTags" object:nil];
        }else if ([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_ADD_SKILLS]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            NSNotification *notification = [[NSNotification alloc] initWithName:@"user_skills" object:nil userInfo:nil];
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
    [self endLoad];
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
}

#pragma mark - Tag delegate

- (void)tagDidAddTag:(AOTag *)tag
{
    // NSLog(@"count==:%zd",[self.tagList.tags count]);
}

- (void)tagDidRemoveTag:(AOTag *)tag
{
    // NSLog(@"count==:%zd",[self.tagList.tags count]);
}

- (void)tagDidSelectTag:(AOTag *)tag
{
    // NSLog(@"Tag > %@ has been selected", tag);
}

- (void)tagDidEdited:(AOEditTag *)editTag{
    // NSLog(@"Tag > %@ has been selected", editTag);
}

- (void)skilltagDidSelectTag:(SkillName *)tag{
    UILabel *skillLabel = [[tag subviews] objectAtIndex:0];
    [self.tagList addTag:skillLabel.text];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    pageControl.currentPage=page;
}

#pragma mark - UItextfiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
