//
//  ghunterMySkillViewController.m
//  ghunter
//
//  Created by chensonglu on 14-9-16.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//我的技能

#import "ghunterMySkillViewController.h"
#import "ghunterSkillViewController.h"

@interface ghunterMySkillViewController ()
@property(nonatomic, retain)NSMutableArray *skills;
@property(nonatomic, retain)NSMutableArray *skillShow;

@property (strong, nonatomic) IBOutlet UIView *bg;


@end

@implementation ghunterMySkillViewController

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
    // Do any additional setup after loading the view from its nib.
     _bg.backgroundColor = Nav_backgroud;
    page = 1;
    self.skills = [[NSMutableArray alloc] init];
    self.skillShow = [[NSMutableArray alloc] init];
    mutablearr = [[NSMutableArray alloc] init];
    
    myskillTable = [[PullTableView alloc]initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64)];
    myskillTable.delegate = self;
    myskillTable.dataSource = self;
    myskillTable.pullDelegate = self;
    myskillTable.backgroundColor = RGBCOLOR(235, 235, 235);
    myskillTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myskillTable.showsHorizontalScrollIndicator = NO;
    myskillTable.showsVerticalScrollIndicator = NO;

    [self.view addSubview:myskillTable];
    [ghunterRequester postwithDelegate:self withUrl:URL_GET_USER_SKILL withUserInfo:REQUEST_FOR_USER_SKILL withDictionary:nil];
    [self startLoad];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"user_skills" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skillsChanged:) name:@"user_skills" object:nil];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"add_skillshows" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidAppear:(BOOL)animated {
    [MobClick event:UMEVENT_MY_SKILL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"user_skills" object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"add_skillshows" object:nil];
}

#pragma mark - Custom Methods

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)iconTaped:(UITapGestureRecognizer *)sender {
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

- (void)skillsChanged:(NSNotification *)notification {
    // 更新技能页面
    [self refreshTable];
}

- (void)operate_skillshow:(UILongPressGestureRecognizer *)sender {
    if(UIGestureRecognizerStateBegan == sender.state) {
        operateAlert = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"operateskillshowView" owner:self options:nil];
        UIView *taskFilter = [[UIView alloc] init];
        taskFilter = [nibs objectAtIndex:0];
        [operateAlert setCornerRadius:8.0];
        CGRect taskfilterFrame = taskFilter.frame;
        operateAlert.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height - 10), taskfilterFrame.size.width, taskfilterFrame.size.height);
        operateAlert.showView = taskFilter;
        UIButton *modify = (UIButton *)[taskFilter viewWithTag:1];
        UIButton *delelte = (UIButton *)[taskFilter viewWithTag:2];
        UIButton *cancel = (UIButton *)[taskFilter viewWithTag:3];
        modify.tag = sender.view.tag;
        delelte.tag = sender.view.tag;
        [modify addTarget:self action:@selector(modify_show:) forControlEvents:UIControlEventTouchUpInside];
        [delelte addTarget:self action:@selector(delete_show:) forControlEvents:UIControlEventTouchUpInside];
        [cancel addTarget:self action:@selector(cancel_show) forControlEvents:UIControlEventTouchUpInside];
        operateAlert.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
        [operateAlert show];
    }
}

- (void)modify_show:(UIButton *)sender {
    NSInteger row = sender.tag - 1;
    [operateAlert dismissAnimated:YES];
    NSMutableDictionary* skillShow=[[NSMutableDictionary alloc] init];
    skillShow = [self.skillShow objectAtIndex:row];
    NSString* str=[NSString stringWithFormat:@"?showid=%@",[skillShow objectForKey:@"sid"]];
    [ghunterRequester getwithDelegate:self withUrl:URL_GET_SKILL_CONTENT withUserInfo:REQUEST_FOR_GET_SKILL_CONTENT withString:str];
}

- (void)delete_show:(UIButton *)sender {
    NSInteger row = sender.tag - 1;
    NSDictionary *skillshow = [self.skillShow objectAtIndex:row];
    [operateAlert dismissAnimated:YES];
    [ghunterRequester getwithDelegate:self withUrl:URL_DELETE_SKILL_SHOW withUserInfo:REQUEST_FOR_DELETE_SKILL_SHOW withString:[NSString stringWithFormat:@"?sid=%zd",[[skillshow objectForKey:@"sid"] integerValue]]];
}

- (void)cancel_show {
    [operateAlert dismissAnimated:YES];
}

#pragma mark - UITableViewDelegate
// 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath:%zd",indexPath.row);
    if(indexPath.row == 0) {
        ghunterModifySkillViewController *modify = [[ghunterModifySkillViewController alloc] init];
        modify.tags = [self.skills mutableCopy];
        [self.navigationController pushViewController:modify animated:YES];
    }
    else
    {
        ghunterSkillViewController* skillView=[[ghunterSkillViewController alloc] init];
        NSDictionary* skillDic=[self.skillShow objectAtIndex:indexPath.row-1];
        skillView.skillid = [skillDic objectForKey:@"sid"];
        skillView.callBackBlock = ^{};
        [self.navigationController pushViewController:skillView animated:YES];
    }
}

// 行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.skillShow count] + 1;
}

#pragma mark - UITableVIewDatasource
// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

// 创建
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
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"skillHeadView" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UIView *realBack = (UIView *)[cell viewWithTag:4];
        UIView * backGView = (UIView *)[cell viewWithTag:777];
//        UIImageView *bgImg = (UIImageView *)[cell viewWithTag:5];
        UIImageView * editImgV = (UIImageView *)[cell viewWithTag:6];
        toshowTagList *tagList = [[toshowTagList alloc] initWithFrame:CGRectMake(0,10,mainScreenWidth - 20,0)];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < [self.skills count]; i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[self.skills objectAtIndex:i] forKey:@"title"];
            [dic setObject:RGBA(120, 120, 120, 1.0) forKey:@"titleColor"];
            [dic setObject:[UIColor whiteColor] forKey:@"backgroundColor"];
            [dic setObject:RGBA(246, 152, 83, 1.0) forKey:@"borderColor"];
            [dic setObject:@"1.0" forKey:@"borderWidth"];
            [array addObject:dic];
        }
        
        
        [tagList addTags:array];
        UIImageView *edit = (UIImageView *)[cell viewWithTag:6];
        
        CGRect tagListFrame = [tagList frame];
        tagListFrame.size.height += tagList.heightFinal;
        tagList.frame = tagListFrame;

//        [realBack addSubview:tagList];
        [backGView addSubview:tagList];
        
        // 设置内层view
        CGRect backFrame = backGView.frame;
        backFrame.size.height = tagList.heightFinal + 15;
//        backFrame.size.height =
        backFrame.size.width = mainScreenWidth - 20;
        backGView.frame = backFrame;
        
        // 设置外层view
        CGRect realbackFrame = realBack.frame;
//        realbackFrame.size.height = tagList.heightFinal + 30 ;
        realbackFrame.size.height = backGView.frame.size.height + backGView.frame.origin.y + 10;
        realbackFrame.size.width = mainScreenWidth;
        realBack.frame = realbackFrame;
        
        CGRect bgFrame = realBack.frame;
        bgFrame.size.width = mainScreenWidth;
        bgFrame.size.height = realBack.frame.size.height;
        realbackFrame.origin.y = 45;
        realBack.frame = bgFrame;
        
        CGRect editFrame = edit.frame;
        editFrame.origin.x = mainScreenWidth - editFrame.size.width;
        edit.frame = editFrame;
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = bgFrame.origin.y + bgFrame.size.height + 58;
//        cellFrame.size.height = 1;
        cell.frame = cellFrame;

        editbtn = [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth-70, 10, 60, 25)];
        [editbtn addTarget:self action:@selector(edit:) forControlEvents:(UIControlEventTouchUpInside)];
        [editbtn setBackgroundImage:[UIImage imageNamed:@"排序"] forState:UIControlStateNormal];
        editbtn.selected = NO;
        editbtn.tag = 1001;
        
        UIView * paixuView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 52, mainScreenWidth, 45)];
        paixuView.backgroundColor = RGBCOLOR(255, 255, 255);
//        paixuView.backgroundColor = [UIColor redColor];
        paixuView.userInteractionEnabled = YES;

        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, mainScreenWidth / 2, 25)];
        UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, mainScreenWidth / 2, 25)];
        lb.textAlignment = NSTextAlignmentLeft;
//        lb.backgroundColor = [UIColor yellowColor];
        lb.textColor = RGBCOLOR(105, 105, 105);
        lb.text = [NSString stringWithFormat:@"累积发布%lu条技能 :", (unsigned long)self.skillShow.count];
        lb.font = [UIFont systemFontOfSize:14];
        
        [btn addSubview:lb];
        [paixuView addSubview:btn];
        [paixuView addSubview:editbtn];
        [cell addSubview:paixuView];
        
        editImgV.frame = CGRectMake(mainScreenWidth - editImgV.frame.size.width - 10, editImgV.frame.origin.y, 14, 14);
        return cell;
    } else {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"hunterCircle" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UIView *bgview = (UIView *)[cell viewWithTag:10];
        UIImageView* bgImage=(UIImageView*)[cell viewWithTag:11];
        UILabel* titleLabel=(UILabel*)[cell viewWithTag:2];
//        UIImageView* circleImage=(UIImageView*)[cell viewWithTag:3];
//        UILabel* sellLabel=(UILabel*)[cell viewWithTag:999];
        UILabel* priceLabel=(UILabel*)[cell viewWithTag:444];
        UILabel* contentLabel=(UILabel*)[cell viewWithTag:5];
        UILabel* isSellLabel=(UILabel*)[cell viewWithTag:6];
        UILabel* buyLabel=(UILabel*)[cell viewWithTag:7];
        UILabel* hotLabel=(UILabel*)[cell viewWithTag:8];
        UILabel *linelabel = (UILabel *)[cell viewWithTag:1005];
        CGRect heightframe = linelabel.frame;
        heightframe.size.height = 0.5;
        linelabel.frame = heightframe;
        CGSize width = CGSizeMake(self.view.frame.size.width,cell.frame.size.height);
        CGRect  cellframe = cell.frame;
        cellframe.size.width = width.width;
        cell.frame = cellframe;
        skillDic=[self.skillShow objectAtIndex:indexPath.row-1];
        bgImage.frame = cell.frame;
        
        CGRect bgView = bgview.frame;
        bgView.size.width = cellframe.size.width;
        bgview.frame = bgView;
        
        titleLabel.text=[skillDic objectForKey:@"skill"];
        NSString* priceStr=[NSString stringWithFormat:@"%@元/%@",[skillDic objectForKey:@"price"],[skillDic objectForKey:@"priceunit"]];
        priceLabel.text=priceStr;
        CGSize priceSize = [priceStr sizeWithFont:priceLabel.font];
        
        CGRect frame1=priceLabel.frame;
        frame1.size.width = priceSize.width;
        frame1.origin.x=mainScreenWidth - priceSize.width - 10;
        priceLabel.frame=frame1;
        
        UILabel * sellLabel = [[UILabel alloc] init];
        sellLabel.text = @"售";
        sellLabel.textAlignment = NSTextAlignmentCenter;
        sellLabel.textColor = RGBCOLOR(234, 85, 20);
        sellLabel.font = [UIFont systemFontOfSize:12];
        sellLabel.frame = CGRectMake(mainScreenWidth - 10 - priceLabel.frame.size.width - 10 - 20, titleLabel.frame.origin.y, 20, 20);
        [sellLabel.layer setBorderWidth:1.0];
        [sellLabel.layer setBorderColor:RGBCOLOR(226, 63, 18).CGColor];
        sellLabel.layer.cornerRadius = sellLabel.frame.size.width / 2;
        [cell addSubview:sellLabel];
        
        NSString* buyStr=[NSString stringWithFormat:@"%@人购买",[skillDic objectForKey:@"salenum"]];
        buyLabel.text=buyStr;
        NSString* hotStr=[NSString stringWithFormat:@"%@热度",[skillDic objectForKey:@"hot"]];
        hotLabel.text=hotStr;
        
        contentLabel.text=[skillDic objectForKey:@"description"];
        contentLabel.numberOfLines=1;
        //技能内容对应的size
//        CGSize contentSize=[contentLabel.text sizeWithFont:contentLabel.font];
//        CGRect frame3=contentLabel.frame;
//        frame3.size.height=contentSize.height;
//        contentLabel.frame=frame3;
        
        CGSize size = [contentLabel.text sizeWithFont:[UIFont systemFontOfSize:10]constrainedToSize:CGSizeMake(contentLabel.frame.size.width, 300) lineBreakMode:UILineBreakModeWordWrap];
        CGRect frame3 = contentLabel.frame;
        frame3.size.width = cell.frame.size.width-40;
        contentLabel.frame = frame3;
        
        
        // ghuntertaskViewController.iss
        if([[skillDic objectForKey:@"isshow"] isEqualToString:@"2"])
        {
            isSellLabel.text=@"已上架";
        }
        else
        {
            isSellLabel.text=@"已下架";
            isSellLabel.textColor=[UIColor grayColor];
        }
        CGRect frame4=isSellLabel.frame;
        frame4.origin.y=frame3.origin.y+frame3.size.height+3;
        isSellLabel.frame=frame4;
        CGRect frame5=buyLabel.frame;
        CGRect frame6=hotLabel.frame;
        frame5.origin.y=frame4.origin.y;
        frame6.origin.y=frame4.origin.y;
        buyLabel.frame=frame5;
        hotLabel.frame=frame6;
//        CGRect bgFrame=bgImage.frame;
//        bgFrame.origin.y=frame4.origin.y+12;
//        bgImage.frame=bgFrame;
//        
//        CGRect cellFrame=cell.frame;
//        cellFrame.size.height=bgFrame.size.height+1;
//        cell.frame=cellFrame;
        
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(operate_skillshow:)];
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:longpress];
        return cell;
    }
    return cell;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIDeviceOrientationLandscapeLeft);
}

//哪几行可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        return YES;
    }
    return NO;
}
//移动 cell,防止移动 cell到不支持移动的列表下面
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{

    return proposedDestinationIndexPath;
}

//哪几行可以移动(可移动的行数小于等于可编辑的行数)
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        return YES;
    }
    return NO;
}
//self.skillShow


//移动cell时的操作
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if (sourceIndexPath != destinationIndexPath) {
        NSArray* object = [self.skillShow objectAtIndex:sourceIndexPath.row-1];
        
        [self.skillShow removeObjectAtIndex:sourceIndexPath.row-1];
        if (destinationIndexPath.row > [self.skillShow count]) {
            [self.skillShow addObject:object];
        }else {
            [self.skillShow insertObject:object atIndex:destinationIndexPath.row-1];
        }
    }
}

//当 tableview 为 editing 时,左侧按钮的 style
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}
#pragma mark - ASIHttpRequest

-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_USER_SKILL]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            self.skills = [dic objectForKey:@"skills"];
            [ghunterRequester postwithDelegate:self withUrl:[NSString stringWithFormat:@"%@?uid=%@&page=%zd",URL_GET_USER_SKILL_SHOW,[self.dic objectForKey:@"uid"],page] withUserInfo:REQUEST_FOR_USER_SKILLSHOW withDictionary:nil];
        }else if([dic objectForKey:@"msg"]){
            [self endLoad];
            myskillTable.pullTableIsRefreshing = NO;
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [self endLoad];
            myskillTable.pullTableIsRefreshing = NO;
            [ghunterRequester noMsg];
        }
    } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_USER_SKILLSHOW]){
        myskillTable.pullTableIsRefreshing = NO;
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [self.skillShow removeAllObjects];
            page = 2;
            NSArray *array = [dic valueForKey:@"skillshows"];
            [self.skillShow addObjectsFromArray:array];
            
            [myskillTable reloadData];
        }else if([dic objectForKey:@"msg"]){
            if([error_number integerValue] == 1 && [self.skillShow count] == 1) {
                [self.skillShow removeAllObjects];
            }
            [myskillTable reloadData];
        }else{
            
        }
    } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_SKILLSHOW]){
        myskillTable.pullTableIsLoadingMore = NO;
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            page++;
            NSArray *array = [dic valueForKey:@"skillshows"];
            [self.skillShow addObjectsFromArray:array];
            [myskillTable reloadData];
        } else if ([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_DELETE_SKILL_SHOW]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester postwithDelegate:self withUrl:[NSString stringWithFormat:@"%@?uid=%@&page=%zd",URL_GET_USER_SKILL_SHOW,[self.dic objectForKey:@"uid"],1] withUserInfo:REQUEST_FOR_USER_SKILLSHOW withDictionary:nil];
        }
    }
    else if([[request.userInfo objectForKey:REQUEST_TYPE] isEqual:REQUEST_FOR_GET_SKILL_CONTENT])
    {
        if(responseCode==200&&[error_number integerValue]==0)
        {
            [self endLoad];
            NSMutableDictionary* _mutSkillDic=[[NSMutableDictionary alloc] init];;
            _mutSkillDic=[dic objectForKey:@"skillshow"];
            ghunterReleaseSkillViewController* skill=[[ghunterReleaseSkillViewController alloc] init];
            
            skill.skillDic = _mutSkillDic;
            skill.callBackBlock = ^{};
            [self.navigationController pushViewController:skill animated:YES];
        }
        else if([dic objectForKey:@"msg"]){
            [self endLoad];
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [self endLoad];
            [ghunterRequester noMsg];
        }
    }

}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self endLoad];
    myskillTable.pullTableIsRefreshing = NO;
    myskillTable.pullTableIsLoadingMore = NO;
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
    //    NSError *error = [request error];
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    editbtn.selected = NO;
    [myskillTable setEditing:!myskillTable animated:NO];
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
    [ghunterRequester postwithDelegate:self withUrl:URL_GET_USER_SKILL withUserInfo:REQUEST_FOR_USER_SKILL withDictionary:nil];
}

- (void)loadMoreDataToTable
{
    
    [ghunterRequester postwithDelegate:self withUrl:[NSString stringWithFormat:@"%@?uid=%@&page=%zd",URL_GET_USER_SKILL_SHOW,[self.dic objectForKey:@"uid"],page] withUserInfo:REQUEST_FOR_LOADMORE_SKILLSHOW withDictionary:nil];
}

// 排序
- (void)edit:(UIButton *)sender {
    UIButton * btn = (UIButton *)[sender viewWithTag:1001];
    if (btn.selected == NO) {
        btn.selected = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"确定"] forState:UIControlStateNormal];
        [myskillTable setEditing:!myskillTable.editing animated:YES];
    }else  {
        btn.selected = NO;
        [myskillTable setEditing:!myskillTable animated:NO];
        [btn setBackgroundImage:[UIImage imageNamed:@"排序"] forState:UIControlStateNormal];
        
        // 开始排序，排序技能秀
        NSMutableArray *sortDic = [[NSMutableArray alloc] init];
        int i = 1;
        for (NSDictionary *obj in self.skillShow) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%zd",i],[NSString stringWithFormat:@"%@", [obj objectForKey:@"sid"]], nil];
            [sortDic addObject:dict];
            i++;
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sortDic
                                                           options:NSJSONWritingPrettyPrinted error:nil];
        NSString *sortParamters = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:sortParamters forKey:@"sortorder"];
        
        [AFNetworkTool httpPostWithUrl:URL_SKILLSHOW_SORTORDER andParameters:dic success:^(NSData *data) {
            NSError *error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if ( [[json objectForKey:@"error"] integerValue] == 0 ) {
                [ProgressHUD show:[json objectForKey:@"msg"]];
            }else{
                [ProgressHUD show:[json objectForKey:@"msg"]];
            }
        } fail:^{
            [ProgressHUD show:HTTPREQUEST_ERROR];
        }];
    }
}

@end
