//
//  ghunterCheckEvaluationViewController.m
//  ghunter
//
//  Created by imgondar on 15/3/30.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import "ghunterCheckEvaluationViewController.h"
#import "AFNetworkTool.h"
#import "UMSocialQQHandler.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"


@interface ghunterCheckEvaluationViewController ()
- (IBAction)back:(UIButton *)sender;
- (IBAction)share:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *skillView;
@property (strong, nonatomic) IBOutlet UIView *toHunterView;
@property (strong, nonatomic) IBOutlet UIView *toOwnerView;
@property (strong, nonatomic) IBOutlet UIImageView *hunterIcon;
@property (strong, nonatomic) IBOutlet UILabel *skillName;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIView *toHunterView1;
@property (strong, nonatomic) IBOutlet UIView *toHunterView2;
@property (strong, nonatomic) IBOutlet UIView *toHunterView3;
@property (strong, nonatomic) IBOutlet UIView *toHunterView4;
@property (strong, nonatomic) IBOutlet UILabel *toHunterComment;
@property (strong, nonatomic) IBOutlet UIView *toOwnerView1;
@property (strong, nonatomic) IBOutlet UIView *toOwnerView2;
@property (strong, nonatomic) IBOutlet UIView *toOwnerView3;
@property (strong, nonatomic) IBOutlet UIImageView *toOwnerIcon;
@property (strong, nonatomic) IBOutlet UILabel *toOwnerComment;



@property (strong, nonatomic) IBOutlet UIView *bg;


@end

@implementation ghunterCheckEvaluationViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     _bg.backgroundColor = Nav_backgroud;
//    self.skillView.layer.cornerRadius = 8.0;
//    self.toHunterView.layer.cornerRadius = 8.0;
//    self.toOwnerView.layer.cornerRadius = 8.0;
    self.toHunterComment.layer.cornerRadius = 5.0;
    self.toHunterComment.clipsToBounds = YES;
    self.toOwnerComment.layer.cornerRadius = 5.0;
    self.toOwnerComment.clipsToBounds = YES;
    [self.hunterIcon setImage:[UIImage imageNamed:@"avatar"]];
    [self.hunterIcon setImage:[UIImage imageNamed:@"avatar"]];
    [ghunterRequester getwithDelegate:self withUrl:URL_GET_SKILL_DETAILCOMMENT withUserInfo:REQUEST_FOR_SKILL_DETAILCOMMENT withString:[NSString stringWithFormat:@"?api_session_id=%@&tid=%@",[ghunterRequester getUserInfo:API_SESSION_ID],self.tid]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ASIRequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_SKILL_DETAILCOMMENT]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            valDic = [dic objectForKey:@"valuation"];
            taskDic = [dic objectForKey:@"task"];
            TQStarRatingView *allStarView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [allStarView setuserInteractionEnabled:NO];
            [allStarView setScore:[[valDic objectForKey:@"owner_valuation"] floatValue]];
            [self.toHunterView1 addSubview:allStarView];
            
            TQStarRatingView *attiStarView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [attiStarView setuserInteractionEnabled:NO];
            [attiStarView setScore:[[valDic objectForKey:@"owner_attitude"] floatValue]];
            [self.toHunterView2 addSubview:attiStarView];
            
            TQStarRatingView *speedStarView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [speedStarView setuserInteractionEnabled:NO];
            [speedStarView setScore:[[valDic objectForKey:@"owner_speed"] floatValue]];
            [self.toHunterView3 addSubview:speedStarView];
            
            TQStarRatingView *quaStarView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [quaStarView setuserInteractionEnabled:NO];
            [quaStarView setScore:[[valDic objectForKey:@"owner_quality"] floatValue]];
            [self.toHunterView4 addSubview:quaStarView];
            
            self.toHunterComment.text = [valDic objectForKey:@"owner_description"];
            
            TQStarRatingView *hunterVal = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [hunterVal setuserInteractionEnabled:NO];
            [hunterVal setScore:[[valDic objectForKey:@"hunter_valuation"] floatValue]];
            [self.toOwnerView1 addSubview:hunterVal];
            
            TQStarRatingView *honStarView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [honStarView setuserInteractionEnabled:NO];
            [honStarView setScore:[[valDic objectForKey:@"hunter_honesty"] floatValue]];
            [self.toOwnerView2 addSubview:honStarView];
            
            TQStarRatingView *friStarView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [friStarView setuserInteractionEnabled:NO];
            [friStarView setScore:[[valDic objectForKey:@"hunter_friendly"] floatValue]];
            [self.toOwnerView3 addSubview:friStarView];
            
            self.toOwnerComment.text = [valDic objectForKey:@"hunter_description"];
            
            // 圆角头像
            self.hunterIcon.clipsToBounds = YES;
            self.hunterIcon.layer.cornerRadius = Radius;
            
            [self.hunterIcon sd_setImageWithURL:[valDic objectForKey:@"owner_middle_avatar"]];
            
            self.toOwnerIcon.clipsToBounds = YES;
            self.toOwnerIcon.layer.cornerRadius = Radius;
            
            [self.toOwnerIcon sd_setImageWithURL:[valDic objectForKey:@"hunter_middle_avatar"]];
            self.skillName.text = [taskDic objectForKey:@"title"];
            self.priceLabel.text = [NSString stringWithFormat:@"%@.0元",[taskDic objectForKey:@"bounty"]];
        }
        else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }
        else{
            [ghunterRequester noMsg];
        }
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络异常" waitUntilDone:false];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)share:(UIButton *)sender {
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
    NSString *shareUrl = [NSString stringWithFormat:@"http://apiadmin.imgondar.com/mobile/task/view?tid=%@&code=%zd", self.tid, code];
    NSString *imgUrl = [[valDic objectForKey:@"owner_middle_avatar"] stringValue];
    
    if ( [btn tag] == 1 ) {
        // wxcircle
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"我在「赏金猎人」上完成了任务「%@」，赚取赏金￥%@",[taskDic objectForKey:@"title"],[NSString stringWithFormat:@"%@.0元",[taskDic objectForKey:@"bounty"]]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.tid :SHARETYPE_VALUATION :self.tid :SHAREPLATFORM_WXMOMENTS];
            }
        }];
    }else if([btn tag] == 2){
        // weixinfriends
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"赏金猎人";
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"悬赏￥%@，我需要「%@」",[taskDic objectForKey:@"bounty"],[taskDic objectForKey:@"title"]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.tid :SHARETYPE_VALUATION :self.tid :SHAREPLATFORM_WECHAT];
            }
        }];
    }else if([btn tag] == 3){
        // weibo
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:@"http://imgondar.com/images/shareimg.png"];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"#赏金猎人# 我刚刚在@赏金猎人imGondar 完成任务「%@」赚取赏金￥%@，快来围观吧！→_→ http://mob.imGondar.com/task/view?tid=%@",[taskDic objectForKey:@"title"],[NSString stringWithFormat:@"%@.0元",[taskDic objectForKey:@"bounty"]],self.tid] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.tid :SHARETYPE_VALUATION :self.tid :SHAREPLATFORM_SINAWEIBO];
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
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:[NSString stringWithFormat:@"我在「赏金猎人」上赚取赏金￥%@，完成了任务「%@」，小伙伴们快来下载使用吧~",[NSString stringWithFormat:@"%@.0元",[taskDic objectForKey:@"bounty"]],[taskDic objectForKey:@"title"]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.tid :SHARETYPE_VALUATION :self.tid:SHAREPLATFORM_QZONE];
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
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"悬赏￥%@，我需要「%@」",[taskDic objectForKey:@"bounty"],[taskDic objectForKey:@"title"]]  image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.tid :SHARETYPE_VALUATION :self.tid:SHAREPLATFORM_QQ];
            }
        }];
    }
}

- (void)sharecancel:(id)sender {
    [shareAlertView dismissAnimated:YES];
}
@end