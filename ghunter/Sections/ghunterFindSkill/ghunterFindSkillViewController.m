//
//  ghunterFindSkillViewController.m
//  ghunter
//
//  Created by imgondar on 15/7/14.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import "ghunterFindSkillViewController.h"
#import "ghunterSkillViewController.h"


#define TASK_SKILL_TYPE_NEAREST @"nearest"
#define TASK_SKILL_TYPE_LATEST @"latest"
#define TASK_SKILL_TYPE_PEICEHIGH @"pricehigh"
#define TASK_SKILL_TYPE_BOUNTHIGH @"bountyhigh"
#define TASK_SKILL_TYPE_HOTEST @"hotest"

@interface ghunterFindSkillViewController ()

@property(nonatomic,retain)NSString *taskType;
@property(nonatomic,retain)NSString *skillType;
@property (strong, nonatomic) IBOutlet UIImageView *filterImg;

@property (strong, nonatomic) IBOutlet UIView *bg;


@property(nonatomic,assign)BOOL firstTimeShowTaskTableView;
@property(nonatomic,assign)BOOL firstTimeShowSkillTableView;
@property (weak, nonatomic) UIImageView *topBGSliderImageView;
@property (strong, nonatomic) IBOutlet UILabel *filterLabel;
@property (strong, nonatomic) IBOutlet UILabel *otherFilterLabel;
@property (weak, nonatomic) IBOutlet UILabel *FSTitle;


@end

@implementation ghunterFindSkillViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _bg.backgroundColor = Nav_backgroud;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    _FSTitle.text = _nametitle;
    self.tabBarController.tabBar.hidden = YES;
    self.firstTimeShowSkillTableView = YES;
    self.firstTimeShowTaskTableView = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    skillSelected = NO;
    
//    taskpage = 1;
    skillpage = 1;
    self.filterLabel.hidden = YES;
    self.otherFilterLabel.hidden = NO;
    self.skillCurrentPage = @"0";
//    self.findtaskArray = [[NSMutableArray alloc] init];
//    self.findskillArray = [[NSMutableArray alloc] init];
    skillArray = [[NSMutableArray alloc] init];
    skillMoreDataArr = [[NSMutableArray alloc] init];
    skillTmpNum = 0;
    
    double latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:LATITUDE];
    double longitude = [[NSUserDefaults standardUserDefaults] doubleForKey:LONGITUDE];
    [ghunterRequester setUserInfoWithKey:LATITUDE withValue:[NSString stringWithFormat:@"%f", latitude]];
    [ghunterRequester setUserInfoWithKey:LONGITUDE withValue:[NSString stringWithFormat:@"%f", longitude]];
    
    // 默认都是最新发布的技能
    self.skillType = TASK_SKILL_TYPE_LATEST;
    self.taskType = TASK_SKILL_TYPE_LATEST;

   
    if ([findSkillTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [findSkillTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([findSkillTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [findSkillTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    // 获取数据
    [self didGetTotalSkillListIsloading:YES withPage:skillpage andType:self.skillType andCatalogID:_skillCid];
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


- (void)createTableView:(NSInteger) num {
    
    skillBackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, mainScreenWidth, mainScreenheight - 104)];
    skillBackScrollView.contentSize = CGSizeMake(mainScreenWidth * num, mainScreenheight - 104);
    skillBackScrollView.bounces = NO;
    skillBackScrollView.showsHorizontalScrollIndicator = NO;
    skillBackScrollView.showsVerticalScrollIndicator = NO;
    skillBackScrollView.delegate = self;
    skillBackScrollView.pagingEnabled = YES;
    skillBackScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:skillBackScrollView];
    
    
    for (int i = 0; i < num; i++) {
        
        findSkillTableView = [[PullTableView alloc]initWithFrame:CGRectMake(i * mainScreenWidth, 0, mainScreenWidth, skillBackScrollView.frame.size.height)];
        findSkillTableView.delegate = self;
        findSkillTableView.dataSource = self;
        findSkillTableView.pullDelegate = self;
        UIView * footView = [[UIView alloc] initWithFrame:CGRectZero];
        footView.backgroundColor = [UIColor whiteColor];
        findSkillTableView.tableFooterView = footView;
        findSkillTableView.tag = 301 + i;
        findSkillTableView.showsVerticalScrollIndicator = NO;
        findSkillTableView.showsHorizontalScrollIndicator = NO;
        findSkillTableView.separatorColor = RGBCOLOR(235, 235, 235);
        findSkillTableView.backgroundColor = [UIColor clearColor];
        findSkillTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [skillBackScrollView addSubview:findSkillTableView];
    }
    
}


#pragma mark --- 创建顶部滑动视图 ---
-(void)createTopScrollView:(NSInteger) num andWithCatalogs:(NSArray *) catalogsArr{
    
    skillTopScrollVIew = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, 30)];
    skillTopScrollVIew.delegate = self;
    skillTopScrollVIew.contentSize = CGSizeMake(num * 60, 0);
    skillTopScrollVIew.showsHorizontalScrollIndicator = NO;
    skillTopScrollVIew.showsHorizontalScrollIndicator = NO;
    skillTopScrollVIew.pagingEnabled = YES;
    skillTopScrollVIew.tag = 1001;
    skillTopScrollVIew.bounces = YES;
    skillTopScrollVIew.userInteractionEnabled = YES;
    skillTopScrollVIew.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:skillTopScrollVIew];
    
    for (int i = 0; i < num; i++) {
        NSMutableArray * dataArray = [[NSMutableArray alloc] init];
        [dataArray addObject:@"1"];
        [skillArray addObject:dataArray];
        
        NSMutableString * skillPageStr = [[NSMutableString alloc] initWithFormat:@"1"];
        [skillMoreDataArr addObject:skillPageStr];
    }
    
    
    for (int i = 0; i < catalogsArr.count; i++) {
        
        skillTopBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * 60, 0, 60, 28.5)];
        NSDictionary * dict = [catalogsArr objectAtIndex:i];
        skillTopBtn.tag = i + 101;
        //        titleLb.backgroundColor = [UIColor redColor];
        [skillTopBtn setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
        [skillTopBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
        
        skillLabel = [[UILabel alloc] init];
        skillLabel.text = [dict objectForKey:@"cid"];
        skillLabel.tag = 201 + i;
        [skillTopScrollVIew addSubview:skillLabel];
        if (i == 0) {
            [skillTopBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
            skillNotselectBtn = skillTopBtn;
        }
        skillTopBtn.userInteractionEnabled = YES;
        skillTopBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        skillTopBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [skillTopBtn addTarget:self action:@selector(skillScrollBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [skillTopScrollVIew addSubview:skillTopBtn];
    }
    
    self.skillRedView = [[UIView alloc] initWithFrame:CGRectMake(0, skillTopBtn.frame.size.height, 60, 1.5)];
    self.skillRedView.backgroundColor = RGBCOLOR(234, 85, 20);
    [skillTopScrollVIew addSubview:self.skillRedView];
}


#pragma mark --- 点击 ---
- (void) skillScrollBtnClick:(UIButton *) btn {
    
    
    NSInteger page = btn.tag - 101;
    
    // 点击会触发页面滑动事件，从而调用scrollViewDidScroll方法，造成重复加载
    // 解决方法，当点击radioButton的时候，增加标志位，scrollViewDidScroll不应该加载数据
    
    NSTimeInterval animationDuration = 0.20f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [skillBackScrollView setContentOffset:CGPointMake(mainScreenWidth * page, 0)];
    
    [UIView commitAnimations];
}



#pragma mark - 加载网络数据
// 获取总列表
-(void)didGetTotalSkillListIsloading:(BOOL )isloading withPage:(NSInteger)p andType:(NSString *)tp andCatalogID:(NSInteger)cid{
    if (isloading) {
        [self startLoad];
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:@"latitude"];
    [parameters setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:@"longitude"];
    [parameters setObject:tp forKey:@"type"];
    [parameters setObject:[NSString stringWithFormat:@"%zd", p] forKey:@"page"];
    
    NSString * cidStr = [NSString stringWithFormat:@"%zd", cid];
    [parameters setObject:cidStr forKey:@"cid"];
    
    PullTableView * table = (PullTableView *)[skillBackScrollView viewWithTag:301];
    [AFNetworkTool httpRequestWithUrl:URL_FIND_SKILL params:parameters success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {
//            if (p == 1) {
//                skillSelected = YES;
            NSArray * catalogsArray = [result valueForKey:@"catalogs"];
            [self createTopScrollView:[[result valueForKey:@"catalogs"] count] andWithCatalogs:catalogsArray];
            self.skillArrCount = [NSString stringWithFormat:@"%lu", (unsigned long)catalogsArray.count];
            
            [[skillArray objectAtIndex:self.skillCurrentPage.integerValue] removeAllObjects];
           
            skillPagesAdd = 2;
            [[skillMoreDataArr objectAtIndex:self.skillCurrentPage.integerValue] setString:[NSString  stringWithFormat:@"%ld", (long)skillPagesAdd++]];
           
            NSArray *array = [result valueForKey:@"skillshows"];
            [[skillArray objectAtIndex:0] addObjectsFromArray:array];
            [self createTableView:[[result valueForKey:@"catalogs"] count]];
            
            [table reloadData];
            table.pullTableIsRefreshing = NO;
    
//                if([self.findskillArray count]>0)
//                {
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                    [findSkillTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
//                }
                //            }else{
//                skillpage++;
//                NSArray *array = [result valueForKey:@"skillshows"];
//                [self.findskillArray addObjectsFromArray:array];
//                [findSkillTableView reloadData];
//                findSkillTableView.pullTableIsLoadingMore = NO;
//            }
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
            table.pullTableIsRefreshing = NO;
            table.pullTableIsLoadingMore = NO;
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
        table.pullTableIsRefreshing = NO;
        table.pullTableIsLoadingMore = NO;
    }];
}

// 获取技能列表
-(void)didGetSkillListIsloading:(BOOL )isloading withPage:(NSInteger)p andType:(NSString *)tp andCatalogID:(NSInteger)cid{
    if (isloading) {
        [self startLoad];
    }

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:@"latitude"];
    [parameters setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:@"longitude"];
    [parameters setObject:tp forKey:@"type"];
    [parameters setObject:[NSString stringWithFormat:@"%zd", p] forKey:@"page"];
    
    NSString * cidStr = [NSString stringWithFormat:@"%zd", cid];
    [parameters setObject:cidStr forKey:@"cid"];
    
    PullTableView * table = (PullTableView *)[skillBackScrollView viewWithTag:self.skillCurrentPage.integerValue + 301];

    [AFNetworkTool httpRequestWithUrl:URL_FIND_SKILL params:parameters success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

        if ([[result objectForKey:@"error"]integerValue] == 0) {
            if (p == 1) {
                
                [[skillArray objectAtIndex:self.skillCurrentPage.integerValue] removeAllObjects];
                
                skillPagesAdd = 2;
                [[skillMoreDataArr objectAtIndex:self.skillCurrentPage.integerValue] setString:[NSString  stringWithFormat:@"%ld", (long)skillPagesAdd++]];
                
                NSArray *array = [result valueForKey:@"tasks"];
                [[skillArray objectAtIndex:self.skillCurrentPage.integerValue] addObjectsFromArray:array];
                
                [table reloadData];
                //                if([self.findtaskArray count]>0)
                //                {
                //                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                //                    [findTaskTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                //                }
                table.pullTableIsRefreshing = NO;
            }else{
                skillPagesAdd++;
                [[skillMoreDataArr objectAtIndex:self.skillCurrentPage.integerValue] setString:[NSString  stringWithFormat:@"%ld", (long)skillPagesAdd++]];
                
                NSArray *array = [result valueForKey:@"tasks"];
                [[skillArray objectAtIndex:self.skillCurrentPage.integerValue] addObjectsFromArray:array];
                [table reloadData];
                table.pullTableIsLoadingMore = NO;
            }
        }else{
            
            if ([[result objectForKey:@"msg"] isEqualToString:@"暂无技能秀"]) {
                [[skillArray objectAtIndex:self.skillCurrentPage.integerValue] removeAllObjects];
                [table reloadData];
            }
            
            [ProgressHUD show:[result objectForKey:@"msg"]];
            table.pullTableIsRefreshing = NO;
            table.pullTableIsLoadingMore = NO;
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

-(NSString *)getFilterName:(NSString *)filterType{
    if ([filterType isEqualToString:TASK_SKILL_TYPE_NEAREST]) {
        return @"最近";
    }else if([filterType isEqualToString:TASK_SKILL_TYPE_LATEST]){
        return @"最新";
    }else if([filterType isEqualToString:TASK_SKILL_TYPE_HOTEST]){
        return @"最热";
    }else if([filterType isEqualToString:TASK_SKILL_TYPE_BOUNTHIGH]){
        return @"赏金";
    }else if([filterType isEqualToString:TASK_SKILL_TYPE_PEICEHIGH]){
        return @"售价";
    }
    return  @"最近";
}

- (void)change:(NSNotification *)notidi
{
    self.filterImg.image = [UIImage imageNamed:@"nearby_filter_dropdown_normal"];
}
- (void)changeImageCount:(NSNotification *)noti
{
    self.filterImg.image = [UIImage imageNamed:@"nearby_filter_normal"];
}

- (void)viewWillAppear:(BOOL)animated {
    // 这样才能右滑返回上一个页面
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
}

- (void)viewDidAppear:(BOOL)animated {

//    [findSkillTableView setFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64)];
//    self.firstTimeShowSkillTableView = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

#pragma mark --- UIscrollviewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = skillBackScrollView.frame.size.width;
    int page = floor(skillBackScrollView.contentOffset.x / pageWidth);
    
    //    NSLog(@"1");
    UIButton * btn = (UIButton *)[skillTopScrollVIew viewWithTag:101 + page];
    if (btn != skillNotselectBtn) {
        
        [skillNotselectBtn setTitleColor:RGBCOLOR(137, 137, 137) forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
        skillNotselectBtn = btn;
    }
    
    
    //    float bigX = scrollView.bounds.size.width / _btnScroll.bounds.size.width;
    float littleX = ((self.skillArrCount.integerValue) * 60) / (self.skillArrCount.integerValue * mainScreenWidth);
    
    CGRect frame = self.skillRedView.frame;
    frame.size.width = skillTopBtn.frame.size.width;
    frame.origin.x = btn.frame.origin.x;
    
    self.skillRedView.frame = frame;
    skillTopScrollVIew.contentOffset = CGPointMake(skillBackScrollView.contentOffset.x * littleX, skillBackScrollView.contentOffset.y);
}

- ( void )scrollViewDidEndDecelerating:( UIScrollView *)scrollView{
    
    CGFloat pageWidth = skillBackScrollView.frame.size.width;
    int page = floor(skillBackScrollView.contentOffset.x / pageWidth);
    
    self.skillCurrentPage = [NSString stringWithFormat:@"%d", page];
    UILabel * cidLb = (UILabel *)[skillTopScrollVIew viewWithTag:201 + page];
    
    if (self.skillCurrentPage.integerValue == 0) {
        return;
    }else if (self.skillCurrentPage.integerValue == page && skillTmpNum != page){
        [self didGetSkillListIsloading:YES withPage:1 andType:self.skillType andCatalogID:cidLb.text.integerValue];
    }
    
    skillTmpNum = page - 1;
}



- (void)dealloc {
    
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

    skill=[[skillArray objectAtIndex:self.skillCurrentPage.integerValue] objectAtIndex:sender.view.tag];
    ghunterUserCenterViewController *user = [[ghunterUserCenterViewController alloc] init];
    user.uid=[[skill objectForKey:@"owner"] objectForKey:@"uid"];
    [self.navigationController pushViewController:user animated:YES];
}

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}


- (IBAction)backButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)filter {
    taskAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"taskfiltertoView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    CGRect taskfilterFrame = taskFilter.frame;
    taskfilterFrame.size.width = mainScreenWidth;
    taskFilter.frame = taskfilterFrame;

    
    taskAlertView.containerFrame=CGRectMake(0,64, taskfilterFrame.size.width, taskfilterFrame.size.height);
    taskAlertView.showView = taskFilter;
    taskAlertView.showView.layer.cornerRadius=0;
    UIButton *nearestBtn = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *recentlyBtn = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *moneyBtn = (UIButton *)[taskFilter viewWithTag:3];
    UIButton *hotBtn = (UIButton *)[taskFilter viewWithTag:4];
    UILabel* label1=(UILabel*)[taskFilter viewWithTag:5];
    
    label1.text=@"赏金最高";

    [nearestBtn addTarget:self action:@selector(nearest:) forControlEvents:UIControlEventTouchUpInside];
    [recentlyBtn addTarget:self action:@selector(recently:) forControlEvents:UIControlEventTouchUpInside];
    [moneyBtn addTarget:self action:@selector(money:) forControlEvents:UIControlEventTouchUpInside];
    [hotBtn addTarget:self action:@selector(hot:) forControlEvents:UIControlEventTouchUpInside];
    taskAlertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    taskAlertView.transitionStyle = SIAlertViewTransitionStyleFade;
    [taskAlertView show];
}

#pragma mark - filterClick
- (void)nearest:(id)sender {
    
        [MobClick event:UMEVENT_TNEAREST];
        self.skillType = TASK_SKILL_TYPE_NEAREST;
        skillpage = 1;
        [taskAlertView dismissAnimated:YES];
        self.otherFilterLabel.text = @"最近";
        [self didGetSkillListIsloading:YES withPage:1 andType:self.skillType andCatalogID:_skillCid];
        
        // 本地保存用户默认筛选方式
        _filter4skill = TASK_SKILL_TYPE_NEAREST;
        [[NSUserDefaults standardUserDefaults] setValue:TASK_SKILL_TYPE_NEAREST forKey:@"filter4skill"];
    
    self.filterImg.image = [UIImage imageNamed:@"nearby_filter_normal"];
}

- (void)recently:(id)sender {
   
        [MobClick event:UMEVENT_TLATEST];
        self.skillType= TASK_SKILL_TYPE_LATEST;
        skillpage = 1;
        [taskAlertView dismissAnimated:YES];
        self.otherFilterLabel.text = @"最新";
        [self didGetSkillListIsloading:YES withPage:1 andType:self.skillType andCatalogID:_skillCid];
        
        // 本地保存用户默认筛选方式
        _filter4skill = TASK_SKILL_TYPE_LATEST;
        [[NSUserDefaults standardUserDefaults] setValue:TASK_SKILL_TYPE_LATEST forKey:@"filter4skill"];
        self.filterImg.image = [UIImage imageNamed:@"nearby_filter_normal"];
}

- (void)money:(id)sender {
    
        [MobClick event:UMEVENT_TBOUNTY];
        self.skillType= TASK_SKILL_TYPE_PEICEHIGH;
        skillpage = 1;
        self.otherFilterLabel.text = @"售价";
        [taskAlertView dismissAnimated:YES];
        [self didGetSkillListIsloading:YES withPage:1 andType:self.skillType andCatalogID:_skillCid];
        
        // 本地保存用户默认筛选方式
        _filter4skill = TASK_SKILL_TYPE_PEICEHIGH;
        [[NSUserDefaults standardUserDefaults] setValue:TASK_SKILL_TYPE_PEICEHIGH forKey:@"filter4skill"];
       self.filterImg.image = [UIImage imageNamed:@"nearby_filter_normal"];
}

- (void)hot:(id)sender {
            [MobClick event:UMEVENT_THOTEST];
        self.skillType= TASK_SKILL_TYPE_HOTEST;
        skillpage = 1;
        [taskAlertView dismissAnimated:YES];
        self.otherFilterLabel.text = @"最热";
        [self didGetSkillListIsloading:YES withPage:1 andType:self.skillType andCatalogID:_skillCid];
        
        // 本地保存用户默认筛选方式
        _filter4skill = TASK_SKILL_TYPE_HOTEST;
        [[NSUserDefaults standardUserDefaults] setValue:TASK_SKILL_TYPE_HOTEST forKey:@"filter4skill"];
    
    self.filterImg.image = [UIImage imageNamed:@"nearby_filter_normal"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSDictionary *skill = [[skillArray objectAtIndex:self.skillCurrentPage.integerValue] objectAtIndex:indexPath.row];
        ghunterSkillViewController *skillView = [[ghunterSkillViewController alloc] init];
        skillView.skillid = [skill objectForKey:@"sid"];
        skillView.callBackBlock = ^{};
        [self.navigationController pushViewController:skillView animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return [[skillArray objectAtIndex:self.skillCurrentPage.integerValue] count];

}

#pragma mark - UITableVIewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height+5;
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

    findSkillTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    NSDictionary *skill = [[skillArray objectAtIndex:self.skillCurrentPage.integerValue] objectAtIndex:indexPath.row];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"taskCell" owner:self options:nil];
    cell = [nibs objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *owner = [skill objectForKey:@"owner"];

    UILabel *title = (UILabel *)[cell viewWithTag:2];
//    OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:3];
    UIImageView *huntericon = (UIImageView *)[cell viewWithTag:4];
    UILabel *distance = (UILabel *)[cell viewWithTag:5];
    UILabel *huntername = (UILabel *)[cell viewWithTag:6];
    UILabel *dateline = (UILabel *)[cell viewWithTag:7];
    UILabel *bidnum = (UILabel *)[cell viewWithTag:8];
    UILabel *hot = (UILabel *)[cell viewWithTag:9];
    UIImageView *gender = (UIImageView *)[cell viewWithTag:10];

    UIView* ageview=(UIView*)[cell viewWithTag:54];
    ageview.layer.cornerRadius = 2.0;
    NSString *titleStr = [skill objectForKey:@"skill"];
    CGRect titleFrame = title.frame;
    CGSize titleSize = [titleStr sizeWithFont:title.font constrainedToSize:CGSizeMake(title.frame.size.width,MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//    CGFloat titleDiff = titleSize.height - titleFrame.size.height;
    titleFrame.size.height = titleSize.height;
    [title setFrame:titleFrame];
    
//        title.lineBreakMode = NSLineBreakByWordWrapping;
    title.numberOfLines = 1;
//        [title sizeToFit];
    [title setText:titleStr];
        
    huntericon.clipsToBounds = YES;
    huntericon.layer.cornerRadius = 25;
    [huntericon sd_setImageWithURL:[owner objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
    huntericon.userInteractionEnabled = YES;
    huntericon.tag = indexPath.row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
    [huntericon addGestureRecognizer:tap];
    NSString *distancestar = [ghunterRequester calculateDistanceWithLatitude:[skill objectForKey:@"latitude"] withLongitude:[skill objectForKey:@"longitude"]];
    [distance setText:distancestar];
//    NSString *nameStr = [owner objectForKey:@"username"];
//    CGSize nameSize = [nameStr sizeWithFont:huntername.font];
    CGRect nameFrame = huntername.frame;
    nameFrame.origin.x = huntericon.frame.origin.y + huntericon.frame.size.width + 10;
//    if (nameFrame.origin.x + nameSize.width > bountyImage.frame.origin.x) {
//        nameFrame.size.width = bountyImage.frame.origin.x - nameFrame.origin.x;
//    }
    huntername.frame = nameFrame;
    [huntername setText:[owner objectForKey:@"username"]];
    [dateline setText:[ghunterRequester getTimeDescripton:[skill objectForKey:@"dateline"]]];
    [bidnum setText:[NSString stringWithFormat:@"%@人购买",[skill objectForKey:@"salenum"]]];
    [hot setText:[NSString stringWithFormat:@"%@热度",[skill objectForKey:@"hot"]]];
    if([[owner objectForKey:@"sex"] isEqualToString:@"0"]){
        [gender setImage:[UIImage imageNamed:@"female"]];
//           ageview.backgroundColor = RGBCOLOR(240, 136, 146);
    }else{
        [gender setImage:[UIImage imageNamed:@"male"]];
//           ageview.backgroundColor = RGBCOLOR(119, 158, 211);
    }

    CGRect distanceFrame = distance.frame;
    distance.frame = distanceFrame;

    NSString * bountySelf = [skill objectForKey:@"price"];
    NSString * priceUnit = [skill objectForKey:@"priceunit"];
    NSString *bountyStr = [NSString stringWithFormat:@"%@元/%@",bountySelf, priceUnit];
    UILabel * bounty = [[UILabel alloc] initWithFrame:CGRectMake(100, huntername.frame.origin.y, 100, 20)];
    CGSize bountySize = [bountyStr sizeWithFont:bounty.font];
    [cell.contentView addSubview:bounty];
    bounty.text = bountyStr;
    bounty.font = [UIFont systemFontOfSize:12];
    bounty.textColor = RGBCOLOR(234, 85, 20);
    
    CGRect bountyFrame = bounty.frame;
    bountyFrame.size.width = bountySize.width;
    bountyFrame.origin.x = mainScreenWidth - bountySize.width - 10;
    bounty.frame = bountyFrame;
    
    UILabel * goldLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, huntername.frame.origin.y - 3, 26, 26)];
    [cell.contentView addSubview:goldLabel];
    goldLabel.text = @"售";
    goldLabel.textAlignment = NSTextAlignmentCenter;
    goldLabel.textColor = RGBCOLOR(234, 85, 20);
    goldLabel.layer.cornerRadius = goldLabel.frame.size.width / 2;
    goldLabel.clipsToBounds = YES;
    [goldLabel.layer setBorderWidth:1.0f];
    goldLabel.font = [UIFont systemFontOfSize:12];
    [goldLabel.layer setBorderColor:RGBCOLOR(234, 85, 20).CGColor];
    
    // 赏字位置
    CGRect goldLbFrame = goldLabel.frame;
    goldLbFrame.origin.x = bounty.frame.origin.x - 10 - goldLbFrame.size.width;
    goldLbFrame.origin.y = huntername.frame.origin.y - 3;
    goldLabel.frame = goldLbFrame;

    // 图片内容
    UIImageView *imagetent = (UIImageView *)[cell viewWithTag:111];
    [imagetent sd_setImageWithURL:[skill objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"avatar"]];
    //        imagetent.image =[UIImage imageNamed:@"neighbor_task_dialog_hhigh2"];
    imagetent.clipsToBounds = YES;
    imagetent.layer.cornerRadius = 3.0;
    UILabel *tabbartxt  = (UILabel *)[cell viewWithTag:110];
    
    
    tabbartxt.textColor = [UIColor redColor];
    tabbartxt.text = [skill objectForKey:@"c_name"];
    tabbartxt.font = [UIFont systemFontOfSize:10];
    tabbartxt.clipsToBounds = YES;
    NSString *LENstr = tabbartxt.text;
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
    
    
    tabbartxt.layer.cornerRadius = 3.0;
    [tabbartxt.layer setBorderWidth:1.0];   //边框宽度
    tabbartxt.textAlignment = NSTextAlignmentCenter;
    [tabbartxt.layer setBorderColor:[UIColor redColor].CGColor];//边框颜色
    
    CGRect tabFrame = tabbartxt.frame;
    tabFrame.origin.y = title.frame.origin.y;
    tabbartxt.frame = tabFrame;
    
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = title.frame.origin.y + 47;
    cell.frame = cellFrame;
    
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
    UILabel * cidLb = (UILabel *)[skillTopScrollVIew viewWithTag:201 + self.skillCurrentPage.integerValue];
    
    if (self.skillCurrentPage.integerValue == 0) {
        [self didGetTotalSkillListIsloading:NO withPage:1 andType:self.skillType andCatalogID:cidLb.text.integerValue];
    }else {
        [[skillArray objectAtIndex:self.skillCurrentPage.integerValue] removeAllObjects];
        [self didGetSkillListIsloading:NO withPage:1 andType:self.skillType andCatalogID:cidLb.text.integerValue];
    }

}

- (void)loadMoreDataToTable
{
    if (self.skillCurrentPage.integerValue == 0) {
        [self didGetSkillListIsloading:NO withPage:[[skillMoreDataArr objectAtIndex:self.skillCurrentPage.integerValue] integerValue] andType:self.skillType andCatalogID:_skillCid];
    }else {
        [self didGetSkillListIsloading:NO withPage:[[skillMoreDataArr objectAtIndex:self.skillCurrentPage.integerValue] integerValue] andType:self.skillType andCatalogID:self.skillCurrentPage.integerValue];
    }
}

#pragma mark  -UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 100) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        if (buttonIndex == 1) {
            NSURL *url = [[NSURL alloc] initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_URL]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


@end
