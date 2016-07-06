//
//  ghunterHomeViewController.m
//  ghunter
//
//  Created by chensonglu on 14-3-13.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//发现页面

#import "ghunterDiscoverViewController.h"
#import "ghuntertaskViewController.h"
#import "ghunterSkillViewController.h"
#import "ghunterTabViewController.h"
#import "QRcodeViewController.h"
#import "UMSocialQQHandler.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"
#import "ghunterMyNotUseDiscountViewController.h"

@interface ghunterDiscoverViewController ()
@property (strong, nonatomic) IBOutlet UIView *searchView;
- (IBAction)searchBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *signInBtn;
- (IBAction)signInBtn:(UIButton *)sender;
@property(strong,nonatomic)NSMutableArray *bannersArr;
@property(strong,nonatomic)CycleScrollView *scrollView;
@property(assign,nonatomic)NSInteger timeCount;
@property(strong,nonatomic)UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger taskfid;
@property (nonatomic, assign) NSInteger skillfid;
@property (nonatomic, strong) UIScrollView *findTaskScroll;

@property (strong, nonatomic) IBOutlet UIView *bg;

@end

@implementation ghunterDiscoverViewController{
    NSInteger skillPage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageNumber:) name:@"pageNum" object:nil];
    
    [self createPageControl];
    _bg.backgroundColor = Nav_backgroud;
    self.searchView.layer.cornerRadius = 3.0;
    self.signInBtn.layer.cornerRadius = 3.0;
    extern NSString *gunread_signreward;
    skillPage = 1;
    self.bannersArr=[[NSMutableArray alloc] init];
    intrestArray = [[NSMutableArray alloc] init];
    hotArray = [[NSMutableArray alloc] init];
    FindTaskArray = [[NSMutableArray alloc] init];
    FindSkillArray = [[NSMutableArray alloc] init];
    
    _findTaskScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 80)];
    pullTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 62, mainScreenWidth, mainScreenheight - 64 - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
    
    pullTable.delegate = self;
    pullTable.dataSource = self;
    pullTable.pullDelegate = self;
    pullTable.showsVerticalScrollIndicator = NO;
    pullTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    pullTable.separatorColor = RGBCOLOR(229, 229, 229);
    pullTable.backgroundColor = RGBCOLOR(235, 235, 235);
//    pullTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pullTable];
    if ([pullTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [pullTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([pullTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [pullTable setLayoutMargins:UIEdgeInsetsZero];
    }
    // 开始加重网络数据
    [self didGetBannderIsloading:YES];
    
    // 注册完毕后，如果还未完善个人资料，则显示此弹框，引导用户去完善个人资料
    if ([[Monitor sharedInstance].alter isEqualToString:@"yes"]) {
        bgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
        bgview.image = [UIImage imageNamed:@"aler"];
        //    bgview.backgroundColor = [UIColor blackColor];
        bgview.userInteractionEnabled = YES;
        //    bgview.alpha=0.5;
        [self.view addSubview:bgview];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgview:)];
        [bgview addGestureRecognizer:singleTap];
        [self.view addSubview:bgview];
        
        UIView *whitevw = [[UIView alloc]initWithFrame:CGRectMake(60, 150, mainScreenWidth-120, 200)];
        whitevw.backgroundColor = [UIColor whiteColor];
        [bgview addSubview:whitevw];
        
        UIImageView * images = [[UIImageView alloc]initWithFrame:CGRectMake(whitevw.frame.size.width/2-25, 30, 50, 50)];
        //    images.backgroundColor = [UIColor redColor];
        images.image = [UIImage imageNamed:@"yellimg"];
        [whitevw addSubview:images];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, whitevw.frame.size.width-60, 20)];
        //    26046990
        label1.text = @"您还未完善个人资料,";
        label1.textColor = [UIColor blackColor];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:11];
        [whitevw addSubview:label1];
        NSMutableAttributedString *str111 = [[NSMutableAttributedString alloc] initWithString:@"完善资料百分之百有现金奖励哦!"];
        
        [str111 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8,5)];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 120, whitevw.frame.size.width-30, 20)];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.attributedText = str111;
        label2.font = [UIFont systemFontOfSize:11];
        [whitevw addSubview:label2];
        //灰色线
        UILabel *line =[[UILabel alloc]initWithFrame:CGRectMake(5, 165, whitevw.frame.size.width-10, 0.5)];
        line.backgroundColor = backgroud_Bg;
        [whitevw addSubview:line];
        
        UIButton *Cancel = [[UIButton alloc]initWithFrame:CGRectMake(20, 170, 60, 25)];
        [Cancel setTitle:@"取消" forState:(UIControlStateNormal)];
        Cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        [Cancel setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [Cancel addTarget:self action:@selector(cancel:) forControlEvents:(UIControlEventTouchUpInside)];
        [whitevw addSubview:Cancel];
        
        UIButton *make = [[UIButton alloc]initWithFrame:CGRectMake(whitevw.frame.size.width-80, 170, 60, 25)];
        [make setTitle:@"确定" forState:(UIControlStateNormal)];
        make.titleLabel.font = [UIFont systemFontOfSize:14];
        [make setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [make addTarget:self action:@selector(make:) forControlEvents:(UIControlEventTouchUpInside)];
        [whitevw addSubview:make];
        UILabel *line2 =[[UILabel alloc]initWithFrame:CGRectMake(whitevw.frame.size.width/2, 175, 0.5, 15)];
        line2.backgroundColor = backgroud_Bg;
        [whitevw addSubview:line2];
    }else{

    }
}

-(void)make:(UIButton *)btn{
    ghunterUserInfoViewController *userinfo = [ghunterUserInfoViewController new];
    Monitor *ale = [Monitor sharedInstance];
    ale.alter = @"no";
    [self.navigationController pushViewController:userinfo animated:YES];
}

-(void)cancel:(UIButton *)btn{
    Monitor *ale = [Monitor sharedInstance];
    ale.alter = @"no";
    [bgview removeFromSuperview];
}

-(void)bgview:(UITapGestureRecognizer *)tap{
    [bgview removeFromSuperview];
}
// 更新UI
-(void)update_sign_ui{
    // 如果用户未登录，显示“签到测人品”
    if (!imgondar_islogin) {
        [self.signInBtn setImage:[UIImage imageNamed:@"icon_sign"] forState:UIControlStateNormal];
        [self.signInBtn setTitleColor:[UIColor colorWithRed:226/255.0 green:61/255.0 blue:0/255.0 alpha:1]  forState:UIControlStateNormal];
        [self.signInBtn setTitle:@"签到" forState:UIControlStateNormal];
    }else{
        // 已登录
        if([gunread_signreward floatValue] > 0)
        {
            // image: mysign_signed
            [self.signInBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.signInBtn setTitleColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1] forState:UIControlStateNormal];
            [self.signInBtn setTitle:[NSString stringWithFormat:@"人品：%.1f",[gunread_signreward floatValue]] forState:UIControlStateNormal];
        }else{
            [self.signInBtn setImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
            [self.signInBtn setTitleColor:[UIColor colorWithRed:226/255.0 green:61/255.0 blue:0/255.0 alpha:1]  forState:UIControlStateNormal];
            [self.signInBtn setTitle:@"签到" forState:UIControlStateNormal];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    ghunterTabViewController *tbvc = (ghunterTabViewController *)self.tabBarController;
    if (!tbvc.didSelectItemOfTabBar) {
        self.tabBarController.tabBar.hidden = YES;
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = mainScreenheight;
        [self.tabBarController.tabBar setFrame:frame];
        [pullTable setFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64)];
    }
    else {
        [pullTable setFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64 - TAB_BAR_HEIGHT)];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    if (!imgondar_islogin) {
        [self.signInBtn setImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
        [self.signInBtn setTitleColor:[UIColor colorWithRed:226/255.0 green:61/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
        [self.signInBtn setTitle:@"签到" forState:UIControlStateNormal];
    }
    
    [self update_sign_ui];
}

- (void)viewDidAppear:(BOOL)animated {
    ghunterTabViewController *tbvc = (ghunterTabViewController *)self.tabBarController;
    if (self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = self.tabBarController.tabBar.frame;
            frame.origin.y = mainScreenheight - TAB_BAR_HEIGHT;
            [self.tabBarController.tabBar setFrame:frame];
        }completion:^(BOOL finished) {
            [pullTable setFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64 - TAB_BAR_HEIGHT)];
        }];
    }
    tbvc.didSelectItemOfTabBar = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods

- (void)iconTaped:(UITapGestureRecognizer *)sender {
    NSInteger tag = sender.view.tag;
    NSDictionary *task = [intrestArray objectAtIndex:tag];
    NSDictionary *user = [task objectForKey:@"owner"];
    ghunterUserCenterViewController *usercenter = [[ghunterUserCenterViewController alloc] init];
    usercenter.uid = [user objectForKey:@"uid"];
    [self.navigationController pushViewController:usercenter animated:YES];
}

- (void)startLoad{
    loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [loadingView startAnimition];
}

- (void)endLoad{
    [loadingView inValidate];
}

- (void)hotTaskTaped:(UITapGestureRecognizer *)sender{
    NSInteger tag = sender.view.tag / 10 - 1;
    NSDictionary *taskDic = [hotArray objectAtIndex:tag];
    ghuntertaskViewController *task = [[ghuntertaskViewController alloc] init];
    task.tid = [taskDic objectForKey:@"tid"];
    task.callBackBlock = ^{};
    [MobClick event:UMEVENT_HOT_TASK];
    [self.navigationController pushViewController:task animated:YES];
}

- (void)findTaskTaped:(UITapGestureRecognizer *)sender{
    NSInteger tag = sender.view.tag - 121;
    NSString * cid = [[FindTaskArray objectAtIndex:tag] objectForKey:@"cid"];
    ghunterFindTaskViewController * findTask = [[ghunterFindTaskViewController alloc] init];
    findTask.taskCid = [cid integerValue];
    findTask.nametitle = [[FindTaskArray objectAtIndex:tag] objectForKey:@"name"];
    
    [self.navigationController pushViewController:findTask animated:YES];
    
}

- (void)findSkillTaped:(UITapGestureRecognizer *)sender{
    
    NSInteger tag = sender.view.tag - 121;
    NSString * cid = [[FindSkillArray objectAtIndex:tag] objectForKey:@"cid"];
    ghunterFindSkillViewController * findSkill = [[ghunterFindSkillViewController alloc] init];
    findSkill.skillCid = [cid integerValue];
    findSkill.nametitle = [[FindSkillArray objectAtIndex:tag] objectForKey:@"name"];
    [self.navigationController pushViewController:findSkill animated:YES];
    
}

#pragma mark - 请求加载网络数据

// 签到
-(void)didCheckinIsloading:(BOOL)isloading{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:URL_CHACKIN params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            gunread_signreward = [result objectForKey:@"reward"];
            signText = [result objectForKey:@"extra"];
            
            [self update_sign_ui];
            [self didShowSignDialogNo];

        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}
-(void)didShowSignAlerView{
    if ( signInView == nil ) {
        signInView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"signInView" owner:self options:nil];
        UIView *signView = [[UIView alloc] init];
        signView = [nibs objectAtIndex:0];
        [signInView setCornerRadius:8.0];
        CGRect signViewFrame = signView.frame;
        signInView.containerFrame = CGRectMake((mainScreenWidth - signViewFrame.size.width) / 2.0, (mainScreenheight - signViewFrame.size.height) / 2.0, signViewFrame.size.width, signViewFrame.size.height);

        UILabel* label = (UILabel*)[signView viewWithTag:10];
        UIButton *determine = (UIButton *)[signView viewWithTag:12];
        // 确定按钮，添加事件
        [determine addTarget:self action:@selector(determineClick) forControlEvents:UIControlEventTouchUpInside];
        UIButton *cancel = (UIButton *)[signView viewWithTag:11];
        // 取消按钮，添加事件
        [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        [AFNetworkTool httpRequestWithUrl:URL_CHACKIN params:nil success:^(NSData *data) {
            
            NSError *error;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if ([[result objectForKey:@"error"]integerValue] == 0) {
                gunread_signreward = [result objectForKey:@"reward"];
                NSString *reward =[result objectForKey:@"reward"];
                label.text =[NSString stringWithFormat:@"今日人品%@,可兑换%@金币",gunread_signreward,reward];
                
            }else{
                [ProgressHUD show:[result objectForKey:@"msg"]];
            }
        

        } fail:^{
            [ProgressHUD show:HTTPREQUEST_ERROR];
            
        }];
        signInView.showView = signView;

        signInView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        signInView.transitionStyle = SIAlertViewTransitionStyleDropDown;
        
        [signInView show];
        [self.signInBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.signInBtn setTitleColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1] forState:UIControlStateNormal];
    }else{
        [signInView show];
    }
}
-(void)determineClick
{
    [signInView dismissAnimated:YES];

    [AFNetworkTool httpRequestWithUrl:URL_COINSHOP_LOGIN params:nil success:^(NSData *data) {
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            NSString *loginurl = [result objectForKey:@"url"];
            CreditWebViewController *web = [[CreditWebViewController alloc]initWithUrlByPresent:loginurl];
            CreditNavigationController *nav = [[CreditNavigationController alloc]initWithRootViewController:web];
            [nav setNavColorStyle:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1]];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
    }];
}
-(void)cancelClick
{
    [signInView dismissAnimated:YES];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

// 获得banner数据
-(void)didGetBannderIsloading:(BOOL)isloading{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:URL_GET_BANNER params:nil success:^(NSData *data) {
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            NSArray* imageArr = [result objectForKey:@"banners"];
            
            [self.bannersArr removeAllObjects];
            [self.bannersArr addObjectsFromArray:imageArr];
            // 全局变量保存签到数据
            // 判断是不是字符串
            if ( [[result objectForKey:@"sign_reward"] isKindOfClass:[NSString class]] ) {
                gunread_signreward = [result objectForKey:@"sign_reward"];
            }else{
                gunread_signreward = [[result objectForKey:@"sign_reward"] stringValue];
            }
            
            [FindTaskArray removeAllObjects];
            NSArray *ftarray = [result objectForKey:@"finds_task"];
            [FindTaskArray addObjectsFromArray:ftarray];
            
            [FindSkillArray removeAllObjects];
            NSArray *fsarray=[result objectForKey:@"finds_skill"];
            [FindSkillArray addObjectsFromArray:fsarray];
            
            // 更新UI
            [pullTable reloadData];
            // 已登录，更新签到UI
            [self update_sign_ui];
            
            // 获取热门任务
            [self endLoad];
            [self didGetHotTaskIsloading:NO];
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}


// 获取最火任务
-(void)didGetHotTaskIsloading:(BOOL)isloading{
    if ([[ghunterRequester getUserInfo:LATITUDE] floatValue] == 0 || [[ghunterRequester getUserInfo:LONGITUDE] floatValue] == 0) {
        [ghunterRequester setUserInfoWithKey:LATITUDE withValue:LOC_DEFAULT_LATITUDE];
        [ghunterRequester setUserInfoWithKey:LONGITUDE withValue:LOC_DEFAULT_LONGITUDE];
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:@"latitude"];
    [parameters setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:@"longitude"];
    
    [AFNetworkTool httpRequestWithUrl:URL_GET_TASK_HOT params:parameters success:^(NSData *data) {
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            [hotArray removeAllObjects];
            NSArray *array = [result valueForKey:@"tasks"];
            [hotArray addObjectsFromArray:array];
            
            // 获取火热技能
            [self endLoad];
            [self didGetHotSkillsIsloading:NO withPage:skillPage];
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}

// 获取热门技能列表
-(void)didGetHotSkillsIsloading:(BOOL )isloading withPage:(NSInteger)p{
    if ([[ghunterRequester getUserInfo:LATITUDE] floatValue] == 0 || [[ghunterRequester getUserInfo:LONGITUDE] floatValue] == 0) {
        [ghunterRequester setUserInfoWithKey:LATITUDE withValue:LOC_DEFAULT_LATITUDE];
        [ghunterRequester setUserInfoWithKey:LONGITUDE withValue:LOC_DEFAULT_LONGITUDE];
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:@"latitude"];
    [parameters setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:@"longitude"];
    [parameters setObject:[NSString stringWithFormat:@"%zd", p] forKey:@"page"];
    [AFNetworkTool httpRequestWithUrl:URL_GET_TASK_INTRESTED params:parameters success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            
            if (p == 1) {
                skillPage = 2;
                
                [intrestArray removeAllObjects];
                NSArray *array = [result valueForKey:@"skillshows"];
                [intrestArray addObjectsFromArray:array];
                [pullTable reloadData];
                
                pullTable.pullTableIsRefreshing = NO;
            }else{
                skillPage++;
                
                NSArray *array = [result valueForKey:@"skillshows"];
                [intrestArray addObjectsFromArray:array];
                [pullTable reloadData];
                
                pullTable.pullTableIsLoadingMore = NO;
            }
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
            pullTable.pullTableIsRefreshing = NO;
            pullTable.pullTableIsLoadingMore = NO;
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
        pullTable.pullTableIsRefreshing = NO;
        pullTable.pullTableIsLoadingMore = NO;
    }];
}



#pragma mark - UITableViewDelegate UITableViewDatasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    if([hotArray count] > 0) {
        if(indexPath.row <= 7) return;
        if([intrestArray count] > 0) {
            ghunterSkillViewController *ghuntertask = [[ghunterSkillViewController alloc] init];
            NSDictionary *task = [intrestArray objectAtIndex:(indexPath.row - 8)];
            ghuntertask.skillid = [task objectForKey:@"sid"];
            ghuntertask.callBackBlock = ^{};
            [self.navigationController pushViewController:ghuntertask animated:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 8;
    if([intrestArray count] > 0) {
        row += [intrestArray count];
    }
    return row;
}

//定义cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ( indexPath.row == 2 ) {
        return 148;
    } else
        return cell.frame.size.height+4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else {
        while ([cell.contentView.subviews lastObject]) {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    // 轮播图
    if (indexPath.row == 0) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"homeHeadCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* placehoderImg=(UIImageView *)[cell viewWithTag:4];
        
        if( self.bannersArr.count ) {
            placehoderImg.hidden = YES;
        }
        
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = placehoderImg.frame.size.height;
        cell.frame = cellFrame;
        
        NSMutableArray *viewsArray = [@[] mutableCopy];
        
        for (int i = 0; i < self.bannersArr.count; ++i) {
            UIImageView *ImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, mainScreenWidth, 140)];
            
            [ImgView sd_setImageWithURL:[self.bannersArr[i] objectForKey:@"poster"]];
            ImgView.clipsToBounds = YES;
            ImgView.contentMode = UIViewContentModeScaleAspectFit;
            [viewsArray addObject:ImgView];
        }
        self.scrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, -20, mainScreenWidth, 140) animationDuration:3];
        [self createPageControl];
        
        self.scrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        self.scrollView.totalPagesCount = ^NSInteger(void){
            return [self.bannersArr count];
        };
        
        self.scrollView.TapActionBlock = ^(NSInteger pageIndex){
            NSDictionary* imgDic = self.bannersArr[pageIndex];
            NSString* dataStr = [imgDic objectForKey:@"data"];
            NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if([[imgDic objectForKey:@"type"] isEqualToString:@"0"])
            {
                NSString *url = [dataDic objectForKey:@"url"];
                NSString *target1 = @"apiadmin.imgondar.com";
                NSString *target2 = @"mob.imgondar.com";
                NSRange range1 = [url rangeOfString:target1];
                NSRange range2 = [url rangeOfString:target2];
                if (range1.length!=0 || range2.length!=0) {
                    NSRange range3 = [url rangeOfString:@"?"];
                    if (range3.length!=0) {
                        url = [url stringByAppendingString:[NSString stringWithFormat:@"&api_token=%@&api_session_id=%@",API_TOKEN_NUM, [ghunterRequester getApi_session_id]]];
                    }else{
                        url = [url stringByAppendingString:[NSString stringWithFormat:@"?api_token=%@&api_session_id=%@", API_TOKEN_NUM, [ghunterRequester getApi_session_id]]];
                    }
                    // 转换中文编码，转成字符
                    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                }
                
                ghunterWebViewController *webView = [[ghunterWebViewController alloc] init];
                webView.webTitle = [NSMutableString stringWithString:APP_NAME];
                webView.urlPassed = [NSMutableString stringWithString:url];
                [self.navigationController pushViewController:webView animated:YES];
            }
            else if([[imgDic objectForKey:@"type"] isEqualToString:@"1"])
            {
                ghuntertaskViewController* taskView = [[ghuntertaskViewController alloc] init];
                taskView.tid=[dataDic objectForKey:@"tid"];
                taskView.callBackBlock = ^{};
                [self.navigationController pushViewController:taskView animated:YES];
            }
            else if([[imgDic objectForKey:@"type"] isEqualToString:@"2"])
            {
                ghunterSkillViewController* taskView = [[ghunterSkillViewController alloc] init];
                taskView.skillid=[dataDic objectForKey:@"showid"];
                taskView.callBackBlock = ^{};
                [self.navigationController pushViewController:taskView animated:YES];
            }
            else if([[imgDic objectForKey:@"type"] isEqualToString:@"3"])
            {
                ghunterUserCenterViewController* userCenter = [[ghunterUserCenterViewController alloc]  init];
                userCenter.uid=[dataDic objectForKey:@"uid"];
                [self.navigationController pushViewController:userCenter animated:YES];
            }else if([[imgDic objectForKey:@"type"] isEqualToString:@"4"]){
                // 点击进入后是某个任务分类集合
                // 当用户点击某个banner，可以进入某种分类任务集合（某一商家广告任务集合）里面
                NSString *fid = [dataDic objectForKey:@"fid"];
                ghunterFindTaskViewController *findTask = [[ghunterFindTaskViewController alloc] init];
                findTask.taskCid = [fid integerValue];
                findTask.nametitle = [dataDic objectForKey:@"name"];
                [self.navigationController pushViewController:findTask animated:YES];
            }
            else if([[imgDic objectForKey:@"type"] isEqualToString:@"5"]){
                // 找技能广告banner
                // 当用户点击某个banner，可以进入某种分类技能集合（某一商家广告任务集合）里面
                NSString *fid = [dataDic objectForKey:@"fid"];
                ghunterFindSkillViewController *findSkill = [[ghunterFindSkillViewController alloc] init];
                findSkill.skillCid = [fid integerValue];
                findSkill.nametitle = [dataDic objectForKey:@"name"];
                [self.navigationController pushViewController:findSkill animated:YES];
            }else if([[imgDic objectForKey:@"type"] isEqualToString:@"6"]){
                // 点击进入金币商城
                [AFNetworkTool httpRequestWithUrl:URL_COINSHOP_LOGIN params:nil success:^(NSData *data) {
                    NSError *error;
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    if ([[result objectForKey:@"error"]integerValue] == 0) {
                        NSString *loginurl = [result objectForKey:@"url"];
                        CreditWebViewController *web = [[CreditWebViewController alloc]initWithUrlByPresent:loginurl];
                        CreditNavigationController *nav = [[CreditNavigationController alloc]initWithRootViewController:web];
                        [nav setNavColorStyle:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1]];
                        [self presentViewController:nav animated:YES completion:nil];
                    }else{
                        [ProgressHUD show:[result objectForKey:@"msg"]];
                    }
                } fail:^{
                    [ProgressHUD show:HTTPREQUEST_ERROR];
                }];
            }
        };
        [cell addSubview:self.scrollView];
    }else if(indexPath.row == 1){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"descriptionView" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        UILabel *description = (UILabel *)[cell viewWithTag:1];
        description.textAlignment = NSTextAlignmentLeft;
        [description setText:@"找任务"];
        description.font = [UIFont systemFontOfSize:14];
        description.textColor = RGBCOLOR(51, 51, 51);
        description.backgroundColor = [UIColor clearColor];
        description.frame = CGRectMake(10 + 5 + 3, 9, 100, 13);
        UILabel *line = (UILabel *)[cell viewWithTag:2];
        line.hidden = YES;
        UILabel *redline=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 3, 13)];
        redline.backgroundColor = RGBCOLOR(250, 120, 41);
        [cell addSubview:redline];
        return cell;
    }else if(indexPath.row == 2){
        if([FindTaskArray count] > 0){
            
            UIView *ftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 140)];
            
            UIImageView *findIcon1 = [[UIImageView alloc] initWithFrame:CGRectMake((mainScreenWidth-(40*4))/5-12, 10, 40, 40)];
            findIcon1.tag = 121;
            UILabel *findLabel1 = [[UILabel alloc] initWithFrame:CGRectMake((mainScreenWidth-(40*4))/5-2-12, 50, 69, 25)];
            findLabel1.tag = 131;
            
            // hot
            UIImageView * hotImgV = [[UIImageView alloc] initWithFrame:CGRectMake(48, 10, 25, 15)];
            hotImgV.tag = 9;
            hotImgV.center = CGPointMake(findIcon1.frame.size.width, findIcon1.frame.origin.y);
            
            
            UIImageView *findIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*2)+40-3, 10, 40, 40)];
            findIcon2.tag = 122;
            UILabel *findLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*2)+40-2-3, 50, 69, 25)];
            findLabel2.tag = 132;
            
            UIImageView *findIcon3 = [[UIImageView alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*3)+80+3, 10, 40, 40)];
            findIcon3.tag = 123;
            UILabel *findLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*3)+80-2+3, 50, 69, 25)];
            findLabel3.tag = 133;
            
            UIImageView *findIcon4 = [[UIImageView alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*4)+120+12, 10, 40, 40)];
            findIcon4.tag = 124;
            UILabel *findLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*4)+120+12-8, 50, 69, 25)];
            findLabel4.textAlignment = NSTextAlignmentCenter;
            findLabel4.tag = 134;
            
            
            UIImageView *findIcon5 = [[UIImageView alloc] initWithFrame:CGRectMake((mainScreenWidth-(40*4))/5-12, 75, 40, 40)];
            findIcon5.tag = 125;
            UILabel *findLabel5 = [[UILabel alloc] initWithFrame:CGRectMake((mainScreenWidth-(40*4))/5-2-12, 113, 69, 25)];
            findLabel5.tag = 135;
            
            UIImageView *findIcon6 = [[UIImageView alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*2)+40-3, 75, 40, 40)];
            findIcon6.tag = 126;
            UILabel *findLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*2)+40-2-3, 113, 69, 25)];
            findLabel6.tag = 136;
            
            UIImageView *findIcon7 = [[UIImageView alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*3)+80+3, 75, 40, 40)];
            findIcon7.tag = 127;
            UILabel *findLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*3)+80-2+3, 113, 69, 25)];
            findLabel7.tag = 137;
            
            UIImageView *findIcon8 = [[UIImageView alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*4)+120+12, 75, 40, 40)];
            findIcon8.tag = 128;
            UILabel *findLabel8 = [[UILabel alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*4)+120-2+12, 113, 69, 25)];
            findLabel8.tag = 138;
            
            [ftView addSubview:findIcon1];
            [findIcon1 addSubview:hotImgV];
            [ftView addSubview:findIcon2];
            [ftView addSubview:findIcon3];
            [ftView addSubview:findIcon4];
            [ftView addSubview:findIcon5];
            [ftView addSubview:findIcon6];
            [ftView addSubview:findIcon7];
            [ftView addSubview:findIcon8];
            [ftView addSubview:findLabel1];
            [ftView addSubview:findLabel2];
            [ftView addSubview:findLabel3];
            [ftView addSubview:findLabel4];
            [ftView addSubview:findLabel5];
            [ftView addSubview:findLabel6];
            [ftView addSubview:findLabel7];
            [ftView addSubview:findLabel8];
            ftView.backgroundColor = [UIColor whiteColor];
            //            ftView.layer.cornerRadius = Radius;
            
            CGRect cellFram1 = cell.frame;
            cell.backgroundColor = [UIColor clearColor];
            cellFram1.size.height = 140;
            cell.layer.cornerRadius = Radius;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:ftView];
            
            for (NSInteger i = 0; i < [FindTaskArray count]; i++) {
                NSDictionary *FTask = [FindTaskArray objectAtIndex:i];
                UIImageView *findTIcon = (UIImageView *)[cell viewWithTag:121 + i];
                UILabel *findLabel = (UILabel *)[cell viewWithTag:131 + i];
                [[findTIcon layer] setCornerRadius:findIcon1.frame.size.width * 0.5];
                
                // hot
//                NSDictionary *FTaskHot = [FindTaskArray objectAtIndex:0];
//                [hotImgV sd_setImageWithURL:[FTaskHot objectForKey:@"badge_icon"] placeholderImage:[UIImage imageNamed:@"avatar"]];
                
                [findTIcon sd_setImageWithURL:[FTask objectForKey:@"img_url"] placeholderImage:[UIImage imageNamed:@"avatar"]];
                NSString *btStr = [FTask objectForKey:@"name"];
                [findLabel setText:btStr];
                findLabel.center = CGPointMake(findTIcon.center.x, findLabel.center.y);
                findLabel.textAlignment = NSTextAlignmentCenter;
                [findLabel setTextColor:RGBCOLOR(51, 51, 51)];
                findLabel.font = [UIFont systemFontOfSize:14];
                findTIcon.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findTaskTaped:)];
                [findTIcon addGestureRecognizer:tap];
            }
        }
    }else if(indexPath.row == 3){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"descriptionView" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        UILabel *description = (UILabel *)[cell viewWithTag:1];
        description.textAlignment = NSTextAlignmentLeft;
        [description setText:@"找技能"];
        description.textColor = RGBCOLOR(51, 51, 51);
        description.font = [UIFont systemFontOfSize:14];
        description.frame = CGRectMake(5 + 10 + 3, 9, 100, 13);
        UILabel *redline=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 3, 13)];
//        redline.backgroundColor = RGBCOLOR(234, 88, 24);
        redline.backgroundColor = RGBCOLOR(250, 120, 41);
        [cell addSubview:redline];
        
        UILabel *line = (UILabel *)[cell viewWithTag:2];
        line.hidden = YES;
    }else if(indexPath.row == 4){
        if ([FindSkillArray count] > 0) {
            
            float width = 40;
            float height = 40;
            
            
            UIView * ftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 160)];
            
            UIImageView *findIcon1 = [[UIImageView alloc] initWithFrame:CGRectMake((mainScreenWidth-(40*4))/5-12, 10, width, height)];
            findIcon1.tag = 121;
            UILabel *findLabel1 = [[UILabel alloc] initWithFrame:CGRectMake((mainScreenWidth-(40*4))/5-2-12, 50, 69, 25)];
            findLabel1.tag = 131;
            
            UIImageView *findIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*2)+40-3, 10, width, height)];
            findIcon2.tag = 122;
            UILabel *findLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*2)+40-2-3, 50, 69, 25)];
            findLabel2.tag = 132;
            
            UIImageView *findIcon3 = [[UIImageView alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*3)+80+3, 10, width, height)];
            findIcon3.tag = 123;
            UILabel *findLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*3)+80-2+3, 50, 69, 25)];
            findLabel3.tag = 133;
            
            UIImageView *findIcon4 = [[UIImageView alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*4)+120+12,10, width, height)];
            findIcon4.tag = 124;
            UILabel *findLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*4)+120+12-8, 50, 69, 25)];
            findLabel4.tag = 134;
            
            
            UIImageView *findIcon5 = [[UIImageView alloc] initWithFrame:CGRectMake((mainScreenWidth-(40*4))/5-12, 75, width, height)];
            findIcon5.tag = 125;
            UILabel *findLabel5 = [[UILabel alloc] initWithFrame:CGRectMake((mainScreenWidth-(40*4))/5-2-12, 113, 69, 25)];
            findLabel5.tag = 135;
            
            UIImageView *findIcon6 = [[UIImageView alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*2)+40-3, 75, width, height)];
            findIcon6.tag = 126;
            UILabel *findLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*2)+40-2-3, 113, 69, 25)];
            findLabel6.tag = 136;
            
            UIImageView *findIcon7 = [[UIImageView alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*3)+80+3, 75, width, height)];
            findIcon7.tag = 127;
            UILabel *findLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*3)+80-2+3, 113, 69, 25)];
            findLabel7.tag = 137;
            
            UIImageView *findIcon8 = [[UIImageView alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*4)+120+12, 75, 40, 40)];
            findIcon8.tag = 128;
            UILabel *findLabel8 = [[UILabel alloc] initWithFrame:CGRectMake(((mainScreenWidth-(40*4))/5*4)+120-2+12, 113, 69, 25)];
            findLabel8.tag = 138;
            
            [ftView addSubview:findIcon1];
            [ftView addSubview:findIcon2];
            [ftView addSubview:findIcon3];
            [ftView addSubview:findIcon4];
            [ftView addSubview:findIcon5];
            [ftView addSubview:findIcon6];
            [ftView addSubview:findIcon7];
            [ftView addSubview:findIcon8];
            [ftView addSubview:findLabel1];
            [ftView addSubview:findLabel2];
            [ftView addSubview:findLabel3];
            [ftView addSubview:findLabel4];
            [ftView addSubview:findLabel5];
            [ftView addSubview:findLabel6];
            [ftView addSubview:findLabel7];
            [ftView addSubview:findLabel8];
            ftView.backgroundColor = [UIColor whiteColor];
            
            CGRect cellFram1 = cell.frame;
            cell.backgroundColor = [UIColor whiteColor];
            cellFram1.size.height = 140;
            cell.frame = cellFram1;
//            cell.layer.cornerRadius = Radius;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:ftView];
            

            /*
            if ([FindTaskArray count] == 1) {
                bg2.hidden = YES;
                bg3.hidden = YES;
                bg4.hidden = YES;
                bg5.hidden = YES;
                bg6.hidden = YES;
                bg7.hidden = YES;
                bg8.hidden = YES;
            }
            if ([FindTaskArray count] == 2) {
                bg3.hidden = YES;
                bg4.hidden = YES;
                bg5.hidden = YES;
                bg6.hidden = YES;
                bg7.hidden = YES;
                bg8.hidden = YES;
            }
            if ([FindTaskArray count] == 3) {
                bg4.hidden = YES;
                bg5.hidden = YES;
                bg6.hidden = YES;
                bg7.hidden = YES;
                bg8.hidden = YES;
            }
            if ([FindTaskArray count] == 4) {
                bg5.hidden = YES;
                bg6.hidden = YES;
                bg7.hidden = YES;
                bg8.hidden = YES;
            }
            if ([FindTaskArray count] == 5) {
                bg6.hidden = YES;
                bg7.hidden = YES;
                bg8.hidden = YES;
            }
            if ([FindTaskArray count] == 6) {
                bg7.hidden = YES;
                bg8.hidden = YES;
            }
            if ([FindTaskArray count] == 7) {
                bg8.hidden = YES;
            }
             */

            
            for (NSInteger i = 0; i < [FindSkillArray count]; i++) {
                
                NSDictionary *FSkill = [FindSkillArray objectAtIndex:i];
                
//                UIView *bg = (UIView *)[cell viewWithTag:81 + i];
                UILabel *lb = (UILabel *)[cell viewWithTag:131 + i];
                UIImageView *icon = (UIImageView *)[cell viewWithTag:121 + i];
                icon.clipsToBounds = YES;
                icon.layer.cornerRadius = icon.frame.size.width / 2;
                icon.userInteractionEnabled = YES;
                [icon sd_setImageWithURL:[FSkill objectForKey:@"img_url"] placeholderImage:[UIImage imageNamed:@"avatar"]];
                NSString *btStr = [FSkill objectForKey:@"name"];
                [lb setText:btStr];
                lb.textAlignment = NSTextAlignmentCenter;
                lb.font = [UIFont systemFontOfSize:14];
                lb.center = CGPointMake(icon.center.x, lb.center.y);

                lb.textColor = RGBCOLOR(51, 51, 51);
                NSString *bgcolor = @"#F6F6F6";
                if ([bgcolor hasPrefix:@"#"]) bgcolor = [bgcolor substringFromIndex:1];
                NSRange range;
                range.location = 0;
                range.length = 2;
                NSString *rString = [bgcolor substringWithRange:range];
                range.location = 2;
                NSString *gString = [bgcolor substringWithRange:range];
                range.location = 4;
                NSString *bString = [bgcolor substringWithRange:range];
                // Scan values
                unsigned int r, g, b;
                [[NSScanner scannerWithString:rString] scanHexInt:&r];
                [[NSScanner scannerWithString:gString] scanHexInt:&g];
                [[NSScanner scannerWithString:bString] scanHexInt:&b];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findSkillTaped:)];
                [icon addGestureRecognizer:tap];
            }
            cell.backgroundColor = [UIColor whiteColor];
        }
    }else if(indexPath.row == 5){
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"hotTaskTitleView" owner:self options:nil];
        //
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *description = (UILabel *)[cell viewWithTag:1];
        description.textAlignment = NSTextAlignmentLeft;
        [description setText:@"最火任务"];
        description.font = [UIFont systemFontOfSize:14];
        description.textColor = RGBCOLOR(51, 51, 51);
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFull, 8)];
        line.backgroundColor = RGBCOLOR(235, 235, 235);
        [cell addSubview:line];
        
        UILabel *redline=[[UILabel alloc]initWithFrame:CGRectMake(10, 17, 3, 13)];
        redline.backgroundColor = RGBCOLOR(250, 120, 41);
        description.frame = CGRectMake(5 + 3 + 10, 15, 100, 13);
        [cell addSubview:redline];
    }else if(indexPath.row == 6){
        if([hotArray count] > 0){
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"hotView" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CGRect cellFrame = cell.frame;
            
            UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 63, ScreenWidthFull, 0.5)];
            line2.backgroundColor =  RGBCOLOR(229, 229, 229);
            [cell addSubview:line2];
            
            if([hotArray count] <= 2) cellFrame.size.height = 60.0;
            if ([hotArray count] == 1) {
                UIView *bg = (UIView *)[cell viewWithTag:25];
                bg.hidden = YES;
                UIView *bg1 = (UIView *)[cell viewWithTag:35];
                bg1.hidden = YES;
                UIView *bg2 = (UIView *)[cell viewWithTag:45];
                bg2.hidden = YES;
            }
            if ([hotArray count] == 2) {
                UIView *bg1 = (UIView *)[cell viewWithTag:35];
                bg1.hidden = YES;
                UIView *bg2 = (UIView *)[cell viewWithTag:45];
                bg2.hidden = YES;
            }
            if([hotArray count] == 3) {
                UIView *bg = (UIView *)[cell viewWithTag:45];
                bg.hidden = YES;
            }
            [cell setFrame:cellFrame];
            for (NSUInteger i = 1; i <= [hotArray count]; i++) {
                NSDictionary *task = [hotArray objectAtIndex:i - 1];
                NSDictionary *owner = [task objectForKey:@"owner"];
                UIImageView *icon = (UIImageView *)[cell viewWithTag:i * 10 + 1];
                UIImageView *gender = (UIImageView *)[cell viewWithTag:i * 10 + 2];
                //                UILabel *age = (UILabel *)[cell viewWithTag:i * 10 + 3];
                UILabel *catalog = (UILabel *)[cell viewWithTag:i * 10 + 4];
                UIView *bg = (UIView *)[cell viewWithTag:i * 10 + 5];
                UILabel *name = (UILabel *)[cell viewWithTag:i * 10 + 6];
                //                icon.clipsToBounds = YES;
                //                icon.layer.cornerRadius = Radius;
                icon.layer.masksToBounds =YES;
                icon.layer.cornerRadius = 22.5;
                [icon sd_setImageWithURL:[owner objectForKey:TINY_AVATAR] placeholderImage:[UIImage imageNamed:@"avatar"]];
                if([[owner objectForKey:@"sex"] isEqualToString:@"0"]){
                    [gender setImage:[UIImage imageNamed:@"female"]];
                }else if ([[owner objectForKey:@"sex"] isEqualToString:@"1"]){
                    [gender setImage:[UIImage imageNamed:@"male_hunter_icon"]];
                }
                //                [age setText:[NSString stringWithFormat:@"%@",[owner objectForKey:@"age"]]];
                [catalog setText:[task objectForKey:@"typename"]];
                catalog.textColor = RGBCOLOR(51, 51, 51);
                catalog.font = [UIFont systemFontOfSize:14];
                
                bg.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotTaskTaped:)];
                [bg addGestureRecognizer:tap];
                [name setText:[owner objectForKey:@"username"]];
                name.textColor = RGBCOLOR(102, 102, 102);
                name.font = [UIFont systemFontOfSize:12];
            }
            UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(mainScreenWidth / 2, 2, 0.5, cellFrame.size.height)];
            line3.backgroundColor =  RGBCOLOR(229, 229, 229);
            [cell addSubview:line3];
        }
    }else if(indexPath.row == 7){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"descriptionView" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        UILabel *description = (UILabel *)[cell viewWithTag:1];
        
        description.textAlignment = NSTextAlignmentLeft;
        [description setText:@"热门技能"];
        description.font = [UIFont systemFontOfSize:14];
        description.textColor = RGBCOLOR(51, 51, 51);
        description.frame = CGRectMake(5 + 3 + 10, 14, 100, 13);
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFull, 8)];
        line.backgroundColor = backgroud_Bg;
        [cell addSubview:line];
        UILabel *redline=[[UILabel alloc]initWithFrame:CGRectMake(10, 17, 3, 12)];
        //        redline.backgroundColor = RGBCOLOR(234, 88, 24);
        redline.backgroundColor = RGBCOLOR(250, 120, 41);
        [cell addSubview:redline];
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = 35.0;
        cell.frame = cellFrame;
    }else if(indexPath.row >= 8){
        NSDictionary *task = [intrestArray objectAtIndex:indexPath.row - 8];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"taskCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *owner = [task objectForKey:@"owner"];
        
        
        UILabel *title = (UILabel *)[cell viewWithTag:2];
//        OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:3];
        UIImageView *huntericon = (UIImageView *)[cell viewWithTag:4];
        UILabel *distance = (UILabel *)[cell viewWithTag:5];
        UILabel *huntername = (UILabel *)[cell viewWithTag:6];
        UILabel *dateline = (UILabel *)[cell viewWithTag:7];
        UILabel *bidnum = (UILabel *)[cell viewWithTag:8];
        UILabel *hot = (UILabel *)[cell viewWithTag:9];
        UIImageView *gender = (UIImageView *)[cell viewWithTag:10];
//        UIView *bg = (UIView *)[cell viewWithTag:12];
//        UIImageView *bountyImage = (UIImageView *)[cell viewWithTag:13];
//        UILabel* goldLabel=(UILabel*)[cell viewWithTag:99];
      
        huntericon.layer.masksToBounds =YES;
        huntericon.layer.cornerRadius = 25;
        huntericon.center = CGPointMake(35, 35);
        
        [huntericon sd_setImageWithURL:[owner objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        huntericon.userInteractionEnabled = YES;
        huntericon.tag = indexPath.row - 8;
        huntericon.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
        [huntericon addGestureRecognizer:tap];
        
        NSString *distancestar = [ghunterRequester calculateDistanceWithLatitude:[task objectForKey:@"latitude"] withLongitude:[task objectForKey:@"longitude"]];
        [distance setText:distancestar];
        distance.textColor = RGBCOLOR(153, 153, 153);
        NSString *nameStr = [owner objectForKey:@"username"];
        CGSize nameSize = [nameStr sizeWithFont:huntername.font];
        CGRect nameFrame = huntername.frame;
//        if (nameFrame.origin.x + nameSize.width > bountyImage.frame.origin.x) {
//            nameFrame.size.width = bountyImage.frame.origin.x - nameFrame.origin.x;
//        }
        nameFrame.origin.x = huntericon.frame.origin.x + huntericon.frame.size.width + 10;
        huntername.frame = nameFrame;
        [huntername setText:[owner objectForKey:@"username"]];
        huntername.textColor = RGBCOLOR(102, 102, 102);
        huntername.font = [UIFont systemFontOfSize:12];
        [dateline setText:[ghunterRequester getTimeDescripton:[task objectForKey:@"dateline"]]];
        [bidnum setText:[NSString stringWithFormat:@"%@人购买",[task objectForKey:@"salenum"]]];
        [hot setText:[NSString stringWithFormat:@"%@热度",[task objectForKey:@"hot"]]];
        
        dateline.textColor = RGBCOLOR(153, 153, 153);
        dateline.font = [UIFont systemFontOfSize:10];
        bidnum.textColor = RGBCOLOR(153, 153, 153);
        bidnum.font = [UIFont systemFontOfSize:10];
        hot.textColor = RGBCOLOR(153, 153, 153);
        hot.font = [UIFont systemFontOfSize:10];
        
        if([[owner objectForKey:@"sex"] isEqualToString:@"0"]){
            [gender setImage:[UIImage imageNamed:@"female"]];
        }else{
            [gender setImage:[UIImage imageNamed:@"male"]];
        }
        CGRect distanceFrame = distance.frame;
        distance.frame = distanceFrame;
        NSString *bountySelf = [task objectForKey:@"price"];
        NSString* priceUnit=[task objectForKey:@"priceunit"];
        NSString *bountyStr = [NSString stringWithFormat:@"%@元/%@",bountySelf,priceUnit];

        // 元/次
        UILabel * bounty = [[UILabel alloc] initWithFrame:CGRectMake(200, huntername.frame.origin.y + 4, 69, 21)];
        [cell.contentView addSubview:bounty];
        bounty.text = bountyStr;
        bounty.font = [UIFont systemFontOfSize:12];
        bounty.textColor = RGBCOLOR(234, 85, 20);
        CGSize bontySize = [bountyStr sizeWithFont:bounty.font];
        CGRect attLbStrFrame = bounty.frame;
//        attLbStrFrame.origin.x = goldLbFrame.origin.x + 20 + goldLabel.text.length;
        attLbStrFrame.origin.x = mainScreenWidth - 10 - bontySize.width;
        attLbStrFrame.origin.y = huntername.frame.origin.y - 4;
        attLbStrFrame.size.width = bontySize.width;
        bounty.frame = attLbStrFrame;
        
        // 赏字位置
        UILabel * goldLabel = [[UILabel alloc] initWithFrame:CGRectMake(bounty.frame.origin.x - 10, huntername.frame.origin.y - 8, 23, 23)];
        [cell.contentView addSubview:goldLabel];
        goldLabel.textAlignment = NSTextAlignmentCenter;
        goldLabel.text = @"售";
        goldLabel.textColor = RGBCOLOR(234, 85, 20);
        goldLabel.font = [UIFont systemFontOfSize:14];
        [goldLabel.layer setBorderWidth:1.0];
        goldLabel.layer.cornerRadius = goldLabel.frame.size.width / 2;
        goldLabel.clipsToBounds = YES;
        [goldLabel.layer setBorderColor:RGBCOLOR(234, 85, 20).CGColor];
        CGRect goldLbFrame = goldLabel.frame;
        
        goldLbFrame.origin.x = bounty.frame.origin.x - 10 - goldLbFrame.size.width;
        goldLbFrame.origin.y = huntername.frame.origin.y - 5;
        
        goldLabel.font = [UIFont systemFontOfSize:12];
        
        goldLabel.frame = goldLbFrame;
        
        //图片内容
        UIImageView *imagetent = (UIImageView *)[cell viewWithTag:111];
        [imagetent sd_setImageWithURL:[task objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        imagetent.clipsToBounds = YES;
        imagetent.layer.cornerRadius = 3.0;
        CGRect imgFrame = imagetent.frame;
        imgFrame.origin.x = mainScreenWidth - imagetent.frame.size.width - 10;
//        imgFrame.origin.y = gender.frame.origin.y;
        imagetent.frame = imgFrame;
        
        // 颜色
        UILabel *tabbartxt  = (UILabel *)[cell viewWithTag:110];
        NSString*string =[task objectForKey:@"color"];
        
        NSString *b = [string substringFromIndex:0];
        NSString *colorstr = [NSString stringWithFormat:@"0x%@",b];
        
        tabbartxt.textColor = [Monitor colorWithHexString:colorstr alpha:1.0f];
        tabbartxt.text = [task objectForKey:@"c_name"];
        tabbartxt.font = [UIFont systemFontOfSize:10];
        
        NSString *LENstr = [task objectForKey:@"c_name"];
        if ([LENstr length]>1) {
            CGRect tabbartxtFrame = tabbartxt.frame;
            tabbartxtFrame.size.width =25;
            tabbartxtFrame.origin.y = huntericon.frame.size.height + huntericon.frame.origin.y + 10;
            tabbartxt.frame = tabbartxtFrame;
        }
        if ([LENstr length]>2) {
            CGRect tabbartxtFrame = tabbartxt.frame;
            tabbartxtFrame.size.width =35;
            tabbartxtFrame.origin.y = huntericon.frame.size.height + huntericon.frame.origin.y + 10;
            tabbartxt.frame = tabbartxtFrame;
        }
        if ([LENstr length]>3) {
            CGRect tabbartxtFrame = tabbartxt.frame;
            tabbartxtFrame.size.width = 45;
            tabbartxtFrame.origin.y = huntericon.frame.size.height + huntericon.frame.origin.y + 10;
            tabbartxt.frame = tabbartxtFrame;
        }
        tabbartxt.clipsToBounds = YES;
        tabbartxt.layer.cornerRadius = 3.0;
        [tabbartxt.layer setBorderWidth:1.0];   //边框宽度
        tabbartxt.textAlignment = NSTextAlignmentCenter;
        [tabbartxt.layer setBorderColor: [Monitor colorWithHexString:colorstr alpha:1.0f].CGColor];//边框颜色
        
        // 虚线
        UILabel * xuxianLb = (UILabel *)[cell viewWithTag:999];
        CGRect xuxianFrame = xuxianLb.frame;
        xuxianFrame.origin.y = tabbartxt.frame.size.height + tabbartxt.frame.origin.y + 6;
        xuxianLb.frame = xuxianFrame;
        
        NSString *titleStr = [task objectForKey:@"skill"];
        CGRect titleFrame = title.frame;
//        CGSize titleSize = [titleStr sizeWithFont:title.font constrainedToSize:CGSizeMake(title.frame.size.width,MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        titleFrame.origin.y = tabbartxt.frame.origin.y - 3;
        [title setFrame:titleFrame];
        [title setText:titleStr];
        title.textColor = RGBCOLOR(51, 51, 51);
        
        
        // 下面6个图标对齐
        UIImageView * bidImgV = (UIImageView *)[cell viewWithTag:91];
        UIImageView * hotImgV = (UIImageView *)[cell viewWithTag:92];
        UIImageView * timeImgV = (UIImageView *)[cell viewWithTag:93];
        
        CGRect bidImgVFrame = bidImgV.frame;
        CGRect hotImgVFrame = hotImgV.frame;
        CGRect timeImgVFrame = timeImgV.frame;
        CGRect bidnumFrame = bidnum.frame;
        CGRect hotLbFrame = hot.frame;
        CGRect timeLbFrame = dateline.frame;
        
        CGFloat height = cell.frame.size.height - 21;
        
        bidImgVFrame.origin.x = tabbartxt.frame.origin.x;
        bidImgVFrame.origin.y = height;
        hotImgVFrame.origin.x = tabbartxt.frame.origin.x + 70;
        hotImgVFrame.origin.y = height;
        timeImgVFrame.origin.x =tabbartxt.frame.origin.x + 150;
        timeImgVFrame.origin.y = height;
        
        bidnumFrame.origin.x = bidImgVFrame.origin.x + 14;
        bidnumFrame.origin.y = height - 3;
        hotLbFrame.origin.x = hotImgVFrame.origin.x + 14;
        hotLbFrame.origin.y = height - 3;
        timeLbFrame.origin.x = timeImgVFrame.origin.x + 14;
        timeLbFrame.origin.y = height - 3;
        
        bidImgV.frame = bidImgVFrame;
        hotImgV.frame = hotImgVFrame;
        timeImgV.frame = timeImgVFrame;
        bidnum.frame = bidnumFrame;
        hot.frame = hotLbFrame;
        dateline.frame = timeLbFrame;

        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        CGRect cellFrame = cell.frame;
        
        cellFrame.size.height = imagetent.frame.size.height + imagetent.frame.origin.y + 6;
        cell.frame = cellFrame;
    }
    return cell;
}




#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
}

#pragma mark - Refresh and load more methods

- (void)refreshTable
{
    skillPage = 1;
    [self didGetBannderIsloading:NO];
}

- (void)loadMoreDataToTable
{
    [self didGetHotSkillsIsloading:NO withPage:skillPage];
}

- (IBAction)searchBtn:(UIButton *)sender {
    ghuntersearchViewController *search = [[ghuntersearchViewController alloc] init];
    search.type = 0;
    [self.navigationController pushViewController:search animated:YES];
}


// 点击签到按钮
- (IBAction)signInBtn:(UIButton *)sender {
    

    if(!imgondar_islogin)
    {
        [self click2Login];
        return;
    }
    CGFloat signReward = [gunread_signreward floatValue];
    if(signReward > 0)
    {
        // 已经签到过，直接弹框显示今日签到成绩
        [self didShowSignDialog];
    }
    else
    {
        // 没有签到，开始签到
        [self didCheckinIsloading:NO];
    }
}
-(void)didShowSignDialog{
    
    [AFNetworkTool httpRequestWithUrl:URL_CHACKIN params:nil success:^(NSData *data) {
        
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            gunread_signreward = [result objectForKey:@"reward"];
            
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
        
        
        ghunterSigninViewController *signin =[[ghunterSigninViewController alloc]init];
        signin.reward = [[NSString alloc]init];
        signin.estra = [[NSString alloc]init];
        signin.days = [[NSString alloc]init];
        signin.estra = [[NSString alloc]init];
        signin.rankLabel = [[UILabel alloc]init];
        signin.daysLabel = [[UILabel alloc]init];
        signin.reward =[result objectForKey:@"reward"];
        signin.days =[result objectForKey:@"days"];
        
        signin.estra =[result objectForKey:@"extra"];
        
        signin.rank =[result objectForKey:@"rank"];
        
        signin.proportion =[result objectForKey:@"proportion"];
        
        [self.navigationController pushViewController:signin animated:YES];
        
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        
    }];
    
    
}
-(void)didShowSignDialogNo{
    
    [AFNetworkTool httpRequestWithUrl:URL_CHACKIN params:nil success:^(NSData *data) {
        
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            gunread_signreward = [result objectForKey:@"reward"];
            
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
        
        
        ghunterSigninViewController *signin =[[ghunterSigninViewController alloc]init];
        signin.reward = [[NSString alloc]init];
        signin.estra = [[NSString alloc]init];
        signin.days = [[NSString alloc]init];
        signin.estra = [[NSString alloc]init];
        signin.rankLabel = [[UILabel alloc]init];
        signin.daysLabel = [[UILabel alloc]init];
        signin.reward =[result objectForKey:@"reward"];
        signin.days =[result objectForKey:@"days"];
        
        signin.estra =[result objectForKey:@"extra"];
        
        signin.rank =[result objectForKey:@"rank"];
        
        signin.proportion =[result objectForKey:@"proportion"];
        
        [self.navigationController pushViewController:signin animated:YES];
        [self didShowSignAlerView];

        
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        
    }];
    

}

#pragma mark - share
// 分享签到
- (void)shareSignrewardClick:(id)sender {
    [signInView dismissAnimated:YES];
    shareView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"shareView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    [shareView setCornerRadius:8.0];
    CGRect taskfilterFrame = taskFilter.frame;
    shareView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height - 10), taskfilterFrame.size.width, taskfilterFrame.size.height);
    shareView.showView = taskFilter;
    UIButton *weixincircle = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *weixinfried = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *weibo = (UIButton *)[taskFilter viewWithTag:3];
    UIButton *qzone = (UIButton*)[taskFilter viewWithTag:6];
    UIButton *qq = (UIButton*)[taskFilter viewWithTag:7];
    UIButton *copy = (UIButton *)[taskFilter viewWithTag:4];
    UIButton *cancel = (UIButton *)[taskFilter viewWithTag:5];
    [weixincircle addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [weixinfried addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [weibo addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [copy addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [qzone addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [qq addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    shareView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    
    [shareView show];
}

// 分享任务到第三方平台
-(void)shareToPlatforms:(id)sender{
    [shareView dismissAnimated:YES];
    
    UIButton *btn = (UIButton *)sender;
    int code = [AFNetworkTool getHunterID:[[ghunterRequester getUserInfo:UID] intValue] :0];
    NSString *shareUrl = [NSString stringWithFormat:@"http://mob.imGondar.com/activity/checkin/%@?code=%d",[ghunterRequester getUserInfo:UID], code];
    
    if ( [btn tag] == 1 ) {
        // wxcircle
        [shareView dismissAnimated:YES];
        
        CGFloat signReward = [gunread_signreward floatValue];
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[ghunterRequester getUserInfo:TINY_AVATAR]];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"【赏金测人品】我的今日人品为%@，成功领取%@金币",[NSString stringWithFormat:@"%.1f", signReward],[NSString stringWithFormat:@"%.1f",signReward]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:@"0" :SHARETYPE_SIGN :gunread_signreward :SHAREPLATFORM_WXMOMENTS];
            }
        }];
    }else if([btn tag] == 2){
        // weixinfriend
        [shareView dismissAnimated:YES];
        
        CGFloat signReward = [gunread_signreward floatValue];
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[ghunterRequester getUserInfo:TINY_AVATAR]];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"赏金猎人";
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"【赏金测人品】我的今日人品为%@，成功领取%@金币",[NSString stringWithFormat:@"%.1f",signReward],[NSString stringWithFormat:@"%.1f",signReward]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:@"0" :SHARETYPE_SIGN :gunread_signreward :SHAREPLATFORM_WECHAT];
            }
        }];
    }else if([btn tag] == 3){
        // weibo
        [shareView dismissAnimated:YES];
        CGFloat signReward = [gunread_signreward floatValue];
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:@"http://imgondar.com/images/shareimg.png"];
        int code = [AFNetworkTool getHunterID:[[ghunterRequester getUserInfo:UID] intValue] :0];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"【赏金测人品】我的今日人品为%@，成功领取%@金币http://mob.imGondar.com/activity/checkin/%@?code=%d",[NSString stringWithFormat:@"%.1f",signReward],[NSString stringWithFormat:@"%.1f",signReward],[ghunterRequester getUserInfo:UID], code] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:@"0" :SHARETYPE_SIGN :gunread_signreward :SHAREPLATFORM_SINAWEIBO];
            }
        }];
    }else if([btn tag] == 4){
        // copy
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        // 链接后加入邀请码，为了更好地统计链接分享情况
        NSString *copyStr = shareUrl;
        [pasteboard setString:copyStr];
        [ProgressHUD show:@"已复制到剪贴板"];
        [shareView dismissAnimated:YES];
    }else if([btn tag] == 5){
        // cancel
        [shareView dismissAnimated:YES];
    }else if([btn tag] == 6){
        // qzone
        if (![QQApiInterface isQQInstalled]) {
            [AFNetworkTool isInstallQQ];
            return;
        }

        [shareView dismissAnimated:YES];
        CGFloat signReward = [gunread_signreward floatValue];
        [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qzoneData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[ghunterRequester getUserInfo:TINY_AVATAR]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:[NSString stringWithFormat:@"【赏金测人品】我的今日人品为%@，成功领取%@金币",[NSString stringWithFormat:@"%.1f",signReward],[NSString stringWithFormat:@"%.1f",signReward]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:@"0" :SHARETYPE_SIGN :gunread_signreward :SHAREPLATFORM_QZONE];
            }
        }];
    }else if([btn tag] == 7){
        // qq
        if (![QQApiInterface isQQInstalled]) {
            [AFNetworkTool isInstallQQ];
            return;
        }

        [shareView dismissAnimated:YES];
        CGFloat signReward = [gunread_signreward floatValue];
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qqData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[ghunterRequester getUserInfo:TINY_AVATAR]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"【赏金测人品】我的今日人品为%@，成功领取%@金币",[NSString stringWithFormat:@"%.1f",signReward],[NSString stringWithFormat:@"%.1f",signReward]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:@"0" :SHARETYPE_SIGN :gunread_signreward :SHAREPLATFORM_QQ];
            }
        }];
    }
}

#pragma mark --- 未登录点击
-(void)click2Login{
    ghunterLoginViewController *login = [[ghunterLoginViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
    [login setCallBackBlock:^{
        // 如果不成功，回到发现页面
//        self.tabBarController.selectedIndex = 0;
        
        [self update_sign_ui];
        [self didGetBannderIsloading:NO];
    }];
}


#pragma mark --- 滚动协议
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    当滑动停止的时候，计算出当前是第几个页面，修改小点点的值(偏移量/视图的宽度)
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

// 点击二维码，进入二维码扫描界面
- (IBAction)QRcode:(UIButton *)sender {
    
    [self.QRcode setImage:[UIImage imageNamed:@"扫一扫-拷贝"] forState:UIControlStateHighlighted];
    QRcodeViewController *qrcode = [QRcodeViewController new];
    [self.navigationController pushViewController:qrcode animated:YES];
}


- (void) pageNumber:(NSNotification *) notify {
    
    NSString * count = notify.userInfo[@"pageNum"];
    
    _pageControl.currentPage = count.intValue;
}


- (void) createPageControl {
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(mainScreenWidth / 2 + 50, 90, mainScreenWidth / 4, 20)];
    _pageControl.numberOfPages = self.bannersArr.count;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
}


@end
