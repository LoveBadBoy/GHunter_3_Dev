//
//  ghuntersearchViewController.m
//  ghunter
//
//  Created by chensonglu on 14-9-16.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//搜索页面

#import "ghunterSkillViewController.h"
#import "ghuntersearchViewController.h"
// #import "HttpRequest.h"
@interface ghuntersearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchbar;
@property (nonatomic, retain)NSMutableArray *searchArray;
@property (weak, nonatomic) IBOutlet UIView *searchbar_bg;
@property (strong, nonatomic) IBOutlet UIView *hotView;
@property (strong, nonatomic) IBOutlet UIView *smallView;
- (IBAction)taskBtn:(UIButton *)sender;
- (IBAction)skillBtn:(UIButton *)sender;
- (IBAction)hunter:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *taskBtn;
@property (strong, nonatomic) IBOutlet UIButton *skillBtn;
@property (strong, nonatomic) IBOutlet UIButton *hunterBtn;
@property (strong, nonatomic) IBOutlet UIView *kindView;

@property (strong, nonatomic) IBOutlet UIView *bg;


@property(strong,nonatomic) NSMutableArray* hotArr;

@end

@implementation ghuntersearchViewController

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
    _taskpage = 1;
    _hunterpage = 1;
    _skillpage=1;
    
    self.searchArray = [[NSMutableArray alloc] init];
    _hotArr=[[NSMutableArray alloc] init];
    self.searchbar_bg.clipsToBounds = YES;
//    _searchbar.clearsOnBeginEditing=YES;
    self.searchbar_bg.layer.cornerRadius = 8.0;
    _searchbar.delegate = self;
    _searchbar.clearButtonMode=UITextFieldViewModeAlways;
    [_searchbar becomeFirstResponder];
    _taskBtn.selected=YES;
    _skillBtn.selected=NO;
    _hunterBtn.selected=NO;
    [_taskBtn setTitleColor:[UIColor colorWithRed:89/255.0 green:87/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_taskBtn setTitleColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0] forState:UIControlStateSelected];
    [_skillBtn setTitleColor:[UIColor colorWithRed:89/255.0 green:87/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_skillBtn setTitleColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0] forState:UIControlStateSelected];
    [_hunterBtn setTitleColor:[UIColor colorWithRed:89/255.0 green:87/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_hunterBtn setTitleColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _taskBtn.frame.origin.y + _taskBtn.frame.size.height - 1.5, mainScreenWidth / 3, 1.5)];
    self.bottomView.backgroundColor = RGBCOLOR(234, 85, 20);
    [_taskBtn addSubview:self.bottomView];
    
    self.searchbar.placeholder = @"任务关键字/分类";
    searchTable = [[PullTableView alloc]initWithFrame:CGRectMake(0, 74, mainScreenWidth, mainScreenheight - 74) style:UITableViewStylePlain];
    searchTable.delegate = self;
    searchTable.dataSource = self;
    searchTable.pullDelegate = self;
    searchTable.showsVerticalScrollIndicator = NO;
//    searchTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchTable.separatorColor = RGBA(235, 235, 235, 1);
    searchTable.backgroundColor = RGBCOLOR(235, 235, 235);
    
    _smallView.layer.cornerRadius=8.0;
    _hotView.hidden=YES;
    if(_taskBtn.selected==YES)
    {
        [ghunterRequester getwithDelegate:self withUrl:URL_SEARCH_HOT withUserInfo:REQUEST_FOR_HOT withString:[NSString stringWithFormat:@"?api_session_id=%@&latitude=%@&longitude=%@&type=%@",[ghunterRequester getUserInfo:API_SESSION_ID],[ghunterRequester getUserInfo:LATITUDE],[ghunterRequester getUserInfo:LONGITUDE],[NSString stringWithFormat:@"%zd",0]]];
    }
    else if(_hunterBtn.selected== YES)
    {
        [ghunterRequester getwithDelegate:self withUrl:URL_SEARCH_HOT withUserInfo:REQUEST_FOR_HOT withString:[NSString stringWithFormat:@"?api_session_id=%@&latitude=%@&longitude=%@&type=%@",[ghunterRequester getUserInfo:API_SESSION_ID],[ghunterRequester getUserInfo:LATITUDE],[ghunterRequester getUserInfo:LONGITUDE],[NSString stringWithFormat:@"%zd",1]]];
    }
    else if(_skillBtn.selected==YES)
    {
        [ghunterRequester getwithDelegate:self withUrl:URL_SEARCH_HOT withUserInfo:REQUEST_FOR_HOT withString:[NSString stringWithFormat:@"?api_session_id=%@&latitude=%@&longitude=%@&type=%@",[ghunterRequester getUserInfo:API_SESSION_ID],[ghunterRequester getUserInfo:LATITUDE],[ghunterRequester getUserInfo:LONGITUDE],[NSString stringWithFormat:@"%zd",2]]];
    }
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    [searchTable setTableFooterView:view];
    [searchTable setTableFooterView:view];
    searchTable.hidden=YES;
    [self.view addSubview:searchTable];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification*)noti
{
    searchTable.hidden=YES;
    _hotView.hidden=NO;
    _kindView.hidden=NO;
    
}
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidAppear:(BOOL)animated {
    [MobClick event:UMEVENT_SEARCH];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillHideNotification
//                                                  object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate UITableViewDatasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_taskBtn.selected==YES) {
        ghuntertaskViewController *ghuntertask = [[ghuntertaskViewController alloc] init];
        NSDictionary *task = [self.searchArray objectAtIndex:indexPath.row];
        ghuntertask.tid = [task objectForKey:@"tid"];
        ghuntertask.callBackBlock = ^{};
        [self.navigationController pushViewController:ghuntertask animated:YES];
    } else if (_hunterBtn.selected== YES) {
        NSDictionary *hunter = [self.searchArray objectAtIndex:indexPath.row];
        ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
        userCenter.uid = [hunter objectForKey:UID];
        [self.navigationController pushViewController:userCenter animated:YES];
    }
    
    else if (_skillBtn.selected== YES){
        NSDictionary *skill = [self.searchArray objectAtIndex:indexPath.row];
        ghunterSkillViewController *skillView = [[ghunterSkillViewController alloc] init];
        skillView.skillid=[skill objectForKey:@"sid"];
        skillView.callBackBlock = ^{};
        [self.navigationController pushViewController:skillView animated:YES];
//        NSLog(@"skillCellClicked:%@",indexPath);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if(self.type==1&&indexPath.row==0)
    {
        return cell.frame.size.height+10;
    }
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(_taskBtn.selected==YES) {

        NSDictionary *task = [self.searchArray objectAtIndex:indexPath.row];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"searchCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *owner = [task objectForKey:@"owner"];
        
        // 移除虚线
        UILabel * xuxianLb = (UILabel *)[cell viewWithTag:999];
        [xuxianLb removeFromSuperview];
        
        if ([[[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"istop"] intValue]==1) {
            UIImageView *redtabbar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
            redtabbar.image = [UIImage imageNamed:@"推荐"];
            [cell.contentView addSubview:redtabbar];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 20, 10)];
            label.text = @"推荐";
            label.font = [UIFont systemFontOfSize:8];
            label.textColor=[UIColor whiteColor];
            [redtabbar addSubview:label];
        }
        
//        img2.hidden = YES;
        
        // 头像
        UIImageView * huntericon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [cell.contentView addSubview:huntericon];
        huntericon.layer.masksToBounds = YES;
        huntericon.layer.cornerRadius = huntericon.frame.size.width / 2;
        [huntericon sd_setImageWithURL:[owner objectForKey:@"middle_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        huntericon.userInteractionEnabled = YES;
        huntericon.tag = indexPath.row;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
        [huntericon addGestureRecognizer:tap];

        // 姓名
        NSString *nameStr = [owner objectForKey:@"username"];
        UILabel * huntername = [[UILabel alloc] initWithFrame:CGRectMake(huntericon.frame.size.width + huntericon.frame.origin.x + 10, huntericon.frame.origin.y, 100, 20)];
        [cell.contentView addSubview:huntername];
        huntername.font = [UIFont systemFontOfSize:13];
        huntername.textColor = RGBCOLOR(51, 51, 51);
        [huntername setText:[owner objectForKey:@"username"]];
        CGSize nameSize = [nameStr sizeWithFont:huntername.font];
        CGRect nameFrame = huntername.frame;
        huntername.frame = nameFrame;
        
        // 性别
        UIImageView * gender = [[UIImageView alloc] initWithFrame:CGRectMake(huntername.frame.origin.x, huntername.frame.size.height + huntername.frame.origin.y + 5, 8, 8)];
        [cell.contentView addSubview:gender];
        if([[owner objectForKey:@"sex"] isEqualToString:@"0"]){
            [gender setImage:[UIImage imageNamed:@"female"]];
        }else{
            [gender setImage:[UIImage imageNamed:@"male"]];
        }

        // 计算距离
        UILabel * distance = [[UILabel alloc] initWithFrame:CGRectMake(gender.frame.size.width + gender.frame.origin.x + 5, gender.frame.origin.y - 6, 50, 20)];
        [cell.contentView addSubview:distance];
        NSString *distancestar = [ghunterRequester calculateDistanceWithLatitude:[task objectForKey:@"latitude"] withLongitude:[task objectForKey:@"longitude"]];
        [distance setText:distancestar];
        distance.textColor = RGBCOLOR(153, 153, 153);
        distance.font = [UIFont systemFontOfSize:10];
        
        // 标签
        UILabel * tabbartext = [[UILabel alloc] initWithFrame:CGRectMake(10, huntericon.frame.origin.y + huntericon.frame.size.height + 8, 30, 16)];
        [cell.contentView addSubview:tabbartext];
        
        NSString*string =[task objectForKey:@"color"];
        //        NSLog(@"擦-------为：%@",string);
        NSString *b = [string substringFromIndex:0];
        //        NSLog(@"-----%@",b);
        NSString *colorstr = [NSString stringWithFormat:@"0x%@",b];
        tabbartext.textColor = [Monitor colorWithHexString:colorstr alpha:1.0f];
        tabbartext.font = [UIFont systemFontOfSize:10];
        tabbartext.clipsToBounds = YES;
        tabbartext.layer.cornerRadius = 2.0;
        tabbartext.text = [task objectForKey:@"c_name"];
        [tabbartext.layer setBorderWidth:1.0];   //边框宽度
        tabbartext.textAlignment = NSTextAlignmentCenter;
        [tabbartext.layer setBorderColor:[Monitor colorWithHexString:colorstr alpha:1.0f].CGColor];//边框颜色
        NSString *LENstr = [task objectForKey:@"c_name"];
        CGRect tabbartxtFrame = tabbartext.frame;
        tabbartxtFrame.origin.x = huntername.frame.origin.x;
        tabbartxtFrame.origin.y = gender.frame.origin.y + gender.frame.size.height + 10;

        if ([LENstr length] > 1) {
            tabbartxtFrame.size.width = 25;
        }
        if ([LENstr length] > 2) {
            tabbartxtFrame.size.width = 35;
        }
        if ([LENstr length] > 3) {
            tabbartxtFrame.size.width = 45;
        }
        tabbartext.frame = tabbartxtFrame;
        
        // 内容
        UILabel * titleLb =[[UILabel alloc] initWithFrame:CGRectMake(tabbartext.frame.origin.x + tabbartext.frame.size.width + 8,tabbartext.frame.origin.y - 2, mainScreenWidth - 10 - huntername.frame.origin.x - 20 - 10, 20)];
        [cell.contentView addSubview:titleLb];
        [titleLb setFont:[UIFont systemFontOfSize:14]];
        titleLb.textColor = RGBCOLOR(51, 51, 51);
        titleLb.numberOfLines = 1;
        titleLb.text = [task objectForKey:@"title"];
        
        // 元
        UILabel * bounty = [[UILabel alloc] initWithFrame:CGRectMake(200, huntername.frame.origin.y + 5, 100, 20)];
        [cell.contentView addSubview:bounty];
        bounty.font = [UIFont systemFontOfSize:12];
        bounty.textColor = RGBCOLOR(234, 85, 20);
        NSString * bountySelf = [task objectForKey:@"bounty"];
        NSString * bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
        bounty.text = bountyStr;
        CGSize bountySize = [bountyStr sizeWithFont:bounty.font];
        CGRect bountyFrame = bounty.frame;
        bountyFrame.size.width = bountySize.width;
        bountyFrame.origin.x = mainScreenWidth - 10 - bountySize.width;
        bounty.frame = bountyFrame;

        // 赏
        UILabel * goldLabel = [[UILabel alloc] initWithFrame:CGRectMake(bounty.frame.origin.x - 20, huntername.frame.origin.y + 3, 26, 26)];
        [cell.contentView addSubview:goldLabel];
        goldLabel.text = @"赏";
        goldLabel.font = [UIFont systemFontOfSize:12];
        goldLabel.textColor = RGBCOLOR(234, 85, 20);
        goldLabel.textAlignment = NSTextAlignmentCenter;

        CGSize  goldSize = [goldLabel.text sizeWithFont:goldLabel.font];
        CGRect goldLbFrame = goldLabel.frame;
        goldLbFrame.origin.x = bounty.frame.origin.x - goldSize.width - 15;
        goldLabel.frame = goldLbFrame;
        
        goldLabel.layer.cornerRadius = goldLabel.frame.size.width / 2;
        goldLabel.clipsToBounds = YES;
        [goldLabel.layer setBorderWidth:1.0];
        [goldLabel.layer setBorderColor:RGBCOLOR(234, 85, 20).CGColor];
        
        // 下面小图标
        UIImageView * bidImg = [[UIImageView alloc] initWithFrame:CGRectMake(huntername.frame.origin.x, tabbartext.frame.origin.y + tabbartext.frame.size.height + 5, 10, 10)];
        bidImg.image = [UIImage imageNamed:@"task_joinnum"];
        [cell.contentView addSubview:bidImg];
        UILabel * bidnum = [[UILabel alloc] initWithFrame:CGRectMake(bidImg.frame.origin.x + 14, bidImg.frame.origin.y - 2, 50, 15)];
        [cell.contentView addSubview:bidnum];
        bidnum.textColor = RGBCOLOR(153, 153, 153);
        bidnum.font = [UIFont systemFontOfSize:11];
        [bidnum setText:[NSString stringWithFormat:@"%@人竞标",[task objectForKey:@"biddingnum"]]];
        
        UIImageView * hotImg = [[UIImageView alloc] initWithFrame:CGRectMake(huntername.frame.origin.x + 80, bidImg.frame.origin.y - 2, 10, 10)];
        [cell.contentView addSubview:hotImg];
        hotImg.image = [UIImage imageNamed:@"task_hot"];
        UILabel * hot = [[UILabel alloc] initWithFrame:CGRectMake(hotImg.frame.origin.x + 14, bidnum.frame.origin.y, 50, 15)];
        [cell.contentView addSubview:hot];
        hot.textColor = RGBCOLOR(153, 153, 153);
        hot.font = [UIFont systemFontOfSize:11];
        [hot setText:[NSString stringWithFormat:@"%@热度",[task objectForKey:@"hot"]]];
        
        UIImageView * timeImg = [[UIImageView alloc] initWithFrame:CGRectMake(huntername.frame.origin.x + 160, bidImg.frame.origin.y, 10, 10)];
        [cell.contentView addSubview:timeImg];
        timeImg.image = [UIImage imageNamed:@"task_dateline"];
        UILabel * dateline = [[UILabel alloc] initWithFrame:CGRectMake(timeImg.frame.origin.x + 14, bidnum.frame.origin.y - 2, 50, 15)];
        [cell.contentView addSubview:dateline];
        dateline.textColor = RGBCOLOR(153, 153, 153);
        dateline.font = [UIFont systemFontOfSize:11];
        [dateline setText:[ghunterRequester getTimeDescripton:[task objectForKey:@"dateline"]]];

        
        
        CGRect cellFrame = cell.frame;
        
        cellFrame.size.height = bidnum.frame.origin.y + bidnum.frame.size.height + 5;
        cell.frame = cellFrame;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
    else if (_hunterBtn.selected== YES) {
        NSDictionary *follow = [self.searchArray objectAtIndex:indexPath.row];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"followsView" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *userIcon = (UIImageView *)[cell viewWithTag:1];
        UILabel *name1 = (UILabel *)[cell viewWithTag:2];
        name1.hidden = YES;
        UIImageView *gender1 = (UIImageView *)[cell viewWithTag:3];
        gender1.hidden = YES;
//        UILabel *age = (UILabel *)[cell viewWithTag:4];
        UIImageView *identity = (UIImageView *)[cell viewWithTag:5];
//        UILabel *level = (UILabel *)[cell viewWithTag:6];
        UIView *back = (UIView *)[cell viewWithTag:7];
        UIView * line=(UIView*)[cell viewWithTag:10];
            line.hidden = YES;
//        UIView *skillBack = (UIView *)[cell viewWithTag:8];
        userIcon.clipsToBounds = YES;
        userIcon.layer.cornerRadius = userIcon.frame.size.height/2.0;
        [userIcon sd_setImageWithURL:[follow objectForKey:@"middle_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        
        // 名字
        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(userIcon.frame.origin.x + userIcon.frame.size.width + 7, userIcon.frame.origin.y, 100, 20)];
        [cell.contentView addSubview:name];
        [name setText:[follow objectForKey:@"username"]];

        UIImageView * gender = [[UIImageView alloc] initWithFrame:CGRectMake(100, userIcon.frame.origin.y + 6, 8, 8)];
        [cell.contentView addSubview:gender];
        if([[follow objectForKey:@"sex"] isEqualToString:@"0"]){
            [gender setImage:[UIImage imageNamed:@"female"]];
        }else{
            [gender setImage:[UIImage imageNamed:@"male"]];
        }
        name.font = [UIFont systemFontOfSize:13];
        CGSize usernameSize = [[follow objectForKey:USERNAME] sizeWithFont:[UIFont systemFontOfSize:13]];
        CGRect nameFrame = name.frame;
        nameFrame.size.width = usernameSize.width;
        name.frame = nameFrame;
        CGRect genderFrame = gender.frame;
        genderFrame.origin.x = name.frame.origin.x + usernameSize.width + 5;
        gender.frame = genderFrame;

        UIImageView * levelImg = (UIImageView *)[cell viewWithTag:88];

        if([[follow objectForKey:@"is_identity"] isEqualToString:@"3"]) {
            
            TQStarRatingView *star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(levelImg.frame.origin.x + levelImg.frame.size.width + 3, levelImg.frame.origin.y + (levelImg.frame.size.height - 10) / 2.0-2.0, 50, 10) numberOfStar:5];
            [back addSubview:star];
            [star setScore:[[follow objectForKey:@"kopubility"] floatValue]];
            [star setuserInteractionEnabled:NO];
            
        } else if ([[follow objectForKey:@"is_identity"] isEqualToString:@"1"]) {
            
            TQStarRatingView *star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(identity.frame.origin.x + identity.frame.size.width + 3, identity.frame.origin.y + (identity.frame.size.height - 10) / 2.0, 50, 10) numberOfStar:5];
            [back addSubview:star];
            [star setScore:[[follow objectForKey:@"kopubility"] floatValue]];
            [star setuserInteractionEnabled:NO];
            
            [identity setImage:[UIImage imageNamed:@"实名认证"]];
        }
        
        levelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级是%@",[follow objectForKey:@"level"]]];

        toshowTagList *tagList = [[toshowTagList alloc] initWithFrame:CGRectMake(0,0,back.frame.size.width - 50,0)];
        NSArray *skills = [follow objectForKey:@"skills"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < [skills count]; i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[skills objectAtIndex:i] forKey:@"title"];
            [dic setObject:[UIColor colorWithRed:156.0 / 255 green:156.0 / 255 blue:153.0 / 255 alpha:1] forKey:@"titleColor"];
            [dic setObject:[UIColor whiteColor] forKey:@"backgroundColor"];
            [dic setObject:RGBA(248.0, 140.0, 86, 1.0) forKey:@"borderColor"];
            [dic setObject:@"1.0" forKey:@"borderWidth"];
            [array addObject:dic];
            
        }
        [tagList addTags:array];
        
        UIView *skillBG = [[UIView alloc] initWithFrame:CGRectMake(50, 48, self.view.frame.size.width - 60, tagList.heightFinal)];
        skillBG.backgroundColor = RGBCOLOR(245, 245, 245);
        CGRect r = [tagList frame];
        r.size.height += tagList.heightFinal;
        tagList.frame = r;
        [skillBG addSubview:tagList];
        CGRect r1 = [cell frame];
        r1.size.height += tagList.heightFinal;
        cell.frame = r1;
        [cell addSubview:skillBG];

        
       /*
        if(indexPath.row == 0){
            if ([self.searchArray count] == 1) {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:back.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = back.bounds;
                maskLayer.path = maskPath.CGPath;
                back.layer.mask = maskLayer;
            } else {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:back.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = back.bounds;
                maskLayer.path = maskPath.CGPath;
                back.layer.mask = maskLayer;
//                CGRect frame1=back.frame;
//                frame1.origin.y+=10;
//                back.frame=frame1;
//                CGRect frame2=line.frame;
//                frame2.origin.y-=19;
//                line.frame=frame2;
            }
        }
        if(indexPath.row == [self.searchArray count] - 1) {
            if ([self.searchArray count] == 1) {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:back.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = back.bounds;
                maskLayer.path = maskPath.CGPath;
                back.layer.mask = maskLayer;
            } else {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:back.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = back.bounds;
                maskLayer.path = maskPath.CGPath;
                back.layer.mask = maskLayer;
            }
        }
        */
            
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
    }
        else if (_skillBtn.selected==YES){
            NSDictionary *skill = [self.searchArray objectAtIndex:indexPath.row];
            
//            NSLog(@"--------%@",skill);
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
            if ([[[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"istop"] intValue]==1) {
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

            

            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    return cell;
}
#pragma mark - ASIHTTPRequest
//http请求处理的代理方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REFRESH_SEARCH_TASK]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [self.searchArray removeAllObjects];
            _taskpage = 2;
            NSArray *array = [dic valueForKey:@"tasks"];
            [self.searchArray addObjectsFromArray:array];
            _hotView.hidden=YES;
            _kindView.hidden=YES;
            searchTable.hidden=NO;
            [_searchbar resignFirstResponder];

            [searchTable reloadData];
            if([self.searchArray count]>0)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [searchTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_SEARCH_TASK]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            _taskpage++;
            NSArray *array = [dic valueForKey:@"tasks"];
            [self.searchArray addObjectsFromArray:array];
            NSLog(@"%zd",self.searchArray.count);
            [_searchbar resignFirstResponder];

            [searchTable reloadData];
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
        searchTable.pullTableIsLoadingMore = NO;
    } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REFRESH_SEARCH_HUNTER]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [self.searchArray removeAllObjects];
            _hunterpage = 2;
            NSArray *array = [dic valueForKey:@"users"];
            [self.searchArray addObjectsFromArray:array];
            _hotView.hidden=YES;
            _kindView.hidden=YES;
            searchTable.hidden=NO;
            [_searchbar resignFirstResponder];
            
            [searchTable reloadData];
            if([self.searchArray count]>0)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [searchTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_SEARCH_HUNTER]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            _hunterpage++;
            
            NSArray *array = [dic valueForKey:@"users"];
            [self.searchArray addObjectsFromArray:array];
            [_searchbar resignFirstResponder];
            [searchTable reloadData];
            
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
        searchTable.pullTableIsLoadingMore = NO;
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REFRESH_SEARCH_SKILL]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [self.searchArray removeAllObjects];
            _skillpage = 2;
            NSArray *array = [dic valueForKey:@"skillshows"];
            [self.searchArray addObjectsFromArray:array];
            for(NSUInteger i=0;i<self.searchArray.count;i++)
            {
                NSDictionary* dic=self.searchArray[i];
                NSDictionary *owner = [dic objectForKey:@"owner"];
                NSString* userName=[owner objectForKey:@"uesrname"];
                if(userName.length==0)
                {
                    [self.searchArray removeObject:dic];
                }
            }
            _hotView.hidden=YES;
            _kindView.hidden=YES;
            searchTable.hidden=NO;
            [_searchbar resignFirstResponder];
            
            [searchTable reloadData];
            if([self.searchArray count]>0)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [searchTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_SEARCH_SKILL]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            _skillpage++;
            
            NSArray *array = [dic valueForKey:@"skillshows"];
            [self.searchArray addObjectsFromArray:array];
            for(NSUInteger i=0;i<self.searchArray.count;i++)
            {
                NSDictionary* dic=self.searchArray[i];
                NSDictionary *owner = [dic objectForKey:@"owner"];
                NSString* userName=[owner objectForKey:@"uesrname"];
                if(userName.length==0)
                {
                    [self.searchArray removeObject:dic];
                }
            }
            [_searchbar resignFirstResponder];
            [searchTable reloadData];
            
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
        searchTable.pullTableIsLoadingMore = NO;
    }

    else if([[request.userInfo objectForKey:REQUEST_TYPE] isEqual:REQUEST_FOR_HOT])
    {
        if(responseCode==200&&[error_number integerValue]==0)
        {
            _hotView.hidden=NO;
            _kindView.hidden=NO;
            [_hotArr removeAllObjects];
            NSArray* array=[dic valueForKey:@"keywords"];
           // NSLog(@"keyWords:%@",array);
            [_hotArr addObjectsFromArray:array];
            for(UIButton* btn in _smallView.subviews)
            {
                [btn removeFromSuperview];
            }
            
            NSUInteger cnt = 0;
            for(NSUInteger i = 0;i < 3;i++)
            {
                for(NSUInteger j = 0;j < 4;j++)
                {
                    if (cnt >= _hotArr.count) {
                        return;
                    }
                    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
                    //btn.backgroundColor=[UIColor whiteColor];
                    [btn setBackgroundImage:[UIImage imageNamed:@"gender_bg"] forState:UIControlStateNormal];
                    //            [button setFrame:CGRectMake(0+y*(size.width+25), 0+i*(size.height+25), size.width+25, size.height+25)];
                    [btn setFrame:CGRectMake(10+j*(mainScreenWidth-40)/4, 8+i*29, (mainScreenWidth-40)/4-5, 24)];
                    btn.layer.cornerRadius=8.0;
                    btn.tag=i*4+j+30;
                    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
                    btn.titleLabel.font=[UIFont systemFontOfSize:12];
                    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    [btn setTitle:_hotArr[btn.tag-30] forState:UIControlStateNormal];
                    [_smallView addSubview:btn];
                    cnt++;
                }
            }
        }
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    searchTable.pullTableIsLoadingMore = NO;
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
    //    NSError *error = [request error];
//    NSLog(@"%@",error);

}
-(void)btnClick:(UIButton*)btn
{
    [_searchbar resignFirstResponder];
    _searchbar.text=btn.titleLabel.text;
    if(_taskBtn.selected==YES) {
        self.taskpage = 1;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
        [dic setObject:[NSString stringWithFormat:@"%zd",self.taskpage] forKey:@"page"];
        [dic setObject:btn.titleLabel.text forKey:@"keyword"];
        [ghunterRequester postwithDelegate:self withUrl:URL_SEARCH_TASK withUserInfo:REQUEST_FOR_REFRESH_SEARCH_TASK withDictionary:dic];
    } else if (_hunterBtn.selected== YES) {
        self.hunterpage = 1;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
        [dic setObject:[NSString stringWithFormat:@"%zd",self.hunterpage] forKey:@"page"];
        [dic setObject:btn.titleLabel.text forKey:@"keyword"];
        [ghunterRequester postwithDelegate:self withUrl:URL_SEARCH_HUNTER withUserInfo:REQUEST_FOR_REFRESH_SEARCH_HUNTER withDictionary:dic];
    }
    else if (_skillBtn.selected== YES) {
        self.skillpage = 1;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
        [dic setObject:[NSString stringWithFormat:@"%zd",self.skillpage] forKey:@"page"];
        [dic setObject:btn.titleLabel.text forKey:@"keyword"];
        [ghunterRequester postwithDelegate:self withUrl:URL_SEARCH_SKILL withUserInfo:REQUEST_FOR_REFRESH_SEARCH_SKILL withDictionary:dic];
    }
    searchTable.pullTableIsRefreshing = NO;
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
    if([self.searchbar.text length] == 0) {
        searchTable.pullTableIsRefreshing = NO;
        
        return;
    }
    if(_taskBtn.selected==YES) {
        self.taskpage = 1;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
        [dic setObject:[NSString stringWithFormat:@"%zd",self.taskpage] forKey:@"page"];
        [dic setObject:self.searchbar.text forKey:@"keyword"];
        [ghunterRequester postwithDelegate:self withUrl:URL_SEARCH_TASK withUserInfo:REQUEST_FOR_REFRESH_SEARCH_TASK withDictionary:dic];
    } else if (_hunterBtn.selected== YES) {
        self.hunterpage = 1;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
        [dic setObject:[NSString stringWithFormat:@"%zd",self.hunterpage] forKey:@"page"];
        [dic setObject:self.searchbar.text forKey:@"keyword"];
        [ghunterRequester postwithDelegate:self withUrl:URL_SEARCH_HUNTER withUserInfo:REQUEST_FOR_REFRESH_SEARCH_HUNTER withDictionary:dic];
    }
    else if (_skillBtn.selected== YES) {
        self.skillpage = 1;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
        [dic setObject:[NSString stringWithFormat:@"%zd",self.skillpage] forKey:@"page"];
        [dic setObject:self.searchbar.text forKey:@"keyword"];
        [ghunterRequester postwithDelegate:self withUrl:URL_SEARCH_SKILL withUserInfo:REQUEST_FOR_REFRESH_SEARCH_SKILL withDictionary:dic];
    }
    searchTable.pullTableIsRefreshing = NO;
}

- (void)loadMoreDataToTable
{
    if([self.searchbar.text length] == 0) {
        searchTable.pullTableIsLoadingMore = NO;
        return;
    }
    if(_taskBtn.selected==YES) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
        [dic setObject:self.searchbar.text forKey:@"keyword"];
        [ghunterRequester postwithDelegate:self withUrl:[NSString stringWithFormat:@"%@?page=%zd",URL_SEARCH_TASK,self.taskpage] withUserInfo:REQUEST_FOR_LOADMORE_SEARCH_TASK withDictionary:dic];
    } else if (_hunterBtn.selected== YES) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
       
        [dic setObject:self.searchbar.text forKey:@"keyword"];
        [ghunterRequester postwithDelegate:self withUrl:[NSString stringWithFormat:@"%@?page=%zd",URL_SEARCH_HUNTER,self.hunterpage] withUserInfo:REQUEST_FOR_LOADMORE_SEARCH_HUNTER withDictionary:dic];
    }
    else if (_skillBtn.selected== YES) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
       
        [dic setObject:self.searchbar.text forKey:@"keyword"];
        [ghunterRequester postwithDelegate:self withUrl:[NSString stringWithFormat:@"%@?page=%zd",URL_SEARCH_SKILL,self.skillpage] withUserInfo:REQUEST_FOR_LOADMORE_SEARCH_SKILL withDictionary:dic];
    }
}

#pragma mark - UITextfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if([self.searchbar.text length] == 0) {
        [ghunterRequester showTip:@"请输入关键字"];
        [self.searchbar resignFirstResponder];
        return NO;
    }
    if (_taskBtn.selected==YES) {
        self.taskpage = 1;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
        [dic setObject:[NSString stringWithFormat:@"%zd",self.taskpage] forKey:@"page"];
        [dic setObject:self.searchbar.text forKey:@"keyword"];
        [ghunterRequester postwithDelegate:self withUrl:URL_SEARCH_TASK withUserInfo:REQUEST_FOR_REFRESH_SEARCH_TASK withDictionary:dic];
    } else if (_hunterBtn.selected== YES) {
        self.hunterpage = 1;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
        [dic setObject:[NSString stringWithFormat:@"%zd",self.hunterpage] forKey:@"page"];
        [dic setObject:self.searchbar.text forKey:@"keyword"];
        [ghunterRequester postwithDelegate:self withUrl:URL_SEARCH_HUNTER withUserInfo:REQUEST_FOR_REFRESH_SEARCH_HUNTER withDictionary:dic];
    }
    else if (_skillBtn.selected== YES) {
        self.skillpage = 1;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[ghunterRequester getUserInfo:LATITUDE] forKey:LATITUDE];
        [dic setObject:[ghunterRequester getUserInfo:LONGITUDE] forKey:LONGITUDE];
        [dic setObject:[NSString stringWithFormat:@"%zd",self.skillpage] forKey:@"page"];
        [dic setObject:self.searchbar.text forKey:@"keyword"];
        [ghunterRequester postwithDelegate:self withUrl:URL_SEARCH_SKILL withUserInfo:REQUEST_FOR_REFRESH_SEARCH_SKILL withDictionary:dic];
    }
    [self.searchbar resignFirstResponder];
    return YES;
}

- (IBAction)taskBtn:(UIButton *)sender {
    _taskBtn.selected=YES;
    _skillBtn.selected=NO;
    _hunterBtn.selected=NO;
    self.bottomView.frame = CGRectMake(0, _taskBtn.frame.origin.y + _taskBtn.frame.size.height - 1.5, mainScreenWidth / 3, 1.5);
    [_taskBtn addSubview:self.bottomView];
    self.searchbar.placeholder = @"任务关键字/分类";
    [ghunterRequester getwithDelegate:self withUrl:URL_SEARCH_HOT withUserInfo:REQUEST_FOR_HOT withString:[NSString stringWithFormat:@"?api_session_id=%@&latitude=%@&longitude=%@&type=%@",[ghunterRequester getUserInfo:API_SESSION_ID],[ghunterRequester getUserInfo:LATITUDE],[ghunterRequester getUserInfo:LONGITUDE],[NSString stringWithFormat:@"%zd",0]]];
}

- (IBAction)skillBtn:(UIButton *)sender {
    _taskBtn.selected=NO;
    _skillBtn.selected=YES;
    _hunterBtn.selected=NO;
    self.bottomView.frame = CGRectMake(0, _skillBtn.frame.origin.y + _skillBtn.frame.size.height - 1.5, mainScreenWidth / 3, 1.5);
    [_skillBtn addSubview:self.bottomView];
    self.searchbar.placeholder=@"技能关键字/分类";
    [ghunterRequester getwithDelegate:self withUrl:URL_SEARCH_HOT withUserInfo:REQUEST_FOR_HOT withString:[NSString stringWithFormat:@"?api_session_id=%@&latitude=%@&longitude=%@&type=%@",[ghunterRequester getUserInfo:API_SESSION_ID],[ghunterRequester getUserInfo:LATITUDE],[ghunterRequester getUserInfo:LONGITUDE],[NSString stringWithFormat:@"%zd",2]]];
}

- (IBAction)hunter:(UIButton *)sender {
    _taskBtn.selected=NO;
    _skillBtn.selected=NO;
    _hunterBtn.selected=YES;
    self.bottomView.frame = CGRectMake(0, _hunterBtn.frame.origin.y + _hunterBtn.frame.size.height - 1.5, mainScreenWidth / 3, 1.5);
    [_hunterBtn addSubview:self.bottomView];
    self.searchbar.placeholder = @"昵称/手机号/技能标签";
    [ghunterRequester getwithDelegate:self withUrl:URL_SEARCH_HOT withUserInfo:REQUEST_FOR_HOT withString:[NSString stringWithFormat:@"?api_session_id=%@&latitude=%@&longitude=%@&type=%@",[ghunterRequester getUserInfo:API_SESSION_ID],[ghunterRequester getUserInfo:LATITUDE],[ghunterRequester getUserInfo:LONGITUDE],[NSString stringWithFormat:@"%zd",1]]];
}
@end
