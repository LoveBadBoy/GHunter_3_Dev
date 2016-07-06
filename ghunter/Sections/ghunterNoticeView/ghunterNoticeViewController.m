//
//  ghunterNoticeViewController.m
//  ghunter
//
//  Created by chensonglu on 14-5-23.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//  消息页面

#import "ghunterNoticeViewController.h"
#import "ghunterTabViewController.h"
#import "ghunterSkillViewController.h"

static dispatch_once_t onceTokenTask;
static dispatch_once_t onceTokenMsg;

@interface ghunterNoticeViewController (){
    NSInteger noticeIndex;  // 存放被处理的消息的索引值
    NSInteger msgIndex;
    
    BOOL secondLoginNotice;
    BOOL secondLoginMsg;
}
- (IBAction)moreBtn:(UIButton *)sender;
@property (nonatomic,retain) NSMutableArray *radioArray;
@property (nonatomic,assign) BOOL doNotShowActivityView;
@property(nonatomic,assign)BOOL swapByTapButton;

@property (nonatomic,assign) NSInteger unreadNoticeConter;
@property (nonatomic,assign) NSInteger unreadMessageConter;
@property (nonatomic,assign) NSInteger unreadConter;
@property (weak, nonatomic) IBOutlet UIImageView *topBGImageView;
@property (strong, nonatomic) IBOutlet UIView *bg;

@end

@implementation ghunterNoticeViewController

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
    self.swapByTapButton = NO;
    
    secondLoginNotice = NO;
    secondLoginMsg = NO;
    
    extern BOOL noticeRequested;
    extern BOOL messageRequested;
    
    ghuntersettingsViewController *settings = [[ghuntersettingsViewController alloc] init];
    settings.resetPageDelegate = self;
    [APService clearAllLocalNotifications];
    taskpage = 1;
    messagepage = 1;
    delete_task_num = 0;
    delete_message_num = 0;
    
    // 私信页面是否被请求过
    messageRequested = NO;
    // 通知页面是否被请求过
    noticeRequested = NO;
    
    taskArray = [[NSMutableArray alloc]init];
    messageArray = [[NSMutableArray alloc] init];
    
    // 初始化选中颜色
    selectedColor = [UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0];
    defaultColor = [UIColor blackColor];
    
    // 初始化scrollView页面
    [self initScrollView];
    [self.view addSubview:headerView];
    // 更新headerView的样式
    [self update_noticepage_unreadui];
    [self.view addSubview:_scrollView];
    
    //更新我的页面的未读消息UI
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"update_noticepage_unreadui" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update_noticepage_unreadui) name:@"update_noticepage_unreadui" object:nil];
    
    // 注册更新通知页面的广播通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"update_notice_page" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update_notice_page) name:@"update_notice_page" object:nil];
    // 注册更新私信页面的广播通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"update_message_page" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update_message_page) name:@"update_message_page" object:nil];
    
    // 注销登录之后
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"update_notice_ui" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update_notice_ui) name:@"update_notice_ui" object:nil];
}

-(void)initScrollView{
    /*
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, mainScreenheight - 104)];
    _scrollView.contentSize = CGSizeMake(mainScreenWidth * 2, _scrollView.bounds.size.height + 20);
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    */
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, mainScreenheight - 104 - TAB_BAR_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(mainScreenWidth * 2, _scrollView.bounds.size.height);
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    
    // 加上headerView
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *headerLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth/ 2, 40)];
    [headerView addSubview:headerLeftView];
    noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerLeftView.frame.size.width / 2 - mainScreenWidth / 16, 10, 35, 20)];
    noticeLabel.text = @"通知";
    noticeLabel.userInteractionEnabled = YES;
    noticeLabel.textColor = selectedColor;
    
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taskClick:)];
    [headerLeftView addGestureRecognizer:taps];
    
    noticeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerLeftView.frame.size.width / 2 - mainScreenWidth / 16 + 35 , 10, 20, 20)];
    [noticeCountLabel.layer setCornerRadius:10];
    noticeCountLabel.layer.masksToBounds = YES;
    noticeCountLabel.textAlignment = NSTextAlignmentCenter;
    noticeCountLabel.font = [UIFont systemFontOfSize:12];
    noticeCountLabel.backgroundColor = [UIColor colorWithRed:255/255 green:76/255.0 blue:36/255.0 alpha:1.0];
    noticeCountLabel.textColor = [UIColor whiteColor];
    UIView *headRightView = [[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth/2, 0, mainScreenWidth / 2, 40)];
    UITapGestureRecognizer *tapRight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageClick:)];
    [headRightView addGestureRecognizer:tapRight];
    
    msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(headRightView.frame.size.width / 2 - mainScreenWidth / 16, 10, 35, 20)];
    msgLabel.text = @"私信";
    msgCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(headRightView.frame.size.width / 2 - mainScreenWidth / 16 + 35, 10, 20, 20)];
    [msgCountLabel.layer setCornerRadius:10];
    msgCountLabel.layer.masksToBounds = YES;
    // 居中显示
    msgCountLabel.backgroundColor = [UIColor colorWithRed:255/255 green:76/255.0 blue:36/255.0 alpha:1.0];
    msgCountLabel.textAlignment = NSTextAlignmentCenter;
    msgCountLabel.font = [UIFont systemFontOfSize:12];
    msgCountLabel.textColor = [UIColor whiteColor];
    
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth / 2, 5, 1, 30)];
    lineImage.backgroundColor = [UIColor grayColor];
    lineImage.alpha = 0.4;
    UIImageView *lineImageH = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, mainScreenWidth, 1)];
    lineImageH.backgroundColor = [UIColor grayColor];
    lineImageH.alpha = 0.4;
    [headerView addSubview:headerLeftView];
    [headerView addSubview:headRightView];
    [headerView addSubview:lineImage];
    [headerView addSubview:lineImageH];
    [headRightView addSubview:msgLabel];
    [headRightView addSubview:msgCountLabel];
    [headerLeftView addSubview:noticeLabel];
    [headerLeftView addSubview:noticeCountLabel];
    
    // 下划线
    UIView * headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 2, mainScreenWidth / 2, 1.5)];
    headLineView.tag = 99;
    headLineView.backgroundColor = RGBCOLOR(234, 85, 20);
    [headerView addSubview:headLineView];
    
    
    noticeTableview = [[PullTableView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    noticeTableview.delegate = self;
    noticeTableview.dataSource = self;
    noticeTableview.pullDelegate = self;
    noticeTableview.showsVerticalScrollIndicator = NO;
//    noticeTableview.showsHorizontalScrollIndicator = NO;
    noticeTableview.bounces = YES;
    noticeTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    noticeTableview.backgroundColor=RGBA(228, 227, 220, 1);
    [noticeTableview setClipsToBounds:NO];
    [_scrollView addSubview:noticeTableview];
    
    messageTableView = [[PullTableView alloc]initWithFrame:CGRectMake(mainScreenWidth, 0, mainScreenWidth, _scrollView.frame.size.height) style:UITableViewStylePlain];
    messageTableView.delegate = self;
    messageTableView.dataSource = self;
    messageTableView.pullDelegate = self;
    messageTableView.showsVerticalScrollIndicator = NO;
//    messageTableView.showsHorizontalScrollIndicator = NO;
    messageTableView.bounces = YES;
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageTableView.backgroundColor=RGBA(228, 227, 220, 1);
    [messageTableView setClipsToBounds:NO];
    [_scrollView addSubview:messageTableView];
    
    
}

// 更新本页未读通知数量UI
-(void)update_noticepage_unreadui{
    if ( gunread_notice > 0 ) {
        [noticeCountLabel setText:[NSString stringWithFormat:@"%zd", gunread_notice]];
        noticeCountLabel.hidden = NO;
    }else{
        noticeCountLabel.hidden = YES;
    }
    if (gunread_message > 0) {
        msgCountLabel.text = [NSString stringWithFormat:@"%zd", gunread_message];
        msgCountLabel.hidden = NO;
    }else{
        msgCountLabel.hidden = YES;
    }
}

-(void)update_notice_page{
    if ( noticeRequested ) {
        [self refreshtaskTable];
    }else{
        // 更新全局消息提示数量
        gunread_notice = gunread_notice + 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
    }
}
-(void)update_message_page{
    if ( messageRequested ) {
        [self refreshmessageTable];
    }else{
        // 更新全局消息提示数量
        gunread_message = gunread_message + 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
    }
}

// 注销登录执行此防范
-(void)update_notice_ui{
    taskpage = 1;
    messagepage = 1;
    noticeRequested = NO;
    messageRequested = NO;
    [taskArray removeAllObjects];
    [messageArray removeAllObjects];
    delete_task_num = 0;
    delete_message_num = 0;
    _swapByTapButton = NO;
    
    [noticeTableview reloadData];
    [messageTableView reloadData];
    
    secondLoginNotice = YES;
    secondLoginMsg = YES;
}

// 注销后此方法会被settings页面调用，重置此页面page为1
- (void)resetPages {
    taskpage = 1;
    messagepage = 1;
}

-(void)taskClick:(UITapGestureRecognizer *)taps {
    self.swapByTapButton = YES;
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    noticeLabel.textColor = selectedColor;
    msgLabel.textColor = defaultColor;
    
    UIView * lineV = (UIView *)[headerView viewWithTag:99];
    
    CGRect lineVFrame = lineV.frame;
    
    lineVFrame.origin.x = 0;
    lineV.frame = lineVFrame;
}

-(void)messageClick:(UITapGestureRecognizer *)tapRight {
    self.swapByTapButton = YES;
    [self.scrollView setContentOffset:CGPointMake(mainScreenWidth, 0) animated:YES];
    msgLabel.textColor = selectedColor;
    noticeLabel.textColor = defaultColor;
    
    UIView * lineV = (UIView *)[headerView viewWithTag:99];
    
    CGRect lineVFrame = lineV.frame;
    
    lineVFrame.origin.x = mainScreenWidth / 2;
    lineV.frame = lineVFrame;

    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    ghunterTabViewController *tbvc = (ghunterTabViewController *)self.tabBarController;
    if (!tbvc.didSelectItemOfTabBar) {
        self.tabBarController.tabBar.hidden = YES;
        [self.tabBarController.tabBar setFrame:CGRectMake(0, mainScreenheight, mainScreenWidth, TAB_BAR_HEIGHT)];
    }
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    if(imgondar_islogin)
    {
        // 如果已登录
        if ([noticeTableview convertPoint:CGPointMake(0, 0) toView:self.view].x < 0) {
            msgLabel.textColor = selectedColor;
            noticeLabel.textColor = defaultColor;
            
            dispatch_once(&onceTokenMsg, ^{
                [self didGetMessageListIsloading:YES withPage:messagepage];
            });
            if (secondLoginMsg) {
                [self didGetMessageListIsloading:YES withPage:messagepage];
                secondLoginMsg = NO;
            }
        }else {
            msgLabel.textColor = defaultColor;
            noticeLabel.textColor = selectedColor;
            
            dispatch_once(&onceTokenTask, ^{
                [self didGetNoticeListIsloading:YES withPage:taskpage];
            });
            if (secondLoginNotice) {
                [self didGetNoticeListIsloading:YES withPage:taskpage];
                secondLoginNotice = NO;
            }
        }
    }else{
        // 如果未登录
        taskpage = 1;
        messagepage = 1;
        noticeRequested = NO;
        messageRequested = NO;
        ghunterLoginViewController *login=[[ghunterLoginViewController alloc] init];
        [login setCallBackBlock:^{
            self.tabBarController.selectedIndex = 3;
        }];
        // 模态跳转，从下往上
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
        // [self.navigationController pushViewController:login animated:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    ghunterTabViewController *tbvc = (ghunterTabViewController *)self.tabBarController;
    if (self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            [self.tabBarController.tabBar setFrame:CGRectMake(0, mainScreenheight - TAB_BAR_HEIGHT, mainScreenWidth, TAB_BAR_HEIGHT)];
        } completion:^(BOOL finished) {
            [_scrollView setFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, mainScreenheight - 104 - TAB_BAR_HEIGHT)];
            _scrollView.contentSize = CGSizeMake(mainScreenWidth * 2, _scrollView.bounds.size.height);
            [noticeTableview setFrame:CGRectMake(0, 0, mainScreenWidth, _scrollView.frame.size.height)];
            [messageTableView setFrame:CGRectMake(mainScreenWidth, 0, mainScreenWidth, _scrollView.frame.size.height)];
        }];
    }
    tbvc.didSelectItemOfTabBar = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [_scrollView setFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, mainScreenheight - 104 - TAB_BAR_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(mainScreenWidth * 2, _scrollView.bounds.size.height);
    [noticeTableview setFrame:CGRectMake(0, 0, mainScreenWidth, _scrollView.frame.size.height)];
    [messageTableView setFrame:CGRectMake(mainScreenWidth, 0, mainScreenWidth, _scrollView.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.loadingView = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = [messageTableView convertPoint:CGPointZero toView:self.view];
    if (point.x >= mainScreenWidth * 0.5) {
        dispatch_once(&onceTokenTask, ^{
            [self didGetNoticeListIsloading:YES withPage:taskpage];
        });
        if (secondLoginNotice) {
            [self didGetNoticeListIsloading:YES withPage:taskpage];
            secondLoginNotice = NO;
        }
        if (self.swapByTapButton) {
            return;
        }
        msgLabel.textColor = defaultColor;
        noticeLabel.textColor = selectedColor;
    } else {
        dispatch_once(&onceTokenMsg, ^{
            [self didGetMessageListIsloading:YES withPage:messagepage];
        });
        if (secondLoginMsg) {
            [self didGetMessageListIsloading:YES withPage:messagepage];
            secondLoginMsg = NO;
        }
        if (self.swapByTapButton) {
            return;
        }
        msgLabel.textColor = selectedColor;
        noticeLabel.textColor = defaultColor;
    }
    
    if (scrollView == _scrollView) {
        
        UIView * lineV = (UIView *)[headerView viewWithTag:99];
        
        CGRect lineVFrame = lineV.frame;
        lineVFrame.origin.x = scrollView.contentOffset.x / 2;
        lineV.frame = lineVFrame;
    }
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // NSLog(@"scrollViewDidEndDragging");
    self.swapByTapButton = NO;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([_type isEqualToString:@"3"])
    {
        tableView = noticeTableview;
    }
    if([_type isEqualToString:@"5"])
    {
        tableView = messageTableView;
    }
    
    if(tableView == noticeTableview){
        NSMutableDictionary *taskDic = [[taskArray objectAtIndex:indexPath.row] mutableCopy];
        NSInteger count = [[taskDic objectForKey:@"count"] integerValue];
        if ( count <=0 ) {
            // 此消息已处理
        }else{
            // 此消息未处理，处理消息
            noticeIndex = indexPath.row;   // 记录被处理的消息的索引值
            [ghunterRequester getwithDelegate:self withUrl:URL_DEAL_UNREAD_NOTICE withUserInfo:REQUEST_FOR_DEAL_UNREAD_NOTICE withString:[NSString stringWithFormat:@"?api_session_id=%@&nid=%@",[ghunterRequester getUserInfo:@"api_session_id"],[taskDic objectForKey:@"nid"]]];
        }
        NSInteger type = [[taskDic objectForKey:@"type"] integerValue];
        if (type == 10) {
            NSString *siteurl = [taskDic objectForKey:@"siteurl"];
            siteurl = [NSString stringWithFormat:@"%@?api_token=%@&api_session_id=%@", siteurl, API_TOKEN_NUM, [ghunterRequester getApi_session_id]];
            // 转换中文编码，转成字符
            siteurl = [siteurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            
            ghunterWebViewController *web = [[ghunterWebViewController alloc] init];
            web.urlPassed = siteurl;
            web.webTitle = @"申请返现";
            [self.navigationController pushViewController:web animated:YES];
        }else{
            // 其他消息类型,3任务消息类型,6技能消息类型
            if (type == 3) {
                // 任务消息
                ghuntertaskViewController *task = [[ghuntertaskViewController alloc] init];
                task.tid = [taskDic objectForKey:@"oid"];
                task.callBackBlock = ^{
                    // [self refreshtaskTable];
                };
                [self.navigationController pushViewController:task animated:YES];
            }else{
                // 技能消息
                ghunterSkillViewController *skillView = [[ghunterSkillViewController alloc] init];
                skillView.skillid = [taskDic objectForKey:@"oid"];
                skillView.callBackBlock = ^{};
                [self.navigationController pushViewController:skillView animated:YES];
            }
        }
    }else{
        // 点击私信列表
        NSMutableDictionary *messageDic = [[messageArray objectAtIndex:indexPath.row] mutableCopy];
        NSInteger count = [[messageDic objectForKey:@"count"] integerValue];
        if (count > 0) {
            msgIndex = indexPath.row;
            // 需要处理的消息
            [ghunterRequester getwithDelegate:self withUrl:URL_DEAL_UNREAD_MESSAGE withUserInfo:REQUEST_FOR_DEAL_UNREAD_MESSAGE withString:[NSString stringWithFormat:@"?api_session_id=%@&mid=%@",[ghunterRequester getUserInfo:@"api_session_id"],[messageDic objectForKey:@"mid"]]];
        }else{
            // 此消息已经处理，不用再处理
        }
        ghunterChatViewController *chat = [[ghunterChatViewController alloc] init];
        chat.sender_uid = [messageDic objectForKey:@"sender_uid"];
        chat.sender_username = [messageDic objectForKey:@"sender_username"];
        [chat setCallBackBlock:^{
            // [self refreshmessageTable];
        }];
        [self.navigationController pushViewController:chat animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == noticeTableview){
        return [taskArray count];
    }else if(tableView == messageTableView){
        return [messageArray count];
    }
    return 0;
}

#pragma mark - UITableviewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

//  渲染每一行的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else {
        while ([cell.contentView.subviews lastObject]) {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
//    if(tableView == noticeTableview){
//            if ( [taskArray count] == 0 ) {
//                return  cell;
//            }
//            NSDictionary *taskDic = [taskArray objectAtIndex:indexPath.row];
//            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"alieView" owner:self options:nil];
//            cell = [nibs objectAtIndex:0];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            UIView *backView = (UIView*)[cell viewWithTag:1];
//            backView.clipsToBounds = YES;
//            UIImageView *icon = (UIImageView*)[cell viewWithTag:2];
//            UILabel *username = (UILabel*)[cell viewWithTag:3];
//            UILabel *content = (UILabel*)[cell viewWithTag:4];
//            UILabel *dateline = (UILabel*)[cell viewWithTag:5];
//            UILabel *line = (UILabel*)[cell viewWithTag:6];
////            UILabel *replyLabel = (UILabel*)[cell viewWithTag:7];
//            UIButton *unreadCountButton = (UIButton *)[cell viewWithTag:9999];
//            [unreadCountButton.layer setCornerRadius:10];
//            [unreadCountButton setClipsToBounds:YES];
//            [unreadCountButton addTarget:self action:@selector(cancelUnreadNoticeStat:) forControlEvents:UIControlEventTouchUpInside];
//        
//            NSInteger unreadConter = [[taskDic objectForKey:@"count"] integerValue];
//            if (unreadConter > 0) {
//                [unreadCountButton setHidden:NO];
//                [unreadCountButton setTitle:[NSString stringWithFormat:@"%zd",unreadConter] forState:UIControlStateNormal];
//            }
//            else {
//                [unreadCountButton setHidden:YES];
//            }
//            icon.clipsToBounds = YES;
//            icon.layer.cornerRadius = icon.frame.size.height / 2.0;
//            icon.userInteractionEnabled = YES;
//            [icon sd_setImageWithURL:[taskDic objectForKey:@"fromuser_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
//            icon.tag = indexPath.row;
//            [icon addGestureRecognizer:tap];
//            [username setText:[taskDic objectForKey:@"fromuser_username"]];
//
////            replyLabel.text = [taskDic objectForKey:@"title"];
//        
//            //重设name和回复的坐标
//            CGRect nameframe = username.frame;
//            NSString *datelineStr = [taskDic objectForKey:@"dateline"];
//            [dateline setText:[ghunterRequester getTimeDescripton:datelineStr]];
//            CGSize namesize = [username.text sizeWithFont:username.font constrainedToSize:CGSizeMake(200, 17) lineBreakMode:NSLineBreakByWordWrapping];
//            nameframe.size.width = namesize.width;
//            username.frame = nameframe;
////            CGRect replyframe = replyLabel.frame;
////            replyframe.origin.x = nameframe.origin.x + namesize.width + 3;
////            replyLabel.frame = replyframe;
//        
//            content.numberOfLines = 0;
//            NSString *contentStr = [taskDic objectForKey:@"content"];
//        
//            CGSize contentSize = [contentStr sizeWithFont:content.font constrainedToSize:CGSizeMake(content.frame.size.width, MAXFLOAT)lineBreakMode:NSLineBreakByWordWrapping];
//            CGRect contentFrame = content.frame;
//            contentFrame.size.height = contentSize.height + 10;
//            content.frame = contentFrame;
//            
//            [content setText:contentStr];
//            // NSLog(@"contentText:%@",content.text);
//            CGRect cellFrame = cell.frame;
//            if (content.frame.origin.y + contentSize.height > (icon.frame.origin.x + icon.frame.size.height)) {
//                cellFrame.size.height = content.frame.origin.y + contentSize.height + 5;
//                
//            }else {
//                
//                cellFrame.size.height = content.frame.origin.y + contentSize.height + 10;
//            }
//            cell.frame = cellFrame;
//            CGRect lineFrame = line.frame;
//            lineFrame.origin.y = cellFrame.size.height - 1;
//            line.frame = lineFrame;
//                 UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(delete_task_notice:)];
//            cell.tag = indexPath.row;
//            [cell addGestureRecognizer:longpress];
//            //tableView削圆
//            if(indexPath.row == 0){
//                if ([taskArray count] == 1) {
//                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerAllCorners  cornerRadii:CGSizeMake(10, 10)];
//                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//                    maskLayer.frame = backView.bounds;
//                    maskLayer.path = maskPath.CGPath;
//                    backView.layer.mask = maskLayer;
//                } else {
//                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//                    maskLayer.frame = backView.bounds;
//                    maskLayer.path = maskPath.CGPath;
//                    backView.layer.mask = maskLayer;
//                    
//                }
//            }
//            if(indexPath.row == [taskArray count] - 1) {
//                if ([taskArray count] == 1) {
//                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
//                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//                    maskLayer.frame = backView.bounds;
//                    maskLayer.path = maskPath.CGPath;
//                    backView.layer.mask = maskLayer;
//                } else {
//                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//                    maskLayer.frame = backView.bounds;
//                    maskLayer.path = maskPath.CGPath;
//                    backView.layer.mask = maskLayer;
//                }
//            }
//        
//        return cell;
//    }
    if(tableView == noticeTableview){
        if ([taskArray count] == 0) {
            return cell;
        }
        NSDictionary * taskDic = [taskArray objectAtIndex:indexPath.row];
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"alieView" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *backView = (UIView*)[cell viewWithTag:1];
        backView.clipsToBounds = YES;
        UIImageView *icon = (UIImageView*)[cell viewWithTag:2];
        UILabel *username = (UILabel*)[cell viewWithTag:3];
        UILabel *content = (UILabel*)[cell viewWithTag:4];
        UILabel *dateline = (UILabel*)[cell viewWithTag:5];
        UILabel *line = (UILabel*)[cell viewWithTag:6];
        UILabel *replyLabel = (UILabel*)[cell viewWithTag:7];
        UILabel *toView = (UILabel *)[cell viewWithTag:20];

        replyLabel.text = [taskDic objectForKey:@"title"];
        NSString *str = [[NSString alloc]init];
        str = [replyLabel.text substringToIndex:3];
        

        UIButton *unreadCountButton = (UIButton *)[cell viewWithTag:9999];
        [unreadCountButton.layer setCornerRadius:10];
        [unreadCountButton setClipsToBounds:YES];
        [unreadCountButton addTarget:self action:@selector(cancelUnreadNoticeStat:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger unreadConter = [[taskDic  objectForKey:@"count"] integerValue];
        if (unreadConter > 0) {
            [unreadCountButton setHidden:NO];
            [unreadCountButton setTitle:[NSString stringWithFormat:@"%zd", unreadConter] forState:UIControlStateNormal];
        }
        else {
            [unreadCountButton setHidden:YES];
        }
        icon.clipsToBounds = YES;
        icon.layer.cornerRadius = icon.frame.size.height / 2.0;
        icon.userInteractionEnabled = YES;
        [icon sd_setImageWithURL:[taskDic objectForKey:@"fromuser_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
        icon.tag = indexPath.row;
        [icon addGestureRecognizer:tap];
        [username setText:[ taskDic objectForKey:@"fromuser_username"]];
        replyLabel.text = [taskDic objectForKey:@"title"];
        CGRect nameFrame = username.frame;
        
        CGSize nameSize = [username.text sizeWithFont:username.font constrainedToSize:CGSizeMake(200, 17) lineBreakMode:NSLineBreakByWordWrapping];
        nameFrame.size.width = nameSize.width;
        username.frame = nameFrame;
        CGRect replyframe = replyLabel.frame;
         replyframe.origin.x = nameFrame.origin.x + nameSize.width + 3;
        replyLabel.frame = replyframe;
        NSString *datelineStr = [taskDic objectForKey:@"dateline"];
        [dateline setText:[ghunterRequester getTimeDescripton:datelineStr]];
        NSString * contentStr= [taskDic objectForKey:@"content"];
        
        CGSize contentSize = [contentStr sizeWithFont:content.font constrainedToSize:CGSizeMake(content.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect contentFrame = content.frame;
        contentFrame.size.height = contentSize.height-3;
        content.frame = contentFrame;
        [content setText: contentStr];
        CGRect cellFrame = cell.frame;
        
        UIView * accountView = [[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth - toView.frame.size.width,content.frame.origin.y+content.frame.size.height - 10, 100, 25)];
        [cell.contentView addSubview:accountView];
        accountView.backgroundColor = [UIColor clearColor];
        
        toView = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, accountView.frame.size.width, 10)];
        toView.textAlignment = kCTTextAlignmentRight;
        [toView setUserInteractionEnabled:YES];
        if ([str isEqualToString:@"打赏优"]) {
            toView.text = @"查看【我的优惠劵】";
            toView.textColor = [UIColor colorWithRed:0.92f green:0.33f blue:0.08f alpha:1.00f];
            [toView setFont:[UIFont systemFontOfSize:10]];
            UITapGestureRecognizer *toViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toViewMyCoupon)];
            [accountView addGestureRecognizer:toViewTap];
            [accountView addSubview:toView];
        }else if ([str isEqualToString:@"评价支"]||[str isEqualToString:@"打赏你"]||[str isEqualToString:@"任务已"])
        {
            toView.text = @"查看【我的金库】";
            toView.textColor = [UIColor colorWithRed:0.92f green:0.33f blue:0.08f alpha:1.00f];
            [toView setFont:[UIFont systemFontOfSize:10]];
            UITapGestureRecognizer *toViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toViewMyGold)];
            [accountView addGestureRecognizer:toViewTap];
            [accountView addSubview:toView];
        }else{
            toView.text = @"";
        }
        
        if (content.frame.origin.y + contentSize.height > (icon.frame.origin.x + icon.frame.size.height)) {
            cellFrame.size.height = content.frame.origin.y + contentSize.height + 15;
            
        }else {
            
            cellFrame.size.height = content.frame.origin.y + contentSize.height + 10;
        }
        cell.frame = cellFrame;
        CGRect backViewFrame = backView.frame;
        backViewFrame.size.height = cellFrame.size.height;
        backView.frame = backViewFrame;
        CGRect lineFrame = line.frame;
        lineFrame.origin.y = cellFrame.size.height - 1;
        lineFrame.size.height = 0.5;
        line.frame = lineFrame;
        
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(delete_task_notice:)];
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:longpress];
        if(indexPath.row == 0){
//            if ([messageArray count] == 1) {
//                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//                maskLayer.frame = backView.bounds;
//                maskLayer.path = maskPath.CGPath;
//                backView.layer.mask = maskLayer;
//            } else {
//                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//                maskLayer.frame = backView.bounds;
//                maskLayer.path = maskPath.CGPath;
//                backView.layer.mask = maskLayer;
//            }
        }
        if(indexPath.row == [messageArray count] - 1) {
            if ([messageArray count] == 1) {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = backView.bounds;
                maskLayer.path = maskPath.CGPath;
                backView.layer.mask = maskLayer;
            } else {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = backView.bounds;
                maskLayer.path = maskPath.CGPath;
                backView.layer.mask = maskLayer;
            }
        }
        return cell;
    }
    else if(tableView == messageTableView){
        if ([messageArray count] == 0) {
            return cell;
        }
        NSDictionary *messageDic = [messageArray objectAtIndex:indexPath.row];
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"alieView" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *backView = (UIView*)[cell viewWithTag:1];
        backView.clipsToBounds = YES;
        UIImageView *icon = (UIImageView*)[cell viewWithTag:2];
        UILabel *username = (UILabel*)[cell viewWithTag:3];
        UILabel *content = (UILabel*)[cell viewWithTag:4];
        UILabel *dateline = (UILabel*)[cell viewWithTag:5];
        UILabel *line = (UILabel*)[cell viewWithTag:6];
        UIButton *unreadCountButton = (UIButton *)[cell viewWithTag:9999];
        content.numberOfLines = 1;
        [unreadCountButton.layer setCornerRadius:10];
        [unreadCountButton setClipsToBounds:YES];
        [unreadCountButton addTarget:self action:@selector(cancelUnreadMessageStat:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger unreadConter = [[messageDic objectForKey:@"count"] integerValue];
        if (unreadConter > 0) {
            [unreadCountButton setHidden:NO];
            [unreadCountButton setTitle:[NSString stringWithFormat:@"%zd", unreadConter] forState:UIControlStateNormal];
        }
        else {
            [unreadCountButton setHidden:YES];
        }
        icon.clipsToBounds = YES;
        icon.layer.cornerRadius = icon.frame.size.height / 2.0;
        icon.userInteractionEnabled = YES;
        [icon sd_setImageWithURL:[messageDic objectForKey:@"sender_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
        icon.tag = indexPath.row;
        [icon addGestureRecognizer:iconTap];
        [username setText:[messageDic objectForKey:@"sender_username"]];
        CGRect nameFrame = username.frame;
        CGSize nameSize = [username.text sizeWithFont:username.font constrainedToSize:CGSizeMake(200, 17) lineBreakMode:NSLineBreakByWordWrapping];
        nameFrame.size.width = nameSize.width;
        username.frame = nameFrame;
        NSString *datelineStr = [messageDic objectForKey:@"dateline"];
        [dateline setText:[ghunterRequester getTimeDescripton:datelineStr]];
        NSString *messageStr = [messageDic objectForKey:@"content"];
        
        CGSize contentSize = [messageStr sizeWithFont:content.font constrainedToSize:CGSizeMake(content.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect contentFrame = content.frame;
        contentFrame.size.height = 10;
        content.frame = contentFrame;
        [content setText:messageStr];
        CGRect cellFrame = cell.frame;
        if (content.frame.origin.y + contentSize.height > (icon.frame.origin.x + icon.frame.size.height)) {
            cellFrame.size.height = content.frame.origin.y + 25;
            
        }else {
            
            cellFrame.size.height = content.frame.origin.y + contentSize.height + 10;
        }
        cell.frame = cellFrame;
        CGRect backViewFrame = backView.frame;
        backViewFrame.size.height = cellFrame.size.height;
        backView.frame = backViewFrame;
        CGRect lineFrame = line.frame;
        lineFrame.origin.y = cellFrame.size.height - 1;
        line.frame = lineFrame;
        
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(delete_message_notice:)];
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:longpress];
        if(indexPath.row == 0){
//            if ([messageArray count] == 1) {
//                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//                maskLayer.frame = backView.bounds;
//                maskLayer.path = maskPath.CGPath;
//                backView.layer.mask = maskLayer;
//            } else {
//                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//                maskLayer.frame = backView.bounds;
//                maskLayer.path = maskPath.CGPath;
//                backView.layer.mask = maskLayer;
//            }
        }
        if(indexPath.row == [messageArray count] - 1) {
            if ([messageArray count] == 1) {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = backView.bounds;
                maskLayer.path = maskPath.CGPath;
                backView.layer.mask = maskLayer;
            } else {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = backView.bounds;
                maskLayer.path = maskPath.CGPath;
                backView.layer.mask = maskLayer;
            }
        }
        return cell;
    }
    return cell;
}
-(void)toViewMyGold
{
    ghuntermyAccountViewController *ghuntermyAccount = [[ghuntermyAccountViewController alloc] init];
    [self.navigationController pushViewController:ghuntermyAccount animated:YES];
}
-(void)toViewMyCoupon
{
    ghunterMyCouponViewController * ghunterMyCoupon = [[ghunterMyCouponViewController alloc] init];
    [self.navigationController pushViewController:ghunterMyCoupon animated:YES];
}

- (void)cancelUnreadNoticeStat:(UIButton *)sender {
    [self animateWithSender:sender Completion:nil];
}

- (void)cancelUnreadMessageStat:(UIButton *)sender {
    [self animateWithSender:sender Completion:nil];
}

- (void)animateWithSender:(UIButton *)sender Completion:(void (^)())completion {
    [UIView animateWithDuration:0.05f animations:^{
        sender.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05f animations:^{
            sender.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
}

#pragma mark - 请求网络数据
// 获取通知列表
-(void)didGetNoticeListIsloading:(BOOL )isloading withPage:(NSInteger)p{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?page=%zd", URL_GET_NOTICE_LIST, p] params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        noticeRequested = YES;
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            if (p == 1) {
                if (gunread_notice != [[result objectForKey:@"unread_notice_count"] integerValue]) {
                    gunread_notice = [[result objectForKey:@"unread_notice_count"] integerValue];
                    // 更新全局消息提示数量
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
                }
                
                [taskArray removeAllObjects];
                taskpage = 2;
                NSArray *array = [result valueForKey:@"notices"];
                
                taskArray = [NSMutableArray arrayWithArray:array];
                [noticeTableview reloadData];
                
                noticeTableview.pullTableIsRefreshing = NO;
            }else{
                taskpage++;
                NSArray *array = [result valueForKey:@"notices"];
                [taskArray addObjectsFromArray:array];
                [noticeTableview reloadData];
                noticeTableview.pullTableIsLoadingMore = NO;
            }
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
            if ([[result objectForKey:@"msg"] isEqualToString:@"未登录"]) {
                imgondar_islogin = NO;
                ghunterLoginViewController *login=[[ghunterLoginViewController alloc] init];
                [login setCallBackBlock:^{
                    self.tabBarController.selectedIndex = 3;
                }];
                // 模态跳转，从下往上
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
            }
            noticeTableview.pullTableIsLoadingMore = NO;
            noticeTableview.pullTableIsRefreshing = NO;
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
        noticeTableview.pullTableIsLoadingMore = NO;
        noticeTableview.pullTableIsRefreshing = NO;
    }];
}

// 获取私信列表
-(void)didGetMessageListIsloading:(BOOL )isloading withPage:(NSInteger)p{
    if (isloading) {
        [self startLoad];
    }
    
    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?page=%zd", URL_GET_MESSAGE_NOTICE, p] params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        messageRequested = YES;
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            if (p == 1) {
                if ([[result objectForKey:@"unread_message_count"] integerValue] != gunread_message) {
                    gunread_message = [[result objectForKey:@"unread_message_count"] integerValue];
                    // 更新全局消息提示数量
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
                }
                
                [messageArray removeAllObjects];
                messagepage = 2;
                NSArray *array = [result valueForKey:@"messages"];
                messageArray = [NSMutableArray arrayWithArray:array];
                [messageTableView reloadData];
                
                messageTableView.pullTableIsRefreshing = NO;
            }else{
                messagepage++;
                NSArray *array = [result valueForKey:@"messages"];
                [messageArray addObjectsFromArray:array];
                [messageTableView reloadData];
                
                messageTableView.pullTableIsLoadingMore = NO;
            }
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
            messageTableView.pullTableIsLoadingMore = NO;
            messageTableView.pullTableIsRefreshing = NO;
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
        messageTableView.pullTableIsLoadingMore = NO;
        messageTableView.pullTableIsRefreshing = NO;
    }];
}

#pragma mark - ASIHttpRequest

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSInteger responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_DEAL_UNREAD_MESSAGE]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
           // 更新全局消息的数量
            NSDictionary *msgDic = [messageArray objectAtIndex:msgIndex];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:msgDic];
            [dict setObject:@"0" forKey:@"count"];
            [messageArray replaceObjectAtIndex:msgIndex withObject:dict];
            [messageTableView reloadData];
            
            // 更新全局消息
            gunread_message = gunread_message - [[msgDic objectForKey:@"count"] integerValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
        }
    } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_DELETE_TASK_NOTICE]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [taskArray removeObjectAtIndex:delete_task_num];
            [noticeTableview reloadData];
        }
    } else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_DELETE_MESSAGE_NOTICE]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [messageArray removeObjectAtIndex:delete_message_num];
            [messageTableView reloadData];
        }
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_MARKALL_NOTICE]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            if(_scrollView.contentOffset.x ==0)
            {
                gunread_notice = 0;
                // 刷新通知页面
                for (int i = 0; i < [taskArray count]; i++) {
                    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:[taskArray objectAtIndex:i]];
                    [newDict setObject:@"0" forKey:@"count"];
                    [taskArray replaceObjectAtIndex:i withObject:newDict];
                }
                [noticeTableview reloadData];
            }else if(_scrollView.contentOffset.x == mainScreenWidth)
            {
                gunread_message = 0;
                // 刷新私信页面
                for (int i = 0; i < [messageArray count]; i++) {
                    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:[messageArray objectAtIndex:i]];
                    [newDict setObject:@"0" forKey:@"count"];
                    [messageArray replaceObjectAtIndex:i withObject:newDict];
                }
                [messageTableView reloadData];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
        }
        else if([dic objectForKey:@"msg"])
        {
            // 处理没有未读消息的Bug
            if (_scrollView.contentOffset.x == 0 && gunread_notice > 0) {
                if ([[dic objectForKey:@"msg"]isEqualToString:@"没有未读消息"] ) {
                    gunread_notice = 0;
                    // 刷新通知页面
                    for (int i = 0; i < [taskArray count]; i++) {
                        NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:[taskArray objectAtIndex:i]];
                        [newDict setObject:@"0" forKey:@"count"];
                        [taskArray replaceObjectAtIndex:i withObject:newDict];
                    }
                    [noticeTableview reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
                }
            }
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }
        else
        {
            [ghunterRequester noMsg];
        }
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_CLEANALL_NOTICE]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            if(_scrollView.contentOffset.x ==0)
            {
                [taskArray removeAllObjects];
                [noticeTableview reloadData];
                gunread_notice = 0;
            }
            if(_scrollView.contentOffset.x == mainScreenWidth)
            {
                [messageArray removeAllObjects];
                [messageTableView reloadData];
                gunread_message = 0;
            }
            // 清空所有消息或者私信列表的时候，需要设置gunread_notice和gunread_message为0，并且更新全局UI
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
        }
        else if([dic objectForKey:@"msg"])
        {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }
        else
        {
            [ghunterRequester noMsg];
        }
    }else if([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_DEAL_UNREAD_NOTICE]){
        if (responseCode == 200 && [error_number integerValue] == 0) {
            NSDictionary *noticeDic = [taskArray objectAtIndex:noticeIndex];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:noticeDic];
            [dict setObject:@"0" forKey:@"count"];
            // 替换之前数组里面的消息字典
            [taskArray replaceObjectAtIndex:noticeIndex withObject:dict];
            [noticeTableview reloadData];
            
            // 更新全局消息
            gunread_notice = gunread_notice - [[noticeDic objectForKey:@"count"] integerValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_unread_ui" object:nil];
        }
    }
    [self endLoad];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self endLoad];
    noticeTableview.pullTableIsLoadingMore = NO;
    messageTableView.pullTableIsLoadingMore = NO;
    [ghunterRequester showTip:HTTPREQUEST_ERROR];
}

/*
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
    if(_scrollView.contentOffset.x == 0){
        [self refreshtaskTable];
    }
    if(_scrollView.contentOffset.x == mainScreenWidth){
        [self refreshmessageTable];
    }
}

- (void)loadMoreDataToTable
{
    if(_scrollView.contentOffset.x == 0){
        [self loadmoretaskTable];
    }
    if (_scrollView.contentOffset.x == mainScreenWidth) {
        [self loadmoremessageTable];
    }
}
*/

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
    if(_scrollView.contentOffset.x == 0){
        [self refreshtaskTable];
    }
    if(_scrollView.contentOffset.x == mainScreenWidth){
        [self refreshmessageTable];
    }
}

- (void)loadMoreDataToTable
{
    if(_scrollView.contentOffset.x == 0){
        [self loadmoretaskTable];
    }
    if (_scrollView.contentOffset.x == mainScreenWidth) {
        [self loadmoremessageTable];
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

- (void)refreshtaskTable{
    taskpage = 1;
    [self didGetNoticeListIsloading:NO withPage:taskpage];
}

- (void)loadmoretaskTable{
    [self didGetNoticeListIsloading:NO withPage:taskpage];
}

- (void)refreshmessageTable{
    messagepage = 1;
    [self didGetMessageListIsloading:NO withPage:messagepage];
}

- (void)loadmoremessageTable{
    [self didGetMessageListIsloading:NO withPage:messagepage];
}

- (void)iconTaped:(UITapGestureRecognizer *)sender {
    NSDictionary *taskDic;
    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
    if(_scrollView.contentOffset.x == 0)
    {
        NSInteger tag = sender.view.tag;
        taskDic = [taskArray objectAtIndex:tag];
        userCenter.uid = [taskDic objectForKey:@"fromuid"];
    }
    else
    {
        NSInteger tag = sender.view.tag;
        taskDic = [messageArray objectAtIndex:tag];
        userCenter.uid = [taskDic objectForKey:@"sender_uid"];
    }
    [self.navigationController pushViewController:userCenter animated:YES];
}

- (void)delete_task_notice:(UILongPressGestureRecognizer *)sender {
    if(UIGestureRecognizerStateBegan == sender.state) {
        taskAction = [[UIActionSheet alloc] initWithTitle:@"确定删除这条通知吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        taskAction.tag = sender.view.tag;
        [taskAction showInView:self.view];
    }
}

- (void)delete_message_notice:(UILongPressGestureRecognizer *)sender {
    if(UIGestureRecognizerStateBegan == sender.state) {
        // Called on start of gesture, do work here
        messageAction = [[UIActionSheet alloc] initWithTitle:@"确定删除此私信对话吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        messageAction.tag = sender.view.tag;
        [messageAction showInView:self.view];
    }
}

#pragma mark -UIActionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet == taskAction) {
        if (buttonIndex == 0) {
            delete_task_num = actionSheet.tag;
            NSDictionary *task = [taskArray objectAtIndex:actionSheet.tag];
            [ghunterRequester getwithDelegate:self withUrl:URL_DELETE_TASK_NOTICE withUserInfo:REQUEST_FOR_DELETE_TASK_NOTICE withString:[NSString stringWithFormat:@"?api_session_id=%@&nid=%@",[ghunterRequester getUserInfo:@"api_session_id"],[task objectForKey:@"nid"]]];
        }
    }
    else if (actionSheet == messageAction) {
        if (buttonIndex == 0) {
            delete_message_num = actionSheet.tag;
            NSDictionary *message = [messageArray objectAtIndex:actionSheet.tag];
            [ghunterRequester getwithDelegate:self withUrl:URL_DELETE_MESSAGE_NOTICE withUserInfo:REQUEST_FOR_DELETE_MESSAGE_NOTICE withString:[NSString stringWithFormat:@"?api_session_id=%@&uid=%@",[ghunterRequester getUserInfo:@"api_session_id"],[message objectForKey:@"sender_uid"]]];
        }
    }
    else if (actionSheet == cleanAction)
    {
        if (buttonIndex == 0) {
            [MobClick event:UMEVENT_NOTICE_DELETE_ALL];
            [noticeAlertView dismissAnimated:YES];
            [ghunterRequester postwithDelegate:self withUrl:URL_CLEANALL_NOTICE withUserInfo:REQUEST_FOR_CLEANALL_NOTICE withDictionary:nil];
        }
    }
}
- (IBAction)moreBtn:(UIButton *)sender {
    if(self.scrollView.contentOffset.x == 0)
    {
        noticeAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"noticeSmallView" owner:self options:nil];
        UIView *taskFilter = [[UIView alloc] init];
        taskFilter = [nibs objectAtIndex:0];
        CGRect taskfilterFrame = taskFilter.frame;
        //    taskAlertView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height) / 2.0, taskfilterFrame.size.width, taskfilterFrame.size.height);
        noticeAlertView.containerFrame=CGRectMake(mainScreenWidth-taskfilterFrame.size.width,64, taskfilterFrame.size.width, taskfilterFrame.size.height);
        noticeAlertView.showView = taskFilter;
        noticeAlertView.showView.layer.cornerRadius=0;
        UIButton *markBtn = (UIButton *)[taskFilter viewWithTag:1];
        UIButton *cleanBtn = (UIButton *)[taskFilter viewWithTag:2];
//        UILabel* label1=(UILabel*)[taskFilter viewWithTag:3];
        [markBtn addTarget:self action:@selector(markBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cleanBtn addTarget:self action:@selector(cleanBtn:) forControlEvents:UIControlEventTouchUpInside];
        noticeAlertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        noticeAlertView.transitionStyle = SIAlertViewTransitionStyleFade;
        [noticeAlertView show];
    }
    else
    {
        noticeAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"noticeSmallView1" owner:self options:nil];
        UIView *taskFilter = [[UIView alloc] init];
        taskFilter = [nibs objectAtIndex:0];
        CGRect taskfilterFrame = taskFilter.frame;
        noticeAlertView.containerFrame=CGRectMake(mainScreenWidth-taskfilterFrame.size.width,64, taskfilterFrame.size.width, taskfilterFrame.size.height);
        noticeAlertView.showView = taskFilter;
        noticeAlertView.showView.layer.cornerRadius=0;
        UIButton *markBtn = (UIButton *)[taskFilter viewWithTag:1];
        [markBtn addTarget:self action:@selector(markBtn:) forControlEvents:UIControlEventTouchUpInside];
        noticeAlertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        noticeAlertView.transitionStyle = SIAlertViewTransitionStyleFade;
        [noticeAlertView show];
    }
}
- (void)markBtn:(UIButton *)sender
{
    [noticeAlertView dismissAnimated:YES];
    if (sender.superview.subviews.count == 1) {
        [MobClick event:UMEVENT_MESSAGE_MARK_ALL];
        [ghunterRequester getwithDelegate:self withUrl:URL_MARKALL_MESSAGE withUserInfo:REQUEST_FOR_MARKALL_NOTICE withString:[NSString stringWithFormat:@"?api_session_id=%@",[ghunterRequester getUserInfo:@"api_session_id"]]];
    }else {
        [MobClick event:UMEVENT_MARK_ALL];
        [ghunterRequester getwithDelegate:self withUrl:URL_MARKALL_NOTICE withUserInfo:REQUEST_FOR_MARKALL_NOTICE withString:[NSString stringWithFormat:@"?api_session_id=%@",[ghunterRequester getUserInfo:@"api_session_id"]]];
    }
    taskpage = 1;
    messagepage = 1;
}
- (void)cleanBtn:(UIButton *)sender
{
    cleanAction = [[UIActionSheet alloc] initWithTitle:@"确定取清空所有消息？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    cleanAction.delegate = self;
    [cleanAction showInView:self.view];
}
@end
