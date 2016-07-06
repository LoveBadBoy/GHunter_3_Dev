//
//  ghunterLevelViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-26.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//猎人等级

#import "ghunterLevelViewController.h"

@interface ghunterLevelViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *levelupView;
@property (weak, nonatomic) IBOutlet UIView *ownerBG;
@property (weak, nonatomic) IBOutlet UIView *numBG;
@property (weak, nonatomic) IBOutlet UIView *levelupBG;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UIImageView *identity;
@property (weak, nonatomic) IBOutlet UILabel *identityText;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet THProgressView *activitinessProgress;
@property (weak, nonatomic) IBOutlet THProgressView *abilityProgress;
@property (weak, nonatomic) IBOutlet THProgressView *growthProgress;
@property (weak, nonatomic) IBOutlet UILabel *activitinessNum;
@property (weak, nonatomic) IBOutlet UILabel *abilityNum;
@property (weak, nonatomic) IBOutlet UILabel *growthNum;
@property (weak, nonatomic) IBOutlet UILabel *largeLevel;
@property (weak, nonatomic) IBOutlet UILabel *leftGrowth;
@property (nonatomic,retain) NSDictionary *levelInfo;

@property (strong, nonatomic) IBOutlet UIView *bg;

// 体力值
@property (weak, nonatomic) IBOutlet UILabel *leftVit;

@end

@implementation ghunterLevelViewController

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
    self.ownerBG.clipsToBounds = YES;
    self.ownerBG.layer.cornerRadius = Radius;
    self.levelupBG.clipsToBounds = YES;
    self.levelupBG.layer.cornerRadius = Radius;
    self.numBG.clipsToBounds = YES;
    self.numBG.layer.cornerRadius = Radius;
    self.icon.clipsToBounds = YES;
    self.icon.layer.cornerRadius = Radius;
    CGRect levelupViewFrame = self.levelupView.frame;
    levelupViewFrame.size.width = self.view.frame.size.width;
    self.levelupView.frame = levelupViewFrame;
    CGRect frame = self.scrollView.frame;
    frame.size.height = mainScreenheight - 44 -20;
    self.scrollView.frame = frame;
    self.scrollView.contentSize = self.levelupView.frame.size;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:self.levelupView];
    self.levelInfo = [[NSDictionary alloc] init];
    
    if (!self.userDic) {
        return;
    }
    [self.icon sd_setImageWithURL:[self.userDic objectForKey:TINY_AVATAR] placeholderImage:[UIImage imageNamed:@"avatar"]];
    [self.username setText:[self.userDic objectForKey:@"username"]];
    if ([[self.userDic objectForKey:@"sex"] isEqualToString:@"0"]) {
        [self.gender setImage:[UIImage imageNamed:@"female_hunter_icon"]];
    }else if ([[self.userDic objectForKey:@"sex"] isEqualToString:@"1"]){
        [self.gender setImage:[UIImage imageNamed:@"male_hunter_icon"]];
    }
    NSString *ageStr = [NSString stringWithFormat:@"%@岁",[self.userDic objectForKey:@"age"]];
    CGSize ageSize = [ageStr sizeWithFont:self.age.font];
//    [self.age setText:ageStr];
    // 岁数的字体颜色
//    [self.age setTextColor:[UIColor colorWithRed:89/255 green:87/255 blue:87/255 alpha:1.0]];
    CGSize usernameSize = [[self.userDic objectForKey:USERNAME] sizeWithFont:self.username.font];
    if (self.username.frame.origin.x + usernameSize.width + 3 + self.gender.frame.size.width + 3 + ageSize.width + 3 > self.identity.frame.origin.x) {
        usernameSize.width = self.identity.frame.origin.x - 3 - ageSize.width - 3 - self.gender.frame.size.width - 3 - self.username.frame.origin.x;
    }
    CGRect nameFrame = self.username.frame;
    nameFrame.size.width = usernameSize.width;
    self.username.frame = nameFrame;
    CGRect genderFrame = self.gender.frame;
    genderFrame.origin.x = self.username.frame.origin.x + self.username.frame.size.width + 3;
    self.gender.frame = genderFrame;
    CGRect ageFrame = self.age.frame;
    ageFrame.origin.x = self.gender.frame.origin.x + self.gender.frame.size.width + 3;
    self.age.frame = ageFrame;
    if([[self.userDic objectForKey:@"is_identity"] isEqualToString:@"0"]) {
        [self.identity setImage:[UIImage imageNamed:@"not_identity"]];
        [self.identityText setText:@"未认证"];
    } else if ([[self.userDic objectForKey:@"is_identity"] isEqualToString:@"1"]) {
        [self.identity setImage:[UIImage imageNamed:@"is_identity"]];
        [self.identityText setText:@"已认证"];
    }
    self.identity.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toIdentity)];
    [self.identity addGestureRecognizer:tap];
    
    [ghunterRequester postwithDelegate:self withUrl:[NSString stringWithFormat:@"%@?uid=%@",URL_GET_HUNTER_LEVEL,[ghunterRequester getUserInfo:UID]] withUserInfo:REQUEST_FOR_HUNTER_LEVEL withDictionary:nil];
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
    [MobClick event:UMEVENT_MY_LEVEL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASIHttpRequest

-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_HUNTER_LEVEL]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            self.levelInfo = [dic objectForKey:@"levelinfo"];
            NSUInteger activitiness = [[self.levelInfo objectForKey:@"activeness"] integerValue];
            NSUInteger ability = [[self.levelInfo objectForKey:@"ability"] integerValue];
            NSUInteger growth = [[self.levelInfo objectForKey:@"growth"] integerValue];
            [self.activitinessNum setText:[NSString stringWithFormat:@"%zd",activitiness]];
            [self.abilityNum setText:[NSString stringWithFormat:@"%zd",ability]];
            [self.growthNum setText:[NSString stringWithFormat:@"%zd",growth]];
            
            NSUInteger totalActivitiness = [[self.levelInfo objectForKey:@"activeness_max"] integerValue]; //(activitiness/500 + 1) * 500;
            NSUInteger totalAbility =  [[self.levelInfo objectForKey:@"ability_max"] integerValue]; // (ability/500 + 1) * 500;
            NSUInteger totalGrowth = [[self.levelInfo objectForKey:@"growth_max"] integerValue]; //(growth/500 + 1) * 500;
            
            self.activitinessProgress.borderTintColor = [UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0];
            self.activitinessProgress.progressTintColor = [UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0];
            [self.activitinessProgress setProgress:activitiness/(CGFloat)totalActivitiness animated:YES];
            
            self.abilityProgress.borderTintColor = [UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0];
            self.abilityProgress.progressTintColor = [UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0];
            [self.abilityProgress setProgress:ability/(CGFloat)totalAbility animated:YES];
            
            self.growthProgress.borderTintColor = [UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0];
            self.growthProgress.progressTintColor = [UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0];
            [self.growthProgress setProgress:growth/(CGFloat)totalGrowth animated:YES];
            
            [self.level setText:[NSString stringWithFormat:@"lv%zd",[[self.levelInfo objectForKey:@"level"] integerValue]]];
            [self.largeLevel setText:[NSString stringWithFormat:@"lv%zd",[[self.levelInfo objectForKey:@"level"] integerValue]]];
            // 今日剩余体力值
            [self.leftVit setText:[NSString stringWithFormat:@"今日剩余%zd体力值",[[self.levelInfo objectForKey:@"vit_left"] integerValue]]];
            // 成长值
            [self.leftGrowth setText:[NSString stringWithFormat:@"距下一猎人等级还需%zd成长值",[[self.levelInfo objectForKey:@"growth_next"] integerValue]]];
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toIdentity {
    ghunterWebViewController *web = [[ghunterWebViewController alloc] init];
    web.urlPassed = IDENTITY;
    web.webTitle = @"实名认证";
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)seeMoreLevelSystem:(id)sender {
    ghunterWebViewController *web = [[ghunterWebViewController alloc] init];
    web.webTitle = @"升级规则";
    web.urlPassed = LEVELUPRULES;
    [self.navigationController pushViewController:web animated:YES];
}
@end
