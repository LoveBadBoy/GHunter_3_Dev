//
//  ghunterRewardAndSelectViewController.m
//  ghunter
//
//  Created by ImGondar on 15/12/29.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import "ghunterRewardAndSelectViewController.h"

@interface ghunterRewardAndSelectViewController ()


- (IBAction)back:(id)sender;

//打赏模式
- (IBAction)rewardBtnClick:(id)sender;

// 中意模式
- (IBAction)selectBtnClick:(id)sender;

@end

@implementation ghunterRewardAndSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.joinBtn.selected = NO;
    page = 1;
    
    rewardMutArray = [[NSMutableArray alloc] init];
    
    self.bidNumLabel.text = [NSString stringWithFormat:@"竞标人数：%@", self.bidString];
    
    rewardTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 104, mainScreenWidth, self.view.frame.size.height - 104 - 44) style:UITableViewStylePlain];
    rewardTableView.delegate = self;
    rewardTableView.dataSource = self;
    rewardTableView.pullDelegate = self;
    rewardTableView.showsVerticalScrollIndicator = NO;
    rewardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rewardTableView.backgroundColor = RGBCOLOR(235, 235, 235);
    [self.view addSubview:rewardTableView];
//    [self registerCell];
    
    // 数据
    [self didGetjoinersIsloading:YES withPages:page];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
}


// 注册cell
-(void)registerCell {
    
    UINib *nib=[UINib nibWithNibName:@"ghunterRewardCell" bundle:nil];
    [rewardTableView registerNib:nib forCellReuseIdentifier:@"strId"];
}



#pragma mark --- 参与竞标猎人信息 --- 
-(void)didGetjoinersIsloading:(BOOL )isloading withPages:(NSInteger) p{
    if (isloading) {
        [self startLoad];
    }
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.tidString forKey:@"tid"];
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)p] forKey:@"page"];
    
    [AFNetworkTool httpRequestWithUrl:URL_GET_JOINEDHUNTERS params:dict success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            
            
            if (p == 1) {
                [rewardMutArray removeAllObjects];
                
                page = 2;
                NSArray *array = [result valueForKey:@"joiners"];
                
                [rewardMutArray addObjectsFromArray:array];
                [rewardTableView reloadData];
                rewardTableView.pullTableIsRefreshing = NO;
            }else{
                page++;
                NSArray *array = [result valueForKey:@"joiners"];
                [rewardMutArray addObjectsFromArray:array];
                [rewardTableView reloadData];
                rewardTableView.pullTableIsLoadingMore = NO;
            }
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


#pragma mark --- UITableViewDeledate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rewardMutArray.count + 1;
}

#pragma mark --- UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    ghunterRewardCell * cell = [rewardTableView dequeueReusableCellWithIdentifier:@"strId"];
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    ghunterRewardCell * cell = [rewardTableView dequeueReusableCellWithIdentifier:@"strId"];
    static NSString *CellIdentifier = @"CellIdentifier123";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else {
        while ([cell.contentView.subviews lastObject]) {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if(indexPath.row == 0){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"descriptionView" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = 0;
        cell.frame = cellFrame;
    }else {
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ghunterRewardCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary * dict = [rewardMutArray objectAtIndex:indexPath.row - 1];

    
        UIImageView * userIcon = (UIImageView *)[cell viewWithTag:1];
        UILabel * nameLabel = (UILabel *)[cell viewWithTag:2];
//        UIImageView * genderImg = (UIImageView *)[cell viewWithTag:3];
//        UILabel * distanceLabel = (UILabel *)[cell viewWithTag:4];
        UIImageView * levelImg = (UIImageView *)[cell viewWithTag:5];
        UIImageView * identityImg = (UIImageView *)[cell viewWithTag:6];
        UILabel * abilityLabel = (UILabel *)[cell viewWithTag:7];

        // 头像
        [userIcon sd_setImageWithURL:[dict objectForKey:@"tiny_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        userIcon.layer.masksToBounds =YES;
        userIcon.layer.cornerRadius = userIcon.frame.size.width / 2;
        
//        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 10, 100, 21)];
        // 名字
        nameLabel.text = [dict objectForKey:@"username"];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        
        CGSize nameSize = [[dict objectForKey:@"username"] sizeWithFont:nameLabel.font];
        CGRect nameFrame = nameLabel.frame;
        if (nameSize.width > 120) {
            
            nameFrame.size.width = 120;
        }else {
            nameFrame.size.width = nameSize.width;
        }
        nameFrame.origin.x = userIcon.frame.origin.x + userIcon.frame.size.width + 10;
        nameLabel.frame = nameFrame;
        [cell addSubview:nameLabel];
        
        UIImageView * genderImg = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 8, 8)];
        // 性别
        if ([[dict objectForKey:@"sex"] isEqualToString:@"1"]) {
            genderImg.image = [UIImage imageNamed:@"male"];
        }else {
            genderImg.image = [UIImage imageNamed:@"female"];
        }
        CGRect genderFrame = genderImg.frame;
        genderFrame.origin.x = nameLabel.frame.origin.x + nameSize.width + 5;
        genderImg.frame = genderFrame;
        [cell addSubview:genderImg];
        
        // 距离
        UILabel * distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(genderImg.frame.size.width + genderImg.frame.origin.x + 5, 8, 100, 21)];
        distanceLabel.font = [UIFont systemFontOfSize:10];
        distanceLabel.textColor = [UIColor grayColor];
        distanceLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:distanceLabel];
        if ([[dict objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:UID]]) {
            [distanceLabel setText:@"0m"];
        }
        NSString * distancestar = [ghunterRequester calculateDistanceWithLatitude:[dict objectForKey:@"latitude"] withLongitude:[dict objectForKey:@"longitude"]];
        distanceLabel.text = [NSString stringWithFormat:@"%@", distancestar];
        [distanceLabel setText:distancestar];
        
        CGSize distanceSize = [distancestar sizeWithFont:distanceLabel.font];
        CGRect distanceFrame = distanceLabel.frame;
        distanceFrame.origin.x = genderImg.frame.origin.x + genderImg.frame.size.width + 5;
        distanceFrame.size.width = distanceSize.width;
        distanceLabel.frame = distanceFrame;
        
        // 星级
        star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(distanceLabel.frame.size.width + distanceLabel.frame.origin.x + 5,13, 50, 10) numberOfStar:5 ];
        [cell addSubview:star];
        [star setScore:[[dict objectForKey:@"kopubility"] floatValue]];
        [star setuserInteractionEnabled:NO];
        
        // 等级
        NSInteger i = [NSString stringWithFormat:@"%@",[dict objectForKey:@"level"]].intValue;
        levelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级%ld", (long)i]];
        
        // 认证
        if ([[dict objectForKey:@"is_identity"] isEqualToString:@"1"]){
            identityImg.image = [UIImage imageNamed:@"实名认证"];
        }else{
            identityImg.hidden = YES;
        }
        
        // 能力值
        abilityLabel.text = [NSString stringWithFormat:@"活跃值：%@  能力值：%@", [dict objectForKey:@"activeness"], [dict objectForKey:@"ability"]];
        abilityLabel.textAlignment = NSTextAlignmentLeft;
        abilityLabel.font = [UIFont systemFontOfSize:10];
        
        
        //
        UILabel * lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, mainScreenWidth, 0.5)];
        lineLb.backgroundColor = RGBCOLOR(235, 235, 235);
        [cell addSubview:lineLb];
    }
    
    return cell;
}


- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark --- refreshAndLoad
- (void)refreshTable {
    
    page = 1;
    [self didGetjoinersIsloading:NO withPages:page];
}

- (void)loadMoreDataToTable {
    
    [self didGetjoinersIsloading:NO withPages:page];
}


#pragma mark --- 打赏 ---
- (IBAction)rewardBtnClick:(id)sender {
}

#pragma mark --- 中意 ---
- (IBAction)selectBtnClick:(id)sender {
    
    if (self.joinBtn.selected == NO) {
        self.joinBtn.selected = YES;
        [rewardTableView setEditing:YES animated:YES];
    }else {
        self.joinBtn.selected = NO;
        [rewardTableView setEditing:NO animated:YES];
    }
    
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


@end