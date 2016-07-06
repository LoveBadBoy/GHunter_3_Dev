//
//  ghuntertaskwithKeyViewController.m
//  ghunter
//
//  Created by chensonglu on 14-3-25.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//附近任务

#import "ghuntertaskwithKeyViewController.h"

@interface ghuntertaskwithKeyViewController ()
@property(nonatomic,retain)NSString *taskType;
@property(nonatomic,retain)NSString *taskCid;
@end

@implementation ghuntertaskwithKeyViewController

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
    findTableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64) style:UITableViewStylePlain];
    findTableView.delegate = self;
    findTableView.dataSource = self;
    findTableView.pullDelegate = self;
    findTableView.showsVerticalScrollIndicator = NO;
    findTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    findTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:findTableView];
    self.findArray = [[NSMutableArray alloc] init];
    parent = [[NSDictionary alloc] init];
    childs = [[NSArray alloc] init];
    page = 1;
    middleOpen = NO;
    self.taskType = @"nearest";
    catalogs = [ghunterRequester getCacheContentWithKey:TASK_CATALOG];
    catalog = [catalogs objectAtIndex:[self.catalogNum integerValue]];
    parent = [catalog objectForKey:@"parent"];
    self.taskCid = [parent objectForKey:@"cid"];
    childs = [catalog objectForKey:@"child"];
    [self.catalogName setText:[parent objectForKey:@"title"]];
    [self rlTaskList:self.taskType withCid:self.taskCid withRL:REQUEST_FOR_REFRESH_TASK];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CUstom Methods
- (void)iconTaped:(UITapGestureRecognizer *)sender {
    NSDictionary *task = [self.findArray objectAtIndex:sender.view.tag];
    ghunterUserCenterViewController *user = [[ghunterUserCenterViewController alloc] init];
    user.uid = [[task objectForKey:@"owner"] objectForKey:@"uid"];
    [self.navigationController pushViewController:user animated:YES];
}

- (void)rlTaskList:(NSString *)key withCid:(NSString *)cid withRL:(NSString *)rl{
    [ghunterRequester getwithDelegate:self withUrl:URL_GET_TASK withUserInfo:rl withString:[NSString stringWithFormat:@"?api_session_id=%@&latitude=%@&longitude=%@&type=%@&cid=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],[ghunterRequester getUserInfo:LATITUDE],[ghunterRequester getUserInfo:LONGITUDE],key,cid,page]];
}

- (IBAction)filter:(id)sender {
    taskAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"taskfilterView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    CGRect taskfilterFrame = taskFilter.frame;
    taskAlertView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height) / 2.0, taskfilterFrame.size.width, taskfilterFrame.size.height);
    taskAlertView.showView = taskFilter;
    UIButton *nearestBtn = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *recentlyBtn = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *moneyBtn = (UIButton *)[taskFilter viewWithTag:3];
    UIButton *hotBtn = (UIButton *)[taskFilter viewWithTag:4];
    [nearestBtn addTarget:self action:@selector(nearest:) forControlEvents:UIControlEventTouchUpInside];
    [recentlyBtn addTarget:self action:@selector(recently:) forControlEvents:UIControlEventTouchUpInside];
    [moneyBtn addTarget:self action:@selector(money:) forControlEvents:UIControlEventTouchUpInside];
    [hotBtn addTarget:self action:@selector(hot:) forControlEvents:UIControlEventTouchUpInside];
    taskAlertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    taskAlertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [taskAlertView show];
}

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}
- (void)endLoad{
    [self.loadingView inValidate];
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nearest:(id)sender {
    self.taskType = @"nearest";
    page = 1;
    [taskAlertView dismissAnimated:YES];
    [self startLoad];
    [self rlTaskList:self.taskType withCid:self.taskCid withRL:REQUEST_FOR_REFRESH_TASK];
}

- (void)recently:(id)sender {
    self.taskType = @"latest";
    page = 1;
    [taskAlertView dismissAnimated:YES];
    [self startLoad];
    [self rlTaskList:self.taskType withCid:self.taskCid withRL:REQUEST_FOR_REFRESH_TASK];
}

- (void)money:(id)sender {
    self.taskType = @"bountyhigh";
    page = 1;
    [taskAlertView dismissAnimated:YES];
    [self startLoad];
    [self rlTaskList:self.taskType withCid:self.taskCid withRL:REQUEST_FOR_REFRESH_TASK];
}

- (void)hot:(id)sender {
    self.taskType = @"hotest";
    page = 1;
    [taskAlertView dismissAnimated:YES];
    [self startLoad];
    [self rlTaskList:self.taskType withCid:self.taskCid withRL:REQUEST_FOR_REFRESH_TASK];
}


#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ghuntertaskViewController *ghuntertask = [[ghuntertaskViewController alloc] init];
    NSDictionary *task = [self.findArray objectAtIndex:indexPath.row];
    ghuntertask.tid = [task objectForKey:@"tid"];
    ghuntertask.dismissControllerToBackToHomeBlock = ^{};
    [self.navigationController pushViewController:ghuntertask animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.findArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
    NSDictionary *task = [self.findArray objectAtIndex:indexPath.row];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"taskCell" owner:self options:nil];
    cell = [nibs objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *owner = [task objectForKey:@"owner"];
    
    UILabel *title = (UILabel *)[cell viewWithTag:2];
    OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:3];
    UIImageView *huntericon = (UIImageView *)[cell viewWithTag:4];
    UILabel *distance = (UILabel *)[cell viewWithTag:5];
    UILabel *huntername = (UILabel *)[cell viewWithTag:6];
    UILabel *dateline = (UILabel *)[cell viewWithTag:7];
    UILabel *bidnum = (UILabel *)[cell viewWithTag:8];
    UILabel *hot = (UILabel *)[cell viewWithTag:9];
    UIImageView *gender = (UIImageView *)[cell viewWithTag:10];
    UILabel *age = (UILabel *)[cell viewWithTag:11];
    UIView *bg = (UIView *)[cell viewWithTag:12];
    UIImageView *bountyImage = (UIImageView *)[cell viewWithTag:13];
    NSString *titleStr = [task objectForKey:@"title"];
    CGRect titleFrame = title.frame;
    CGSize titleSize = [titleStr sizeWithFont:title.font constrainedToSize:CGSizeMake(title.frame.size.width,MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat titleDiff = titleSize.height - titleFrame.size.height;
    titleFrame.size.height = titleSize.height;
    [title setFrame:titleFrame];
    [title setText:titleStr];
    huntericon.clipsToBounds = YES;
    huntericon.layer.cornerRadius = Radius / 2.0;
    [huntericon sd_setImageWithURL:[owner objectForKey:@"middle_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
    huntericon.userInteractionEnabled = YES;
    huntericon.tag = indexPath.row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
    [huntericon addGestureRecognizer:tap];
    NSString *distancestar = [ghunterRequester calculateDistanceWithLatitude:[task objectForKey:@"latitude"] withLongitude:[task objectForKey:@"longitude"]];
    [distance setText:distancestar];
    NSString *nameStr = [owner objectForKey:@"username"];
    CGSize nameSize = [nameStr sizeWithFont:huntername.font];
    CGRect nameFrame = huntername.frame;
    if (nameFrame.origin.x + nameSize.width > bountyImage.frame.origin.x) {
        nameFrame.size.width = bountyImage.frame.origin.x - nameFrame.origin.x;
    }
    huntername.frame = nameFrame;
    [huntername setText:[owner objectForKey:@"username"]];
    [dateline setText:[ghunterRequester getTimeDescripton:[task objectForKey:@"dateline"]]];
    [bidnum setText:[NSString stringWithFormat:@"%@人竞标",[task objectForKey:@"biddingnum"]]];
    [hot setText:[NSString stringWithFormat:@"%@热度",[task objectForKey:@"hot"]]];
    if([[owner objectForKey:@"sex"] isEqualToString:@"0"]){
        [gender setImage:[UIImage imageNamed:@"female_hunter_icon"]];
    }else{
        [gender setImage:[UIImage imageNamed:@"male_hunter_icon"]];
    }
    NSString *ageStr = [NSString stringWithFormat:@"%@岁",[owner objectForKey:@"age"]];
    CGSize ageSize = [ageStr sizeWithFont:age.font];
    CGRect ageFrame = age.frame;
    ageFrame.size.width = ageSize.width;
    age.frame = ageFrame;
    [age setText:ageStr];
    CGRect distanceFrame = distance.frame;
    distanceFrame.origin.x = age.frame.origin.x + age.frame.size.width + 3;
    distance.frame = distanceFrame;
    NSString *bountySelf = [task objectForKey:@"bounty"];
    NSString *bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
    CGSize bountySize = [bountyStr sizeWithFont:bounty.font];
    CGRect bountyFrame = bounty.frame;
    bountyFrame.origin.x = bg.frame.size.width - bountySize.width;
    bountyFrame.size.width = bountySize.width;
    bounty.frame = bountyFrame;
    NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
    [attrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange([bountySelf length], 1)];
    [attrStr setFont:[UIFont systemFontOfSize:24.0] range:NSMakeRange(0, [bountySelf length])];
    [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0]];
    [bounty setAttributedText:attrStr];
    CGRect bountyImageFrame = bountyImage.frame;
    bountyImageFrame.origin.x = bounty.frame.origin.x - 5 - bountyImageFrame.size.width;
    bountyImage.frame = bountyImageFrame;
    bg.layer.cornerRadius = Radius;
    CGRect cellFrame = cell.frame;
    cellFrame.size.height += titleDiff;
    cell.frame = cellFrame;
    return cell;
}

#pragma mark - ASIHttpRequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REFRESH_TASK]){
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [self.findArray removeAllObjects];
            page = 2;
            NSArray *array = [dic valueForKey:@"tasks"];
            [self.findArray addObjectsFromArray:array];
            [findTableView reloadData];
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            [self.findArray removeAllObjects];
            [findTableView reloadData];
        } else {
            [ghunterRequester noMsg];
        }
    }else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_TASK]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            page++;
            NSArray *array = [dic valueForKey:@"tasks"];
            [self.findArray addObjectsFromArray:array];
            [findTableView reloadData];
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
        findTableView.pullTableIsLoadingMore = NO;
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    findTableView.pullTableIsLoadingMore = NO;
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
    NSError *error = [request error];
    NSLog(@"%@",error);
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
    page = 1;
    [self rlTaskList:self.taskType withCid:self.taskCid withRL:REQUEST_FOR_REFRESH_TASK];
    findTableView.pullTableIsRefreshing = NO;
}

- (void)loadMoreDataToTable
{
    [self rlTaskList:self.taskType withCid:self.taskCid withRL:REQUEST_FOR_LOADMORE_TASK];
//    [ghunterRequester wrongMsg:@"没有更多了"];
    
}

@end
