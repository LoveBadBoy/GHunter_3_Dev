//
//  ghunterHunterCircleViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-22.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//  猎友圈

#import "ghunterHunterCircleViewController.h"
#import "ghunterSkillViewController.h"
#import "AFNetworkTool.h"

@interface ghunterHunterCircleViewController ()
{
    NSDictionary *dicSelf;
}


@end

@implementation ghunterHunterCircleViewController

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
    page = 1;
    feeds = [[NSMutableArray alloc] init];
    self.table = [[PullTableView alloc]initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 44 - 20) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.pullDelegate = self;
    self.table.showsVerticalScrollIndicator = NO;
//    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.table.backgroundColor = [UIColor colorWithRed:228/255.0 green:227/255.0 blue:220/255.0 alpha:1.0];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"hunterCircleHeadView" owner:self options:nil];
    UIView *head = [[UIView alloc] init];
    head = [nibs objectAtIndex:0];
    head.frame = CGRectMake(0, 0, mainScreenWidth, 175);
    self.table.tableHeaderView = head;
    UILabel *username = (UILabel *)[head viewWithTag:99];
//    username.backgroundColor = [UIColor redColor];
    [username setFont:[UIFont systemFontOfSize:16]];
    username.textAlignment = NSTextAlignmentRight;
    UIImageView *icon = (UIImageView *)[head viewWithTag:2];
    icon.userInteractionEnabled = YES;
//    [username setText:[self.dic objectForKey:@"username"]];
//    [username setText:self.nameString];
    username.text = self.nameString;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Usercenter:)];
    [icon addGestureRecognizer:tap];
    icon.clipsToBounds = YES;
    icon.layer.cornerRadius = icon.frame.size.height / 2.0;
    
    // 猎友圈头像
    NSURL* urlStr=[NSURL URLWithString:[ghunterRequester getUserInfo:MIDDLE_AVATAR]];
    [icon sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    UILabel * lb = (UILabel *)[head viewWithTag:123];
    lb.backgroundColor = [UIColor whiteColor];
    

    [self.view addSubview:self.table];
    // 请求第一页数据
    [self getFeedWithPage:page isloading:YES];
}

-(void)getFeedWithPage:(NSInteger)p isloading:(BOOL)isloading{
    if (isloading) {
        [self startLoad];
    }
    NSString *url = [NSString stringWithFormat:@"%@?uid=%@&page=%zd", URL_GET_HUNTER_CIRCLE, [ghunterRequester getUserInfo:UID], p];
    [AFNetworkTool httpRequestWithUrl:url params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"] integerValue] == 0) {
            if (page == 1) {
                [feeds removeAllObjects];
                page = 2;
                NSArray *array = [result valueForKey:@"feeds"];
                
                [feeds addObjectsFromArray:array];
                [self.table reloadData];
                
                gunread_feedavatar = @"";
                
                // 更新底部发现图标+发现页面的猎友圈UI
                NSNotification *notification = [NSNotification notificationWithName:@"update_unread_ui" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            }else{
                // 第2+页
                page++;
                NSArray *array = [result valueForKey:@"feeds"];
                [feeds addObjectsFromArray:array];
                [self.table reloadData];
                
                self.table.pullTableIsLoadingMore = NO;
            }
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
            self.table.pullTableIsLoadingMore = NO;
        }
    } fail:^{
        if (isloading) {
            [self endLoad];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)Usercenter:(UITapGestureRecognizer *)tap
{
    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
    userCenter.uid =  [ghunterRequester getUserInfo:UID];
    [self.navigationController pushViewController:userCenter animated:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [MobClick event:UMEVENT_HUNTER_CIRCLE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feeds count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.table.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    NSDictionary *feed = [feeds objectAtIndex:indexPath.row];
    NSArray *nibs;
    if([[feed objectForKey:@"type"] isEqualToString:@"0"]){
        nibs = [[NSBundle mainBundle] loadNibNamed:@"hunterCircleView" owner:self options:nil];
    }else if ([[feed objectForKey:@"type"] isEqualToString:@"1"]){
        nibs = [[NSBundle mainBundle] loadNibNamed:@"hunterCircleView_nobounty" owner:self options:nil];
    }else if([[feed objectForKey:@"type"] isEqualToString:@"2"]){
        // 我关注的人发布技能的动态xib
        nibs = [[NSBundle mainBundle] loadNibNamed:@"hunterCircleView" owner:self options:nil];
    }else if ([[feed objectForKey:@"type"] isEqualToString:@"3"]){
        
        // 技能秀
        nibs = [[NSBundle mainBundle] loadNibNamed:@"hunterCircleView_SkillShow" owner:self options:nil];
    }
    
    cell = [nibs objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    UIView *bgView = (UIView *)[cell viewWithTag:10];
    UIImageView *icon = (UIImageView *)[cell viewWithTag:1];
    UILabel *username = (UILabel *)[cell viewWithTag:2];
    UILabel *type = (UILabel *)[cell viewWithTag:3];
    UILabel *dateline = (UILabel *)[cell viewWithTag:4];
    UIImageView *gender = (UIImageView *)[cell viewWithTag:5];
    UILabel *age = (UILabel *)[cell viewWithTag:6];
    UILabel *distance = (UILabel *)[cell viewWithTag:7];
    UILabel *circleTitle = (UILabel *)[cell viewWithTag:8];
    UIImageView *cellView = (UIImageView *)[cell viewWithTag:11];
    UILabel *shangLabel = (UILabel *)[cell viewWithTag:110];
    UIView *grayView = [cell viewWithTag:10000];
    [grayView.layer setCornerRadius:5];
    grayView.backgroundColor = RGBCOLOR(245, 245, 245);
    CGSize width = CGSizeMake(self.view.frame.size.width,cell.frame.size.height);
    CGRect  cellframe = cell.frame;
    cellframe.size.width = width.width;
    cell.frame = cellframe;
    CGRect bgViewframe = bgView.frame;
    bgViewframe.size.width = cellframe.size.width;
    bgView.frame = bgViewframe;
    cellView.frame = CGRectMake(0, 0, self.view.frame.size.width, cellView.frame.size.height);
    grayView.frame = CGRectMake(grayView.frame.origin.x, grayView.frame.origin.y, self.view.frame.size.width - grayView.frame.origin.x-8, grayView.frame.size.height);
    circleTitle.frame = CGRectMake(5, 5,grayView.frame.size.width-10, circleTitle.frame.size.height);
    dateline.frame = CGRectMake(self.view.frame.size.width-8-dateline.frame.size.width, dateline.frame.origin.y, dateline.frame.size.width, dateline.frame.size.height);
    cellView.frame = cell.frame;
    [shangLabel.layer setCornerRadius:10];
    [shangLabel.layer setBorderWidth:1];
//    [shangLabel.layer setBorderColor:[UIColor colorWithRed:89/255.0 green:87/255.0 blue:87/255.0 alpha:1.0].CGColor];
//    shangLabel.textColor = [UIColor colorWithRed:89/255.0 green:87/255.0 blue:87/255.0 alpha:1.0];
    [shangLabel.layer setBorderColor:RGBCOLOR(153, 153, 153).CGColor];
    shangLabel.textColor = RGBCOLOR(153, 153, 153);
    shangLabel.textAlignment = NSTextAlignmentCenter;
    shangLabel.text = @"赏";
//    [shangLabel setFont:[UIFont boldSystemFontOfSize:13]];
    shangLabel.font = [UIFont systemFontOfSize:10];
    OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:9];
    if([[feed objectForKey:@"type"] isEqualToString:@"0"]){
        if (![[feed objectForKey:@"bounty"] isKindOfClass:[NSNull class]]) {
            NSString *bountySelf = [feed objectForKey:@"bounty"];
            NSString *bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
            NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
            [attrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange([bountySelf length], 1)];
            [attrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, [bountySelf length])];
//            [attrStr setTextColor:[UIColor colorWithRed:89/255.0 green:87/255.0 blue:87/255.0 alpha:1.0]];
            [attrStr setTextColor:RGBCOLOR(135, 135, 135)];
            [bounty setAttributedText:attrStr];
        }
    }
    
    if([[feed objectForKey:@"type"] isEqualToString:@"2"]){
        shangLabel.text = @"售";
//        OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:9];
        
        NSString *bountySelf = [feed objectForKey:@"price"];
        NSString *priceunit = [feed objectForKey:@"priceunit"];
        NSString *bountyStr = [NSString stringWithFormat:@"%@元/%@",bountySelf,priceunit];
        NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
        [attrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange([bountySelf length], 1)];
        [attrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, [bountySelf length])];
//        [attrStr setTextColor:[UIColor colorWithRed:89/255.0 green:87/255.0 blue:87/255.0 alpha:1.0]];
        [attrStr setTextColor:RGBCOLOR(135, 135, 135)];
//        bounty.font = [UIFont systemFontOfSize:12];
        [bounty setAttributedText:attrStr];
    }

    CGRect shangLabelFrame = shangLabel.frame;
    CGRect bountyFrame = bounty.frame;
    
    bountyFrame.origin.y = shangLabelFrame.origin.y + 4;
    bounty.frame = bountyFrame;
    icon.userInteractionEnabled = YES;
    icon.clipsToBounds = YES;
    icon.layer.cornerRadius = icon.frame.size.width*0.5;
    [icon sd_setImageWithURL:[feed objectForKey:@"tiny_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
    icon.tag = indexPath.row;
    [icon addGestureRecognizer:tap];
    NSString *usernameStr = [feed objectForKey:@"username"];
    NSString *typeStr = [feed objectForKey:@"title"];
    CGSize usernameSize = [usernameStr sizeWithFont:username.font];
    CGSize typeSize = [typeStr sizeWithFont:type.font];
    if(username.frame.origin.x + usernameSize.width + 3 +typeSize.width + 3 > dateline.frame.origin.x){
        usernameSize.width = dateline.frame.origin.x - 3 - typeSize.width - 3 - username.frame.origin.x;
    }
    CGRect usernameFrame = username.frame;
    usernameFrame.size.width = usernameSize.width;
    [username setFrame:usernameFrame];
    [username setText:usernameStr];
    CGRect typeFrame = type.frame;
    typeFrame.origin.x = username.frame.origin.x + username.frame.size.width + 5;
    typeFrame.size.width = typeSize.width;
    type.frame = typeFrame;
    // 猎友圈标题文字
    type.textColor = [UIColor colorWithRed:242/255.0 green:153/255.0 blue:114/255.0 alpha:1.0];
    
    [type setText:typeStr];
    [dateline setText:[ghunterRequester getTimeDescripton:[feed objectForKey:@"dateline"]]];
//    NSString *ageStr = [NSString stringWithFormat:@"%@岁",[feed objectForKey:@"age"]];
    NSString *distanceStr = [ghunterRequester calculateDistanceWithLatitude:[feed objectForKey:@"latitude"] withLongitude:[feed objectForKey:@"longitude"]];
    if([[feed objectForKey:@"sex"] isEqualToString:@"0"]){
        [gender setImage:[UIImage imageNamed:@"female_hunter_icon"]];
    }else if ([[feed objectForKey:@"sex"] isEqualToString:@"1"]){
        [gender setImage:[UIImage imageNamed:@"male"]];
    }
    

    CGRect distanceFrame = distance.frame;
    distanceFrame.origin.x = age.frame.origin.x + age.frame.size.width + 3;
//    distance.frame = distanceFrame;
    [distance setText:distanceStr];
    [circleTitle setText:[feed objectForKey:@"content"]];
//    bg.layer.cornerRadius = Radius;
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    return cell;
}

#pragma mark - UITaleview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *feed = [feeds objectAtIndex:indexPath.row];
    if([[feed objectForKey:@"type"] isEqualToString:@"0"]) {
        ghuntertaskViewController *task = [[ghuntertaskViewController alloc] init];
        task.tid = [feed objectForKey:@"oid"];
        task.callBackBlock = ^{};
        [self.navigationController pushViewController:task animated:YES];
    } else if([[feed objectForKey:@"type"] isEqualToString:@"1"]) {
        
        ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
        userCenter.uid = [feed objectForKey:@"oid"];
        [self.navigationController pushViewController:userCenter animated:YES];
    }
    else if ([[feed objectForKey:@"type"] isEqualToString:@"2"])
    {
        ghunterSkillViewController *task = [[ghunterSkillViewController alloc] init];
        task.skillid = [feed objectForKey:@"oid"];
        task.callBackBlock = ^{};
        [self.navigationController pushViewController:task animated:YES];
    }
    else if ([[feed objectForKey:@"type"] isEqualToString:@"3"])
    {        
        ghuntertaskViewController * task = [[ghuntertaskViewController alloc] init];
        task.tid = [feed objectForKey:@"oid"];
        task.callBackBlock = ^{};
        [self.navigationController pushViewController:task animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
    [self getFeedWithPage:page isloading:NO];
    self.table.pullTableIsRefreshing = NO;
}

- (void)loadMoreDataToTable
{
    [self getFeedWithPage:page isloading:NO];
}

#pragma mark - Custom Methods

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)iconTaped:(UITapGestureRecognizer *)sender{
    NSDictionary *feed = [feeds objectAtIndex:sender.view.tag];
    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
    userCenter.uid = [feed objectForKey:UID];
    [self.navigationController pushViewController:userCenter animated:YES];
}

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}

@end
