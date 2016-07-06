//
//  ghunterMainViewController.m
//  ghunter
//
//  Created by chensonglu on 14-3-11.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import "ghunterMyViewController.h"
#import "ghunterTabViewController.h"
#import "ghunterIdentityViewController.h"
#import "ghunterMyGoldCoinShopViewController.h"
#import "Header.h"
#import "CreditNavigationController.h"
#import "CreditWebViewController.h"
#import "CreditWebView.h"
#import "ghunterMyCouponViewController.h"
#import "UMSocialQQHandler.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"


@interface ghunterMyViewController ()<UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UIView *notlogin;


@property (strong, nonatomic) IBOutlet UIView *login;
@property (weak, nonatomic) IBOutlet UIImageView *userBackgroundImageView;
@property(nonatomic,retain) NSMutableDictionary *user;
@property (strong, nonatomic) IBOutlet UIView *navbg;
@property (weak, nonatomic) IBOutlet UIImageView *identity;
@property (weak, nonatomic) IBOutlet UIImageView *unreadImg;
@property (weak, nonatomic) IBOutlet UIButton *levelButton;
@property (weak, nonatomic) IBOutlet UIImageView *levelBGNormal;
@property (weak, nonatomic) IBOutlet UIImageView *levelBGWhite;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *followNum;
@property (weak, nonatomic) IBOutlet UILabel *friendNum;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIView *badge;
@property (weak, nonatomic) IBOutlet UIImageView *userIconBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIView *userInfoDisplay;
@property (weak, nonatomic) UIView *userLevelDisplay;
@property (nonatomic,retain)TQStarRatingView *star;
@property (weak, nonatomic) IBOutlet UIView *skillAndAccountBG;
@property (weak, nonatomic) IBOutlet UIView *mineBG;
@property (weak, nonatomic) IBOutlet UIView *hunterCircle;
@property (strong, nonatomic) IBOutlet UILabel *evaluationLabel;
@property(assign) BOOL isLoad;
@property(strong,nonatomic)UIActivityIndicatorView* act;
//新加信息 金币商城内
@property (nonatomic,strong) NSDictionary *_loginData;
@property (nonatomic ,retain) ghunterLoadingView *loadingView;
// 猎人ID号
@property (weak, nonatomic) IBOutlet UILabel *hunterIdLabel;

@property (strong, nonatomic) IBOutlet UIView *bg;

// 我的参与
@property (strong, nonatomic) IBOutlet UILabel *myJoinLabel;

// 我的发布
@property (strong, nonatomic) IBOutlet UILabel *myReleaseLabel;

// More更多
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;


// 我的优惠券
- (IBAction)MyDiscount:(id)sender;

// 我要合作
- (IBAction)MyCooperate:(id)sender;

//
- (IBAction)clickSettingBtn:(id)sender;
- (IBAction)iconImageBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *descLb;

@property (strong, nonatomic) IBOutlet UILabel *notLoginLb;

- (IBAction)notLoginMyCoupon:(id)sender;
- (IBAction)notLoginCooperate:(id)sender;
- (IBAction)jifenShop:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lineOne;
@property (strong, nonatomic) IBOutlet UILabel *lineThree;
@property (strong, nonatomic) IBOutlet UILabel *lineTwo;

@end
#pragma mark - UIViewController
@implementation ghunterMyViewController

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
    // 获取本页数据

    if (imgondar_islogin) {
        [self didGetMineDataIsloading:NO];
        [self didGetJoinAndReleaseTaskNum];
    }else{
        // 未登录显示处理
        star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(mainScreenWidth-67,14, 50, 10) numberOfStar:5 ];
        [self.statview addSubview:star];
        [star setScore:0.0];
        [star setuserInteractionEnabled:NO];
    }
    self.notingicon.layer.masksToBounds = YES;
    self.notingicon.layer.cornerRadius = 28;
    self.notingicon.backgroundColor = [UIColor grayColor];
    //label line 的高度
    CGRect lineOneHeight = _lineOne.frame;
    lineOneHeight.size.height = 0.5;
    _lineOne.frame = lineOneHeight;
    CGRect lineTwoHeight = _lineTwo.frame;
    lineTwoHeight.size.height = 0.5;
    _lineTwo.frame = lineTwoHeight;
    CGRect lineThreeHeight = _lineThree.frame;
    lineThreeHeight.size.height = 0.5;
    _lineThree.frame = lineThreeHeight;
    
    // 切出圆角
    self.backGroundView.layer.cornerRadius = 15.0;
    
    //
    UITapGestureRecognizer * levelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLevel:)];
    [self.levelImgV addGestureRecognizer:levelTap];
    
    
    _bg.backgroundColor = Nav_backgroud;
    // Do any additional setup after loading the view from its nib.
    _navbg.backgroundColor = Nav_backgroud;
    self.user = [[NSMutableDictionary alloc] init];
    CGRect myViewFrame = self.myView.frame;
    myViewFrame.size.width = mainScreenWidth;
    self.myView.frame = myViewFrame;
    _isLoad = NO;
    
    self.identity.userInteractionEnabled = YES;
    self.identity.clipsToBounds = YES;
    self.userIcon.userInteractionEnabled = YES;
    self.userIcon.clipsToBounds = YES;
    self.userIcon.layer.cornerRadius = self.userIcon.frame.size.height / 2.0;
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserinfo:)];
    [self.userIcon addGestureRecognizer:iconTap];

    UITapGestureRecognizer * yelltitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserinfo:)];
    [self.yelltit addGestureRecognizer:yelltitTap];

    
    //修改，设置小红点为圆形
    [[_badge layer] setCornerRadius:_badge.frame.size.width * 0.5];
    [self.badge setHidden:YES];
    
    circleBadge.badgeText = [NSString stringWithFormat:@"%zd", 1];
    [circleBadge setBadgeTextColor:RGBA(234.0, 85.0, 20.0, 1.0)];
    noticeBadge.badgeText = [NSString stringWithFormat:@"%zd",0];
    
    self.userInfoDisplay.userInteractionEnabled = YES;
    self.userIconBackgroundView.userInteractionEnabled = YES;
    [self.userBackgroundImageView addSubview:self.userInfoDisplay];
    
    self.scrollView.frame = CGRectMake(0, -20, self.view.frame.size.width, mainScreenheight-20);

    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.myView.frame.size.height + 10);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    [self.scrollView addSubview:self.myView];
    [self.scrollView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 等级图标
    self.levelButton.backgroundColor = [UIColor whiteColor];
    self.levelButton.layer.cornerRadius = 8;
    self.levelImgV.userInteractionEnabled = YES;
    self.levelImgV.layer.cornerRadius = self.levelImgV.frame.size.width / 2;
    
    // 我的参与 我的发布标签
    self.myJoinLabel.hidden = YES;
    self.myJoinLabel.textColor = [UIColor whiteColor];
//    self.myJoinLabel.backgroundColor = [UIColor redColor];
    self.myJoinLabel.backgroundColor = [Monitor colorWithHexString:@"#E75858" alpha:1.0];
    self.myJoinLabel.layer.cornerRadius = self.myJoinLabel.frame.size.height / 2;
    self.myJoinLabel.clipsToBounds = YES;
    self.myJoinLabel.font = [UIFont systemFontOfSize:10];
    
    self.myReleaseLabel.hidden = NO;
    self.myReleaseLabel.textColor = [UIColor whiteColor];
    self.myReleaseLabel.backgroundColor = [Monitor colorWithHexString:@"#E75858" alpha:1.0];;
    self.myReleaseLabel.layer.cornerRadius = self.myReleaseLabel.frame.size.height / 2;
    self.myReleaseLabel.clipsToBounds = YES;
    self.myReleaseLabel.font = [UIFont systemFontOfSize:10];
    
    //登陆之后，修改资料之后
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userinfo_modify" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userinfo_modify) name:@"userinfo_modify" object:nil];
    
    //添加分享按钮的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDuibaShareClick:) name:@"duiba-share-click" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:238.0 / 255.0 green:238.0 / 255.0 blue:238.0 / 255.0 alpha:1.0];
    UIGestureRecognizer * tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    
    self.notLoginLb.userInteractionEnabled = YES;
    self.descLb.userInteractionEnabled = YES;
    [self.notingicon addGestureRecognizer:tap];
    [self.notLoginLb addGestureRecognizer:tap];
    [self.descLb addGestureRecognizer:tap];
}

-(void)headerRereshing{
    if (imgondar_islogin) {
        [self didGetMineDataIsloading:NO];
        [self didGetJoinAndReleaseTaskNum];
    }else{
        [self.scrollView headerEndRefreshing];
    }
}

#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if(_isLoad==YES)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentInset=UIEdgeInsetsMake(60, 0, 0, 0);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
     
    self.navigationController.navigationBarHidden = YES;
    ghunterTabViewController *tbvc = (ghunterTabViewController *)self.tabBarController;
    if (!tbvc.didSelectItemOfTabBar) {
        self.tabBarController.tabBar.hidden = YES;
        // [self.tabBarController.tabBar setAlpha:0];
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = mainScreenheight;
        [self.tabBarController.tabBar setFrame:frame];
        
        self.scrollView.frame = CGRectMake(0, -20, self.view.frame.size.width, mainScreenheight- 20);
    }
    self.notlogin.frame = CGRectMake(0,0, self.view.frame.size.width, mainScreenheight);
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    // 更新猎友圈动态的UI
    [self update_huntercircle_ui];
    if (!imgondar_islogin) {
        [self.scrollView addSubview:self.notlogin];

//      如果没有登录
        [self.Grade setText:@"lv1"];
        // 等级更改为图片
        
        self.levelImgV.image = [UIImage imageNamed:@"等级是1"];
        
        [self.More setText:@"0"];
        [self.Real setText:@"0"];
        [self.username setText:@"点击登录"];
        self.username.textColor = [UIColor grayColor];
        [self.userIcon setImage:[UIImage imageNamed:@"avatar"]];
        star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(mainScreenWidth-67,14, 50, 10) numberOfStar:5 ];
        [self.statview addSubview:star];
        [star setScore:0.0];
        [star setuserInteractionEnabled:NO];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated {

    ghunterTabViewController *tbvc = (ghunterTabViewController *)self.tabBarController;
    if (self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = self.tabBarController.tabBar.frame;
            frame.origin.y = mainScreenheight - TAB_BAR_HEIGHT;
            [self.tabBarController.tabBar setFrame:frame];
//            [self.tabBarController.tabBar setAlpha:1];
        }];
    }
    tbvc.didSelectItemOfTabBar = NO;
    
    // [self update_huntercircle_ui];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 加载网络数据
// 获取个人中心数据
-(void)didGetMineDataIsloading:(BOOL )isloading{
    [AFNetworkTool httpRequestWithUrl:URL_GET_MY_CENTER params:nil success:^(NSData *data) {
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            self.login.frame = CGRectMake(0,0, self.view.frame.size.width, self.myView.frame.size.height + 10);
            [self.scrollView addSubview:self.login];
            UIButton *ziliao = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 100)];
            ziliao.backgroundColor = [UIColor clearColor];
            [ziliao addTarget:self action:@selector(ziliao:) forControlEvents:(UIControlEventTouchUpInside)];
//            [self.scrollView addSubview:ziliao];
            
            self.user = [result objectForKey:@"user"];
            // 获取到是否登录的信息后，在本地保存ability技能 balance
            NSString *identityStatus = [self.user objectForKey:@"is_identity"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:identityStatus forKey:@"identityStatus"];
            
            NSString *strtit = [NSString stringWithFormat:@"   完善个人资料(已完善%d%%),赚取金币!",85];
            self.yelltit.text =strtit;
            self.yelltit.textColor = [UIColor whiteColor];
            self.yelltit.font = [UIFont systemFontOfSize:12];
            
            NSString *strtit2 = [NSString stringWithFormat:@"余额: %@",[self.user objectForKey:@"balance"]];
            self.Balance.text =strtit2;
             
            self.Balance.font = [UIFont systemFontOfSize:12];
            NSString *strtit3 = [NSString stringWithFormat:@"上架: %@",[self.user objectForKey:@"skillshownum"]];
            self.Number.text =strtit3;

            self.Number.font = [UIFont systemFontOfSize:12];
            NSString *strtit4 = [NSString stringWithFormat:@"金币: %@", [self.user objectForKey:@"coin_balance"]];
            self.Golds.text = strtit4;
            self.Golds.font = [UIFont systemFontOfSize:12];
            
            self.Grade.backgroundColor =  RGBCOLOR(249, 103, 40);
            self.Grade.font = [UIFont systemFontOfSize:10];
            self.Grade.textAlignment = NSTextAlignmentCenter;
            self.Grade.adjustsFontSizeToFitWidth = YES;
            self.Grade.textColor = [UIColor whiteColor];
            self.Grade.layer.cornerRadius = 2.0;
            
            // 将实名改为职业
            NSString * jobString = [NSString stringWithFormat:@"%@",[self.user objectForKey:@"job"]];
            self.Real.text = jobString;
            self.Real.font = [UIFont systemFontOfSize:11];
            self.Real.textAlignment = NSTextAlignmentCenter;
            self.Real.textColor = [UIColor whiteColor];
            self.Real.font = [UIFont systemFontOfSize:10];
            self.Real.layer.cornerRadius = 2.0;
            self.Real.textAlignment = NSTextAlignmentLeft;
            
            self.More.backgroundColor =RGBCOLOR(142, 210, 112);
            self.More.text = @"更多";
            self.More.textColor = [UIColor whiteColor];
            self.More.textAlignment = NSTextAlignmentCenter;
            self.More.font = [UIFont systemFontOfSize:7];
            self.More.layer.cornerRadius = self.More.frame.size.width / 2;
            
            // 等级图片
            NSInteger i = [NSString stringWithFormat:@"%@",[self.user objectForKey:@"level"]].intValue;
            self.levelImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级%ld", (long)i]];
            self.levelImgV.frame = CGRectMake(10, 7, 17, 17);
           
            // 职业前图标
            if ([AFNetworkTool getIndustryIcon:[self.user objectForKey:@"industry"]]) {
                UIImageView * jobImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.username.frame.origin.x + self.username.frame.size.width + 5, self.username.frame.origin.y + 2, 12, 12)];
                jobImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [AFNetworkTool getIndustryIcon:[self.user objectForKey:@"industry"]]]];
                [self.userInfoDisplay addSubview:jobImgV];
            }else {
                self.username.center = CGPointMake(self.userIcon.center.x - 5, self.backGroundView.frame.origin.y - 10);
            }
            
            CGRect backGroundFrame = self.backGroundView.frame;
            CGRect moreFrame = self.More.frame;
            // 未认证不显示图标
            if ([[self.user objectForKey:@"is_identity"] isEqualToString:@"1"]){
                self.certifyImg.image = [UIImage imageNamed:@"实名认证"];
                self.certifyImg.layer.cornerRadius = self.certifyImg.frame.size.width / 2;
                backGroundFrame.size.width = 28 + 10 + self.levelImgV.frame.size.width + self.More.frame.size.width+20;
            }else{
                backGroundFrame.size.width = 28 + 10 + self.levelImgV.frame.size.width + self.More.frame.size.width;

            }
            self.More.frame = moreFrame;
            self.moreBtn.frame = moreFrame;
            self.backGroundView.frame = backGroundFrame;
            self.backGroundView.center = CGPointMake(mainScreenWidth / 2, self.username.frame.size.height + self.username.frame.origin.y + 20);
            
            // 关注
            [self.followNum setText:[self.user objectForKey:@"follownum"]];
            self.followNum.font= [UIFont systemFontOfSize:12];
            [self.friendNum setText:[self.user objectForKey:@"friendsnum"]];
            self.friendNum.font= [UIFont systemFontOfSize:12];
            self.username.textColor = [UIColor whiteColor];
            [self.username setText:[self.user objectForKey:@"username"]];
            
            // 猎人号
            int code = [AFNetworkTool getHunterID:[[self.user objectForKey:@"uid"] intValue] :0];
            [self.hunterIdLabel setText:[NSString stringWithFormat:@"猎人ID号：%d", code]];
            
            [self.userIcon sd_setImageWithURL:[self.user objectForKey:@"middle_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            
            for (UIView *view in [self.myView subviews]) {
                if([view isKindOfClass:[TQStarRatingView class]]){
                    [view removeFromSuperview];
                }
            }
            star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(50,12, 50, 10) numberOfStar:5 ];
            [self.starView addSubview:star];
            
            [star setScore:[[self.user objectForKey:@"kopubility"] floatValue]];
            [star setuserInteractionEnabled:NO];
        }else{
            [ghunterRequester showTip:[result objectForKey:@"msg"]];
            if ([[result objectForKey:@"msg"] isEqualToString:@"未登录"]) {
                imgondar_islogin = NO;
                ghunterLoginViewController *login=[[ghunterLoginViewController alloc] init];
                [login setCallBackBlock:^{
                    self.tabBarController.selectedIndex = 3;
                }];
                // 模态跳转，从下往上
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
             }
        }
        if(_isLoad==YES)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
            }];
            _isLoad=NO;
        }
        [self.scrollView headerEndRefreshing];
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if(_isLoad==YES)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
            }];
            _isLoad=NO;
        }
    }];
}

// 更新猎友圈的动态
-(void)update_huntercircle_ui{
    // 如果有猎友圈动态
    if ( [gunread_feedavatar length] > 0 ) {
        [self.unreadImg setHidden:NO];
        [self.badge setHidden:NO];
        NSURL* urlStr=[NSURL URLWithString:gunread_feedavatar];
        [_unreadImg sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"avatar"]];
    }else{
        [self.unreadImg setHidden:YES];
        [self.badge setHidden:YES];
    }
}

-(void)ziliao:(UIButton *)btn{
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    ghunterUserInfoViewController *ghunterUserInfo = [[ghunterUserInfoViewController alloc] init];
    ghunterUserInfo.user = self.user;
    [self.navigationController pushViewController:ghunterUserInfo animated:YES];
}

#pragma mark - Custom Methods
-(void)click2Login{
    ghunterLoginViewController *login = [[ghunterLoginViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
    [login setCallBackBlock:^{
        self.tabBarController.selectedIndex = 3;
    }];
}


// 更多
- (void)showIdentity{
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    ghunterIdentityViewController *identityVc  = [[ghunterIdentityViewController alloc] init];
    [self.navigationController pushViewController:identityVc animated:YES];
}

//
- (void)showIdentity1{
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    ghunterIdentityViewController *identityVc  = [[ghunterIdentityViewController alloc] init];
    [self.navigationController pushViewController:identityVc animated:YES];
}


// 用户信息
- (void)showUserinfo:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    
    ghunterUserInfoViewController *ghunterUserInfo = [[ghunterUserInfoViewController alloc] init];
    ghunterUserInfo.user = self.user;
    [self.navigationController pushViewController:ghunterUserInfo animated:YES];
}

- (IBAction)setting:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    
    ghuntersettingsViewController *ghuntersettings = [[ghuntersettingsViewController alloc] init];
    [self.navigationController pushViewController:ghuntersettings animated:YES];
}

#pragma mark -猎友圈点击事件
- (IBAction)hunterCircleBtnClick:(UIButton *)sender {
    if(!imgondar_islogin)
    {
        [self click2Login];
        return;
    }
    else
    {
        ghunterHunterCircleViewController *hunterCircle = [[ghunterHunterCircleViewController alloc] init];
        hunterCircle.nameString = self.username.text;
        
        [self.navigationController pushViewController:hunterCircle animated:YES];
    }

}


#pragma mark --- 我的参与
- (IBAction)mytask:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    
    ghunterMyTaskViewController *ghuntermytask = [[ghunterMyTaskViewController alloc] init];
    [self.navigationController pushViewController:ghuntermytask animated:YES];
}

#pragma mark --- 我的发布
- (IBAction)myrelease:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    
    ghunterMyReleaseViewController *ghunterMyRelease = [[ghunterMyReleaseViewController alloc] init];
    [self.navigationController pushViewController:ghunterMyRelease animated:YES];
}

#pragma  mark --- 我的收藏
- (IBAction)mycollect:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    
    ghuntermyCollectionViewController *ghuntermyCollection = [[ghuntermyCollectionViewController alloc] init];
    [self.navigationController pushViewController:ghuntermyCollection animated:YES];
}

- (IBAction)muskill:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    ghunterMySkillViewController *skill = [[ghunterMySkillViewController alloc] init];
    skill.dic = self.user;
    [self.navigationController pushViewController:skill animated:YES];
}

- (IBAction)mygold:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    ghuntermyAccountViewController *ghuntermyAccount = [[ghuntermyAccountViewController alloc] init];

    [self.navigationController pushViewController:ghuntermyAccount animated:YES];
}


#pragma mark --- 我的关注
- (IBAction)showMyFollow:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    
    ghunterMyFollowViewController *follow = [[ghunterMyFollowViewController alloc] init];
    follow.type = 0;
    [self.navigationController pushViewController:follow animated:YES];
}


- (IBAction)showMyFried:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    
    ghunterMyFollowViewController *follow = [[ghunterMyFollowViewController alloc] init];
    follow.type = 1;
    [self.navigationController pushViewController:follow animated:YES];
}

- (IBAction)showEvaluations:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    
    ghunterAllEvaluationViewController* newView=[[ghunterAllEvaluationViewController alloc] init];
    newView.iconUrl = [self.user objectForKey:@"large_avatar"];
    [self.navigationController pushViewController:newView animated:YES];
}


// 显示当前等级
- (IBAction)showLevel:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    
    ghunterLevelViewController *level = [[ghunterLevelViewController alloc] init];
    level.userDic = self.user;
    [self.navigationController pushViewController:level animated:YES];
}

// 金币商城
- (IBAction)click2coinShop:(UIButton *)sender {
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

// 刷新我的页面
- (void)userinfo_modify {
    [self didGetMineDataIsloading:NO];
    [self didGetJoinAndReleaseTaskNum];
}

// 兑吧分享
-(void)onDuibaShareClick:(NSNotification *)notify{
    NSDictionary *dict = notify.userInfo;
    productShareUrl = [dict objectForKey:@"shareUrl"];//分享url
    productShareTitle = [NSString stringWithFormat:@"%@ ---来自赏金猎人", [dict objectForKey:@"shareTitle"]];//标题
    productShareImg = [dict objectForKey:@"shareThumbnail"];//缩略图
    productShareSubTitle = [dict objectForKey:@"shareSubtitle"];//副标题
    
    // TODO 需要实现分享对吧商品的功能
    if (shareAlertView != nil) {
        [shareAlertView show];
        return;
    }
    shareAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"shareView" owner:self options:nil];
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    [shareAlertView setCornerRadius:8.0];
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
    
    if ( [btn tag] == 1 ) {
        // wxcircle
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:productShareImg];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = productShareUrl;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:productShareTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
            }
        }];
        
    }else if([btn tag] == 2){
        // weixinfriend
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:productShareImg];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = productShareUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = APP_NAME;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:productShareTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
            }
        }];
    }else if([btn tag] == 3){
        // weibo
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:productShareImg];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"#赏金猎人#我在@赏金猎人imGondar 的金币商城发现商品：%@ 赶快戳这里兑换%@", productShareTitle, productShareUrl] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
            }
        }];
    }else if([btn tag] == 4){
        // copy
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:productShareUrl];
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

        [UMSocialData defaultData].extConfig.qzoneData.url = productShareUrl;
        [UMSocialData defaultData].extConfig.qzoneData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:productShareImg];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:productShareTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
            }
        }];
    }else if([btn tag] == 7){
        // qq
        if (![QQApiInterface isQQInstalled]) {
            [AFNetworkTool isInstallQQ];
            return;
        }

        [UMSocialData defaultData].extConfig.qqData.url = productShareUrl;
        [UMSocialData defaultData].extConfig.qqData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:productShareImg];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:productShareTitle  image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
            }
        }];
    }
}

#pragma mark - Custom Methods
- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}
-(void)naviGaView
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navView.backgroundColor = Nav_backgroud;
    [self.view addSubview:navView];
    
    UIButton *backButt =[[UIButton alloc]initWithFrame:CGRectMake(1, 21, 40, 40)];
    [backButt addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButt setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [navView addSubview:backButt];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
//    [self.navigationItem setBackBarButtonItem:backItem];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
//-(void)viewDidAppear:(BOOL)animated{
//    
//    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars =NO;
//    }
//    if([self respondsToSelector:@selector(setModalPresentationCapturesStatusBarAppearance:)]){
//        self.modalPresentationCapturesStatusBarAppearance =NO;
//    }
//    if([self respondsToSelector:@selector(navigationController)]){
//        if([self.navigationController.navigationBar respondsToSelector:@selector(setTranslucent:)]){
//            self.navigationController.navigationBar.translucent =NO;
//        }
//    }
//
//    
//    
//}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (IBAction)IdentityBtn:(id)sender {
    
    [self showIdentity];
}

// 我的优惠券
- (IBAction)MyDiscount:(id)sender {
    
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    ghunterMyCouponViewController * ghunterMyCoupon = [[ghunterMyCouponViewController alloc] init];
    
    [self.navigationController pushViewController:ghunterMyCoupon animated:YES];
}

- (IBAction)MyCooperate:(id)sender {
    
    NSString * url = @"http://apiadmin.imgondar.com/shops/default/joinus";
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    ghunterWebViewController *webView = [[ghunterWebViewController alloc] init];
    webView.webTitle = @"商家入驻";
    webView.urlPassed = url;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark --- 未登录点击设置
- (IBAction)clickSettingBtn:(id)sender {

    if (!imgondar_islogin) {
        
        [self click2Login];
        return;
    }
}

- (IBAction)iconImageBtn:(id)sender {
    
    if (!imgondar_islogin) {
        
        [self click2Login];
        return;
    }
}

- (void) tapGesture:(UIGestureRecognizer *) tap {
    
    if (!imgondar_islogin) {
        
        [self click2Login];
        return;
    }
}

- (IBAction)notLoginMyCoupon:(id)sender {
    if (!imgondar_islogin) {
        
        [self click2Login];
        return;
    }
}

- (IBAction)notLoginCooperate:(id)sender {
    NSString * url = @"http://apiadmin.imgondar.com/shops/default/joinus";
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    ghunterWebViewController *webView = [[ghunterWebViewController alloc] init];
    webView.webTitle = [NSMutableString stringWithString:@"商家入驻"];
    webView.urlPassed = [NSMutableString stringWithString:url];
    [self.navigationController pushViewController:webView animated:YES];
}

- (IBAction)jifenShop:(id)sender {
    
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
}

- (IBAction)userIconBtn:(id)sender {
    
    if (!imgondar_islogin) {
        
        [self click2Login];
        return;
    }
}

// 获取我的发布，我的参与数据
-(void)didGetJoinAndReleaseTaskNum{
    [AFNetworkTool httpRequestWithUrl:URL_GET_MYTASKNUM params:nil success:^(NSData *data) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ( [[json objectForKey:@"error"] integerValue] == 0 ) {
            NSInteger attend_num = [[[json objectForKey:@"attend_count"] objectForKey:@"count"] integerValue];
            NSString *attend_title = [[json objectForKey:@"attend_count"] objectForKey:@"title"];
            
            NSInteger release_num = [[[json objectForKey:@"publish_count"] objectForKey:@"count"] integerValue];
            NSString *release_title = [[json objectForKey:@"publish_count"] objectForKey:@"title"];
            
            if ( attend_num > 0 ) {
                [self.myJoinLabel setHidden:NO];
                self.myJoinLabel.text = [NSString stringWithFormat:@"%@x%zd", attend_title, attend_num];
            }else{
                [self.myJoinLabel setHidden:YES];
            }
            if ( release_num > 0 ) {
                [self.myReleaseLabel setHidden:NO];
                self.myReleaseLabel.text = [NSString stringWithFormat:@"%@x%zd", release_title, release_num];
            }else{
                [self.myReleaseLabel setHidden:YES];
            }
        }else{
            [self.myJoinLabel setHidden:YES];
            [self.myReleaseLabel setHidden:YES];
        }
    } fail:^{
        // [ProgressHUD show:HTTPREQUEST_ERROR];
    }];
}

@end