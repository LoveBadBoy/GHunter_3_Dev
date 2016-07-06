//
//  ghunter123ViewController.m
//  ghunter
//
//  Created by imgondar on 15/12/31.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import "ghunterSigninViewController.h"

@interface ghunterSigninViewController ()

@end

@implementation ghunterSigninViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBarController.tabBar.hidden = YES;
//    _rewardLabel = [[UILabel alloc]init];
//    _estraLabel = [[UILabel alloc]init];
//    _rankLabel = [[UILabel alloc]init];
//    _daysLabel = [[UILabel alloc]init];
    rankArray = [[NSMutableArray alloc] init];
    _rewardLabel.text = [NSString stringWithFormat:@"%@.0",_reward];
    _estraLabel.text = _estra;
    _rankLabel.text = [NSString stringWithFormat:@"您的排名：%@，击败了%@的猎人",_rank,_proportion];
    _daysLabel.text = [NSString stringWithFormat:@"已连续签到%@天",_days];
    rankTableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, _footView.frame.size.height+_footView.frame.origin.y, mainScreenWidth, mainScreenheight-_footView.frame.size.height-_footView.frame.origin.y)];
    rankTableView.delegate = self;
    rankTableView.dataSource = self;
    rankTableView.pullDelegate = self;
    rankTableView.showsVerticalScrollIndicator = NO;
    rankTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rankTableView];
    page = 1;
    [self didGetTaskListIsloading:NO withPage:page];
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)help:(id)sender {
    [self popHelpView];
}
-(void)popHelpView
{
    pictureAlert = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"Help" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter.backgroundColor = [UIColor yellowColor];
    taskFilter = [nibs objectAtIndex:0];
    CGRect taskfilterFrame = taskFilter.frame;
    taskfilterFrame.size.width = mainScreenWidth;
    taskFilter.frame = taskfilterFrame;
    pictureAlert.containerFrame = CGRectMake(0, (mainScreenheight - taskfilterFrame.size.height), mainScreenWidth, taskfilterFrame.size.height);
    pictureAlert.showView = taskFilter;
    
    
    [pictureAlert show];
}
// 分享签到

#pragma mark - share
- (IBAction)shareSignrewardClick:(id)sender{
    shareView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"shareView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    [shareView setCornerRadius:8.0];
    
    CGRect width = taskFilter.frame;
    width.size.width = mainScreenWidth - 20;
    taskFilter.frame = width;
    
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
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"【赏金测人品】我的今日人品为%@，成功领取%@分赏金",[NSString stringWithFormat:@"%.1f", signReward],[NSString stringWithFormat:@"%.1f",signReward]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
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
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"【赏金测人品】我的今日人品为%@，成功领取%@分赏金",[NSString stringWithFormat:@"%.1f",signReward],[NSString stringWithFormat:@"%.1f",signReward]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
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
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"【赏金测人品】我的今日人品为%@，成功领取%@分赏金http://mob.imGondar.com/activity/checkin/%@?code=%d",[NSString stringWithFormat:@"%.1f",signReward],[NSString stringWithFormat:@"%.1f",signReward],[ghunterRequester getUserInfo:UID], code] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
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
        [shareView dismissAnimated:YES];
        CGFloat signReward = [gunread_signreward floatValue];
        [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qzoneData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[ghunterRequester getUserInfo:TINY_AVATAR]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:[NSString stringWithFormat:@"【赏金测人品】我的今日人品为%@，成功领取%@分赏金",[NSString stringWithFormat:@"%.1f",signReward],[NSString stringWithFormat:@"%.1f",signReward]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:@"0" :SHARETYPE_SIGN :gunread_signreward :SHAREPLATFORM_QZONE];
            }
        }];
    }else if([btn tag] == 7){
        // qq
        [shareView dismissAnimated:YES];
        CGFloat signReward = [gunread_signreward floatValue];
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qqData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[ghunterRequester getUserInfo:TINY_AVATAR]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"【赏金测人品】我的今日人品为%@，成功领取%@分赏金",[NSString stringWithFormat:@"%.1f",signReward],[NSString stringWithFormat:@"%.1f",signReward]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:@"0" :SHARETYPE_SIGN :gunread_signreward :SHAREPLATFORM_QQ];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *task;
    
    task= [rankArray objectAtIndex:indexPath.row];
    
    ghunterUserCenterViewController *user = [[ghunterUserCenterViewController alloc] init];
    
    user.uid = [task objectForKey:@"uid"];
    
    [self.navigationController pushViewController:user animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return rankArray.count;
}

#pragma mark - UITableVIewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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
    
    NSDictionary *task = [rankArray objectAtIndex:indexPath.row];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"rank" owner:self options:nil];
    cell = [nibs objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *icon = (UIImageView *)[cell viewWithTag:2];
    UILabel *rank = (UILabel *)[cell viewWithTag:1];
    UILabel *name = (UILabel *)[cell viewWithTag:3];
    UILabel *reward = (UILabel *)[cell viewWithTag:5];
//        UIImageView *gender = (UIImageView *)[cell viewWithTag:4];
    UIImageView *gender = [[UIImageView alloc]init];
    gender.frame = CGRectMake(10, 17, 10, 10);
    icon.layer.masksToBounds =YES;
    icon.layer.cornerRadius = 15;
    NSString *str = [task objectForKey:@"avatar"];
    [icon sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage alloc]];
    reward.text = [task objectForKey:@"reward"];
    rank.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    CGRect rewardFrame = reward.frame;
    rewardFrame.origin.x = mainScreenWidth - reward.frame.size.width - 10;
    reward.frame = rewardFrame;
    
    CGFloat spaceTitle2Description = name.frame.origin.x + 10;
    NSString *descriptionStr = [task objectForKey:@"username"];
    CGSize descriptionSize = [descriptionStr sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(name.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    name.text = descriptionStr;
    NSString *fourStr = [task objectForKey:@"sex"];
    CGRect descriptionFrameOrigin = gender.frame;
    descriptionFrameOrigin.origin.x = spaceTitle2Description + descriptionSize.width;
    
    gender.frame = descriptionFrameOrigin;
    [cell addSubview:gender];
    if ([fourStr isEqualToString:@"1"]) {
        gender.image = [UIImage imageNamed:@"male"];
    }else{
        gender.image  = [UIImage imageNamed:@"female"];
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
    page = 1;
    [self didGetTaskListIsloading:NO withPage:page ];
    
}

- (void)loadMoreDataToTable{
    [self didGetTaskListIsloading:NO withPage:page ];
}

-(void)didGetTaskListIsloading:(BOOL )isloading withPage:(NSInteger)p {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)p] forKey:@"page"];
    
    [AFNetworkTool httpRequestWithUrl:URL_CHACKIN_RANK params:dict success:^(NSData *data) {
       
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([[result objectForKey:@"error"]integerValue] == 0){
            
            if (p==1) {
                [rankArray removeAllObjects];
                page = 2;
                NSArray * array = [result objectForKey:@"signs"];
                if (array) {
                    [rankArray addObjectsFromArray:array];
                    
                    [rankTableView reloadData];
                    rankTableView.pullTableIsRefreshing = NO;
                }
            }else{
                page++;
                
                NSArray *array = [result valueForKey:@"signs"];
                if (array.count) {
                    [rankArray addObjectsFromArray:array];
                    [rankTableView reloadData];
                    rankTableView.pullTableIsLoadingMore = NO;

                }else{
                    rankTableView.pullTableIsLoadingMore = NO;
                }
            }
        }
    } fail:^{
        
    }];
}


@end
