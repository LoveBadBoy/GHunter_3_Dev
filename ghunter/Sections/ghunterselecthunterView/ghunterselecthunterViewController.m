//
//  ghunterselecthunterViewController.m
//  ghunter
//
//  Created by wangmx on 14-5-17.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//选择猎人

#import "ghunterselecthunterViewController.h"

@interface ghunterselecthunterViewController ()

@property (strong, nonatomic) IBOutlet UIView *bg;
@end

@implementation ghunterselecthunterViewController

#pragma mark - UIViewController

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
    page = 1;
    // Do any additional setup after loading the view from its nib.
    selecthunterArray = [[NSMutableArray alloc] init];
    selecthunterTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 20 - 44) style:UITableViewStylePlain];
    selecthunterTable.delegate = self;
    selecthunterTable.dataSource = self;
    selecthunterTable.pullDelegate = self;
    selecthunterTable.showsVerticalScrollIndicator = NO;
    selecthunterTable.backgroundColor = [UIColor clearColor];
    selecthunterTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:selecthunterTable];
    
    [self didGetjoinersIsloading:YES andWithPgae:page];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 获取竞标猎人列表
-(void)didGetjoinersIsloading:(BOOL )isloading andWithPgae:(NSInteger) p{
    if (isloading) {
        [self startLoad];
    }
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.tid forKey:@"tid"];
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)p] forKey:@"page"];
    
    [AFNetworkTool httpRequestWithUrl:URL_GET_JOINEDHUNTERS params:dict success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {
//            selecthunterArray = [result objectForKey:@"joiners"];
//            [selecthunterTable reloadData];
            
            
            if (p == 1) {
                [selecthunterArray removeAllObjects];
                page = 2;
                NSArray *array = [result valueForKey:@"joiners"];
                
                [selecthunterArray addObjectsFromArray:array];
                [selecthunterTable reloadData];
                selecthunterTable.pullTableIsRefreshing = NO;
            }else{
                page++;
                NSArray *array = [result valueForKey:@"joiners"];
                [selecthunterArray addObjectsFromArray:array];
                [selecthunterTable reloadData];
                selecthunterTable.pullTableIsLoadingMore = NO;
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

    /*
    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?tid=%@", URL_GET_JOINEDHUNTERS, self.tid] params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            selecthunterArray = [result objectForKey:@"joiners"];
            [selecthunterTable reloadData];
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
     */
    
}

// 选择猎人
-(void)didSelectHunterIsloading:(BOOL )isloading withParameters:(NSMutableDictionary *)parameters{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:URL_SELECT_HUNTER params:parameters success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [ProgressHUD show:[result objectForKey:@"msg"]];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            NSNotification *notification = [[NSNotification alloc] initWithName:GHUNTERSELECTHUNTER object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *hunter = [selecthunterArray objectAtIndex:indexPath.row];
    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
    userCenter.uid = [hunter objectForKey:@"uid"];
    [self.navigationController pushViewController:userCenter animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [selecthunterArray count];
}

#pragma mark - UITableviewDatasource
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
    NSDictionary *joiner = [selecthunterArray objectAtIndex:indexPath.row];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"selecthunterCell" owner:self options:nil];
    cell = [nibs objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
//    UIImageView *icon = (UIImageView *)[cell viewWithTag:1];
//    UILabel *name = (UILabel *)[cell viewWithTag:2];
//    UIImageView *gender = (UIImageView *)[cell viewWithTag:3];
//    UILabel *age = (UILabel *)[cell viewWithTag:4];
    UIButton *select = (UIButton *)[cell viewWithTag:6];
//    UIImageView *identity = (UIImageView *)[cell viewWithTag:7];
//    UIImageView *levelImg = (UIImageView *)[cell viewWithTag:8];
//    UIView *bg = (UIView *)[cell viewWithTag:9];
//    UIView *line = (UIView *)[cell viewWithTag:10];
   
    // 头像
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [cell.contentView addSubview:icon];
    [icon sd_setImageWithURL:[joiner objectForKey:@"middle_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
    icon.clipsToBounds = YES;
    icon.layer.cornerRadius = icon.frame.size.width / 2;
    CGPoint cy = icon.center;
    cy.y = cell.frame.size.height / 2;
    icon.center = CGPointMake(icon.center.x, cy.y);
    
    // 名字
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.size.width + icon.frame.origin.x + 10, icon.frame.origin.y, 100, 20)];
    [cell.contentView addSubview:name];
    name.font = [UIFont systemFontOfSize:13];
    name.textAlignment = NSTextAlignmentLeft;
    name.textColor = RGBCOLOR(51, 51, 51);
    [name setText:[joiner objectForKey:@"username"]];
    
    CGSize nameSize = [[joiner objectForKey:@"username"] sizeWithFont:name.font];
    CGRect nameFrame = name.frame;
    nameFrame.size.width = nameSize.width;
    name.frame = nameFrame;
    
    // 性别
    UIImageView * gender = [[UIImageView alloc] initWithFrame:CGRectMake(name.frame.size.width + name.frame.origin.x + 5, name.frame.origin.y + 5, 8, 8)];
    [cell.contentView addSubview:gender];
    if([[joiner objectForKey:@"sex"] isEqualToString:@"0"]){
        [gender setImage:[UIImage imageNamed:@"female"]];
    }else{
        [gender setImage:[UIImage imageNamed:@"male"]];
    }

    select.tag = indexPath.row;
    [select addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
   
    // 等级
    UIImageView * levelImg = [[UIImageView alloc] initWithFrame:CGRectMake(icon.frame.size.width + icon.frame.origin.x + 10, name.frame.origin.y + name.frame.size.height + 5, 14, 14)];
    [cell.contentView addSubview:levelImg];
    NSInteger i = [NSString stringWithFormat:@"%@",[joiner objectForKey:@"level"]].intValue;
    levelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级%ld", (long)i]];
    
    // 认证
    UIImageView * identity = [[UIImageView alloc] initWithFrame:CGRectMake(levelImg.frame.origin.x + levelImg.frame.size.width + 5, levelImg.frame.origin.y, 14, 14)];
    [cell.contentView addSubview:identity];
    if ([[joiner objectForKey:@"is_identity"] isEqualToString:@"1"]){
        identity.image = [UIImage imageNamed:@"实名认证"];
        // 星级
        TQStarRatingView *star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(identity.frame.origin.x + identity.frame.size.width + 5, levelImg.frame.origin.y + (levelImg.frame.size.height - 10) / 2.0, 50, 10) numberOfStar:5];
        [star setScore:[[joiner objectForKey:@"kopubility"] floatValue]];
        [star setuserInteractionEnabled:YES];
        [cell.contentView addSubview:star];
    }else{
        identity.hidden = YES;
        // 星级
        TQStarRatingView *star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(levelImg.frame.origin.x + levelImg.frame.size.width + 5, levelImg.frame.origin.y + (levelImg.frame.size.height - 10) / 2.0, 50, 10) numberOfStar:5];
        [star setScore:[[joiner objectForKey:@"kopubility"] floatValue]];
        [star setuserInteractionEnabled:YES];
        [cell.contentView addSubview:star];
    }
    
//    bg.layer.cornerRadius = Radius;
    
//    CGSize usernameSize = [[joiner objectForKey:USERNAME] sizeWithFont:name.font];
//    if (name.frame.origin.x + usernameSize.width + 3 + gender.frame.size.width + 3 + age.frame.size.width > line.frame.origin.x) {
//        usernameSize.width = select.frame.origin.x - 3 - age.frame.size.width - 3 - gender.frame.size.width - 3 - name.frame.origin.x;
//    }
    
    /*
    NSArray *skills = [joiner objectForKey:@"skills"];
    toshowTagList *tagList = [[toshowTagList alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width, 50.0, line.frame.origin.x - icon.frame.origin.x - icon.frame.size.width, 0)];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < [skills count]; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[skills objectAtIndex:i] forKey:@"title"];
        [dic setObject:[UIColor blackColor] forKey:@"titleColor"];
        [dic setObject:[UIColor whiteColor] forKey:@"backgroundColor"];
        [dic setObject:RGBA(89, 87, 87, 1.0) forKey:@"borderColor"];
        [dic setObject:@"1.0" forKey:@"borderWidth"];
        [array addObject:dic];
    }
    [tagList addTags:array];
    CGRect tagListFrame = [tagList frame];
    tagListFrame.size.height += tagList.heightFinal;
    tagList.frame = tagListFrame;
    CGRect bgFrame = bg.frame;
    bgFrame.size.height += (tagList.heightFinal - 10);
    bg.frame = bgFrame;
    [bg addSubview:tagList];
    */
    
    // 能力值
    UILabel * abilityLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 10, levelImg.frame.size.height + levelImg.frame.origin.y + 5, 100, 20)];
    [cell.contentView addSubview:abilityLabel];
    abilityLabel.text = [NSString stringWithFormat:@"活跃值：%@  能力值：%@", [joiner objectForKey:@"activeness"], [joiner objectForKey:@"ability"]];
    abilityLabel.textAlignment = NSTextAlignmentLeft;
    abilityLabel.font = [UIFont systemFontOfSize:12];
    abilityLabel.textColor = RGBCOLOR(51, 51, 51);
    
    CGSize size = [abilityLabel.text sizeWithFont:abilityLabel.font];
    CGRect abFrame = abilityLabel.frame;
    abFrame.size.width = size.width;
    abilityLabel.frame = abFrame;
    
    
    cell.backgroundColor = RGBCOLOR(235, 235, 235);
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = abilityLabel.frame.size.height + abilityLabel.frame.origin.y + 10;
    cell.frame = cellFrame;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height + cell.frame.origin.y, mainScreenheight, 1)];
    view.backgroundColor = RGBCOLOR(235, 235, 235);
    [cell.contentView addSubview:view];
    
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

#pragma mark --- refreshAndLoad
- (void)refreshTable {
    
    page = 1;
    [self didGetjoinersIsloading:YES andWithPgae:page];
}

- (void)loadMoreDataToTable {
    
    [self didGetjoinersIsloading:NO andWithPgae:page];
}


#pragma mark - Custom Methods

- (void)startLoad{
    loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [loadingView startAnimition];
}

- (void)endLoad{
    [loadingView inValidate];
}

- (void)dealloc {
    self.loadingView = nil;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)select:(UIButton *)sender{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选取猎人后,系统将通过短信和推送即时告知双方的联系方式,确定选择猎人?"] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    action.tag = sender.tag;
    [action showInView:self.view];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self startLoad];
        NSDictionary *joiner = [selecthunterArray objectAtIndex:actionSheet.tag];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.tid forKey:@"tid"];
        [dic setObject:[joiner objectForKey:@"uid"] forKey:@"uid"];
        
        [self didSelectHunterIsloading:YES withParameters:dic];
        
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }else if(buttonIndex == 1){
        [actionSheet dismissWithClickedButtonIndex:1 animated:YES];
    }
}
@end
