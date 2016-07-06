//
//  ghunterModifySkillViewController.m
//  ghunter
//
//  Created by chensonglu on 14-10-2.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//技能标签

#import "ghunterModifySkillViewController.h"

@interface ghunterModifySkillViewController ()
@property (strong, nonatomic) IBOutlet UIView *bg;
@property (strong, nonatomic) IBOutlet UIImageView *tagBG;
@property (strong, nonatomic) IBOutlet UIImageView *skillBG;
@property (strong, nonatomic) IBOutlet UILabel *parentLabel;
@end

@implementation ghunterModifySkillViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _bg.backgroundColor = Nav_backgroud;
    // Do any additional setup after loading the view from its nib.
    self.randomTag = [[NSMutableArray alloc] initWithCapacity:10];
    self.tagList = [[AOTagList alloc] initWithFrame:CGRectMake(10, 80, mainScreenWidth-20, 80)];
    self.tagList.backgroundColor = [UIColor clearColor];
    [self.tagList setDelegate:self];
    [self.view addSubview:self.tagList];
    
    CGFloat top = 20; // 顶端盖高度
    CGFloat bottom = _tagBG.frame.size.height - top - 1; // 底端盖高度
    CGFloat left = 20; // 左端盖宽度
    CGFloat right = _tagBG.frame.size.width - left - 1; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage *image = [UIImage imageNamed:@"white.png"];
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    _tagBG.backgroundColor =[UIColor whiteColor];
    _skillBG.backgroundColor = [UIColor whiteColor];
    [_tagBG setImage:image];
    [_skillBG setImage:image];
    
    NSString *skilltag_time = [ghunterRequester getCacheTimeWithKey:SKILL_TAG_TIME];
    if(!skilltag_time){
        [ghunterRequester getSkillTagWithDelegate:self];
    }else{
        if([ghunterRequester gettimeInterval:skilltag_time] > ONE_DAY){
            [ghunterRequester getSkillTagWithDelegate:self];
        }else{
            [self showSkillTag];
        }
    }
    [self showUserSkills];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)showSkillTag{
    skillsArray = (NSArray *)[ghunterRequester getCacheContentWithKey:SKILL_TAG];
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(10 , self.skillBG.frame.origin.y + 10 + self.parentLabel.frame.size.height + 20, mainScreenWidth - 20, self.skillBG.frame.size.height - 10 - self.parentLabel.frame.size.height - 20)];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake((mainScreenWidth - 20) * [skillsArray count], self.skillBG.frame.size.height - 10 - self.parentLabel.frame.size.height - 20);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    for (NSUInteger i = 0; i < [skillsArray count]; i++) {
        SkillTag *skillTag = [[SkillTag alloc] initWithFrame:CGRectMake((mainScreenWidth - 20) * i, 0, mainScreenWidth - 20, self.skillBG.frame.size.height - 10)];
        skillTag.backgroundColor = [UIColor clearColor];
        [skillTag setDelegate:self];
        [scrollView addSubview:skillTag];
        NSDictionary *skill = [skillsArray objectAtIndex:i];
        NSArray *child = [skill objectForKey:@"child"];
        [skillTag addTags:child];
    }
    [self.view addSubview:scrollView];
    CGFloat pageControlWidth = [skillsArray count]*10.0f+40.f;
    CGFloat pagecontrolHeight = 20.0f;
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.view.frame.size.width-pageControlWidth)/2.0,scrollView.frame.origin.y - 20, pageControlWidth, pagecontrolHeight)];
    pageControl.currentPageIndicatorTintColor = RGBA(137.0, 137.0, 137.0, 1.0);
    pageControl.pageIndicatorTintColor = RGBA(228.0, 227.0, 220.0, 1.0);
    pageControl.currentPage=0;
    pageControl.numberOfPages=[skillsArray count];
    [self.view addSubview:pageControl];
}

- (IBAction)finish:(id)sender {
    if([self.tagList.tags count] == 1){
        [ghunterRequester showTip:@"至少添加一个技能标签"];
        return;
    }
    if([self.tagList.tags count] > 11){
        [ghunterRequester showTip:@"最多添加10个技能标签"];
        return;
    }
    NSMutableArray *skillArray = [[NSMutableArray alloc] init];
    for (id tag in self.tagList.tags) {
        if([tag isKindOfClass:[AOTag class]]){
            [skillArray addObject:[tag tTitle]];
        }
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:skillArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:jsonString forKey:@"skills"];
    
    [ghunterRequester postwithDelegate:self withUrl:URL_ADD_SKILLS withUserInfo:REQUEST_FOR_ADD_SKILLS withDictionary:dic];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showUserSkills{
    for (NSString *string in self.tags) {
        [self.tagList addTag:string];
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
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_GET_SKILL_TAG]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester setCacheTime:[ghunterRequester getTimeNow] withKey:SKILL_TAG_TIME];
            [ghunterRequester setCacheContent:[dic objectForKey:@"skills"] withKey:SKILL_TAG];
            [self showSkillTag];
        }else if ([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_ADD_SKILLS]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            NSNotification *notification = [[NSNotification alloc] initWithName:@"user_skills" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([dic objectForKey:@"msg"]){
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

#pragma mark - Tag delegate

- (void)tagDidAddTag:(AOTag *)tag
{
    }

- (void)tagDidRemoveTag:(AOTag *)tag
{
    
}

- (void)tagDidSelectTag:(AOTag *)tag
{
    
}

- (void)tagDidEdited:(AOEditTag *)editTag{

}

- (void)skilltagDidSelectTag:(SkillName *)tag{
    UILabel *skillLabel = [[tag subviews] objectAtIndex:0];
    [self.tagList addTag:skillLabel.text];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    pageControl.currentPage=page;
    NSDictionary *skill = [skillsArray objectAtIndex:page];
    NSDictionary *parent = [skill objectForKey:@"parent"];
    [self.parentLabel setText:[parent objectForKey:@"title"]];
}

#pragma mark - UItextfiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
