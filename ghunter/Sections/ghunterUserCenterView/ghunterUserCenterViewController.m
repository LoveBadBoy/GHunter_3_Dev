//
//  ghunterUserCenterViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-18.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//其他人的主页

#import "ghunterUserCenterViewController.h"
#import "ghunterSkillViewController.h"
#import "UMSocialQQHandler.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"


@interface ghunterUserCenterViewController ()
@property(nonatomic,retain)PullTableView *table;
@property (strong, nonatomic) IBOutlet UIView *bg;
@property(nonatomic,retain)NSMutableDictionary *user;
@property(nonatomic,retain)NSMutableArray *skillShowsArray;
@property(nonatomic,retain)NSMutableArray *releaseArray;
@property(nonatomic,retain)NSMutableDictionary *evaluationsDic;
@property(nonatomic)NSInteger skillShowsPage;
@property(nonatomic)NSInteger releasePage;
@property(nonatomic)NSInteger evaluationsPage;
@property(nonatomic)NSInteger selected;
@property(nonatomic)BOOL skillShowsSelected;
@property(nonatomic)BOOL releaseSelected;
@property(nonatomic)BOOL evaluationSelected;
@property (weak, nonatomic) IBOutlet UILabel *name_distance;
@property (strong, nonatomic) IBOutlet UIView *tailView;
//@property (strong, nonatomic) IBOutlet UIImageView *followImg;
//@property (strong, nonatomic) IBOutlet UILabel *followLabel;

@property(strong,nonatomic) UIView *popReportView;
@property(strong,nonatomic) UILabel *textTip;
@property(strong,nonatomic) UITextView *text;
@property(strong,nonatomic) UIActionSheet *action;
// 猎人ID号
@property (weak, nonatomic) IBOutlet UILabel *hunterIdLabel;

@end

@implementation ghunterUserCenterViewController

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
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    _bg.backgroundColor = Nav_backgroud;
    // Do any additional setup after loading the view from its nib.
    self.navbg.backgroundColor = Nav_backgroud;
    self.skillShowsPage = 1;
    self.releasePage = 1;
    self.evaluationsPage = 1;
    self.selected = 0;
    self.skillShowsSelected = NO;
    self.releaseSelected = NO;
    self.evaluationSelected = NO;
    self.user = [[NSMutableDictionary alloc] init];
    self.skillShowsArray = [[NSMutableArray alloc] init];
    self.releaseArray = [[NSMutableArray alloc] init];
    self.evaluationsDic  =[[NSMutableDictionary alloc] init];
    if([self.uid isEqualToString:[ghunterRequester getUserInfo:@"uid"]]) {
       self.table = [[PullTableView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight) style:UITableViewStylePlain];
    } else {
       self.table = [[PullTableView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight - 44) style:UITableViewStylePlain];
       self.tailView.frame = CGRectMake(0, mainScreenheight - 44, self.view.frame.size.width, 44);
        [self.view addSubview:self.tailView];
    }
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.pullDelegate = self;
    self.table.showsVerticalScrollIndicator = NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.backgroundColor = [UIColor clearColor];
    
    UIView * bView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.table setTableFooterView:bView];
    
    
    [self.view addSubview:self.table];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //
    [self didGetHUnterInfoIsloading:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    if(!imgondar_islogin) {
        [_tailView setUserInteractionEnabled:YES];
    }
    else {
        [_tailView setUserInteractionEnabled:YES];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                        if ([self.text isFirstResponder]) {
                             CGRect frame = reportAlertView.containerView.frame;
                             frame.origin.y = keyboardRect.origin.y - reportAlertView.containerView.frame.size.height;
                             reportAlertView.containerView.frame = frame;
                             [reportAlertView layoutSubviews];
                         }
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                        if (self.text.isFirstResponder) {
                             CGRect frame = reportAlertView.containerView.frame;
                             frame.origin.y = mainScreenheight - reportAlertView.containerView.frame.size.height - 10;
                             reportAlertView.containerView.frame = frame;
                             [reportAlertView layoutSubviews];
                         }
                     }];
}

#pragma mark - Custom methods

- (void)iconTaped:(UITapGestureRecognizer *)sender{
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

- (void)click2ShowSkillShows{
    self.selected = 0;
    if(!self.skillShowsSelected){
        [self didGetSkillshowsIsloading:NO];
    }
    [self.table reloadData];
}

- (void)click2ShowRelease{
    self.selected = 1;
    if(!self.releaseSelected){
        [self didGetHuntertaskIsloading:NO];
    }
    [self.table reloadData];
}

// 点击查看评价
- (void)click2ShowEvaluations{
    self.selected = 2;
    if(!self.evaluationSelected){
        [self didGetValuationsIsloading:NO];
    }
    [self.table reloadData];
}

- (void)click2ShowFans {
    ghunterMyFollowViewController *follow = [[ghunterMyFollowViewController alloc] init];
    follow.type = 2;
    follow.uid = self.uid;
    [self.navigationController pushViewController:follow animated:YES];
}

- (void)click2ShowFollows {
    ghunterMyFollowViewController *follow = [[ghunterMyFollowViewController alloc] init];
    follow.type = 3;
    follow.uid = self.uid;
    [self.navigationController pushViewController:follow animated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}


#pragma mark ---私信---
- (IBAction)message:(id)sender {
    flag = YES;
    if (!imgondar_islogin) {
        
        [self click2Login];
        return;
    }
    ghunterChatViewController *chat = [[ghunterChatViewController alloc] init];
    chat.sender_uid = [self.user objectForKey:@"uid"];
    chat.sender_username = [self.user objectForKey:@"username"];
    
    [chat setCallBackBlock:^{}];
    [self.navigationController pushViewController:chat animated:YES];
}
#pragma mark --- 关注
- (IBAction)follow:(id)sender {
    flag = YES;
    if (!imgondar_islogin) {
        
        [self click2Login];
        return;
    }
    
    if ([[self.user objectForKey:@"isfollow"] isEqualToString:@"1"]) {
        self.action = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"确定取消关注%@吗?",[self.user objectForKey:@"username"]] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [self.action showInView:self.view];
    } else {
        [self didFollowHunterIsloading:YES];
    }
}

- (IBAction)report:(id)sender {
    flag = YES;
    if (!imgondar_islogin) {
        
        [self click2Login];
        return;
    }
    reportAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"reportView" owner:self options:nil];
    self.popReportView = [[UIView alloc] init];
    self.popReportView = [nibs objectAtIndex:0];
    CGRect width = _popReportView.frame;
    width.size.width = mainScreenWidth - 20;
    _popReportView.frame = width;
    CGRect taskfilterFrame = self.popReportView.frame;
    reportAlertView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, mainScreenheight - taskfilterFrame.size.height - 10, taskfilterFrame.size.width, taskfilterFrame.size.height);
    reportAlertView.showView = self.popReportView;
    UIButton *cancel = (UIButton *)[self.popReportView viewWithTag:1];
    UIButton *confirm = (UIButton *)[self.popReportView viewWithTag:2];
    self.text = (UITextView *)[self.popReportView viewWithTag:3];
    self.textTip = (UILabel *)[self.popReportView viewWithTag:4];
    self.text.delegate = self;
    [cancel addTarget:self action:@selector(cancelReport:) forControlEvents:UIControlEventTouchUpInside];
    [confirm addTarget:self action:@selector(confirmReport:) forControlEvents:UIControlEventTouchUpInside];
    reportAlertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    reportAlertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [reportAlertView show];
}


- (void)cancelReport:(id)sender{
    [reportAlertView dismissAnimated:YES];
}

- (void)confirmReport:(id)sender{
    if ([self.text.text length] == 0) {
        [self.text resignFirstResponder];
        return;
    }
    [reportAlertView dismissAnimated:YES];
    self.text = (UITextView *)[self.popReportView viewWithTag:3];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[self.user objectForKey:@"uid"] forKey:@"oid"];
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:self.text.text forKey:@"content"];
    
    [self didReportHunterIsloading:YES withDic:dic];
}

- (void)fadeIn:(UIView *)popView{
    popView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    popView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        popView.alpha = 1;
        popView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)fadeOut:(UIView *)popView{
    [UIView animateWithDuration:0.3 animations:^{
        popView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        popView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [popView removeFromSuperview];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    if(self.selected == 0){
        if(indexPath.row>1)
        {
            NSDictionary* skillDic=[self.skillShowsArray objectAtIndex:indexPath.row-2];
            NSNumber* num=[skillDic objectForKey:@"sid"];
            if(num!=nil)
            {
                ghunterSkillViewController* skillView=[[ghunterSkillViewController alloc] init];
                skillView.skillid=num.stringValue;
                skillView.callBackBlock = ^{};
                [self.navigationController pushViewController:skillView animated:YES];
            }
        }
        return;
    }else if (self.selected == 1){
        NSDictionary *release = [self.releaseArray objectAtIndex:indexPath.row - 1];
        ghuntertaskViewController *task = [[ghuntertaskViewController alloc] init];
        task.tid = [release objectForKey:@"tid"];
        task.callBackBlock = ^{};
        [self.navigationController pushViewController:task animated:YES];
    }else if (self.selected == 2){
//        NSDictionary *evaluation = [self.evaluationsArray objectAtIndex:indexPath.row - 1];
//        ghuntertaskViewController *task = [[ghuntertaskViewController alloc] init];
//        task.tid = [evaluation objectForKey:@"tid"];
//        task.callBackBlock = ^{};
//        [self.navigationController pushViewController:task animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.selected == 0){
        return [self.skillShowsArray count] + 2;
    }else if (self.selected == 1){
        return [self.releaseArray count] + 1;
    }else if (self.selected == 2){
        return 1+1;
    }
    return 0;
}

#pragma mark - UITableViewDatasource

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
    if(indexPath.row == 0){
        if ([[self.user objectForKey:@"remark"]isEqualToString:@""]||[self.user objectForKey:@"remark"]==nil) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"usercenter_user_now" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }else{
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"usercenter_user_now" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        CGSize cellwidth = CGSizeMake(mainScreenWidth,mainScreenheight);
        CGRect  cellframe = cell.frame;
        cellframe.size.width = cellwidth.width;
        cell.frame = cellframe;
        
        NSDictionary * dict = [[NSDictionary alloc] initWithDictionary:self.user];
        
        UIImageView * imgV = (UIImageView *)[cell viewWithTag:777];
        
        
        // 头像
        UIImageView * huntericon = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth / 2 - 56 / 2, 70, 56, 56)];
        [cell.contentView addSubview:huntericon];
        huntericon.clipsToBounds = YES;
        huntericon.layer.cornerRadius = huntericon.frame.size.height / 2.0;
        huntericon.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
        [huntericon addGestureRecognizer:tap];
        [huntericon sd_setImageWithURL:[self.user objectForKey:@"middle_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
      
        // 名称
        CGSize usernameSize = [[self.user objectForKey:@"username"] sizeWithFont:[UIFont systemFontOfSize:14]];
        UILabel * username = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth*0.5-usernameSize.width*0.5-14, 25,usernameSize.width, 20)];
        [cell.contentView addSubview:username];
        username.textAlignment = NSTextAlignmentRight;
        username.font = [UIFont systemFontOfSize:14];
        NSString * nameStr = [self.user objectForKey:@"username"];
        CGSize nameSize = [nameStr sizeWithFont:username.font constrainedToSize:CGSizeMake(username.frame.size.width, MAXFLOAT)];
        [username setText:[self.user objectForKey:@"username"]];
        username.textColor = [UIColor whiteColor];
        CGRect nameFrame = username.frame;
        if (nameSize.width > 76) {
            nameFrame.size.width = nameSize.width;
        }
        username.frame = nameFrame;
        
        // 等级
        UIImageView * levelImgV = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth / 4 - 7, huntericon.frame.origin.y + huntericon.frame.size.height / 2 - 5, 20, 20)];
        [cell.contentView addSubview:levelImgV];
        NSInteger i = [NSString stringWithFormat:@"%@",[self.user objectForKey:@"level"]].intValue;
        levelImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"猎人%ld", (long)i]];
        levelImgV.layer.cornerRadius = 8;
        
        // 认证
        UIImageView * trueName = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth - mainScreenWidth / 4, huntericon.frame.origin.y + huntericon.frame.size.height / 2 - 5, 20, 20)];
        [cell.contentView addSubview:trueName];
        
        if ([[self.user objectForKey:@"is_identity"] isEqualToString:@"1"]) {
            trueName.image = [UIImage imageNamed:@"猎人"];
        }else {
            trueName.image = [UIImage imageNamed:@"猎人-灰"];
        }
        trueName.layer.cornerRadius = 8;
        
        // 性别
        UIImageView * gender = [[UIImageView alloc] initWithFrame:CGRectMake(username.frame.size.width + username.frame.origin.x + 5, 30, 8, 8)];
        [cell.contentView addSubview:gender];
        if([[self.user objectForKey:@"sex"] isEqualToString:@"0"]){
            [gender setImage:[UIImage imageNamed:@"女"]];
        } else {
            [gender setImage:[UIImage imageNamed:@"男"]];
        }
        
        // 年龄
        UILabel * ageLb = [[UILabel alloc] initWithFrame:CGRectMake(gender.frame.origin.x + gender.frame.size.width + 5, 24, 100, 20)];
        [cell.contentView addSubview:ageLb];
        ageLb.textColor = [UIColor whiteColor];
        ageLb.textAlignment = NSTextAlignmentLeft;
        ageLb.font = [UIFont systemFontOfSize:12];
        ageLb.text = [dict objectForKey:@"age"];
        
        // 猎人号
        UILabel * hunterNum = [[UILabel alloc] initWithFrame:CGRectMake(0, username.frame.origin.y + username.frame.size.height + 5, mainScreenWidth, 20)];
        [cell.contentView addSubview:hunterNum];
        hunterNum.textColor = [UIColor whiteColor];
        hunterNum.font = [UIFont systemFontOfSize:12];
        NSString *code = [NSString stringWithFormat:@"猎人ID号：%d", [AFNetworkTool getHunterID:[[self.user objectForKey:@"uid"] intValue]: 0]];
        hunterNum.text = code;
        hunterNum.textAlignment = NSTextAlignmentCenter;
        
        NSString *distanceStr = [ghunterRequester calculateDistanceWithLatitude:[self.user objectForKey:@"latitude"] withLongitude:[self.user objectForKey:@"longitude"]];
        if([[self.user objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:UID]]){
            distanceStr = @"0m";
        }
        
        // 距离暂时取消
        UILabel * distanceLb = [[UILabel alloc] initWithFrame:CGRectMake(0, huntericon.frame.size.height + huntericon.frame.origin.y + 10, mainScreenWidth, 20)];
        [cell.contentView addSubview:distanceLb];
        distanceLb.textAlignment = NSTextAlignmentCenter;
        distanceLb.textColor = [UIColor whiteColor];
        distanceLb.font = [UIFont systemFontOfSize:13];
        [self.name_distance setText:distanceStr];
        distanceLb.text = distanceStr;
        
        NSArray *identitiesArray = [self.user objectForKey:@"identities"];
        
        jobLb.text = [self.user objectForKey:@"job"];


        
//        CGRect jobframe = jobLb.frame;
        CGSize jobLbSize = [jobLb.text sizeWithFont:[UIFont systemFontOfSize:10]];
//        jobframe.size.width = jobLbSize.width;
//        jobLb.frame = jobframe;
        
        if (identitiesArray.count==0) {
            industryImg = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth / 2 - (17+jobLbSize.width)*0.5, distanceLb.frame.size.height + distanceLb.frame.origin.y + 3, 12, 12)];
            jobLb = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth / 2 - (17+jobLbSize.width)*0.5+17, distanceLb.frame.size.height + distanceLb.frame.origin.y, jobLbSize.width, 20)];
        }
        else{
                industryImg = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth / 2 - 40, distanceLb.frame.size.height + distanceLb.frame.origin.y + 3, 12, 12)];
            jobLb = [[UILabel alloc] initWithFrame:CGRectMake(industryImg.frame.origin.x + industryImg.frame.size.width +5, distanceLb.frame.size.height + distanceLb.frame.origin.y, jobLbSize.width, 20)];
        }
        // 职业前图标
        [cell.contentView addSubview:industryImg];
        NSString * IndustryStr = [NSString stringWithFormat:@"%@",[self.user objectForKey:@"industry"]];
        industryImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [AFNetworkTool getIndustryIcon:IndustryStr]]];
        
        // 职业
        [cell.contentView addSubview:jobLb];
        jobLb.textColor = [UIColor whiteColor];
        jobLb.font = [UIFont systemFontOfSize:10];
        jobLb.textColor = [UIColor whiteColor];
        jobLb.textAlignment = NSTextAlignmentLeft;
        
        NSArray *identitiesArr = [self.user objectForKey:@"identities"];
        if ( [identitiesArr count] > 0 ) {
            for (NSDictionary *ideDic in identitiesArr) {
                UILabel *label  = [[UILabel alloc] init];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = [ideDic objectForKey:@"title"];
                label.font = [UIFont systemFontOfSize:10.0];
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = [Monitor colorWithHexString:[ideDic objectForKey:@"color"] alpha:1.0];
                CGSize size = [label.text sizeWithFont:[UIFont systemFontOfSize:10.0]];
                CGRect frame = label.frame;
                frame.origin.x = jobLb.frame.origin.x + jobLb.frame.size.width + 5;
                frame.origin.y = industryImg.frame.origin.y;
                frame.size.width = size.width + 6;
                frame.size.height = industryImg.frame.size.height;
                
                label.frame = frame;
                [cell addSubview:label];
                break;
            }
        }
        
        // 描述
        UILabel * decription = [[UILabel alloc] initWithFrame:CGRectMake(0, industryImg.frame.size.height + industryImg.frame.origin.y + 5, mainScreenWidth, 20)];
        [cell.contentView addSubview:decription];
        decription.font = [UIFont systemFontOfSize:12];
        decription.textAlignment = NSTextAlignmentCenter;
        decription.numberOfLines = 2;
        NSString *descriptionStr = [self.user objectForKey:@"description"];
        CGSize descriptionSize = [descriptionStr sizeWithFont:decription.font constrainedToSize:CGSizeMake(decription.frame.size.width, MAXFLOAT)];
        CGRect descriptionFrame = decription.frame;
        descriptionFrame.size.height = descriptionSize.height;
        decription.frame = descriptionFrame;
        NSString *strtext = [NSString stringWithFormat:@"宣言: %@",[self.user objectForKey:@"description"]];
        decription.textColor = [UIColor whiteColor];
        [decription setText:strtext];
       
        UIButton * fansButton = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenWidth / 2 - 60, decription.frame.size.height + decription.frame.origin.y + 10, 55, 20)];
        [cell.contentView addSubview:fansButton];
        NSString * friendStr = [dict objectForKey:@"taskNum"];
        
        if (friendStr.integerValue > 0) {
            [fansButton setTitle:[NSString stringWithFormat:@"猎友 %@",[self.user objectForKey:@"fansNum"]] forState:UIControlStateNormal];
        }else {
            [fansButton setTitle:[NSString stringWithFormat:@"猎友 0"] forState:UIControlStateNormal];
        }
        fansButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [fansButton addTarget:self action:@selector(click2ShowFans) forControlEvents:UIControlEventTouchUpInside];
        
        // 关注猎友
        UIButton * followButton = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenWidth / 2 + 1, decription.frame.size.height + decription.frame.origin.y + 10, 60, 20)];
        if ([[self.user objectForKey:@"uid"] isEqualToString:@"1"]) {
            [followButton setTitle:[NSString stringWithFormat:@"关注 99"] forState:UIControlStateNormal];
        }else{
            [followButton setTitle:[NSString stringWithFormat:@"关注 %@", [self.user objectForKey:@"followNum"]] forState:UIControlStateNormal];
        }
        if ([[self.user objectForKey:@"followNum"] integerValue] > 0) {
            [followButton setTitle:[NSString stringWithFormat:@"关注 %@", [self.user objectForKey:@"followNum"]] forState:UIControlStateNormal];
        }else {
            [followButton setTitle:[NSString stringWithFormat:@"关注 0"] forState:UIControlStateNormal];
        }
        
        followButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:followButton];
        [followButton addTarget:self action:@selector(click2ShowFollows) forControlEvents:UIControlEventTouchUpInside];
        UILabel * lineLb = [[UILabel alloc] initWithFrame:CGRectMake(followButton.frame.origin.x - 5, followButton.frame.origin.y + 5, 1, 10)];
        lineLb.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:lineLb];
        
        UIView * back = [[UIView alloc] initWithFrame:CGRectMake(0, imgV.frame.origin.y + imgV.frame.size.height, mainScreenWidth, 40)];
        [cell.contentView addSubview:back];
        back.backgroundColor = [UIColor whiteColor];
        
        CGFloat btnWidth = mainScreenWidth / 3;
        //  技能秀
        UIButton * skillShow = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth - 0.5, 40)];
        [back addSubview:skillShow];
        skillShow.titleLabel.font = [UIFont systemFontOfSize:12];
        [skillShow setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];
        [skillShow setTitle:[NSString stringWithFormat:@"技能秀 %zd",[self.skillShowsArray count]] forState:UIControlStateNormal];
        [skillShow addTarget:self action:@selector(click2ShowSkillShows) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, 10, 1, 20)];
        [back addSubview:line1];
        line1.backgroundColor = RGBCOLOR(235, 235, 235);
        // 发布
        UIButton * release = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth + 1, 0, btnWidth - 0.5, 40)];
        [back addSubview:release];
        release.titleLabel.font = [UIFont systemFontOfSize:12];
        NSString * str = [dict objectForKey:@"taskNum"];
        if (str.integerValue > 0) {
            [release setTitle:[NSString stringWithFormat:@"发布 %@", [dict objectForKey:@"taskNum"]] forState:UIControlStateNormal];
        }else {
            [release setTitle:[NSString stringWithFormat:@"发布 0"] forState:UIControlStateNormal];
        }
        [release setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];

        [release addTarget:self action:@selector(click2ShowRelease) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(btnWidth * 2 + 1, 10, 1, 20)];
        [back addSubview:line2];
        line2.backgroundColor = RGBCOLOR(235, 235, 235);
        
        // 评价
        UIButton * evaluations = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth * 2 + 2, 0, btnWidth - 0.5, 40)];
        [back addSubview:evaluations];
        evaluations.titleLabel.font = [UIFont systemFontOfSize:12];
        [evaluations setTitle:@"评价" forState:UIControlStateNormal];
        [evaluations setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];
        [evaluations setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [evaluations addTarget:self action:@selector(click2ShowEvaluations) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[self.user objectForKey:@"remark"] isEqualToString:@""]||[self.user objectForKey:@"remark"]==nil) {
            TQStarRatingView *star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(evaluations.frame.origin.x + evaluations.frame.size.width / 2 + 10, 15, 40, 10) numberOfStar:5];
            
//            NSLog(@" ---------- kopubility2 = %lf",[[self.user objectForKey:@"kopubility"] floatValue]);
            [star setScore:[[self.user objectForKey:@"kopubility"] floatValue]];
            [star setuserInteractionEnabled:NO];
            [back addSubview:star];
        }else{
            TQStarRatingView *star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(evaluations.frame.origin.x + evaluations.frame.size.width / 2 + 10, 15, 40, 10) numberOfStar:5];
//            NSLog(@" -------------- kopubility3 = %lf",[[self.user objectForKey:@"kopubility"] floatValue]);
            [star setScore:[[self.user objectForKey:@"kopubility"] floatValue]];
            [star setuserInteractionEnabled:NO];
            [back addSubview:star];
        }

        
        //
        CGFloat width = mainScreenWidth / 3.0;
        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, back.frame.origin.y + back.frame.size.height + 1,width, 1.5)];
        [cell.contentView addSubview:bottomView];
        bottomView.backgroundColor = [UIColor redColor];
        CGRect angleFrame = bottomView.frame;
        angleFrame.origin.x = self.selected * width + (width - angleFrame.size.width) / 2.0;
        bottomView.frame = angleFrame;

        
        UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 22, 36, 36)];
        [cell.contentView addSubview:backBtn];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenWidth - 36, 22, 36, 36)];
        [cell.contentView addSubview:shareBtn];
        [shareBtn setImage:[UIImage imageNamed:@"share_hp_normal"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, back.frame.size.height + back.frame.origin.y + 2.5, mainScreenWidth, 10)];
        [cell.contentView addSubview:backView];
        backView.backgroundColor = RGBCOLOR(235, 235, 235);
        
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = backView.frame.origin.y + backView.frame.size.height + 2;
        cell.frame = cellFrame;
        
    }else{
        if(self.selected == 0){
            if(indexPath.row == 1) {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"skillView" owner:self options:nil];
                cell = [nibs objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                UIImageView *back = (UIImageView *)[cell viewWithTag:1];
                CGRect backfram = back.frame;
                back.frame = backfram;
                backfram.origin.y = 10;
                toshowTagList *tagList = [[toshowTagList alloc] initWithFrame:CGRectMake(back.frame.origin.x,back.frame.origin.y - 5,back.frame.size.width,0)];
                NSArray *tags = [self.user objectForKey:@"tags"];
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSUInteger i = 0; i < [tags count]; i++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[tags objectAtIndex:i] forKey:@"title"];
                    [dic setObject:[UIColor colorWithRed:156.0 / 255 green:156.0 / 255 blue:153.0 / 255 alpha:1] forKey:@"titleColor"];
                    [dic setObject:[UIColor whiteColor] forKey:@"backgroundColor"];
                    [dic setObject:RGBA(248.0, 140.0, 86, 1.0) forKey:@"borderColor"];
                    [dic setObject:@"1.0" forKey:@"borderWidth"];
                    [array addObject:dic];
                }
                [tagList addTags:array];
                CGRect r = [tagList frame];
                r.size.height += tagList.heightFinal;
                tagList.frame = r;
                [cell addSubview:tagList];
                CGRect r1 = [cell frame];
//                r1.size.height += (tagList.frame.size.height + 15);
                if (tags.count == 0) {
                    r1.size.height = 0;
                }else{
                    r1.size.height = tagList.frame.size.height + 8;
                }
                
//                cell.backgroundColor = [UIColor blackColor];
//                r1.origin.y = 20;
                cell.frame = r1;
                // NSLog(@"%.f",r.size.height);
                return cell;
            }
            else if(indexPath.row > 1) {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"hunterCircleSkillShowNow" owner:self options:nil];
                cell = [nibs objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                CGSize width = CGSizeMake(mainScreenWidth,mainScreenheight);
                CGRect  cellframe = cell.frame;
                cellframe.size.width = width.width;
                cell.frame = cellframe;
//                UIImageView* bgImage=(UIImageView*)[cell viewWithTag:1];
                UILabel* titleLabel=(UILabel*)[cell viewWithTag:2];
                UILabel* contentLabel=(UILabel*)[cell viewWithTag:5];
//                UILabel* isSellLabel=(UILabel*)[cell viewWithTag:6];
                UILabel* buyLabel=(UILabel*)[cell viewWithTag:7];
                UILabel* hotLabel=(UILabel*)[cell viewWithTag:8];
                UIImageView* tuImage=(UIImageView*)[cell viewWithTag:110];
                UILabel*tablabel=(UILabel*)[cell viewWithTag:111];
                NSDictionary* skillDic=[self.skillShowsArray objectAtIndex:indexPath.row-2];
                [tuImage sd_setImageWithURL:[skillDic objectForKey:@"tiny_image"] placeholderImage:[UIImage imageNamed:@"avatar"]];
                
                if ([[skillDic objectForKey:@"isshow"] intValue] == 2) {
                    
                    tablabel.text = @"上架";
                    tablabel.backgroundColor = [Monitor colorWithHexString:@"#E75858" alpha:1.0];
                    tablabel.textColor = [UIColor whiteColor];
                }else {
                    tablabel.backgroundColor = [Monitor colorWithHexString:@"#999999" alpha:1.0];
                    tablabel.textColor = [UIColor whiteColor];
                    tablabel.text = @"下架";
                }
                
                tuImage.clipsToBounds = YES;
                tuImage.layer.cornerRadius = 3.0;
                titleLabel.text=[skillDic objectForKey:@"skill"];
                titleLabel.font = [UIFont systemFontOfSize:12];
                
                
                UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth - 100, titleLabel.frame.origin.y, 90, titleLabel.frame.size.height)];
                [cell addSubview:priceLabel];
                priceLabel.font = [UIFont systemFontOfSize:12];
                priceLabel.textColor = RGBCOLOR(234, 85, 20);
//                priceLabel.backgroundColor = [UIColor redColor];
                NSString* priceStr=[NSString stringWithFormat:@"%@元/%@",[skillDic objectForKey:@"price"],[skillDic objectForKey:@"priceunit"]];
                priceLabel.text = priceStr;
                CGSize priceSize = [priceStr sizeWithFont:priceLabel.font];
                
                
                CGRect frame1 = priceLabel.frame;
                frame1.size.width = priceSize.width;
                frame1.origin. x= mainScreenWidth - priceSize.width - 10;
                priceLabel.frame = frame1;
                
                UIImageView * circleImage = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth - priceLabel.frame.origin.x - 10, titleLabel.frame.origin.y, 20, 20)];
                [cell addSubview:circleImage];
                circleImage.image = [UIImage imageNamed:@"add_gold"];
                
                CGRect frame2 = circleImage.frame;
                frame2.origin.x = mainScreenWidth - priceLabel.frame.size.width - 10 - circleImage.frame.size.width - 10;
                circleImage.frame=frame2;
                
                
                NSString* buyStr=[NSString stringWithFormat:@"%@人购买",[skillDic objectForKey:@"salenum"]];
                buyLabel.text=buyStr;
                NSString* hotStr=[NSString stringWithFormat:@"%@热度",[skillDic objectForKey:@"hot"]];
                hotLabel.text=hotStr;
                contentLabel.text=[skillDic objectForKey:@"description"];
                contentLabel.numberOfLines=0;
                CGRect frame3=contentLabel.frame;
                contentLabel.frame=frame3;
                

                
                
                CGRect cellFrame=cell.frame;
                cellFrame.size.height=cell.frame.size.height - 3;
                cell.frame=cellFrame;
                
                self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
                self.table.backgroundColor = RGBCOLOR(235, 235, 235);
                return cell;
            }
        }else if(self.selected == 1){
        
            NSDictionary *releaseDic = [self.releaseArray objectAtIndex:indexPath.row - 1];
            
//            NSLog(@"发布-------------===%@",releaseDic);
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"mytaskCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            OHAttributedLabel *status = (OHAttributedLabel *)[cell viewWithTag:118];
            UILabel *taskTitle = (UILabel *)[cell viewWithTag:2];
//            OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:3];
            UIImageView *catalog = (UIImageView *)[cell viewWithTag:4];
            UIView *bg = (UIView *)[cell viewWithTag:5];
            OHAttributedLabel *description = (OHAttributedLabel *)[cell viewWithTag:96];
            UIImageView *round = (UIImageView *)[cell viewWithTag:7];
            NSString *descriptionStr = [NSString stringWithFormat:@"%@人竞标",[releaseDic objectForKey:@"biddingnum"]];
//            NSString *statusStr = [releaseDic objectForKey:@"statusname"];
            UILabel * bidNum = (UILabel *)[cell viewWithTag:91];
            bidNum.text = descriptionStr;
            bidNum.font = [UIFont systemFontOfSize:10];
            bidNum.textColor = RGBCOLOR(153, 153, 153);
            
            CGSize descriptionSize = [descriptionStr sizeWithFont:description.font constrainedToSize:CGSizeMake(description.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect descriptionFrame = description.frame;
            descriptionFrame.origin.y = bg.frame.origin.y+60;
            descriptionFrame.size.height = descriptionSize.height;
            [description setFrame:descriptionFrame];
            description.textColor = [UIColor grayColor];
            [description setText:descriptionStr];
            
            description.backgroundColor = [UIColor clearColor];
            

            CGRect statuFrame = status.frame;
            statuFrame.origin.y = descriptionFrame.origin.y;
            status.backgroundColor = [UIColor clearColor];
//            statuFrame.size.height = statusSize.height;
            status.textColor = [UIColor grayColor];
            [status setFrame:statuFrame];

            [taskTitle setText:[releaseDic objectForKey:@"title"]];
           
            // 元/次
            UILabel * bounty = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth - 100, taskTitle.frame.origin.y, 90, taskTitle.frame.size.height)];
            [cell addSubview:bounty];
            
            NSString *bountyStr = [NSString stringWithFormat:@"%@元",[releaseDic objectForKey:@"bounty"]];
            NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
            bounty.font = [UIFont systemFontOfSize:12];
            bounty.textColor = RGBCOLOR(234, 85, 20);
            [bounty setAttributedText:attrStr];

            CGSize bountySize = [bounty.text sizeWithFont:bounty.font];
            CGRect bountyFrame = bounty.frame;
            bountyFrame.size.width = bountySize.width;
            bountyFrame.origin.x = mainScreenWidth - bountySize.width - 10;
            bounty.frame = bountyFrame;
            
            [catalog setImage:[UIImage imageNamed:[ghunterRequester getTaskCatalogImg:[releaseDic objectForKey:@"pcid"]]]];
            lineOn = (UILabel *)[cell viewWithTag:69];
            
            lineOn.text = [self judgePcidName:[ghunterRequester getTaskCatalogImg:[releaseDic objectForKey:@"pcid"]]];
            lineOn.font = [UIFont systemFontOfSize:10];
            [self judgePcidColor];
            
            lineOn.clipsToBounds = YES;
            lineOn.layer.cornerRadius = 3;
            CGRect lineFrame = lineOn.frame;
            
            lineFrame.origin.x = 10;
            lineFrame.origin.y = 40;
            
            lineOn.frame = lineFrame;
            
            // 赏字图片
            UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth - bountySize.width - 20 - 10 - 10, taskTitle.frame.origin.y + 2, 20, 20)];
            [cell addSubview:img];
            img.image = [UIImage imageNamed:@"add_gold"];

            NSString *LENstr = lineOn.text;
            CGRect tabbartxtFrame = lineOn.frame;
            if ([LENstr length]>1) {
                tabbartxtFrame.origin.x = taskTitle.frame.origin.x;
                tabbartxtFrame.size.width =25;
            }
            if ([LENstr length]>2) {
               tabbartxtFrame.origin.x = taskTitle.frame.origin.x;
                tabbartxtFrame.size.width =35;
            }
            if ([LENstr length]>3) {
                tabbartxtFrame.origin.x = taskTitle.frame.origin.x;
                tabbartxtFrame.size.width = 45;
            }
            
            lineOn.frame = tabbartxtFrame;
         
            CGFloat top = 20; // 顶端盖高度
            CGFloat bottom = bg.frame.size.height - top - 1; // 底端盖高度
            CGFloat left = 8; // 左端盖宽度
            CGFloat right = bg.frame.size.width - left - 1; // 右端盖宽度
            UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
            // 指定为拉伸模式，伸缩后重新赋值
            UIImage *image = [UIImage imageNamed:@"task_angle_round"];
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            [round setImage:image];
            
            UILabel *tabbartxt  = (UILabel *)[cell viewWithTag:67];
//            NSString*string =[releaseDic objectForKey:@"color"];
//            NSString *b = [string substringFromIndex:0];
//            NSString *colorstr = [NSString stringWithFormat:@"0x%@",b];
//            tabbartxt.textColor = [Monitor colorWithHexString:colorstr alpha:1.0f];
            tabbartxt.text = [releaseDic objectForKey:@"statusname"];
//            tabbartxt.textColor = [UIColor grayColor];
            tabbartxt.textColor = RGBCOLOR(153, 153, 153);
            tabbartxt.font = [UIFont systemFontOfSize:10];

            
            CGRect cellFrame = bg.frame;
            cellFrame.size.height = bg.frame.origin.y + 65;
            cell.frame = cellFrame;

            CGRect tabFrame = tabbartxt.frame;
            CGRect bidNumFrame = bidNum.frame;
            
            tabFrame.origin.x = mainScreenWidth - 55;
            tabFrame.origin.y = cell.frame.size.height - 25;
            bidNumFrame.origin.x =tabFrame.origin.x - 30;
            bidNumFrame.origin.y = cell.frame.size.height - 24;
            
            tabbartxt.frame = tabFrame;
            bidNum.frame = bidNumFrame;
            
            
            self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            self.table.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
            
            return cell;
        }else if (self.selected == 2){
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"valuationView" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            UIButton *btnGondar = (UIButton *)[cell viewWithTag:33];
            UIButton *btnHunter = (UIButton *)[cell viewWithTag:34];
            // 赏金评价
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gondarValuatioon)];
            [btnGondar setUserInteractionEnabled:YES];
            [btnGondar addGestureRecognizer:tap];
            // 猎人评价
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hunterValuation)];
            [btnHunter setUserInteractionEnabled:YES];
            [btnHunter addGestureRecognizer:tap2];
         
            OHAttributedLabel *titleLabel = (OHAttributedLabel *)[cell viewWithTag:1];
            NSString *allNum = [NSString stringWithFormat:@"累计%@条评价", [self.evaluationsDic objectForKey:@"valuation"]];
            NSMutableAttributedString *allNumStr = [NSMutableAttributedString attributedStringWithString:allNum];
            NSInteger length = [[self.evaluationsDic objectForKey:@"valuation"] length];
            [allNumStr setFont:[UIFont systemFontOfSize:18.0] range:NSMakeRange(2, length)];
            [allNumStr setTextColor:RGBA(234, 85, 20, 1.0) range:NSMakeRange(2, length)];
            [allNumStr setTextColor:[UIColor colorWithRed:234/255.0 green:85/234.0 blue:20/255.0 alpha:1.0]];
            [titleLabel setAttributedText:allNumStr];
            // 赏金评价
            NSDictionary *gondarDic = [self.evaluationsDic objectForKey:@"owner_valuation"];
            UIView *gondarValu1 =[cell viewWithTag:2];
            UIView *gondarValu2 =[cell viewWithTag:4];
            UIView *gondarValu3 =[cell viewWithTag:6];
            TQStarRatingView *startRating1 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [startRating1 setuserInteractionEnabled:NO];
            [startRating1 setScore:[[gondarDic objectForKey:@"valuation"] floatValue]];
            [gondarValu1 addSubview:startRating1];
            TQStarRatingView *startRating2 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [startRating2 setuserInteractionEnabled:NO];
            [startRating2 setScore:[[gondarDic objectForKey:@"honesty"] floatValue]];
            [gondarValu2 addSubview:startRating2];
            TQStarRatingView *startRating3 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [startRating3 setuserInteractionEnabled:NO];
            [startRating3 setScore:[[gondarDic objectForKey:@"friendly"] floatValue]];
            [gondarValu3 addSubview:startRating3];
            UILabel *curMonthLabel = (UILabel *)[cell viewWithTag:8];
            [curMonthLabel setText:[NSString stringWithFormat:@"本月发布%@个任务，好评率%@", [gondarDic objectForKey:@"curmonth_create_tasknum"], [gondarDic objectForKey:@"curmonth_valuation"]]];
            UILabel *allLabel = (UILabel *)[cell viewWithTag:3];
            UILabel *honestyLabel = (UILabel *)[cell viewWithTag:5];
            UILabel *friendlyLabel = (UILabel *)[cell viewWithTag:7];
            [allLabel setText:[gondarDic objectForKey:@"valuation"]];
            [honestyLabel setText:[gondarDic objectForKey:@"honesty"]];
            [friendlyLabel setText:[gondarDic objectForKey:@"friendly"]];
            // 猎人评价
            NSDictionary *hunterDic = [self.evaluationsDic objectForKey:@"hunter_valuation"];
            UIView *hunterValu1 =[cell viewWithTag:21];
            UIView *hunterValu2 =[cell viewWithTag:23];
            UIView *hunterValu3 =[cell viewWithTag:25];
            UIView *hunterValu4 =[cell viewWithTag:27];
            TQStarRatingView *startRating11 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [startRating11 setuserInteractionEnabled:NO];
            [startRating11 setScore:[[hunterDic objectForKey:@"valuation"] floatValue]];
            [hunterValu1 addSubview:startRating11];
            TQStarRatingView *startRating22 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [startRating22 setuserInteractionEnabled:NO];
            [startRating22 setScore:[[hunterDic objectForKey:@"attitude"] floatValue]];
            [hunterValu2 addSubview:startRating22];
            TQStarRatingView *startRating33 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [startRating33 setuserInteractionEnabled:NO];
            [startRating33 setScore:[[hunterDic objectForKey:@"speed"] floatValue]];
            [hunterValu3 addSubview:startRating33];
            TQStarRatingView *startRating44 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [startRating44 setuserInteractionEnabled:NO];
            [startRating44 setScore:[[hunterDic objectForKey:@"quality"] floatValue]];
            [hunterValu4 addSubview:startRating44];
            UILabel *curMonthLabel2 = (UILabel *)[cell viewWithTag:20];
            [curMonthLabel2 setText:[NSString stringWithFormat:@"本月完成%@个任务，好评率%@", [hunterDic objectForKey:@"curmonth_trade_tasknum"], [hunterDic objectForKey:@"curmonth_valuation"]]];
            UILabel *allLabel2 = (UILabel *)[cell viewWithTag:22];
            UILabel *atitudeLavel = (UILabel *)[cell viewWithTag:24];
            UILabel *speedLabel = (UILabel *)[cell viewWithTag:26];
            UILabel *qualityLabel = (UILabel *)[cell viewWithTag:28];
            [allLabel2 setText:[hunterDic objectForKey:@"valuation"]];
            [atitudeLavel setText:[hunterDic objectForKey:@"attitude"]];
            [speedLabel setText:[hunterDic objectForKey:@"speed"]];
            [qualityLabel setText:[hunterDic objectForKey:@"quality"]];
            return cell;
        }
    }
    return cell;
}

#pragma mark - AFNetworking methods
// 获取猎人信息
-(void)didGetHUnterInfoIsloading:(BOOL )isloading{
    if (isloading) {
        [self startLoad];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.uid forKey:@"uid"];
    [AFNetworkTool httpRequestWithUrl:URL_GET_USER_CENTER params:dic success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            self.user = [[result objectForKey:@"user"] mutableCopy];
            Monitor *data = [Monitor sharedInstance];
            data.remark = @"remark";
            if ([[self.user objectForKey:@"isfollow"] isEqualToString:@"1"]) {
                [self.followBtn setImage:[UIImage imageNamed:@"follow_after"] forState:UIControlStateNormal];
                [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
            } else {
                [self.followBtn setImage:[UIImage imageNamed:@"follow_before"] forState:UIControlStateNormal];
                [self.followBtn setTitle:@"关注Ta" forState:UIControlStateNormal];
            }
            if (flag != YES) {
                [self didGetSkillshowsIsloading:YES];
            }
        }else{
            if (flag != YES) {
                [ProgressHUD show:[result objectForKey:@"msg"]];
            }
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        self.table.pullTableIsLoadingMore = NO;
        self.table.pullTableIsRefreshing = NO;
        if (isloading) {
            [self endLoad];
        }
    }];
}

// 获取技能秀列表
-(void)didGetSkillshowsIsloading:(BOOL )isloading{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?uid=%@&page=%zd",URL_GET_USER_SKILL_SHOW,self.uid,_skillShowsPage] params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            if (_skillShowsPage == 1) {
                self.skillShowsSelected = YES;
                [self.skillShowsArray removeAllObjects];
                self.skillShowsPage = 2;
                NSArray *array = [result valueForKey:@"skillshows"];
                [self.skillShowsArray addObjectsFromArray:array];
            }else{
                self.skillShowsPage ++;
                NSArray *array = [result valueForKey:@"skillshows"];
                [self.skillShowsArray addObjectsFromArray:array];
            }
            [self.table reloadData];
        }else{
            //[ProgressHUD show:[result objectForKey:@"msg"]];
            if (_skillShowsPage >= 2) {
                if (flag != YES) {
                    
                    [ProgressHUD show:[result objectForKey:@"msg"]];
                }
            }else{
                [self.table reloadData];
            }
        }
        self.table.pullTableIsLoadingMore = NO;
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        self.table.pullTableIsLoadingMore = NO;
        self.table.pullTableIsRefreshing = NO;
        if (isloading) {
            [self endLoad];
        }
    }];
}
// 获取猎人发布的历史
-(void)didGetHuntertaskIsloading:(BOOL )isloading{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?uid=%@&page=%zd",URL_GET_HUNTER_RELEASE,self.uid,_releasePage] params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            if (_releasePage == 1) {
                self.releaseSelected = YES;
                [self.releaseArray removeAllObjects];
                self.releasePage = 2;
                NSArray *array = [result valueForKey:@"tasks"];
                [self.releaseArray addObjectsFromArray:array];
            }else{
                self.releasePage++;
                NSArray *array = [result valueForKey:@"tasks"];
                [self.releaseArray addObjectsFromArray:array];
            }
            [self.table reloadData];
        }else{
            //[ProgressHUD show:[result objectForKey:@"msg"]];
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
        self.table.pullTableIsLoadingMore = NO;
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        self.table.pullTableIsLoadingMore = NO;
        self.table.pullTableIsRefreshing = NO;
        if (isloading) {
            [self endLoad];
        }
    }];
}
// 获取猎人评价的历史
-(void)didGetValuationsIsloading:(BOOL )isloading{
       if (isloading) {
  [self startLoad];
 }
 [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?uid=%@&frompage=uservaluation",URL_GET_USER_EVALUATIONS,self.uid] params:nil success:^(NSData *data) {
 if (isloading) {
  [self endLoad];
 }
 NSError *error;
 NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
 if ([[result objectForKey:@"error"]integerValue] == 0) {
 self.evaluationSelected = YES;
 self.evaluationsDic = [NSMutableDictionary dictionaryWithDictionary:result];
 [self.table reloadData];
 }else{
 [ProgressHUD show:[result objectForKey:@"msg"]];
 }
 self.table.pullTableIsLoadingMore = NO;
  } fail:^{
 [ProgressHUD show:HTTPREQUEST_ERROR];
  self.table.pullTableIsLoadingMore = NO;
  self.table.pullTableIsRefreshing = NO;
 if (isloading) {
 [self endLoad];
 }
 }];
    
}
// 关注猎人
-(void)didFollowHunterIsloading:(BOOL )isloading{
    if (isloading) {
        [self startLoad];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[self.user objectForKey:@"uid"] forKey:@"uid"];
    [AFNetworkTool httpPostWithUrl:URL_FOLLOW_HUNTER andParameters:dic success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            [self.followBtn setImage:[UIImage imageNamed:@"follow_after"] forState:UIControlStateNormal];
            [self.user setValue:@"1" forKey:@"isfollow"];
            [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [ProgressHUD show:[result objectForKey:@"msg"]];
            Monitor *data = [Monitor sharedInstance];
            data.remark = @"remark";
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
// 取消关注猎人
-(void)didUNFollowHunterIsloading:(BOOL )isloading{
    if (isloading) {
        [self startLoad];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[self.user objectForKey:@"uid"] forKey:@"uid"];
    [AFNetworkTool httpPostWithUrl:URL_UNFOLLOW_HUNTER andParameters:dic success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            [self.followBtn setImage:[UIImage imageNamed:@"follow_before"] forState:UIControlStateNormal];
            [self.user setValue:@"0" forKey:@"isfollow"];
            [self.followBtn setTitle:@"关注Ta" forState:UIControlStateNormal];
            Monitor *data = [Monitor sharedInstance];
            data.remark = @"";
            [ProgressHUD show:[result objectForKey:@"msg"]];
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
// 举报猎人
-(void)didReportHunterIsloading:(BOOL )isloading withDic:(NSMutableDictionary *)dic{
    if (isloading) {
        [self startLoad];
    }
    // report 必须是post方法提交
    [AFNetworkTool httpPostWithUrl:URL_REPORT_TASK andParameters:dic success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            [ProgressHUD show:[result objectForKey:@"msg"]];
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
    // TODO:refresh
    if(self.selected == 0){
        _skillShowsPage = 1;
        [self didGetSkillshowsIsloading:NO];
    }else if (self.selected == 1){
        self.releasePage = 1;
        [self didGetHuntertaskIsloading:NO];
    }else if (self.selected == 2){
        self.evaluationsPage = 1;
        [self didGetValuationsIsloading:NO];
    }
    self.table.pullTableIsRefreshing = NO;
}

- (void)loadMoreDataToTable
{
    if(self.selected == 0){
        [self didGetSkillshowsIsloading:NO];
    }else if (self.selected == 1){
        [self didGetHuntertaskIsloading:NO];
    }else if (self.selected == 2){
        // 还在采用第一个版本的API
        [self didGetValuationsIsloading:NO];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textviewhere shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        if ([[textviewhere text] length] == 0) {
            [textviewhere resignFirstResponder];
            return NO;
        }
        if (textviewhere == self.text) {
            self.text = (UITextView *)[self.popReportView viewWithTag:3];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[self.user objectForKey:@"uid"] forKey:@"oid"];
            [dic setObject:@"1" forKey:@"type"];
            [dic setObject:self.text.text forKey:@"content"];
            
            [self didReportHunterIsloading:YES withDic:dic];
        }
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)TextView
{
    if (TextView == self.text) {
        if(self.text.text.length != 0){
            self.textTip.hidden = YES;
        }else{
            self.textTip.hidden = NO;
        }
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if(actionSheet == self.action){
            [self didUNFollowHunterIsloading:YES];
        }
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else if (buttonIndex == 1){
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

- (IBAction)share:(id)sender {
    shareAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"shareView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    [shareAlertView setCornerRadius:8.0];
    
    CGRect width = taskFilter.frame;
    width.size.width = mainScreenWidth - 20;
    taskFilter.frame = width;
    
    CGRect taskfilterFrame = taskFilter.frame;
    shareAlertView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height - 10), taskfilterFrame.size.width, taskfilterFrame.size.height);
    shareAlertView.showView = taskFilter;
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
    
    shareAlertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    
    [shareAlertView show];
}

// 分享任务到第三方平台
-(void)shareToPlatforms:(id)sender{
    [shareAlertView dismissAnimated:YES];
    UIButton *btn = (UIButton *)sender;
    int code = [AFNetworkTool getHunterID:[[ghunterRequester getUserInfo:UID] intValue] :0];
    NSString *shareUrl = [NSString stringWithFormat:@"http://apiadmin.imgondar.com/mobile/user/view?uid=%@&code=%zd", self.uid, code];
    NSString *imgUrl = [self.user objectForKey:TINY_AVATAR];
    NSString *data = [self.user objectForKey:@"username"];
    if ( [btn tag] == 1 ) {
        // wxcircle
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"我是猎人「%@」，找我就上赏金猎人！",[self.user objectForKey:@"username"]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.uid :SHARETYPE_HUNTER :data :SHAREPLATFORM_WXMOMENTS];
            }
        }];
    }else if([btn tag] == 2){
        // weixinfriend
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = APP_NAME;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"我是猎人「%@」，找我就上赏金猎人！",[self.user objectForKey:@"username"]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.uid :SHARETYPE_HUNTER :data :SHAREPLATFORM_WECHAT];
            }
        }];
    }else if([btn tag] == 3){
        // weibo
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:SHARE_IMG_URL];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"#赏金猎人#我在@赏金猎人imGondar 发现猎人「%@」，找Ta就上赏金猎人吧~ http://mob.imGondar.com/user/view?uid=%@",[self.user objectForKey:@"username"], self.uid] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.uid :SHARETYPE_HUNTER :data :SHAREPLATFORM_SINAWEIBO];
            }
        }];
    }else if([btn tag] == 4){
        // copy
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:shareUrl];
        [ProgressHUD show:@"已复制到剪贴板"];
        [shareAlertView dismissAnimated:YES];
    }else if([btn tag] == 5){
        // cancel
        [shareAlertView dismissAnimated:YES];
    }else if([btn tag] == 6){
        // qzone
        if (![QQApiInterface isQQInstalled]) {
            [AFNetworkTool isInstallQQ];
            return;
        }

        [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qzoneData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:[NSString stringWithFormat:@"我是猎人「%@」，找我就上赏金猎人！",[self.user objectForKey:@"username"]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.uid :SHARETYPE_HUNTER :data :SHAREPLATFORM_QZONE];
            }
        }];
    }else if([btn tag] == 7){
        // qq
        if (![QQApiInterface isQQInstalled]) {
            [AFNetworkTool isInstallQQ];
            return;
        }

        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qqData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"我是猎人「%@」，找我就上赏金猎人！",[self.user objectForKey:@"username"]]  image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.uid :SHARETYPE_HUNTER :data :SHAREPLATFORM_QQ];
            }
        }];
    }
}

- (void)gondarValuatioon {
   ghunterUserEvaluationViewController* userEva=[[ghunterUserEvaluationViewController alloc] init];
   NSString* typeStr=[NSString stringWithFormat:@"%zd",1];
   userEva.type = typeStr;
   userEva.uid = self.uid;
   [self.navigationController pushViewController:userEva animated:YES];
}
- (void)hunterValuation {
   ghunterUserEvaluationViewController* userEva=[[ghunterUserEvaluationViewController alloc] init];
   NSString* typeStr=[NSString stringWithFormat:@"%zd",0];
   userEva.type = typeStr;
   userEva.uid = self.uid;
   [self.navigationController pushViewController:userEva animated:YES];
}

#pragma mark --- 备注
- (IBAction)beizhu:(UIButton *)sender {
    
    if (!imgondar_islogin) {
        
        [self click2Login];
        return;
    }
    if ([[Monitor sharedInstance].remark isEqualToString:@""]||[Monitor sharedInstance].remark==nil) {
        [ProgressHUD show:@"请先关注Ta才可以添加备注哦"];
    }else{
    shareAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"Remarks" owner:self options:nil];
    textview = [[UIView alloc] init];
    textview = [nibs objectAtIndex:0];
    CGRect taskfilterFrame = textview.frame;
    shareAlertView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height - 10), taskfilterFrame.size.width, taskfilterFrame.size.height);
//    taskfilterFrame.origin.y = 400;
    textview.frame = taskfilterFrame;
    
//    [self.view addSubview:textview];
    textat = (UITextField *)[textview viewWithTag:12];
    textat.delegate = self;//设置代理
//    [shareAlertView setCornerRadius:8.0];
    shareAlertView.showView = textview;
    shareAlertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    [shareAlertView show];
     UIButton *btn = (UIButton *)[textview viewWithTag:10];
     UIButton *btn2 = (UIButton *)[textview viewWithTag:11];
    [btn addTarget:self action:@selector(btn:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn2 addTarget:self action:@selector(btn2:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [textview resignFirstResponder];
}

#pragma textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    shareAlertView.frame = CGRectMake(0,- 245, mainScreenWidth, mainScreenheight);
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
     shareAlertView.frame = [[UIScreen mainScreen] bounds];
    [UIView commitAnimations];
    return YES;
}


-(void)btn:(UIButton *)btn{

    NSString *url = [NSString stringWithFormat:@"%@?uid=%@&remark=%@",URL_GET_SKILL_remark,self.uid,textat.text];
    NSLog(@"1======%@",url);
    [AFNetworkTool httpRequestWithUrl:url success:^(NSData *data) {
        NSError *error;
      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
//        NSLog(@"======%@",dic);
       if (!error) {
           if ([[dic objectForKey:@"error"] intValue]==0) {
               [self.user removeAllObjects];
               [self didGetHUnterInfoIsloading:YES];
                 [ProgressHUD show:[dic objectForKey:@"msg"]];
               [_table reloadData];
               [textview resignFirstResponder];
               [shareAlertView dismissAnimated:YES];
           }else{
               [ProgressHUD show:[dic objectForKey:@"msg"]];
               [textview resignFirstResponder];
               [shareAlertView dismissAnimated:YES];
           }
      }
    } fail:^{
        [textview resignFirstResponder];
        [shareAlertView dismissAnimated:YES];
        [ProgressHUD show:HTTPREQUEST_ERROR];
    }];
    
    
}




-(void)btn2:(UIButton *)btn{
    [textview resignFirstResponder];
    [shareAlertView dismissAnimated:YES];
    
}


- (NSString *) judgePcidName:(NSString *) pcidStr {
    
    if ([pcidStr isEqualToString:@"catalog_study"]) {
        
        return @"学习";
    }
    if ([pcidStr isEqualToString:@"catalog_parttime"]) {
        
        return @"兼职";
    }
    if ([pcidStr isEqualToString:@"catalog_partner"]) {
        
        return @"陪练";
    }
    if ([pcidStr isEqualToString:@"catalog_online"]) {
        
        return @"线上";
    }
    if ([pcidStr isEqualToString:@"catalog_love"]) {
        
        return @"表白";
    }
    if ([pcidStr isEqualToString:@"catalog_leg"]) {
        
        return @"飞毛腿";
    }
    if ([pcidStr isEqualToString:@"catalog_coach"]) {
        
        return @"教练";
    }
    if ([pcidStr isEqualToString:@"catalog_activity"]) {
        
        return @"活动";
    }
    return nil;
}

- (void) judgePcidColor{
    
    
    if ([lineOn.text isEqualToString:@"活动"]) {
        
        lineOn.textColor = [UIColor colorWithRed:107.0 / 255.0 green:185.0 / 255.0 blue:36.0 / 255.0 alpha:1];
        [lineOn.layer setBorderWidth:1.0];
        [lineOn.layer setBorderColor:[UIColor colorWithRed:107.0 / 255.0 green:185.0 / 255.0 blue:36.0 / 255.0 alpha:1].CGColor];//边框颜色
        
        
    }
    if ([lineOn.text isEqualToString:@"教练"]) {
        
        lineOn.textColor = [UIColor colorWithRed:96.0 / 255.0 green:82.0 / 255.0 blue:218.0 / 255.0 alpha:1];
        [lineOn.layer setBorderWidth:1.0];
        [lineOn.layer setBorderColor:[UIColor colorWithRed:96.0 / 255.0 green:185.0 / 255.0 blue:218.0 / 255.0 alpha:1].CGColor];//边框颜色
        
        
    }
    if ([lineOn.text isEqualToString:@"学习"]) {
        
        lineOn.textColor = [UIColor colorWithRed:51.0 / 255.0 green:194.0 / 255.0 blue:189.0 / 255.0 alpha:1];
        [lineOn.layer setBorderWidth:1.0];
        [lineOn.layer setBorderColor:[UIColor colorWithRed:51.0 / 255.0 green:185.0 / 255.0 blue:189.0 / 255.0 alpha:1].CGColor];//边框颜色
    }
    if ([lineOn.text isEqualToString:@"兼职"]) {
        
        lineOn.textColor = [UIColor colorWithRed:234.0 / 255.0 green:135.0 / 255.0 blue:23.0 / 255.0 alpha:1];
        [lineOn.layer setBorderWidth:1.0];
        [lineOn.layer setBorderColor:[UIColor colorWithRed:234.0 / 255.0 green:135.0 / 255.0 blue:23.0 / 255.0 alpha:1].CGColor];//边框颜色
        
    }
    if ([lineOn.text isEqualToString:@"陪练"]) {
        
        lineOn.textColor = [UIColor colorWithRed:23.0 / 255.0 green:181.0 / 255.0 blue:230.0 / 255.0 alpha:1];
        [lineOn.layer setBorderWidth:1.0];
        [lineOn.layer setBorderColor:[UIColor colorWithRed:23.0 / 255.0 green:181.0 / 255.0 blue:230.0 / 255.0 alpha:1].CGColor];//边框颜色
        
        
    }
    if ([lineOn.text isEqualToString:@"线上"]) {
        
        lineOn.textColor = [UIColor colorWithRed:34.0 / 255.0 green:200.0 / 255.0 blue:123.0 / 255.0 alpha:1];
        [lineOn.layer setBorderWidth:1.0];
        [lineOn.layer setBorderColor:[UIColor colorWithRed:34.0 / 255.0 green:200.0 / 255.0 blue:123.0 / 255.0 alpha:1].CGColor];//边框颜色
        
        
    }
    if ([lineOn.text isEqualToString:@"表白"]) {
        
        lineOn.textColor = [UIColor colorWithRed:244.0 / 255.0 green:81.0 / 255.0 blue:87.0 / 255.0 alpha:1];
        [lineOn.layer setBorderWidth:1.0];
        [lineOn.layer setBorderColor:[UIColor colorWithRed:244.0 / 255.0 green:81.0 / 255.0 blue:87.0 / 255.0 alpha:1].CGColor];//边框颜色
        
        
    }
    if ([lineOn.text isEqualToString:@"飞毛腿"]) {
        
        lineOn.textColor = [UIColor colorWithRed:200.0 / 255.0 green:71.0 / 255.0 blue:149.0 / 255.0 alpha:1];
        [lineOn.layer setBorderWidth:1.0];
        [lineOn.layer setBorderColor:[UIColor colorWithRed:200.0 / 255.0 green:71.0 / 255.0 blue:149.0 / 255.0 alpha:1].CGColor];//边框颜色
    }
}

#pragma mark --- 未登录点击
// 未登录，需要点击去登陆
-(void)click2Login{
    ghunterLoginViewController *login = [[ghunterLoginViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
    [login setCallBackBlock:^{
        
        [self didGetHUnterInfoIsloading:NO];
    }];
}



@end