//
//  ghuntermyCollectionViewController.m
//  ghunter
//
//  Created by imGondar on 14-5-16.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//我的收藏

#import "ghuntermyCollectionViewController.h"
#import "ghunterTabViewController.h"
#import "ghunterCollectSkillCell.h"
#import "ghunterSkillViewController.h"

@interface ghuntermyCollectionViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *topBGImageView;
@property (weak, nonatomic) UIImageView *topBGSliderImageView;
@property (nonatomic,assign)BOOL swapByTapButton;
@property(nonatomic,assign)BOOL firstTimeShowTaskTableView;
@property(nonatomic,assign)BOOL firstTimeShowSkillTableView;

@property (strong, nonatomic) IBOutlet UIView *bg;


@end

@implementation ghuntermyCollectionViewController

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
     _bg.backgroundColor = Nav_backgroud;
    // Do any additional setup after loading the view from its nib.
    page = 1;
    self.firstTimeShowTaskTableView = YES;
    self.firstTimeShowSkillTableView = YES;
    [self layoutHeadView];

}
-(void)layoutHeadView
{
    taskRadio = [[QRadioButton alloc] initWithDelegate:self groupId:@"findGroup"];
    CGFloat radioY = _topBGImageView.frame.origin.y + 2;
    CGFloat radioWidth = _topBGImageView.frame.size.width * 0.5 - 4;
    CGFloat radioHeight = _topBGImageView.frame.size.height - 4;
    UIColor *radioColor = [UIColor whiteColor];
    UIColor *radioSelectedColor = [UIColor colorWithRed:205/255.0 green:86/255.0 blue:32/255.0 alpha:1.0];
//    CGRect frame = CGRectMake(_topBGImageView.frame.origin.x + 2, radioY, radioWidth, radioHeight);
    CGRect frame = CGRectMake(mainScreenWidth*0.5 - _topBGImageView.frame.size.width*0.5 + 2, radioY, radioWidth, radioHeight);

    
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
    skillRadio.frame = CGRectMake(mainScreenWidth*0.5+2, radioY, radioWidth, radioHeight);
    [skillRadio setTitle:@"技能" forState:UIControlStateNormal];
    [skillRadio.titleLabel setFont: [UIFont systemFontOfSize:14.0f]];
    [skillRadio setTitleColor:radioColor forState:UIControlStateNormal];
    [skillRadio setTitleColor:radioSelectedColor forState:UIControlStateSelected];
    [skillRadio addTarget:self action:@selector(click2ShowHunter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skillRadio];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64 )];
    _scrollView.contentSize = CGSizeMake(mainScreenWidth *2, _scrollView.bounds.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    collectionArray = [[NSMutableArray alloc] init];
    collectionSkillArray = [[NSMutableArray alloc] init];
    mycollectionTable = [[PullTableView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    mycollectionTable.delegate = self;
    mycollectionTable.dataSource = self;
    mycollectionTable.pullDelegate = self;
    mycollectionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mycollectionTable.showsVerticalScrollIndicator = NO;
    mycollectionTable.backgroundColor = RGBCOLOR(235, 235, 235);
    mycollectionTable.separatorColor = RGBCOLOR(229, 229, 229);
    [_scrollView addSubview:mycollectionTable];
    myCollectionSkill = [[PullTableView alloc] initWithFrame:CGRectMake(mainScreenWidth,0, mainScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    myCollectionSkill.delegate = self;
    myCollectionSkill.dataSource = self;
    myCollectionSkill.pullDelegate = self;
    myCollectionSkill.separatorStyle = UITableViewCellSeparatorStyleNone;

    myCollectionSkill.showsVerticalScrollIndicator = NO;
    myCollectionSkill.backgroundColor = RGBCOLOR(235, 235, 235);
    [_scrollView addSubview:myCollectionSkill];
    
    // 隐藏横线
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    [myCollectionSkill setTableFooterView:view];
    [mycollectionTable setTableFooterView:view];
}
- (void)viewDidAppear:(BOOL)animated {
    [MobClick event:UMEVENT_MY_COLLECTION];
    if (self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = YES;
        [UIView animateWithDuration:0.3f animations:^{
            [self.tabBarController.tabBar setFrame:CGRectMake(0, mainScreenheight - TAB_BAR_HEIGHT, mainScreenWidth, TAB_BAR_HEIGHT)];
        } completion:^(BOOL finished) {
            [_scrollView setFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64)];
            _scrollView.contentSize = CGSizeMake(mainScreenWidth*2, _scrollView.bounds.size.height);
            [mycollectionTable setFrame:CGRectMake(0, 0, mainScreenWidth, _scrollView.frame.size.height)];
            [myCollectionSkill setFrame:CGRectMake(mainScreenWidth, 0, mainScreenWidth, _scrollView.frame.size.height)];
        }];
    }
    if (_scrollView.contentOffset.x && self.firstTimeShowSkillTableView) {
        [self startLoad];
        // 获取技能列表
        [self rlSkillList:@"1" withRL:REQUEST_FOR_COLLECTION_SKILLSHOW];
        self.firstTimeShowSkillTableView = NO;
    }
    if (!_scrollView.contentOffset.x && self.firstTimeShowTaskTableView) {
        [self startLoad];
        // 获取任务列表
        [self rlTaskList:@"0" withRL:REQUEST_FOR_REFRESH_COLLECTION];
        self.firstTimeShowTaskTableView = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    ghunterTabViewController *tbvc = (ghunterTabViewController *)self.tabBarController;
    if (!tbvc.didSelectItemOfTabBar) {
        self.tabBarController.tabBar.hidden = YES;
        [self.tabBarController.tabBar setFrame:CGRectMake(0, mainScreenheight, mainScreenWidth, TAB_BAR_HEIGHT)];
        [_scrollView setFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64)];
        _scrollView.contentSize = CGSizeMake(mainScreenWidth*2, _scrollView.bounds.size.height);
        [mycollectionTable setFrame:CGRectMake(0, 0, mainScreenWidth, _scrollView.frame.size.height)];
        [myCollectionSkill setFrame:CGRectMake(mainScreenWidth, 0, mainScreenWidth, _scrollView.frame.size.height)];
    }
    else {
        [_scrollView setFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64)];
        _scrollView.contentSize = CGSizeMake(mainScreenWidth*2, _scrollView.bounds.size.height);
        [mycollectionTable setFrame:CGRectMake(0, 0, mainScreenWidth, _scrollView.frame.size.height)];
        [myCollectionSkill setFrame:CGRectMake(mainScreenWidth, 0, mainScreenWidth, _scrollView.frame.size.height)];
    }
    self.navigationController.navigationBarHidden = YES;
    if(!_scrollView.contentOffset.x) {
        [taskRadio setSelected:YES];
        [skillRadio setSelected:NO];
    } else {
        [taskRadio setSelected:NO];
        [skillRadio setSelected:YES];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

}
- (void)click2ShowTask {
    
    self.swapByTapButton = YES;
    [taskRadio setSelected:YES];
    [skillRadio setSelected:NO];
   
    [UIView animateWithDuration:0.2 animations:^{
        [_topBGSliderImageView setFrame:taskRadio.frame];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } completion:^(BOOL finished) {
        if (self.firstTimeShowTaskTableView) {
            [self startLoad];
            [self rlSkillList:@"0" withRL:REQUEST_FOR_REFRESH_COLLECTION];
            self.firstTimeShowTaskTableView = NO;
        }
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.swapByTapButton) {
        CGPoint skillViewOrigin = [myCollectionSkill convertPoint:CGPointMake(0, 0) toView:self.view];
        if (skillViewOrigin.x >= mainScreenWidth * 0.5) {
            [taskRadio setSelected:YES];
            [skillRadio setSelected:NO];
            [UIView animateWithDuration:0.2 animations:^{
                [_topBGSliderImageView setFrame:taskRadio.frame];
            }];
        }
        else {
            [taskRadio setSelected:NO];
            [skillRadio setSelected:YES];
            
            [UIView animateWithDuration:0.2 animations:^{
                [_topBGSliderImageView setFrame:skillRadio.frame];
            }];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.x && self.firstTimeShowSkillTableView){
        [self startLoad];
        page = 1;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
        [ghunterRequester postwithDelegate:self withUrl:URL_GET_COLLECTION_SKILLSHOW
                              withUserInfo:REQUEST_FOR_COLLECTION_SKILLSHOW withDictionary:dic];
        [self rlSkillList:@"1" withRL:REQUEST_FOR_COLLECTION_SKILLSHOW];
        self.firstTimeShowSkillTableView = NO;
    }
    else if (!scrollView.contentOffset.x && self.firstTimeShowTaskTableView) {
        [self startLoad];
        [self rlSkillList:@"0" withRL:REQUEST_FOR_REFRESH_COLLECTION];
        self.firstTimeShowTaskTableView = NO;
    }
    self.swapByTapButton = NO;
}

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}

- (void)click2ShowHunter {
    self.swapByTapButton = YES;
    [taskRadio setSelected:NO];
    [skillRadio setSelected:YES];
    [UIView animateWithDuration:0.2 animations:^{
        [_topBGSliderImageView setFrame:skillRadio.frame];
        [_scrollView setContentOffset:CGPointMake(mainScreenWidth, 0) animated:YES];
    } completion:^(BOOL finished) {
        if (self.firstTimeShowSkillTableView) {
            [self startLoad];
            page = 1;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
            
            [ghunterRequester postwithDelegate:self withUrl:URL_GET_COLLECTION_SKILLSHOW
                                  withUserInfo:REQUEST_FOR_COLLECTION_SKILLSHOW withDictionary:dic];
            [self rlSkillList:@"1" withRL:REQUEST_FOR_COLLECTION_SKILLSHOW];
            self.firstTimeShowSkillTableView = NO;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate UITableViewDatasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == mycollectionTable) {
        ghuntertaskViewController *ghuntertask = [[ghuntertaskViewController alloc] init];
        
        NSDictionary *task = [collectionArray objectAtIndex:indexPath.row];
        ghuntertask.tid = [task objectForKey:@"oid"];
        ghuntertask.callBackBlock = ^{};
        [self.navigationController pushViewController:ghuntertask animated:YES];
    }else if(tableView == myCollectionSkill){
        ghunterSkillViewController *skillView = [[ghunterSkillViewController alloc] init];
        NSDictionary *task = [collectionSkillArray objectAtIndex:indexPath.row];
        skillView.skillid = [task objectForKey:@"oid"];
        skillView.callBackBlock = ^{};
        
        [self.navigationController pushViewController:skillView animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == mycollectionTable) {
        return [collectionArray count];
    }
    if (tableView == myCollectionSkill) {
        return collectionSkillArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (tableView ==mycollectionTable) {
        
        return cell.frame.size.height;
    }
    if (tableView == myCollectionSkill) {
        return 115;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == mycollectionTable) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *collect = [collectionArray objectAtIndex:indexPath.row];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"hunterCircleView" owner:self options:nil];
        
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
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
        
        [shangLabel.layer setCornerRadius:10];
        [shangLabel.layer setBorderWidth:1];
        [shangLabel.layer setBorderColor:[UIColor colorWithRed:244.0 / 255 green:78 / 255.0 blue:32.0 / 255 alpha:1].CGColor];
        shangLabel.textColor = [UIColor colorWithRed:244.0 / 255 green:78 / 255.0 blue:32.0 / 255 alpha:1];
        shangLabel.textAlignment = NSTextAlignmentCenter;
        shangLabel.text = @"赏";
        UIView *grayView = [cell viewWithTag:10000];
        [grayView.layer setCornerRadius:5];
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
        OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:9];
        UIView *bg = (UIView *)[cell viewWithTag:10];
        UIImageView *round = (UIImageView *)[cell viewWithTag:11];
        NSString *bountySelf = [collect objectForKey:@"bounty"];
        NSString *bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
        NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
//        [attrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange([bountySelf length], 1)];
//        [attrStr setFont:[UIFont systemFontOfSize:24.0] range:NSMakeRange(0, [bountySelf length])];
        //[attrStr setTextColor:[UIColor colorWithRed:89/255.0 green:87/255.0 blue:87/255.0 alpha:1.0]];
        [attrStr setTextColor:[UIColor colorWithRed:244.0 / 255 green:78 / 255.0 blue:32 / 255.0 alpha:1]];
        bounty.font = [UIFont systemFontOfSize:12];
        [bounty setAttributedText:attrStr];
        
        CGRect bountyFrame = bounty.frame;
        
//        bountyFrame.origin.x = shangLabel.frame.origin.x;
        bountyFrame.origin.y = shangLabel.frame.origin.y + 2;
        
        bounty.frame = bountyFrame;
        
        CGFloat top = 20; // 顶端盖高度
        CGFloat bottom = bg.frame.size.height - top - 1; // 底端盖高度
        CGFloat left = 20; // 左端盖宽度
        CGFloat right = bg.frame.size.width - left - 1; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        bg.backgroundColor=[UIColor whiteColor];
        UIImage *image = [UIImage imageNamed:@"white"];
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        [round setImage:image];
        icon.userInteractionEnabled = YES;
        icon.clipsToBounds = YES;
        icon.layer.cornerRadius = icon.frame.size.width*0.5;
        [icon sd_setImageWithURL:[collect objectForKey:@"owner_tinyavatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
        icon.tag = indexPath.row;
        [icon addGestureRecognizer:tap];
        NSString *usernameStr = [collect objectForKey:@"owner_username"];
        NSString *typeStr = [collect objectForKey:@"ctitle"];
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
        type.textColor = [UIColor colorWithRed:242/255.0 green:153/255.0 blue:114/255.0 alpha:1.0];
        
        [type setText:[collect objectForKey:@"ctitle"]];
        [dateline setText:[ghunterRequester getTimeDescripton:[collect objectForKey:@"dateline"]]];
        NSString *ageStr = [NSString stringWithFormat:@"%@岁",[collect objectForKey:@"owner_age"]];
        NSString *distanceStr = [ghunterRequester calculateDistanceWithLatitude:[collect objectForKey:@"latitude"] withLongitude:[collect objectForKey:@"longitude"]];
        if([[collect objectForKey:@"owner_sex"] isEqualToString:@"0"]){
            [gender setImage:[UIImage imageNamed:@"female"]];
        }else if ([[collect objectForKey:@"owner_sex"] isEqualToString:@"1"]){
            [gender setImage:[UIImage imageNamed:@"male"]];
        }
        CGRect ageFrame = age.frame;
        CGSize ageSize = [ageStr sizeWithFont:age.font];
        ageFrame.origin.x = gender.frame.origin.x + gender.frame.size.width + 3;
        ageFrame.size.width = ageSize.width;
        age.frame = ageFrame;
//        [age setText:ageStr];
        CGRect distanceFrame = distance.frame;
        distanceFrame.origin.x = age.frame.origin.x + age.frame.size.width + 3;
//        distance.frame = distanceFrame;
        [distance setText:distanceStr];
        [circleTitle setText:[collect objectForKey:@"title"]];
//        bg.layer.cornerRadius = Radius;
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(delete_collect:)];
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:longpress];
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }

        
        return cell;
    }else if (tableView == myCollectionSkill)
    {
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *collect = [collectionSkillArray objectAtIndex:indexPath.row];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"hunterCircleView" owner:self options:nil];
        
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
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
        
        [shangLabel.layer setCornerRadius:10];
        [shangLabel.layer setBorderWidth:1];
        [shangLabel.layer setBorderColor:[UIColor colorWithRed:244.0 / 255 green:78 / 255.0 blue:32.0 / 255 alpha:1].CGColor];
        shangLabel.textColor = [UIColor colorWithRed:244.0 / 255 green:78 / 255.0 blue:32.0 / 255 alpha:1];
        shangLabel.textAlignment = NSTextAlignmentCenter;
        shangLabel.text = @"售";
        UIView *grayView = [cell viewWithTag:10000];
        [grayView.layer setCornerRadius:5];
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
        OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:9];
        UIView *bg = (UIView *)[cell viewWithTag:10];
        UIImageView *round = (UIImageView *)[cell viewWithTag:11];
        NSString *priceunit = [collect objectForKey:@"priceunit"];
        NSString *bountySelf = [collect objectForKey:@"price"];
        NSString *bountyStr = [NSString stringWithFormat:@"%@元/%@",bountySelf,priceunit];
        NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
        //        [attrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange([bountySelf length], 1)];
        //        [attrStr setFont:[UIFont systemFontOfSize:24.0] range:NSMakeRange(0, [bountySelf length])];
        //[attrStr setTextColor:[UIColor colorWithRed:89/255.0 green:87/255.0 blue:87/255.0 alpha:1.0]];
        [attrStr setTextColor:[UIColor colorWithRed:244.0 / 255 green:78 / 255.0 blue:32 / 255.0 alpha:1]];
        bounty.font = [UIFont systemFontOfSize:12];
        [bounty setAttributedText:attrStr];
        
        CGRect bountyFrame = bounty.frame;
        
        //        bountyFrame.origin.x = shangLabel.frame.origin.x;
        bountyFrame.origin.y = shangLabel.frame.origin.y + 2;
        
        bounty.frame = bountyFrame;
        
        CGFloat top = 20; // 顶端盖高度
        CGFloat bottom = bg.frame.size.height - top - 1; // 底端盖高度
        CGFloat left = 20; // 左端盖宽度
        CGFloat right = bg.frame.size.width - left - 1; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        bg.backgroundColor=[UIColor whiteColor];
        UIImage *image = [UIImage imageNamed:@"white"];
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        [round setImage:image];
        icon.userInteractionEnabled = YES;
        icon.clipsToBounds = YES;
        icon.layer.cornerRadius = icon.frame.size.width*0.5;
        [icon sd_setImageWithURL:[collect objectForKey:@"owner_tinyavatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
        icon.tag = indexPath.row;
        [icon addGestureRecognizer:tap];
        NSString *usernameStr = [collect objectForKey:@"owner_username"];
        NSString *typeStr = [collect objectForKey:@"ctitle"];
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
        type.textColor = [UIColor colorWithRed:242/255.0 green:153/255.0 blue:114/255.0 alpha:1.0];
        
        [type setText:[collect objectForKey:@"ctitle"]];
        [dateline setText:[ghunterRequester getTimeDescripton:[collect objectForKey:@"dateline"]]];
        NSString *ageStr = [NSString stringWithFormat:@"%@岁",[collect objectForKey:@"owner_age"]];
        NSString *distanceStr = [ghunterRequester calculateDistanceWithLatitude:[collect objectForKey:@"latitude"] withLongitude:[collect objectForKey:@"longitude"]];
        if([[collect objectForKey:@"owner_sex"] isEqualToString:@"0"]){
            [gender setImage:[UIImage imageNamed:@"female"]];
        }else if ([[collect objectForKey:@"owner_sex"] isEqualToString:@"1"]){
            [gender setImage:[UIImage imageNamed:@"male"]];
        }
        CGRect ageFrame = age.frame;
        CGSize ageSize = [ageStr sizeWithFont:age.font];
        ageFrame.origin.x = gender.frame.origin.x + gender.frame.size.width + 3;
        ageFrame.size.width = ageSize.width;
        age.frame = ageFrame;
        //        [age setText:ageStr];
        CGRect distanceFrame = distance.frame;
        distanceFrame.origin.x = age.frame.origin.x + age.frame.size.width + 3;
        //        distance.frame = distanceFrame;
        [distance setText:distanceStr];
        [circleTitle setText:[collect objectForKey:@"title"]];
        //        bg.layer.cornerRadius = Radius;
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(delete_collect:)];
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:longpress];
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        
        return cell;
    }
//    {
//        static NSString *str = @"skill";
//        ghunterCollectSkillCell *cell = [myCollectionSkill dequeueReusableCellWithIdentifier:str];
//        if (cell == nil) {
//            cell = [[ghunterCollectSkillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
//        }
//        cell.userInteractionEnabled = YES;
//        cell.contentView.userInteractionEnabled = YES;
//        cell.backImageview.userInteractionEnabled = YES;
//        NSDictionary *collect = [collectionSkillArray objectAtIndex:indexPath.row];
////        cell.contentView.backgroundColor = [UIColor colorWithRed:228 / 255.0 green:227 / 255.0 blue:221 / 255.0 alpha:1];]
//        cell.contentView.backgroundColor = [UIColor whiteColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.imageView.userInteractionEnabled = YES;
//        [cell.iconImageView  sd_setImageWithURL:[collect objectForKey:@"owner_tinyavatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
//        UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
//        
//        UIImageView *icontap = cell.iconImageView;
//        [icontap.layer setCornerRadius:5];
//        icontap.layer.masksToBounds = YES;
//        icontap.userInteractionEnabled = YES;
//        icontap.tag = indexPath.row;
//        [icontap addGestureRecognizer:taps];
//
//        cell.name.font = [UIFont systemFontOfSize:14];
//        NSString *nameStr = [collect objectForKey:@"owner_username"];
//        NSString *jinengStr = [collect objectForKey:@"ctitle"];
//        cell.jienngLabel.font = [UIFont systemFontOfSize:11];
//        cell.name.frame = CGRectMake(mainScreenWidth / 5.33, 8, mainScreenWidth / 5.71, 15);
//        cell.jienngLabel.frame = CGRectMake(mainScreenWidth / 2.758, 8, mainScreenWidth / 3.5, 15);
//        cell.timeLabel.frame = CGRectMake(mainScreenWidth / 1.25, 8, mainScreenWidth / 6.4, 15);
//        cell.jienngLabel.textColor = [UIColor colorWithRed:242/255.0 green:153/255.0 blue:114/255.0 alpha:1.0];
//        
//        CGSize usernameSize = [nameStr sizeWithFont:cell.name.font];
//        CGSize typeSize = [jinengStr sizeWithFont:cell.jienngLabel.font];
//        if(cell.name.frame.origin.x + usernameSize.width + 3 +typeSize.width + 3 > cell.timeLabel.frame.origin.x){
//            usernameSize.width = cell.timeLabel.frame.origin.x - 3 - typeSize.width - 3 - cell.name.frame.origin.x;
//        }
//        CGRect usernameFrame = cell.name.frame;
//        usernameFrame.size.width = usernameSize.width;
//        [cell.name setFrame:usernameFrame];
//        [cell.name setText:nameStr];
//        CGRect typeFrame = cell.jienngLabel.frame;
//        typeFrame.origin.x = cell.name.frame.origin.x + cell.name.frame.size.width + 5;
//        typeFrame.size.width = typeSize.width;
//        cell.jienngLabel.frame = typeFrame;
//        cell.jienngLabel.textColor = [UIColor colorWithRed:242/255.0 green:153/255.0 blue:114/255.0 alpha:1.0];
//        
//        [cell.jienngLabel setText:[collect objectForKey:@"ctitle"]];
//        
//        if([[collect objectForKey:@"owner_sex"] isEqualToString:@"0"]){
//            [cell.sexImageView setImage:[UIImage imageNamed:@"female"]];
//        }else if ([[collect objectForKey:@"owner_sex"] isEqualToString:@"1"]){
//            [cell.sexImageView setImage:[UIImage imageNamed:@"male"]];
//        }
//        NSString *ageStr = [NSString stringWithFormat:@"%@岁",[collect objectForKey:@"owner_age"]];
//        cell.ageLabel.font = [UIFont systemFontOfSize:12];
//        cell.ageLabel.alpha = 0.7;
////        cell.ageLabel.text = ageStr;
//        NSString *distanceStr = [ghunterRequester calculateDistanceWithLatitude:[collect objectForKey:@"latitude"] withLongitude:[collect objectForKey:@"longitude"]];
//        cell.distanceLabel.font = [UIFont systemFontOfSize:12];
//        cell.distanceLabel.alpha = 0.7;
//        cell.distanceLabel.text = distanceStr;
////        cell.distanceLabel.frame = CGRectMake(mainScreenWidth / 3.1, 32, mainScreenWidth / 5.714, 15);
//        cell.distanceLabel.frame = CGRectMake(cell.sexImageView.frame.origin.x + cell.sexImageView.frame.size.width, 32, mainScreenWidth / 5.714, 15);
//        cell.showSkillLabel.font = [UIFont systemFontOfSize:12];
//        cell.showSkillLabel.alpha = 0.5;
//        cell.showSkillLabel.text =[collect objectForKey:@"title"];
//        cell.timeLabel.font = [UIFont systemFontOfSize:10];
//        cell.timeLabel.alpha = 0.4;
//        cell.timeLabel.text = [ghunterRequester getTimeDescripton:[collect objectForKey:@"dateline"]];
//        cell.scaleLabel.textColor = [UIColor colorWithRed:244.0 / 255 green:78 / 255.0 blue:32.0 / 255 alpha:1];
//        cell.scaleLabel.text = @" 售";
//        cell.scaleLabel.font = [UIFont systemFontOfSize:14];
//        NSString *priceunit = [collect objectForKey:@"priceunit"];
//                NSString *bountySelf = [collect objectForKey:@"price"];
//                NSString *bountyStr = [NSString stringWithFormat:@"%@元/%@",bountySelf,priceunit];
//        NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
//        if (![priceunit isEqualToString:@"小时"]) {
//            
//            [attrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange([bountySelf length], 3)];
//        }else{
//             [attrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange([bountySelf length], 4)];
//        }
//        [attrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, [bountySelf length])];
//        [attrStr setTextColor:[UIColor colorWithRed:244.0 / 255 green:78 / 255.0 blue:32.0 / 255 alpha:1]];
//        cell.priceLabel.textColor = [UIColor colorWithRed:244.0 / 255 green:78 / 255.0 blue:32.0 / 255 alpha:1];
//        [cell.priceLabel setAttributedText:attrStr];
//        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(delete_collect:)];
//        cell.tag = indexPath.row;
//        [cell addGestureRecognizer:longpress];
//        
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//            [cell setSeparatorInset:UIEdgeInsetsZero];
//        }
//        
//        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//            [cell setLayoutMargins:UIEdgeInsetsZero];
//        }
//
//        return cell;
//    }
    else{
        return nil;
    }
}

#pragma mark - ASIHttprequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
        if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REFRESH_COLLECTION]){
            [self endLoad];
            if(responseCode==200 && [error_number integerValue] == 0)
            {
                [collectionArray removeAllObjects];
                page = 2;
                NSArray *array = [dic valueForKey:@"collections"];
                [collectionArray addObjectsFromArray:array];
                [mycollectionTable reloadData];

            } else if ([dic objectForKey:@"msg"]) {
                [collectionArray removeAllObjects];
                [mycollectionTable reloadData];
                [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            } else {
                [collectionArray removeAllObjects];
                [mycollectionTable reloadData];
                [ghunterRequester noMsg];
            }
        } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_COLLECTIONRENWU]){
            if(responseCode==200 && [error_number integerValue] == 0)
            {
                page++;
                NSArray *array = [dic valueForKey:@"collections"];
                [collectionArray addObjectsFromArray:array];
                [mycollectionTable reloadData];
            } else if ([dic objectForKey:@"msg"]) {
                [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            } else {
                [ghunterRequester noMsg];
            }
            mycollectionTable.pullTableIsLoadingMore = NO;
        } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_DELETE_COLLECTION]){
            if(responseCode==200 && [error_number integerValue] == 0)
            {
                [self refreshTable];
            }
        }else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_COLLECTION_SKILLSHOW]){
            // 获取到了收藏的技能
            [self endLoad];
            if(responseCode==200 && [error_number integerValue] == 0)
            {
                [collectionSkillArray removeAllObjects];
                page = 2;
                NSArray *array = [dic valueForKey:@"collections"];
                [collectionSkillArray addObjectsFromArray:array];
                [myCollectionSkill reloadData];
            } else if ([dic objectForKey:@"msg"]) {
                [collectionSkillArray removeAllObjects];
                [myCollectionSkill reloadData];
                [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            } else {
                [collectionSkillArray removeAllObjects];
                [myCollectionSkill reloadData];
                [ghunterRequester noMsg];
            }
        } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_COLLECTION]){
            if(responseCode==200 && [error_number integerValue] == 0)
            {
                page++;
                NSArray *array = [dic valueForKey:@"collections"];
                [collectionSkillArray addObjectsFromArray:array];
                [myCollectionSkill reloadData];
            } else if ([dic objectForKey:@"msg"]) {
                [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            } else {
                [ghunterRequester noMsg];
            }
            myCollectionSkill.pullTableIsLoadingMore = NO;
        } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_DELETE_COLLECTION]){
            if(responseCode==200 && [error_number integerValue] == 0)
            {
                [self refreshTable];
            }
        }

   
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    mycollectionTable.pullTableIsLoadingMore = NO;
    myCollectionSkill.pullTableIsLoadingMore = NO;
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
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
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
   [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    if (_scrollView.contentOffset.x == 0) {
        [self rlTaskList:nil withRL:REQUEST_FOR_REFRESH_COLLECTION];
        mycollectionTable.pullTableIsRefreshing = NO;
    }else if (_scrollView.contentOffset.x == mainScreenWidth) {
        [self rlSkillList:nil withRL:REQUEST_FOR_COLLECTION_SKILLSHOW];
        myCollectionSkill.pullTableIsRefreshing = NO;
    }
}

- (void)loadMoreDataToTable
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    if (_scrollView.contentOffset.x == 0) {
        [self rlSkillList:@"0" withRL:REQUEST_FOR_LOADMORE_COLLECTIONRENWU];
        mycollectionTable.pullTableIsRefreshing = NO;
    }
    
    if (_scrollView.contentOffset.x == mainScreenWidth) {
        [self rlSkillList:@"1" withRL:REQUEST_FOR_LOADMORE_COLLECTION];
        myCollectionSkill.pullTableIsRefreshing = NO;
    }
    
}
- (void)rlTaskList:(NSString *)key withRL:(NSString *)rl{
    [ghunterRequester getwithDelegate:self withUrl:URL_GET_COLLECTION_TASK withUserInfo:rl withString:[NSString stringWithFormat:@"?page=%zd",page]];
}

- (void)rlSkillList:(NSString *)key withRL:(NSString *)rl{
    [ghunterRequester getwithDelegate:self withUrl:URL_GET_COLLECTION_SKILLSHOW withUserInfo:rl withString:[NSString stringWithFormat:@"?page=%zd",page]];
}

#pragma mark - Custom Methods

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)iconTaped:(UITapGestureRecognizer *)sender{
    // NSLog(@"iconTaped:");
    NSDictionary *collect;
    NSDictionary *collectSkill;
    NSInteger tag = sender.view.tag;
    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
    if (_scrollView.contentOffset.x == 0) {
        collect = [collectionArray objectAtIndex:tag];
        userCenter.uid = [collect objectForKey:@"owner_uid"];
    }
    else
    {
        collectSkill = [collectionSkillArray objectAtIndex:tag];
        userCenter.uid = [collectSkill objectForKey:@"owner_uid"];
    }
    
    [self.navigationController pushViewController:userCenter animated:YES];
}
- (void)delete_collect:(UILongPressGestureRecognizer *)sender {
    if(UIGestureRecognizerStateBegan == sender.state) {
        UIActionSheet *action;
        if(_scrollView.contentOffset.x == 0){
            // 删除任务
            action = [[UIActionSheet alloc] initWithTitle:@"确定取消收藏该任务？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        }else{
            // 删除技能
            action = [[UIActionSheet alloc] initWithTitle:@"确定取消收藏技能？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        }
        action.tag = sender.view.tag;
        [action showInView:self.view];
    }
}

#pragma mark - UIActionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (_scrollView.contentOffset.x == 0) {
            
            
            
            NSDictionary *collection = [collectionArray objectAtIndex:actionSheet.tag];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[collection objectForKey:@"oid"] forKey:@"oid"];
            NSString* str=[NSString stringWithFormat:@"?type=0&oid=%@",[collection objectForKey:@"oid"]];
            [ghunterRequester getwithDelegate:self withUrl:URL_DELETE_COLLECTION withUserInfo:REQUEST_FOR_NEW_DELETE_COLLECTION withString:str];
        }
        if (_scrollView.contentOffset.x == mainScreenWidth) {
            NSDictionary *collectionSkill = [collectionSkillArray objectAtIndex:actionSheet.tag];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[collectionSkill objectForKey:@"oid"] forKey:@"oid"];
            NSString* str=[NSString stringWithFormat:@"?type=1&oid=%@",[collectionSkill objectForKey:@"oid"]];

            [ghunterRequester getwithDelegate:self withUrl:URL_DELETE_COLLECTION withUserInfo:REQUEST_FOR_NEW_DELETE_COLLECTION withString:str];
        }
    }
}
@end
