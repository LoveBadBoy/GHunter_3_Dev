//
//  ghunterAllEvaluationViewController.m
//  ghunter
//
//  Created by imgondar on 15/3/10.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import "ghunterAllEvaluationViewController.h"

@interface ghunterAllEvaluationViewController ()
- (IBAction)back:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UIView *allEva;
@property (strong, nonatomic) IBOutlet UILabel *allLabel;
@property (strong, nonatomic) IBOutlet UIView *gondarEva;
@property (strong, nonatomic) IBOutlet UILabel *allGondarEva;
@property (strong, nonatomic) IBOutlet UILabel *gondarLabel1;
@property (strong, nonatomic) IBOutlet UILabel *gondarLabel2;
@property (strong, nonatomic) IBOutlet UILabel *gondarLabel3;
- (IBAction)gondarBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *hunterEva;
@property (strong, nonatomic) IBOutlet UILabel *allHunterEva;
@property (strong, nonatomic) IBOutlet UILabel *hunterLabel1;
@property (strong, nonatomic) IBOutlet UILabel *hunterLabel2;
@property (strong, nonatomic) IBOutlet UILabel *hunterLabel3;
@property (strong, nonatomic) IBOutlet UILabel *hunterLabel4;
- (IBAction)hunterBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *allStar;
@property (strong, nonatomic) IBOutlet UIView *gondarStar1;
@property (strong, nonatomic) IBOutlet UIView *gondarStar2;
@property (strong, nonatomic) IBOutlet UIView *gondarStar3;
@property (strong, nonatomic) IBOutlet UIView *hunterStar1;
@property (strong, nonatomic) IBOutlet UIView *hunterStar2;
@property (strong, nonatomic) IBOutlet UIView *hunterStar3;
@property (strong, nonatomic) IBOutlet UIView *hunterStar4;
@property (strong, nonatomic) IBOutlet UIView *bg;

@end

@implementation ghunterAllEvaluationViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.allEva.layer.cornerRadius=8.0;
//    self.gondarEva.layer.cornerRadius=8.0;
//    self.hunterEva.layer.cornerRadius=8.0;
     _bg.backgroundColor = Nav_backgroud;
    [ghunterRequester getwithDelegate:self withUrl:URL_GET_USER_EVALUATIONS withUserInfo:REQUEST_FOR_GET_USER_EVALUATIONS withString:[NSString stringWithFormat:@"?api_session_id=%@&uid=%@&frompage=uservaluation",[ghunterRequester getUserInfo:API_SESSION_ID],[ghunterRequester getUserInfo:UID]]];
    [self.iconImg sd_setImageWithURL:self.iconUrl placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [MobClick event:UMEVENT_MY_VALUATION];
}

#pragma mark--ASIRequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_GET_USER_EVALUATIONS]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            NSDictionary* hunterDic=[dic objectForKey:@"hunter_valuation"];
            NSDictionary* ownerDic=[dic objectForKey:@"owner_valuation"];
            NSString* allStr=[dic objectForKey:@"valuation"];
            self.allLabel.text = [NSString stringWithFormat:@"累计发布%@，累计完成%@",[dic objectForKey:@"tasknum"],[dic objectForKey:@"donenum"]];
            TQStarRatingView *allStarView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [allStarView setuserInteractionEnabled:NO];
            [allStarView setScore:[allStr floatValue]];
            [self.allStar addSubview:allStarView];
            
            TQStarRatingView *gondar1= [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [gondar1 setuserInteractionEnabled:NO];
            [gondar1 setScore:[[ownerDic objectForKey:@"valuation"] floatValue]];
            [self.gondarStar1 addSubview:gondar1];
            self.gondarLabel1.text=[ownerDic objectForKey:@"valuation"];
            TQStarRatingView *gondar2 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [gondar2 setuserInteractionEnabled:NO];
            [gondar2 setScore:[[ownerDic objectForKey:@"honesty"] floatValue]];
            [self.gondarStar2 addSubview:gondar2];
            self.gondarLabel2.text=[ownerDic objectForKey:@"honesty"];
            TQStarRatingView *gondar3 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [gondar3 setuserInteractionEnabled:NO];
            [gondar3 setScore:[[ownerDic objectForKey:@"friendly"] floatValue]];
            [self.gondarStar3 addSubview:gondar3];
            self.gondarLabel3.text=[ownerDic objectForKey:@"friendly"];
            NSString *allgondarStr = [NSString stringWithFormat:@"近期动态：本月发布%@个任务，好评率%@", [ownerDic objectForKey:@"curmonth_create_tasknum"], [ownerDic objectForKey:@"curmonth_valuation"]];
            self.allGondarEva.text=allgondarStr;
            
            TQStarRatingView *hunter1 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [hunter1 setuserInteractionEnabled:NO];
            [hunter1 setScore:[[hunterDic objectForKey:@"valuation"] floatValue]];
            [self.hunterStar1 addSubview:hunter1];
            self.hunterLabel1.text=[hunterDic objectForKey:@"valuation"];
            TQStarRatingView *hunter2 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [hunter2 setuserInteractionEnabled:NO];
            [hunter2 setScore:[[hunterDic objectForKey:@"attitude"] floatValue]];
            [self.hunterStar2 addSubview:hunter2];
            self.hunterLabel2.text=[hunterDic objectForKey:@"attitude"];
            TQStarRatingView *hunter3 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [hunter3 setuserInteractionEnabled:NO];
            [hunter3 setScore:[[hunterDic objectForKey:@"speed"] floatValue]];
            [self.hunterStar3 addSubview:hunter3];
            self.hunterLabel3.text=[hunterDic objectForKey:@"speed"];
            TQStarRatingView *hunter4 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0, 50,10) numberOfStar:5];
            [hunter4 setuserInteractionEnabled:NO];
            [hunter4 setScore:[[hunterDic objectForKey:@"quality"] floatValue]];
            [self.hunterStar4 addSubview:hunter4];
            self.hunterLabel4.text=[hunterDic objectForKey:@"quality"];
            NSString* allhunterStr = [NSString stringWithFormat:@"近期动态：本月完成%@个任务，好评率%@", [hunterDic objectForKey:@"curmonth_trade_tasknum"], [hunterDic objectForKey:@"curmonth_valuation"]];
            self.allHunterEva.text = allhunterStr;
            
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络异常" waitUntilDone:false];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)gondarBtn:(UIButton *)sender {
    ghunterUserEvaluationViewController* userEva=[[ghunterUserEvaluationViewController alloc] init];
    NSString* typeStr=[NSString stringWithFormat:@"%zd",1];
    userEva.type=typeStr;
    [self.navigationController pushViewController:userEva animated:YES];
}
- (IBAction)hunterBtn:(UIButton *)sender {
    ghunterUserEvaluationViewController* userEva=[[ghunterUserEvaluationViewController alloc] init];
    NSString* typeStr=[NSString stringWithFormat:@"%zd",0];
    userEva.type=typeStr;
    [self.navigationController pushViewController:userEva animated:YES];
}
@end
