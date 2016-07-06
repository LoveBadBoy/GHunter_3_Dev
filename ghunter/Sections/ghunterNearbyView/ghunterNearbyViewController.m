
//
//  ghunterFindViewController.m
//  ghunter
//
//  Created by chensonglu on 14-3-18.
//  Copyright (c) 2014年 ghunter. All rights reserved.
// 任务+猎人

#import "ghunterNearbyViewController.h"
#import "ghunterTabViewController.h"
#import "ghunterSkillViewController.h"
#define TASK_SKILL_TYPE_NEAREST @"nearest"
#define TASK_SKILL_TYPE_LATEST @"latest"
#define TASK_SKILL_TYPE_PRICEHIGH @"pricehigh"
#define TASK_SKILL_TYPE_BOUNTHIGH @"bountyhigh"
#define TASK_SKILL_TYPE_HOTEST @"hotest"

@interface ghunterNearbyViewController ()
@property(nonatomic,retain)NSString *taskType;
@property(nonatomic,retain)NSString *skillType;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property(nonatomic,assign)BOOL swapByTapButton;
@property(nonatomic,assign)BOOL firstTimeShowTaskTableView;
@property(nonatomic,assign)BOOL firstTimeShowSkillTableView;
@property (strong, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *topBGImageView;
@property (weak, nonatomic) UIImageView *topBGSliderImageView;

@end

@implementation ghunterNearbyViewController{
    NSString *filter4task;
    NSString *filter4skill;
    NSString *skillCid;
    NSString *taskCid;
    
    NSString * tmpSortOldStr;
    NSString * tmpFilterOldStr;
    NSString * tmpSortNewStr;
    NSString * tmpFilterNewStr;
    UILabel * headleftlabel;
    UILabel * headrightlabel;
    UIImageView *imageleft;
    UIImageView *imageright;
}

#pragma mark - UIViewController

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
    
    [self loadingView];
    //    _topBGImageView.frame = CGRectMake((mainScreenWidth - _topBGImageView.frame.size.width)*0.5, 29, _topBGImageView.frame.size.width, 25);
    showList = NO;
    showList2 = NO;
    
    _bg.backgroundColor = Nav_backgroud;
    
    self.tabBarController.tabBar.hidden = YES;
    
    zongarr = [NSMutableArray array];
    zongimgarr = [NSMutableArray array];
    
    self.firstTimeShowTaskTableView = YES;
    self.firstTimeShowSkillTableView = YES;
    self.swapByTapButton = NO;
    skillSelected = NO;
    
    self.codeint = 0;
    
    taskpage = 1;
    skillpage = 1;
    self.findtaskArray = [[NSMutableArray alloc] init];
    self.findskillArray = [[NSMutableArray alloc] init];
    
    double latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:LATITUDE];
    double longitude = [[NSUserDefaults standardUserDefaults] doubleForKey:LONGITUDE];
    [ghunterRequester setUserInfoWithKey:LATITUDE withValue:[NSString stringWithFormat:@"%f", latitude]];
    [ghunterRequester setUserInfoWithKey:LONGITUDE withValue:[NSString stringWithFormat:@"%f", longitude]];
    
    filter4skill = [[NSUserDefaults standardUserDefaults] objectForKey:@"filter4skill"];
    filter4task = [[NSUserDefaults standardUserDefaults] objectForKey:@"filter4task"];
    
    taskCid = @"0";
    skillCid = @"0";
    //默认加载最新
    self.skillType = TASK_SKILL_TYPE_LATEST;
    self.taskType = TASK_SKILL_TYPE_LATEST;
    
    taskRadio = [[QRadioButton alloc] initWithDelegate:self groupId:@"findGroup"];
    CGFloat radioY = _topBGImageView.frame.origin.y + 2;
    CGFloat radioWidth = _topBGImageView.frame.size.width * 0.5 - 4;
    CGFloat radioHeight = _topBGImageView.frame.size.height - 4;
    UIColor *radioColor = [UIColor whiteColor];
    UIColor *radioSelectedColor = [UIColor colorWithRed:205/255.0 green:86/255.0 blue:32/255.0 alpha:1.0];
    CGRect frame = CGRectMake(mainScreenWidth*0.5-_topBGImageView.frame.size.width*0.5 + 2, radioY, radioWidth, radioHeight);
    
    UIButton *searchbtn = [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth-50, 15, 50, 50)];
    [searchbtn setImage:[UIImage imageNamed:@"白色搜索"] forState:(UIControlStateNormal)];
    [searchbtn addTarget:self action:@selector(search:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:searchbtn];
    
    // 顶部滑块
    UIImageView *topBGSliderImageView = [[UIImageView alloc] initWithFrame:frame];
    [topBGSliderImageView setImage:[UIImage imageNamed:@"nearby_top_bg_white"]];
    _topBGSliderImageView = topBGSliderImageView;
    [self.view addSubview:_topBGSliderImageView];
    
    taskRadio.frame = frame;
    
    // TODO:radio iphone6
    [taskRadio setTitle:@"任务" forState:UIControlStateNormal];
    [taskRadio.titleLabel setFont: [UIFont systemFontOfSize:14.0f]];
    [taskRadio setTitleColor:radioColor forState:UIControlStateNormal];
    [taskRadio setTitleColor:radioSelectedColor forState:UIControlStateSelected];
    [taskRadio addTarget:self action:@selector(click2ShowTask) forControlEvents:UIControlEventTouchUpInside];
    taskRadio.selected = NO;
    [self.view addSubview:taskRadio];
    
    skillRadio = [[QRadioButton alloc] initWithDelegate:self groupId:@"findGroup"];
    skillRadio.frame = CGRectMake(mainScreenWidth*0.5 +2, radioY, radioWidth, radioHeight);
    [skillRadio setTitle:@"技能" forState:UIControlStateNormal];
    [skillRadio.titleLabel setFont: [UIFont systemFontOfSize:14.0f]];
    [skillRadio setTitleColor:radioColor forState:UIControlStateNormal];
    [skillRadio setTitleColor:radioSelectedColor forState:UIControlStateSelected];
    [skillRadio addTarget:self action:@selector(click2ShowSkillshow) forControlEvents:UIControlEventTouchUpInside];
    skillRadio.selected = NO;
    [self.view addSubview:skillRadio];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, mainScreenWidth, mainScreenheight - 64 - TAB_BAR_HEIGHT - 40)];
    scrollView.contentSize = CGSizeMake(mainScreenWidth*2, scrollView.bounds.size.height);
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    
    
    
    UILabel *redLine = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth / 2, 64 + 10, 0.5, 16)];
    redLine.backgroundColor = RGBCOLOR(235, 235, 235);
    [self.view addSubview:redLine];
    
    listview = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, mainScreenWidth, zongarr.count*40)];
    listview.dataSource = self;
    listview.delegate = self;
    listview.separatorColor = RGBCOLOR(235, 235, 235);
    listview.scrollEnabled =NO;
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, zongarr.count*40+104, mainScreenWidth, mainScreenheight)];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = 0.3;
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewtouch:)];
    [view addGestureRecognizer:singleTap];
    
    findTaskTableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, scrollView.frame.size.height)];
    findTaskTableView.delegate = self;
    findTaskTableView.dataSource = self;
    findTaskTableView.separatorColor = RGBCOLOR(235, 235, 235);
    findTaskTableView.pullDelegate = self;
    findTaskTableView.showsVerticalScrollIndicator = NO;
    findTaskTableView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:findTaskTableView];
    
    findSkillTableView = [[PullTableView alloc]initWithFrame:CGRectMake(mainScreenWidth, 0, mainScreenWidth, scrollView.frame.size.height)];
    findSkillTableView.delegate = self;
    findSkillTableView.separatorColor = RGBCOLOR(229, 229, 229);
    
    findSkillTableView.dataSource = self;
    findSkillTableView.pullDelegate = self;
    findSkillTableView.showsVerticalScrollIndicator = NO;
    findSkillTableView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:findSkillTableView];
    
    [self.view addSubview:scrollView];
    [self layoutheadButton];
    
    if ([findSkillTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [findSkillTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([findSkillTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [findSkillTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([findTaskTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [findTaskTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([findTaskTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [findTaskTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    NSString *taskcatalog_time = [ghunterRequester getCacheTimeWithKey:TASK_CATALOG_TIME];
    if(!taskcatalog_time){
        //获取任务分类
        [self didGetTaskCatalogIsloading:NO];
    }else{
        if([ghunterRequester gettimeInterval:taskcatalog_time] > ONE_DAY){
            //获取任务分类
            [self didGetTaskCatalogIsloading:NO];
        }else{
            task_catalogs = (NSArray *)[ghunterRequester getCacheContentWithKey:TASK_CATALOG];
        }
    }
    
    NSString *skillcatalog_time = [ghunterRequester getCacheContentWithKey:SKILL_TAG_TIME];
    if (!skillcatalog_time) {
        [self didGetSkillCatalogIsloading:NO];
    }else{
        if ([ghunterRequester gettimeInterval:skillcatalog_time] > ONE_DAY) {
            [self didGetSkillCatalogIsloading:NO];
        }else{
            skill_catalogs = [ghunterRequester getCacheContentWithKey:SKILL_TAG];
        }
    }
    
    // 发布任务成功后的通知，需要跳转到任务详情页
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTask" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTaskList:) name:@"refreshTask" object:nil];
    
    // 发布技能成功后的通知，需要跳转到任务详情页
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshSkill" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTaskList:) name:@"refreshSkill" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    
    ghunterTabViewController *tbvc = (ghunterTabViewController *)self.tabBarController;
    if (!tbvc.didSelectItemOfTabBar) {
        self.tabBarController.tabBar.hidden = YES;
        [self.tabBarController.tabBar setFrame:CGRectMake(0, mainScreenheight, mainScreenWidth, TAB_BAR_HEIGHT)];
        [scrollView setFrame:CGRectMake(0, 104, mainScreenWidth, mainScreenheight - 64)];
        scrollView.contentSize = CGSizeMake(mainScreenWidth*2, scrollView.bounds.size.height);
        [findTaskTableView setFrame:CGRectMake(0, 0, mainScreenWidth, scrollView.frame.size.height)];
        [findSkillTableView setFrame:CGRectMake(mainScreenWidth, 0, mainScreenWidth, scrollView.frame.size.height)];
    }
    else {
        [scrollView setFrame:CGRectMake(0, 104, mainScreenWidth, mainScreenheight - 64 - TAB_BAR_HEIGHT)];
        scrollView.contentSize = CGSizeMake(mainScreenWidth*2, scrollView.bounds.size.height);
        [findTaskTableView setFrame:CGRectMake(0, 0, mainScreenWidth, scrollView.frame.size.height-40)];
        [findSkillTableView setFrame:CGRectMake(mainScreenWidth, 0, mainScreenWidth, scrollView.frame.size.height-40)];
    }
    self.navigationController.navigationBarHidden = YES;
    if(!scrollView.contentOffset.x) {
        [taskRadio setSelected:YES];
        [skillRadio setSelected:NO];
    } else {
        [taskRadio setSelected:NO];
        [skillRadio setSelected:YES];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
-(void)layoutheadButton
{
    self.strtit =@"";
    sortbtn = [[UIButton alloc]initWithFrame:CGRectMake(0,64, mainScreenWidth/2, 39.5)];
    sortbtn.backgroundColor = [UIColor whiteColor];
    [sortbtn setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];
    [sortbtn addTarget:self action:@selector(sortBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    if ([self.strtit isEqualToString:@""]||self.strtit == nil) {
        [sortbtn setTitle:@"全部分类" forState:(UIControlStateNormal)];
        
    }
    CGSize contentSizethree = [sortbtn.titleLabel.text sizeWithFont:sortbtn.titleLabel.font constrainedToSize:CGSizeMake(sortbtn.titleLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    [sortbtn setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
    [sortbtn setImageEdgeInsets:UIEdgeInsetsMake(5, contentSizethree.width *4/3+15, 5, 0)];
    sortbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:sortbtn];
    filter = [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth/2, 64, mainScreenWidth/2, 39.5)];
    filter.titleLabel.font = [UIFont systemFontOfSize:12];
    [filter addTarget:self action:@selector(filter) forControlEvents:(UIControlEventTouchUpInside)];
    if ([self.strtit isEqualToString:@""]||self.strtit == nil) {
        [filter setTitle:@"最新发布" forState:(UIControlStateNormal)];
        
    }
    contentSizeTo = [filter.titleLabel.text sizeWithFont:filter.titleLabel.font constrainedToSize:CGSizeMake(filter.titleLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    [filter setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
    [filter setImageEdgeInsets:UIEdgeInsetsMake(5, contentSizeTo.width*2+15, 5, 0)];
    [filter setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];
    filter.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:filter];
    
    tmpSortOldStr = sortbtn.titleLabel.text;
    tmpFilterOldStr = filter.titleLabel.text;
}
- (void)viewDidAppear:(BOOL)animated {
    
    _genint = 1;
    ghunterTabViewController *tbvc = (ghunterTabViewController *)self.tabBarController;
    if (self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            [self.tabBarController.tabBar setFrame:CGRectMake(0, mainScreenheight - TAB_BAR_HEIGHT, mainScreenWidth, TAB_BAR_HEIGHT)];
        } completion:^(BOOL finished) {
            
        }];
    }
    tbvc.didSelectItemOfTabBar = NO;
    if (scrollView.contentOffset.x && self.firstTimeShowSkillTableView) {
        // 获取技能列表
        NSLog(@"第一次获取技能列表");
        [self didGetSkillListIsloading:YES withPage:skillpage andType:self.skillType andCatalogID:skillCid];
        self.firstTimeShowSkillTableView = NO;
    }
    if (!scrollView.contentOffset.x && self.firstTimeShowTaskTableView) {
        // 获取任务列表
        NSLog(@"第一次获取任务列表");
        [self didGetTaskListIsloading:YES withPage:taskpage andType:self.taskType andCatalogID:taskCid];
        self.firstTimeShowTaskTableView = NO;
    }
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

#pragma mark - 自动刷新任务页面
-(void)refreshTaskList:(NSNotificationCenter *)notification{
    if ([self.taskType isEqualToString:TASK_SKILL_TYPE_LATEST] || [self.taskType isEqualToString:TASK_SKILL_TYPE_NEAREST]) {
        // 最新和最近的时候，刷新任务列表
        taskpage = 1;
        [self didGetTaskListIsloading:NO withPage:taskpage andType:self.taskType andCatalogID:@"0"];
    }
}

-(void)refreshSkillList:(NSNotificationCenter *)notification{
    if ([self.skillType isEqualToString:TASK_SKILL_TYPE_LATEST] || [self.skillType isEqualToString:TASK_SKILL_TYPE_NEAREST]) {
        if (skillSelected) {
            // 最新和最近的时候，刷新任务列表
            skillpage = 1;
            [self didGetSkillListIsloading:NO withPage:skillpage andType:self.skillType andCatalogID:@"0"];
        }
    }
}

#pragma mark - 加载网络数据
// 获取任务分类
-(void)didGetCatalogIsloading:(BOOL )isloading{
    if (isloading) {
        [self startLoad];
    }
    
    [AFNetworkTool httpRequestWithUrl:URL_GET_TASK_CATALOG params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            [ghunterRequester setCacheTime:[ghunterRequester getTimeNow] withKey:TASK_CATALOG_TIME];
            [ghunterRequester setCacheContent:[result objectForKey:@"catalogs"] withKey:TASK_CATALOG];
        }else{
            
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}

-(void)search:(UIButton *)btn{
    ghuntersearchViewController *search = [[ghuntersearchViewController alloc] init];
    search.type = 0;
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark --- 获取附近任务分类 ---
// 获取附近任务列表
-(void)didGetTaskListIsloading:(BOOL )isloading withPage:(NSInteger)p andType:(NSString *)tp andCatalogID:(NSString *)cid{
    if (isloading) {
        [self startLoad];
    }
    if ([[ghunterRequester getUserInfo:LATITUDE] floatValue] == 0 || [[ghunterRequester getUserInfo:LONGITUDE] floatValue] == 0) {
        [ghunterRequester setUserInfoWithKey:LATITUDE withValue:LOC_DEFAULT_LATITUDE];
        [ghunterRequester setUserInfoWithKey:LONGITUDE withValue:LOC_DEFAULT_LONGITUDE];
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:@"latitude"];
    [parameters setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:@"longitude"];
    [parameters setObject:tp forKey:@"type"];
    [parameters setObject:[NSString stringWithFormat:@"%zd", p] forKey:@"page"];
    
    if ([cid isEqualToString:@""]||cid==nil) {
        
    }else{
        [parameters setObject:cid forKey:@"cid"];
    }
    [AFNetworkTool httpRequestWithUrl:URL_GET_TASK params:parameters success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            if (p == 1) {
                [self.findtaskArray removeAllObjects];
                taskpage = 2;
                NSArray *array = [result valueForKey:@"tasks"];
                [self.findtaskArray addObjectsFromArray:array];
                [findTaskTableView reloadData];
                if([self.findtaskArray count]>0)
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [findTaskTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                }
                findTaskTableView.pullTableIsRefreshing = NO;
            }else{
                taskpage++;
                NSArray *array = [result valueForKey:@"tasks"];
                [self.findtaskArray addObjectsFromArray:array];
                [findTaskTableView reloadData];
                findTaskTableView.pullTableIsLoadingMore = NO;
            }
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
            findTaskTableView.pullTableIsRefreshing = NO;
            findTaskTableView.pullTableIsLoadingMore = NO;
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
        findTaskTableView.pullTableIsRefreshing = NO;
        findTaskTableView.pullTableIsLoadingMore = NO;
    }];
}

-(void)fabu{
    NSArray *arr = [NSArray arrayWithObjects:@"最新发布",@"距离最近",@"赏金最多",@"热度最高", nil];
    NSArray * arr1 = [NSArray arrayWithObjects:@"最新发布",@"距离最近",@"售价最高",@"热度最高", nil];
    NSArray*  Sep = [NSArray arrayWithObjects:@"img1",@"img2",@"img3",@"img4", nil];
    
    if (skillRadio.selected == YES) {
        for (NSDictionary  *dic in arr1) {
            [zongarr addObject:dic];
        }
    }else {
        for (NSDictionary  *dic in arr) {
            [zongarr addObject:dic];
        }
    }
    for (NSDictionary  *dic in Sep) {
        [zongimgarr addObject:dic];
    }
}

#pragma mark------------排序renwu-------------
-(void)paixurenwu{
    Monitor *qufen = [Monitor sharedInstance];
    qufen.fenzhi = @"renwu";
    NSArray* tearr = [NSArray arrayWithObjects:@"全部分类",@"线上",@"兼职",@"学习",@"陪练",@"教练",@"活动",@"表白",@"飞毛腿", nil];
    NSArray* Sepi = [NSArray arrayWithObjects:@"Separate1",@"Separate2",@"Separate3",@"Separate4",@"Separate5",@"Separate6",@"Separate7",@"Separate8",@"Separate9", nil];
    for (NSDictionary  *dic in tearr) {
        [zongarr addObject:dic];
    }
    for (NSDictionary  *dic in Sepi) {
        [zongimgarr addObject:dic];
    }
}

#pragma mark------------排序技能-------------
-(void)paixujineng{
    Monitor *qufen = [Monitor sharedInstance];
    qufen.fenzhi = @"jineng";
    NSArray *arr = [NSArray arrayWithObjects:@"全部分类",@"生活服务",@"兼职实习",@"运动娱乐",@"IT技能",@"创意设计",@"文化艺术",@"授课辅导",@"情感技能", nil];
    NSArray *Sep = [NSArray arrayWithObjects:@"dzy-1",@"dzy-2",@"dzy-3",@"dzy-4",@"dzy-5",@"dzy-6",@"dzy-7",@"dzy-8",@"dzy-9", nil];
    
    for (NSDictionary  *dic in arr) {
        [zongarr addObject:dic];
    }
    for (NSDictionary  *dic in Sep) {
        [zongimgarr addObject:dic];
    }
}

#pragma mark-----------获取附近的技能列表------------
// 获取附近技能列表
-(void)didGetSkillListIsloading:(BOOL )isloading withPage:(NSInteger)p andType:(NSString *)tp andCatalogID:(NSString *)cid{
    if (isloading) {
        [self startLoad];
    }
    if ([[ghunterRequester getUserInfo:LATITUDE] floatValue] == 0 || [[ghunterRequester getUserInfo:LONGITUDE] floatValue] == 0) {
        [ghunterRequester setUserInfoWithKey:LATITUDE withValue:LOC_DEFAULT_LATITUDE];
        [ghunterRequester setUserInfoWithKey:LONGITUDE withValue:LOC_DEFAULT_LONGITUDE];
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:@"latitude"];
    [parameters setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:@"longitude"];
    [parameters setObject:tp forKey:@"type"];
    [parameters setObject:[NSString stringWithFormat:@"%zd", p] forKey:@"page"];
    if ([cid isEqualToString:@""]||cid==nil) {
        
    }else{
        [parameters setObject:cid forKey:@"cid"];
    }
    [AFNetworkTool httpRequestWithUrl:URL_GET_SKILL params:parameters success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            if (p == 1) {
                skillSelected = YES;
                [self.findskillArray removeAllObjects];
                
                skillpage = 2;
                NSArray *array = [result valueForKey:@"skillshows"];
                [self.findskillArray addObjectsFromArray:array];
                [findSkillTableView reloadData];
                if([self.findskillArray count]>0)
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [findSkillTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                }
                findSkillTableView.pullTableIsRefreshing = NO;
            }else{
                skillpage++;
                NSArray *array = [result valueForKey:@"skillshows"];
                [self.findskillArray addObjectsFromArray:array];
                [findSkillTableView reloadData];
                findSkillTableView.pullTableIsLoadingMore = NO;
            }
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
            findSkillTableView.pullTableIsRefreshing = NO;
            findSkillTableView.pullTableIsLoadingMore = NO;
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
        findSkillTableView.pullTableIsRefreshing = NO;
        findSkillTableView.pullTableIsLoadingMore = NO;
    }];
}

// 获取任务分类
-(void)didGetTaskCatalogIsloading:(BOOL )isloading{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:URL_GET_TASK_CATALOG params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            task_catalogs = [result objectForKey:@"catalogs"];
            [ghunterRequester setCacheTime:[ghunterRequester getTimeNow] withKey:TASK_CATALOG_TIME];
            [ghunterRequester setCacheContent:task_catalogs withKey:TASK_CATALOG];
        }else{
            
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}

// 获取技能分类
-(void)didGetSkillCatalogIsloading:(BOOL )isloading{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:URL_GET_SKILL_TAG params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            skill_catalogs = [result objectForKey:@"skills"];
            [ghunterRequester setCacheTime:[ghunterRequester getTimeNow] withKey:SKILL_TAG_TIME];
            [ghunterRequester setCacheContent:skill_catalogs withKey:SKILL_TAG];
        }else{
            
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTask" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshSkill" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IOS8 map

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self endLoad];
}

#pragma mark - Baidu Map
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [self endLoad];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法定位，请检查网络或到设置->隐私->定位服务->赏金猎人打开定位服务" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Custom Methods

- (void)iconTaped:(UITapGestureRecognizer *)sender {
    NSDictionary* skill;
    NSDictionary *task;
    if(scrollView.contentOffset.x==mainScreenWidth)
    {
        skill=[self.findskillArray objectAtIndex:sender.view.tag];
    }
    else
    {
        task= [self.findtaskArray objectAtIndex:sender.view.tag];
    }
    ghunterUserCenterViewController *user = [[ghunterUserCenterViewController alloc] init];
    if(scrollView.contentOffset.x==0)
    {
        user.uid = [[task objectForKey:@"owner"] objectForKey:@"uid"];
    }
    else
    {
        user.uid=[[skill objectForKey:@"owner"] objectForKey:@"uid"];
    }
    [self.navigationController pushViewController:user animated:YES];
}

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}

// 点击顶部“任务”，获取任务列表
- (void)click2ShowTask {
    self.strtit = @"";
    taskCid = @"0";
    taskpage = 1;
    taskRadio.selected = YES;
    skillRadio.selected = NO;
    if (showList || showList2) {
        showList = NO;
        showList2 = NO;
        [listview removeFromSuperview];
        [view removeFromSuperview];
        if ([self.strtit isEqualToString:@""]||self.strtit == nil) {
            [filter setTitle:@"最新发布" forState:(UIControlStateNormal)];
        }
        [filter setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
        [filter setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
        [filter setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeTo.width*2+15, 5, 0)];
        if ([self.strtit isEqualToString:@""]||self.strtit == nil) {
            [sortbtn setTitle:@"全部分类" forState:(UIControlStateNormal)];
            
        }
        
        
        [sortbtn setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
        [sortbtn setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
        [sortbtn setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeOne.width *2+15, 5, 0)];
        
    }
    self.swapByTapButton = YES;
    [taskRadio setSelected:YES];
    [skillRadio setSelected:NO];
    [UIView animateWithDuration:0.2 animations:^{
        Monitor *ggs = [Monitor sharedInstance];
        ggs.ggzhi = @"任务";
        Monitor *ggs2 = [Monitor sharedInstance];
        ggs2.fenzhi = @"renwu";
        [_topBGSliderImageView setFrame:taskRadio.frame];
        [zongarr removeAllObjects];
        [zongimgarr removeAllObjects];
        [self paixurenwu];
        [listview reloadData];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } completion:^(BOOL finished) {
        if (self.firstTimeShowTaskTableView) {
            [self didGetTaskListIsloading:YES withPage:taskpage andType:self.taskType andCatalogID:taskCid];
            
            self.firstTimeShowTaskTableView = NO;
        }
    }];
    [self didGetTaskListIsloading:YES withPage:taskpage andType:self.taskType andCatalogID:taskCid];
    self.firstTimeShowTaskTableView = NO;

    [listview reloadData];
    
}

// 点击顶部的“技能”按钮，获取技能列表
- (void)click2ShowSkillshow{
    self.strtit=@"";
    skillCid = @"0";
    skillpage = 1;
    skillRadio.selected = YES;
    taskRadio.selected = NO;
    if (showList || showList2) {
        showList = NO;
        showList2 = NO;
        [listview removeFromSuperview];
        [view removeFromSuperview];
        if ([self.strtit isEqualToString:@""]||self.strtit == nil) {
            [filter setTitle:@"最新发布" forState:(UIControlStateNormal)];
        }
        [filter setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
        [filter setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
        [filter setImageEdgeInsets:UIEdgeInsetsMake(5, contentSizeTo.width*2+15, 5, 0)];
        
        if ([self.strtit isEqualToString:@""]||self.strtit == nil) {
            [sortbtn setTitle:@"全部分类" forState:(UIControlStateNormal)];
            
        }
        contentSizeOne = [sortbtn.titleLabel.text sizeWithFont:sortbtn.titleLabel.font];
        
        [sortbtn setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
        [sortbtn setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
        [sortbtn setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeOne.width *2+15, 5, 0)];
        
    }
    
    self.swapByTapButton = YES;
    [taskRadio setSelected:NO];
    [skillRadio setSelected:YES];
    [UIView animateWithDuration:0.2 animations:^{
        Monitor *ggs = [Monitor sharedInstance];
        ggs.ggzhi = @"技能";
        Monitor *ggs2 = [Monitor sharedInstance];
        ggs2.fenzhi = @"jineng";
        [_topBGSliderImageView setFrame:skillRadio.frame];
        [zongarr removeAllObjects];
        [zongimgarr removeAllObjects];
        [self paixujineng];
        [listview reloadData];
        [scrollView setContentOffset:CGPointMake(mainScreenWidth, 0) animated:YES];
    } completion:^(BOOL finished) {
        if (self.firstTimeShowSkillTableView) {
            [self didGetSkillListIsloading:YES withPage:skillpage andType:self.skillType andCatalogID:skillCid];
            self.firstTimeShowSkillTableView = NO;
        }
    }];
    [self didGetSkillListIsloading:YES withPage:skillpage andType:self.skillType andCatalogID:skillCid];
    self.firstTimeShowSkillTableView = NO;

    [listview reloadData];
    
}

- (IBAction)filter {
    if (showList == YES) {
        [sortbtn setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
        [sortbtn setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
        [sortbtn setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeOne.width *2+15, 5, 0)];
        [view removeFromSuperview];
        [listview removeFromSuperview];
        showList = NO;
    }else {
        [listview reloadData];
        taskpage = 1;
        skillpage = 1;
        Monitor *ggs = [Monitor sharedInstance];
        ggs.ggzhi = @"发布";
        [zongimgarr removeAllObjects];
        [zongarr removeAllObjects];
        [self fabu];
        CGRect listfram = listview.frame;
        listfram.size.height = zongarr.count*40;
        listview.frame =listfram;
        [listview reloadData];
        
        if (showList2==NO) {
            [filter setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
            [filter setImage:[UIImage imageNamed:@"小三角-拷贝"] forState:UIControlStateNormal];
            [filter setImageEdgeInsets:UIEdgeInsetsMake(5, contentSizeTo.width*2+15, 5, 0)];
            [self.view addSubview:view];
            [self.view addSubview:listview];
            showList2=YES;
        }
        else
        {
            [filter setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
            [filter setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
            [filter setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeTo.width*2+15, 5, 0)];
            [view removeFromSuperview];
            [listview removeFromSuperview];
            showList2=NO;
        }
        
    }
}

#pragma mark - catalog&delegate
// 筛选分类
- (void)sortBtn:(UIButton *)sender {
    contentSizeOne = [sortbtn.titleLabel.text sizeWithFont:sortbtn.titleLabel.font];
    if (showList2 == YES) {
        [filter setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
        [filter setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
        [filter setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeTo.width*2+15, 5, 0)];
        [view removeFromSuperview];
        [listview removeFromSuperview];
        showList2=NO;
    }else {
        taskpage = 1;
        skillpage = 1;
        [listview reloadData];
        if ([[Monitor sharedInstance].fenzhi isEqualToString:@""]||[Monitor sharedInstance].fenzhi==nil) {
            Monitor *ggs = [Monitor sharedInstance];
            ggs.ggzhi = @"任务";
            [self paixurenwu];
        }
        if ([[Monitor sharedInstance].fenzhi isEqualToString:@"renwu"]) {
            [zongarr removeAllObjects];
            [zongimgarr removeAllObjects];
            [self paixurenwu];
            CGRect listfram = listview.frame;
            listfram.size.height = zongarr.count*40;
            listview.frame =listfram;
            [listview reloadData];
        }
        if ([[Monitor sharedInstance].fenzhi isEqualToString:@"jineng"]) {
            [zongarr removeAllObjects];
            [zongimgarr removeAllObjects];
            Monitor *ggs = [Monitor sharedInstance];
            ggs.ggzhi = @"技能";
            [self paixujineng];
            CGRect listfram = listview.frame;
            listfram.size.height = zongarr.count*40;
            listview.frame =listfram;
            [listview reloadData];
        }
        if (showList==NO) {
            [sortbtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
            [sortbtn setImage:[UIImage imageNamed:@"小三角-拷贝"] forState:UIControlStateNormal];
            
            [sortbtn setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeOne.width*2+15, 5, 0)];
            
            
            [self.view addSubview:view];
            [self.view addSubview:listview];
            listview.separatorStyle = UITableViewCellSeparatorStyleNone;
            showList=YES;
        }
        else
        {
            [sortbtn setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
            [sortbtn setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
            
            [sortbtn setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeOne.width*2+15, 5, 0)];
            
            [view removeFromSuperview];
            [listview removeFromSuperview];
            showList=NO;
        }
    }
}

-(void)viewtouch:(UITapGestureRecognizer *)tap{
    showList = NO;
    showList2 = NO;
    [listview removeFromSuperview];
    [view removeFromSuperview];
    [filter setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
    [filter setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
    [filter setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeTo.width*2+15, 5, 0)];
    [sortbtn setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
    [sortbtn setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
    [sortbtn setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeOne.width*2+15, 5, 0)];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.swapByTapButton) {
        CGPoint skillViewOrigin = [findSkillTableView convertPoint:CGPointMake(0, 0) toView:self.view];
        if (skillViewOrigin.x >= mainScreenWidth * 0.5) {
            [taskRadio setSelected:YES];
            [skillRadio setSelected:NO];
            
            [UIView animateWithDuration:0.2 animations:^{
                Monitor *ggs = [Monitor sharedInstance];
                ggs.ggzhi = @"任务";
                Monitor *ggs2 = [Monitor sharedInstance];
                ggs2.fenzhi = @"renwu";
                [_topBGSliderImageView setFrame:taskRadio.frame];
                [zongarr removeAllObjects];
                [zongimgarr removeAllObjects];
                [self paixurenwu];
                
                [listview reloadData];
            }];
        }
        else {
            [taskRadio setSelected:NO];
            [skillRadio setSelected:YES];
            
            [UIView animateWithDuration:0.2 animations:^{
                Monitor *ggs = [Monitor sharedInstance];
                ggs.ggzhi = @"技能";
                Monitor *ggs2 = [Monitor sharedInstance];
                ggs2.fenzhi = @"jineng";
                [_topBGSliderImageView setFrame:skillRadio.frame];
                [zongarr removeAllObjects];
                [zongimgarr removeAllObjects];
                [self paixujineng];
                [listview reloadData];
            }];
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.x && self.firstTimeShowSkillTableView){
        [self didGetSkillListIsloading:YES withPage:skillpage andType:self.skillType andCatalogID:skillCid];
        self.firstTimeShowSkillTableView = NO;
    }
    else if (!scrollView.contentOffset.x && self.firstTimeShowTaskTableView) {
        [self didGetTaskListIsloading:YES withPage:taskpage andType:self.taskType andCatalogID:taskCid];
        self.firstTimeShowTaskTableView = NO;
    }
    self.swapByTapButton = NO;
}

-(void)setCodeint:(NSInteger)codeint{
    
    if (codeint == _codeint) return;
    
    _codeint = codeint;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:codeint inSection:0];
    [listview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [listview reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView ==listview) {
        self.codeint = indexPath.row;
        if ([[Monitor sharedInstance].ggzhi isEqualToString:@""]||[Monitor sharedInstance].ggzhi==nil) {
            [zongarr removeAllObjects];
            [self paixurenwu];
            self.strtit = [NSString stringWithFormat:@"%@",[zongarr objectAtIndex:self.codeint]];
            [sortbtn setTitle:self.strtit forState:(UIControlStateNormal)];
        }
        
        if ([[Monitor sharedInstance].ggzhi isEqualToString:@"任务"]) {
            [zongarr removeAllObjects];
            [self paixurenwu];
            _strtit = [NSString stringWithFormat:@"%@",[zongarr objectAtIndex:self.codeint]];
            [sortbtn setTitle:self.strtit forState:(UIControlStateNormal)];
            contentSizeOne = [sortbtn.titleLabel.text sizeWithFont:sortbtn.titleLabel.font];
            
            taskpage = 1;
            Taskarray = [NSArray arrayWithObjects:@"0",@"2",@"5",@"8",@"10",@"17",@"21",@"28",@"52", nil];
            
            [self didGetTaskListIsloading:YES withPage:taskpage andType:self.taskType andCatalogID:[Taskarray objectAtIndex:indexPath.row]];
            
            _zhistr =[Taskarray objectAtIndex:indexPath.row];
            
            [sortbtn setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
            [sortbtn setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
            
            [sortbtn setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeOne.width*2+15, 5, 0)];
        }
        if ([[Monitor sharedInstance].ggzhi isEqualToString:@"技能"]) {
            [zongarr removeAllObjects];
            [self paixujineng];
            _strtit = [NSString stringWithFormat:@"%@",[zongarr objectAtIndex:self.codeint]];
            [sortbtn setTitle:self.strtit forState:(UIControlStateNormal)];
            contentSizeOne = [sortbtn.titleLabel.text sizeWithFont:sortbtn.titleLabel.font];
            
            skillpage = 1;
            self.skillType = TASK_SKILL_TYPE_NEAREST;
            skillarray = [NSArray arrayWithObjects:@"0",@"3",@"4",@"10",@"27",@"31",@"35",@"52",@"40", nil];
            [self didGetSkillListIsloading:YES withPage:skillpage andType:self.skillType andCatalogID:[skillarray objectAtIndex:indexPath.row]];
            
            _zhistr =[skillarray objectAtIndex:indexPath.row];
            
            [sortbtn setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
            [sortbtn setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
            [sortbtn setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeOne.width*2+15, 5, 0)];
        }
        if ([[Monitor sharedInstance].ggzhi isEqualToString:@"发布"]) {
            [zongarr removeAllObjects];
            [self fabu];
            self.strtit = [NSString stringWithFormat:@"%@",[zongarr objectAtIndex:self.codeint]];
            [filter setTitle:self.strtit forState:(UIControlStateNormal)];
            
            if (indexPath.row==0) {
                // 时间
                if ([[Monitor sharedInstance].fenzhi isEqualToString:@"renwu"]||[Monitor sharedInstance].fenzhi==nil) {
                    taskpage = 1;
                    self.taskType = TASK_SKILL_TYPE_LATEST;
                    [self didGetTaskListIsloading:YES withPage:taskpage andType:self.taskType andCatalogID:_zhistr];
                }else{
                    skillpage = 1;
                    self.skillType = TASK_SKILL_TYPE_LATEST;
                    [self didGetSkillListIsloading:YES withPage:skillpage andType:self.taskType andCatalogID:_zhistr];
                }
            }else if (indexPath.row==1) {
                // 距离
                if ([[Monitor sharedInstance].fenzhi isEqualToString:@"renwu"]||[Monitor sharedInstance].fenzhi==nil) {
                    taskpage = 1;
                    self.taskType = TASK_SKILL_TYPE_NEAREST;
                    [self didGetTaskListIsloading:YES withPage:taskpage andType:self.taskType andCatalogID:self.zhistr];
                }else{
                    skillpage = 1;
                    self.skillType = TASK_SKILL_TYPE_NEAREST;
                    [self didGetSkillListIsloading:YES withPage:skillpage andType:self.skillType andCatalogID:self.zhistr];
                }
            }else if (indexPath.row==2) {
                // 赏金、售价
                if ([[Monitor sharedInstance].fenzhi isEqualToString:@"renwu"]||[Monitor sharedInstance].fenzhi==nil) {
                    taskpage = 1;
                    self.taskType = TASK_SKILL_TYPE_BOUNTHIGH;
                    [self didGetTaskListIsloading:YES withPage:taskpage andType:self.taskType andCatalogID:_zhistr];
                }else{
                    skillpage = 1;
                    self.skillType = TASK_SKILL_TYPE_PRICEHIGH;
                    [self didGetSkillListIsloading:YES withPage:skillpage andType:self.skillType andCatalogID:_zhistr];
                }
            }else if (indexPath.row==3) {
                // 热度最高
                if ([[Monitor sharedInstance].fenzhi isEqualToString:@"renwu"]||[Monitor sharedInstance].fenzhi==nil) {
                    taskpage = 1;
                    self.taskType= TASK_SKILL_TYPE_HOTEST;
                    [self didGetTaskListIsloading:YES withPage:taskpage andType:self.taskType andCatalogID:_zhistr];
                }else{
                    skillpage = 1;
                    self.skillType= TASK_SKILL_TYPE_HOTEST;
                    [self didGetSkillListIsloading:YES withPage:skillpage andType:self.skillType andCatalogID:_zhistr];
                }
            }
        }
        
        [listview removeFromSuperview];
        [view removeFromSuperview];
        [filter setTitleColor:RGBCOLOR(51, 51, 51) forState:(UIControlStateNormal)];
        [filter setImage:[UIImage imageNamed:@"小三角"] forState:UIControlStateNormal];
        [filter setImageEdgeInsets:UIEdgeInsetsMake(5,contentSizeTo.width*2+15, 5, 0)];
        
    }
    if(tableView == findTaskTableView){
        ghuntertaskViewController *ghuntertask = [[ghuntertaskViewController alloc] init];
        NSDictionary *task = [self.findtaskArray objectAtIndex:indexPath.row];
        ghuntertask.tid = [task objectForKey:@"tid"];
        ghuntertask.callBackBlock = ^{};
        [self.navigationController pushViewController:ghuntertask animated:YES];
    }else if (tableView == findSkillTableView){
        NSDictionary *skill = [self.findskillArray objectAtIndex:indexPath.row];
        ghunterSkillViewController *skillView = [[ghunterSkillViewController alloc] init];
        skillView.skillid=[skill objectForKey:@"sid"];
        skillView.callBackBlock = ^{};
        [self.navigationController pushViewController:skillView animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == findTaskTableView){
        return [self.findtaskArray count];
    }
    if(tableView == findSkillTableView){
        return [self.findskillArray count];
    }
    if (tableView == listview) {
        return zongarr.count;
    }
    return 0;
}

#pragma mark - UITableVIewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView ==listview) {
        return 40;
    }else{
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.bounds.size.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else {
        while ([cell.contentView.subviews lastObject]) {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (tableView ==listview) {
        UILabel *gryline=[[UILabel alloc]initWithFrame:CGRectMake(40, 39, mainScreenWidth, 0.5)];
        gryline.backgroundColor = RGBCOLOR(235, 235, 235);
        [cell addSubview:gryline];
        UILabel *txtbel = [[UILabel alloc]initWithFrame:CGRectMake(40, 7, 100, 25)];
        txtbel.text = [zongarr objectAtIndex:indexPath.row];
        txtbel.textColor = RGBCOLOR(66, 66, 66);
        txtbel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:txtbel];
        NSString * imgstr= [NSString stringWithFormat:@"%@",[zongimgarr objectAtIndex:indexPath.row]];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 7, 21, 21)];
        img.image = [UIImage imageNamed:imgstr];
        [cell.contentView addSubview:img];
        duiimg = [[UIImageView alloc]initWithFrame:CGRectMake(mainScreenWidth-25, 15, 15, 10)];
        duiimg.tag = 100;
        duiimg.hidden = YES;
        duiimg.image = [UIImage imageNamed:@"对号"];
        [cell.contentView addSubview:duiimg];
        
        
        if (indexPath.row == self.codeint) {
            duiimg.hidden = NO;
        }
        
        return cell;
    }
    if(tableView == findTaskTableView){
        NSDictionary *task = [self.findtaskArray objectAtIndex:indexPath.row];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"nearbyTaskCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *owner = [task objectForKey:@"owner"];
        
        //        OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:3];
        UIImageView *huntericon = (UIImageView *)[cell viewWithTag:4];
        //        UILabel *distance = (UILabel *)[cell viewWithTag:5];
        UILabel *huntername = (UILabel *)[cell viewWithTag:6];
        UILabel *dateline = (UILabel *)[cell viewWithTag:7];
        UILabel *bidnum = (UILabel *)[cell viewWithTag:8];
        UILabel *hot = (UILabel *)[cell viewWithTag:9];
        //        UIImageView *gender = (UIImageView *)[cell viewWithTag:10];
        //        UIView *bg = (UIView *)[cell viewWithTag:12];
        //        UIImageView *bountyImage = (UIImageView *)[cell viewWithTag:13];
        //        UILabel* goldLabel=(UILabel*)[cell viewWithTag:99];
        UILabel *tabbartxt  = (UILabel *)[cell viewWithTag:110];
        UIImageView *img2= (UIImageView *)[cell viewWithTag:111];
        
        UIView* ageview=(UIView*)[cell viewWithTag:54];
        ageview.layer.cornerRadius = 2.0;
        
        // 移除虚线
        //        UILabel * xuxianLb = (UILabel *)[cell viewWithTag:999];
        //        [xuxianLb removeFromSuperview];
        
        if ([[[self.findtaskArray objectAtIndex:indexPath.row] objectForKey:@"istop"] intValue]==1) {
            UIImageView *redtabbar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
            redtabbar.image = [UIImage imageNamed:@"推荐"];
            [cell.contentView addSubview:redtabbar];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 20, 10)];
            label.text = @"推荐";
            label.font = [UIFont systemFontOfSize:8];
            label.textColor=[UIColor whiteColor];
            [redtabbar addSubview:label];
        }
        
        img2.hidden = YES;
        
        huntericon.layer.masksToBounds =YES;
        huntericon.layer.cornerRadius = 25;
        [huntericon sd_setImageWithURL:[owner objectForKey:@"middle_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        huntericon.userInteractionEnabled = YES;
        huntericon.tag = indexPath.row;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
        [huntericon addGestureRecognizer:tap];
        
        UILabel * distance = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 66, 15)];
        [cell addSubview:distance];
        // 计算距离
        NSString *distancestar = [ghunterRequester calculateDistanceWithLatitude:[task objectForKey:@"latitude"] withLongitude:[task objectForKey:@"longitude"]];
        [distance setText:distancestar];
        distance.textColor = RGBCOLOR(153, 153, 153);
        distance.font = [UIFont systemFontOfSize:10];
        //        NSString *nameStr = [owner objectForKey:@"username"];
        //        CGSize nameSize = [nameStr sizeWithFont:huntername.font];
        CGRect nameFrame = huntername.frame;
        nameFrame.origin.x = huntericon.frame.size.width + huntericon.frame.origin.x + 10;
        huntername.frame = nameFrame;
        [huntername setText:[owner objectForKey:@"username"]];
        huntername.font = [UIFont systemFontOfSize:12];
        
        [dateline setText:[ghunterRequester getTimeDescripton:[task objectForKey:@"dateline"]]];
        [bidnum setText:[NSString stringWithFormat:@"%@人竞标",[task objectForKey:@"biddingnum"]]];
        [hot setText:[NSString stringWithFormat:@"%@热度",[task objectForKey:@"hot"]]];
        
        UIImageView * gender = [[UIImageView alloc] initWithFrame:CGRectMake(73, 44, 8, 8)];
        [cell addSubview:gender];
        CGRect genderFrame = gender.frame;
        genderFrame.origin.x = huntericon.frame.size.width + huntericon.frame.origin.x + 13;
        genderFrame.origin.y = huntername.frame.origin.y + huntername.frame.size.height + 5;
        gender.frame = genderFrame;
        
        if([[owner objectForKey:@"sex"] isEqualToString:@"0"]){
            [gender setImage:[UIImage imageNamed:@"female"]];
        }else{
            [gender setImage:[UIImage imageNamed:@"male"]];
        }
        
        //        distance.backgroundColor = [UIColor redColor];
        CGRect distanceFrame = distance.frame;
        distanceFrame.origin.x = gender.frame.origin.x + gender.frame.size.width + 5;
        distanceFrame.origin.y = huntername.frame.origin.y + huntername.frame.size.height + 2;
        distance.frame = distanceFrame;
        
        NSString *titleStr = [task objectForKey:@"title"];
        // 内容
        UILabel * titleLb = [[UILabel alloc] initWithFrame:CGRectMake(huntername.frame.origin.x + tabbartxt.frame.size.width - 10, distance.frame.origin.y + distance.frame.size.height + 5, mainScreenWidth - 10 - huntername.frame.origin.x - 20 - 10 - 10, 20)];
        [titleLb setFont:[UIFont systemFontOfSize:14]];
        titleLb.textColor = RGBCOLOR(51, 51, 51);
        titleLb.numberOfLines = 1;
        [titleLb setText:titleStr];
        [cell addSubview:titleLb];
        
        NSString*string =[task objectForKey:@"color"];
        NSString *b = [string substringFromIndex:0];
        NSString *colorstr = [NSString stringWithFormat:@"0x%@",b];
        tabbartxt.textColor = [Monitor colorWithHexString:colorstr alpha:1.0f];
        tabbartxt.font = [UIFont systemFontOfSize:10];
        tabbartxt.clipsToBounds = YES;
        tabbartxt.layer.cornerRadius = 3.0;
        tabbartxt.text = [task objectForKey:@"c_name"];
        [tabbartxt.layer setBorderWidth:0.5];   //边框宽度
        tabbartxt.textAlignment = NSTextAlignmentCenter;
        [tabbartxt.layer setBorderColor:[Monitor colorWithHexString:colorstr alpha:1.0f].CGColor];//边框颜色
        
        NSString *LENstr = [task objectForKey:@"c_name"];
        CGRect tabbartxtFrame = tabbartxt.frame;
        tabbartxtFrame.origin.x = huntername.frame.origin.x;
        tabbartxtFrame.origin.y = gender.frame.origin.y + gender.frame.size.height + 10;
        
        if ([LENstr length]>1) {
            tabbartxtFrame.size.width =25;
        }
        if ([LENstr length]>2) {
            tabbartxtFrame.size.width =35;
        }
        if ([LENstr length]>3) {
            tabbartxtFrame.size.width = 45;
        }
        tabbartxt.frame = tabbartxtFrame;
        //        tabbartxt.backgroundColor = [UIColor redColor];
        
        CGRect titleFrame = titleLb.frame;
        titleFrame.origin.x = tabbartxt.frame.origin.x + tabbartxt.frame.size.width + 5;
        titleLb.frame = titleFrame;
        
        UILabel * bounty = [[UILabel alloc] initWithFrame:CGRectMake(100, huntername.frame.origin.y +  6, 100, 20)];
        [cell.contentView addSubview:bounty];
        bounty.font = [UIFont systemFontOfSize:14];
        bounty.textColor = RGBCOLOR(234, 85, 20);
        
        // 元
        NSString *bountySelf = [task objectForKey:@"bounty"];
        NSString *bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
        CGSize bountySize = [bountyStr sizeWithFont:bounty.font];
        bounty.text = bountyStr;
        CGRect bountyFrame = bounty.frame;
        bountyFrame.size.width = bountySize.width;
        bountyFrame.origin.x = mainScreenWidth - bountySize.width - 10;
        bounty.frame = bountyFrame;
        
        UILabel * goldLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, huntername.frame.origin.y, 26, 26)];
        [cell.contentView addSubview:goldLabel];
        goldLabel.text = @"赏";
        goldLabel.textAlignment = NSTextAlignmentCenter;
        goldLabel.textColor = RGBCOLOR(234, 85, 20);
        goldLabel.layer.cornerRadius = goldLabel.frame.size.width / 2;
        goldLabel.clipsToBounds = YES;
        [goldLabel.layer setBorderWidth:1.0f];
        [goldLabel.layer setBorderColor:RGBCOLOR(234, 85, 20).CGColor];
        
        // 赏字位置
        CGRect goldLbFrame = goldLabel.frame;
        goldLbFrame.origin.x = bounty.frame.origin.x - 10 - goldLabel.frame.size.width;
        goldLbFrame.origin.y = huntername.frame.origin.y + 3;
        goldLabel.font = [UIFont systemFontOfSize:12];
        goldLabel.frame = goldLbFrame;
        
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
        
        CGFloat height = tabbartxt.frame.origin.y + tabbartxt.frame.size.height + 10;
        
        bidImgVFrame.origin.x = tabbartxt.frame.origin.x;
        bidImgVFrame.origin.y = height;
        hotImgVFrame.origin.x = tabbartxt.frame.origin.x + 80;
        hotImgVFrame.origin.y = height;
        timeImgVFrame.origin.x =tabbartxt.frame.origin.x + 160;
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = dateline.frame.size.height + dateline.frame.origin.y + 10;
        cell.frame = cellFrame;
        
    }
    else if (tableView == findSkillTableView){
        NSDictionary *skill = [self.findskillArray objectAtIndex:indexPath.row];
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"skillCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *owner = [skill objectForKey:@"owner"];
        //        图片内容
        UIImageView *imagetent = (UIImageView *)[cell viewWithTag:111];
        [imagetent sd_setImageWithURL:[skill objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        imagetent.clipsToBounds = YES;
        imagetent.layer.cornerRadius = 3.0;
        CGRect imageFrame = imagetent.frame;
        imageFrame.origin.x = mainScreenWidth - imagetent.frame.size.width - 10;
        imagetent.frame = imageFrame;
        
        //        UILabel *title = (UILabel *)[cell viewWithTag:2];
        //        OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:333];
        UIImageView *huntericon = (UIImageView *)[cell viewWithTag:4];
        //        UILabel *distance = (UILabel *)[cell viewWithTag:5];
        UILabel *huntername = (UILabel *)[cell viewWithTag:6];
        UILabel *dateline = (UILabel *)[cell viewWithTag:7];
        UILabel *bidnum = (UILabel *)[cell viewWithTag:8];
        UILabel *hot = (UILabel *)[cell viewWithTag:9];
        //        UIImageView *gender = (UIImageView *)[cell viewWithTag:10];
        //        UILabel *age = (UILabel *)[cell viewWithTag:11];
        UIView *bg = (UIView *)[cell viewWithTag:12];
        UIImageView *bountyImage = (UIImageView *)[cell viewWithTag:19];
        //        UILabel* goldLabel=(UILabel*)[cell viewWithTag:29];
        UIView* ageview=(UIView*)[cell viewWithTag:54];
        //        [title setFrame:titleFrame];
        
        CGRect huntericonfram = huntericon.frame;
        huntericonfram.origin.y = cell.frame.origin.x+15;
        huntericon.frame = huntericonfram;
        if ([[[self.findskillArray objectAtIndex:indexPath.row] objectForKey:@"istop"] intValue]==1) {
            UIImageView *redtabbar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
            redtabbar.image = [UIImage imageNamed:@"推荐"];
            [cell.contentView addSubview:redtabbar];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 20, 10)];
            label.text = @"推荐";
            label.font = [UIFont systemFontOfSize:8];
            label.textColor=[UIColor whiteColor];
            [redtabbar addSubview:label];
        }
        huntericon.layer.masksToBounds =YES;
        huntericon.layer.cornerRadius = 25;
        [huntericon sd_setImageWithURL:[owner objectForKey:@"avatar"]placeholderImage:[UIImage imageNamed:@"avatar"]];
        huntericon.userInteractionEnabled = YES;
        huntericon.tag = indexPath.row;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
        [huntericon addGestureRecognizer:tap];
        
        UILabel * distance = [[UILabel alloc] initWithFrame:CGRectMake(70, 43, 66, 15)];
        [cell addSubview:distance];
        NSString *distancestar = [ghunterRequester calculateDistanceWithLatitude:[skill objectForKey:@"latitude"] withLongitude:[skill objectForKey:@"longitude"]];
        [distance setText:distancestar];
        distance.textColor = RGBCOLOR(153, 153, 153);
        distance.font = [UIFont systemFontOfSize:10];
        
        [huntername setText:[owner objectForKey:@"username"]];
        huntername.font = [UIFont systemFontOfSize:12];
        [dateline setText:[ghunterRequester getTimeDescripton:[skill objectForKey:@"dateline"]]];
        [bidnum setText:[NSString stringWithFormat:@"%@人购买",[skill objectForKey:@"salenum"]]];
        [hot setText:[NSString stringWithFormat:@"%@热度",[skill objectForKey:@"hot"]]];
        
        UIImageView * gender = [[UIImageView alloc] initWithFrame:CGRectMake(73, 47, 8, 8)];
        [cell addSubview:gender];
        CGRect genderFrame = gender.frame;
        genderFrame.origin.x = huntername.frame.origin.x;
        genderFrame.origin.y = huntername.frame.size.height + huntername.frame.origin.y + 5;
        gender.frame = genderFrame;
        
        if([[owner objectForKey:@"sex"] isEqualToString:@"0"]){
            [gender setImage:[UIImage imageNamed:@"female"]];
        }else{
            [gender setImage:[UIImage imageNamed:@"male"]];
        }
        
        ageview.layer.cornerRadius = 2.0;
        CGRect distanceFrame = distance.frame;
        distanceFrame.origin.x = gender.frame.origin.x + gender.frame.size.width + 5;
        distanceFrame.origin.y = huntername.frame.origin.y + huntername.frame.size.height + 2;
        distance.frame = distanceFrame;
        
        // 标签
        UILabel * tabbartxt = [[UILabel alloc] initWithFrame:CGRectMake(10, huntericon.frame.origin.y + huntericon.frame.size.height + 8, 40, 20)];
        [cell.contentView addSubview:tabbartxt];
        tabbartxt.textAlignment = NSTextAlignmentCenter;
        NSString*string =[skill objectForKey:@"color"];
        NSString *b = [string substringFromIndex:0];
        NSString *colorstr = [NSString stringWithFormat:@"0x%@",b];
        tabbartxt.textColor =  [Monitor colorWithHexString:colorstr alpha:1.0f];
        tabbartxt.font = [UIFont systemFontOfSize:10];
        [tabbartxt.layer setBorderWidth:0.5];   //边框宽度
        tabbartxt.clipsToBounds = YES;
        tabbartxt.text = [skill objectForKey:@"c_name"];
        tabbartxt.layer.cornerRadius = 3.0;
        tabbartxt.textAlignment = NSTextAlignmentCenter;
        [tabbartxt.layer setBorderColor:[Monitor colorWithHexString:colorstr alpha:1.0f].CGColor];//边框颜色
        
        NSString *LENstr = [skill objectForKey:@"c_name"];
        
        CGRect tabbartxtFrame = tabbartxt.frame;
        tabbartxtFrame.origin.y = huntericon.frame.size.height + huntericon.frame.origin.y + 3;
        if ([LENstr length]>1) {
            tabbartxtFrame.size.width = 25;
        }
        if ([LENstr length]>2) {
            tabbartxtFrame.size.width = 35;
        }
        if ([LENstr length]>3) {
            tabbartxtFrame.size.width = 45;
        }
        tabbartxt.frame = tabbartxtFrame;
        
        // 内容
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(100, tabbartxt.frame.origin.y, mainScreenWidth - imagetent.frame.size.width - 30 - huntericon.frame.size.width, 20)];
        [cell.contentView addSubview:title];
        title.font = [UIFont systemFontOfSize:14];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = RGBCOLOR(51, 51, 51);
        NSString *titleStr = [skill objectForKey:@"skill"];
        CGRect titleFrame = title.frame;
        CGSize titleSize = [titleStr sizeWithFont:title.font constrainedToSize:CGSizeMake(title.frame.size.width,MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat titleDiff = titleSize.height - titleFrame.size.height;
        
        titleFrame.size.height = titleSize.height;
        titleFrame.origin.x = huntername.frame.origin.x;
        titleFrame.origin.y = tabbartxtFrame.origin.y;
        title.frame = titleFrame;
        //        title.lineBreakMode = 0;
        //        title.numberOfLines = 1;
        [title setText:titleStr];
        
        NSString *bountySelf = [skill objectForKey:@"price"];
        NSString *priceinit = [skill objectForKey:@"priceunit"];
        NSString *bountyStr = [NSString stringWithFormat:@"%@元/%@",bountySelf,priceinit];
        
        //
        UILabel * bounty = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth - 100, 30, 80, 25)];
        bounty.font = [UIFont systemFontOfSize:12];
        bounty.textColor = RGBCOLOR(234, 85, 20);
        bounty.text = bountyStr;
        CGSize bountySize = [bountyStr sizeWithFont:bounty.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
        [cell addSubview:bounty];
        
        UILabel * goldLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth - 100, 30, 23, 23)];
        goldLabel.text=@"售";
        goldLabel.textAlignment = NSTextAlignmentCenter;
        goldLabel.textColor = RGBCOLOR(234, 85, 20);
        goldLabel.clipsToBounds = YES;
        goldLabel.layer.cornerRadius = goldLabel.frame.size.width / 2;
        [goldLabel.layer setBorderWidth:1.0];
        [goldLabel.layer setBorderColor:RGBCOLOR(234, 85, 20).CGColor];
        goldLabel.font = [UIFont systemFontOfSize:12];
        bg.layer.cornerRadius = Radius;
        bounty.textAlignment = NSTextAlignmentRight;
        [cell addSubview:goldLabel];
        
        // 元
        CGRect attLbStrFrame = bounty.frame;
        attLbStrFrame.size.width = bountySize.width;
        attLbStrFrame.origin.x = mainScreenWidth - bountySize.width - 10;
        attLbStrFrame.origin.y = huntername.frame.origin.y - 5;
        bounty.frame = attLbStrFrame;
        
        // 售字位置
        CGRect goldLbFrame = goldLabel.frame;
        goldLbFrame.origin.x = mainScreenWidth - bountySize.width - 10 - goldLabel.frame.size.width - 10;
        goldLbFrame.origin.y = huntername.frame.origin.y - 4;
        goldLabel.frame = goldLbFrame;
        
        //
        NSString *nameStr = [owner objectForKey:@"username"];
        CGSize nameSize = [nameStr sizeWithFont:huntername.font];
        CGRect nameFrame = huntername.frame;
        if (nameFrame.origin.x + nameSize.width > bountyImage.frame.origin.x) {
            nameFrame.size.width = bountyImage.frame.origin.x - nameFrame.origin.x;
        }
        huntername.frame = nameFrame;
        
        // 虚线
        UILabel * xuxianLb = (UILabel *)[cell viewWithTag:999];
        CGRect xuxianFrame = xuxianLb.frame;
        xuxianFrame.origin.y = tabbartxt.frame.origin.y - 5;
        xuxianLb.frame = xuxianFrame;
        
        CGRect cellFrame = cell.frame;
        cellFrame.size.height += titleDiff+6;
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
    if(scrollView.contentOffset.x == 0){
        taskpage = 1;
        [self didGetTaskListIsloading:NO withPage:taskpage andType:self.taskType andCatalogID:taskCid];
    }else if (scrollView.contentOffset.x == mainScreenWidth){
        skillpage = 1;
        [self didGetSkillListIsloading:NO withPage:skillpage andType:self.skillType andCatalogID:skillCid];
    }
}

- (void)loadMoreDataToTable
{
    if(scrollView.contentOffset.x == 0){
        [self didGetTaskListIsloading:NO withPage:taskpage andType:self.taskType andCatalogID:taskCid];
    }else if (scrollView.contentOffset.x == mainScreenWidth){
        [self didGetSkillListIsloading:NO withPage:skillpage andType:self.skillType andCatalogID:skillCid];
    }
}

@end
