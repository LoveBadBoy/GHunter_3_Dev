//
//  ghuntermytaskViewController.m
//  ghunter
//
//  Created by chensonglu on 14-5-19.
//  Copyright (c) 2 015年 ghunter. All rights reserved.
//  我的参与页面

#import "ghunterMyTaskViewController.h"

@interface ghunterMyTaskViewController ()
@property (nonatomic,retain) NSMutableArray *radioArray;
//@property (weak, nonatomic) IBOutlet UILabel *line1;
//@property (weak, nonatomic) IBOutlet UILabel *line2;

@end

@implementation ghunterMyTaskViewController{
    BOOL undoneClick;
    BOOL doneClick;
    
    BOOL doingClick;
    BOOL undonJudgeClick;
    BOOL undonAcceptClick;
    BOOL doingRefundClick;
    
    
    BOOL undoneScroll;
    BOOL doneScroll;
    
    BOOL doingScroll;
    BOOL undonJudgeScroll;
    BOOL undonAcceptScroll;
    BOOL doingRefundScroll;
    
    QRadioButton * _myTaskBtn;
    UIView * _buttomLineView;
    UIScrollView * _btnScroll;
    UIButton * notDidSelBtn;
    
}

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
    // Do any additional setup after loading the view from its nib.
    biddingpage = 1;
    undonepage = 1;
    donepage = 1;
    
    //
    doingpage = 1;
    undoneAcceptPage = 1;
    undoneJudgePage = 1;
    doingRefundPage = 1;
    
    biddingArray = [[NSMutableArray alloc]init];
    undoneArray = [[NSMutableArray alloc] init];
    doneArray = [[NSMutableArray alloc] init];
    
    //
    doingArray = [[NSMutableArray alloc] init];
    undoneJudgeArray = [[NSMutableArray alloc] init];
    undoneAcceptArray = [[NSMutableArray alloc] init];
    doingRefundArray = [[NSMutableArray alloc] init];
    
    
    notfinishRequested = NO;
    finishRequested = NO;
    
    undoneClick = NO;
    doneClick = NO;
    
    doingClick = NO;
    undonAcceptClick = NO;
    undonJudgeClick = NO;
    doingRefundClick = NO;
    
    undoneScroll = NO;
    doneScroll = NO;
    
    doingScroll = NO;
    undonAcceptScroll = NO;
    undonJudgeScroll = NO;
    doingRefundScroll = NO;
    
    
    // 请求上面小红点数据
    [self didGetMyJoinNumberIsloading:NO];
    
}


- (void)createUI {
    
    _buttomLineView = [[UIView alloc] initWithFrame:CGRectMake(5, 32, mainScreenWidth / 7, 1.5)];
    _buttomLineView.backgroundColor = RGBCOLOR(234, 85, 20);
    
    NSArray * titleArr = @[@"竞标中", @"进行中", @"待评价", @"待接受", @"已完成", @"退款中", @"未完成"];
    
    // 滚动条
    buttonScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, 34)];
    buttonScroll.bounces = NO;
    buttonScroll.contentSize = CGSizeMake(mainScreenWidth, 30);
    buttonScroll.showsHorizontalScrollIndicator = NO;
    buttonScroll.showsVerticalScrollIndicator = NO;
    buttonScroll.tag = 1010;
    buttonScroll.delegate = self;
    buttonScroll.pagingEnabled = NO;
    buttonScroll.backgroundColor = [UIColor whiteColor];
    _btnScroll = buttonScroll;
    
    float btnWidth = (mainScreenWidth+90) / 7;
    // 创建滑动条上的按钮
    for (int i = 1; i <= 7; i++) {
        
        _myTaskBtn = [[QRadioButton alloc] initWithDelegate:self groupId:@"mytaskGroup"];
        
        _myTaskBtn.frame = CGRectMake((i - 1) * (btnWidth + 10), 1, btnWidth, 33);
        _myTaskBtn.backgroundColor = [UIColor whiteColor];
        
        numLabel.tag = 2000 + i;
        if (i == 2) {
            numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myTaskBtn.frame.size.width - 10, _myTaskBtn.center.y - 8, 13, 13)];
            numLabel.text = [NSString stringWithFormat:@"%ld", (long)doingNum];
            if (doingNum == 0) {
                numLabel.hidden = YES;
            }
            [_myTaskBtn addSubview:numLabel];
        }else if (i == 3){
            numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myTaskBtn.frame.size.width - 10, _myTaskBtn.center.y - 8, 13, 13)];
            numLabel.text = [NSString stringWithFormat:@"%ld", (long)valuateNum];

            if (valuateNum == 0) {
                numLabel.hidden = YES;
            }
            [_myTaskBtn addSubview:numLabel];
        }else if (i == 4) {
            numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myTaskBtn.frame.size.width - 10, _myTaskBtn.center.y - 8, 13, 13)];
            numLabel.text = [NSString stringWithFormat:@"%ld", (long)acceptNum];
            if (acceptNum == 0) {
                numLabel.hidden = YES;
            }
            [_myTaskBtn addSubview:numLabel];
        }else if(i == 6){
            numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myTaskBtn.frame.size.width - 10, _myTaskBtn.center.y - 8, 13, 13)];
            numLabel.text = [NSString stringWithFormat:@"%ld", (long)withDrawNum];
            if (withDrawNum == 0) {
                numLabel.hidden = YES;
            }
            [_myTaskBtn addSubview:numLabel];
        }
        
        numLabel.textColor = [UIColor whiteColor];
        numLabel.backgroundColor = [UIColor redColor];
        numLabel.layer.cornerRadius = 6.5;
        numLabel.clipsToBounds = YES;
        numLabel.font = [UIFont systemFontOfSize:9];
        numLabel.textAlignment = NSTextAlignmentCenter;

        float lineBtnX = i * btnWidth + (i - 1) * 10 + 4;
        if (i<7) {
            UIButton * lineBtn = [[UIButton alloc] initWithFrame:CGRectMake(lineBtnX, 10, 1, 14)];
            lineBtn.alpha = 0.5;
            lineBtn.backgroundColor = [UIColor grayColor];
            lineBtn.backgroundColor = [UIColor grayColor];
            
            [buttonScroll addSubview:lineBtn];
        }
        
        
        [_myTaskBtn setTitle:[NSString stringWithFormat:@"%@", titleArr[i - 1]] forState:UIControlStateNormal];
        _myTaskBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_myTaskBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _myTaskBtn.userInteractionEnabled = YES;
        _myTaskBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _myTaskBtn.tag = i + 1000;
        [_myTaskBtn addTarget:self action:@selector(taskScrollBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_myTaskBtn.tag == 1001) {
            notDidSelBtn = _myTaskBtn;
            
            [_myTaskBtn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
        }
        
        
        
        [buttonScroll addSubview:_myTaskBtn];
    }
    
    [buttonScroll addSubview:_buttomLineView];
    [self.view addSubview:buttonScroll];
    
    dataScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64 + 35, mainScreenWidth, mainScreenheight - 64 - 35)];
    dataScroll.contentSize = CGSizeMake(mainScreenWidth * 7, [UIScreen mainScreen].bounds.size.height - 20 - 44 - 35);
    dataScroll.delegate = self;
    dataScroll.showsHorizontalScrollIndicator = NO;
    dataScroll.showsVerticalScrollIndicator = NO;
    dataScroll.bounces = NO;
    dataScroll.pagingEnabled = YES;
    dataScroll.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:dataScroll];
    
    // 竞标中
    biddingTableview = [[PullTableView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, dataScroll.frame.size.height) style:UITableViewStylePlain];
    biddingTableview.delegate = self;
    biddingTableview.dataSource = self;
    biddingTableview.pullDelegate = self;
    biddingTableview.showsVerticalScrollIndicator = NO;
    biddingTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    biddingTableview.backgroundColor = [UIColor clearColor];
    biddingTableview.tag = 1001;
    
    [dataScroll addSubview:biddingTableview];
    
    // 进行中
    doingTableView = [[PullTableView alloc]initWithFrame:CGRectMake(mainScreenWidth*1, 0, mainScreenWidth, dataScroll.frame.size.height)];
    doingTableView.delegate = self;
    doingTableView.dataSource = self;
    doingTableView.pullDelegate = self;
    doingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    doingTableView.showsVerticalScrollIndicator = NO;
    doingTableView.backgroundColor = [UIColor clearColor];
    doingTableView.tag = 1002;
    [dataScroll addSubview:doingTableView];
    
    // 待评价
    undoneJudgeTableView = [[PullTableView alloc]initWithFrame:CGRectMake(mainScreenWidth*2, 0, mainScreenWidth, dataScroll.frame.size.height)];
    undoneJudgeTableView.delegate = self;
    undoneJudgeTableView.dataSource = self;
    undoneJudgeTableView.pullDelegate = self;
    undoneJudgeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    undoneJudgeTableView.showsVerticalScrollIndicator = NO;
    undoneJudgeTableView.backgroundColor = [UIColor clearColor];
    undoneTableView.tag = 1003;
    [dataScroll addSubview:undoneJudgeTableView];
    
    // 待接受
    undoneAcceptTableView = [[PullTableView alloc]initWithFrame:CGRectMake(mainScreenWidth*3, 0, mainScreenWidth, dataScroll.frame.size.height) style:UITableViewStylePlain];
    undoneAcceptTableView.delegate = self;
    undoneAcceptTableView.dataSource = self;
    undoneAcceptTableView.pullDelegate = self;
    undoneAcceptTableView.showsVerticalScrollIndicator = NO;
    undoneAcceptTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    undoneAcceptTableView.backgroundColor = [UIColor clearColor];
    [dataScroll addSubview:undoneAcceptTableView];
    
    // 已完成
    doneTableView = [[PullTableView alloc]initWithFrame:CGRectMake(mainScreenWidth*4, 0, mainScreenWidth, dataScroll.frame.size.height)];
    doneTableView.delegate = self;
    doneTableView.dataSource = self;
    doneTableView.pullDelegate = self;
    doneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    doneTableView.showsVerticalScrollIndicator = NO;
    doneTableView.backgroundColor = [UIColor clearColor];
    [dataScroll addSubview:doneTableView];
    
    
    // 退款中
    doingRefundTableView = [[PullTableView alloc]initWithFrame:CGRectMake(mainScreenWidth*5, 0, mainScreenWidth, dataScroll.frame.size.height)];
    doingRefundTableView.delegate = self;
    doingRefundTableView.dataSource = self;
    doingRefundTableView.pullDelegate = self;
    doingRefundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    doingRefundTableView.showsVerticalScrollIndicator = NO;
    doingRefundTableView.backgroundColor = [UIColor clearColor];
    [dataScroll addSubview:doingRefundTableView];
    
    // 未完成
    undoneTableView = [[PullTableView alloc]initWithFrame:CGRectMake(mainScreenWidth*6, 0, mainScreenWidth, dataScroll.frame.size.height) style:UITableViewStylePlain];
    undoneTableView.delegate = self;
    undoneTableView.dataSource = self;
    undoneTableView.pullDelegate = self;
    undoneTableView.showsVerticalScrollIndicator = NO;
    undoneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    undoneTableView.backgroundColor = [UIColor clearColor];
    [dataScroll addSubview:undoneTableView];
    
    
    [self.view addSubview:dataScroll];
    
    
    [self startLoad];
    [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_BIDDING withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"bidding",biddingpage]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.alpha = 0;
    
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.loadingView = nil;
}

-(void)didGetMyJoinNumberIsloading:(BOOL)isloading {
    
    if (isloading) {
        [self startLoad];
    }
    
    
    [AFNetworkTool httpRequestWithUrl:URL_MY_JOIN params:nil success:^(NSData *data) {
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            NSDictionary * numDic = [result objectForKey:@"taskNum"];
            
            
            doingNum = [[NSString stringWithFormat:@"%@", [numDic objectForKey:@"doing"]] intValue];
            acceptNum = [[NSString stringWithFormat:@"%@", [numDic objectForKey:@"accept_count"]] intValue];
            withDrawNum = [[NSString stringWithFormat:@"%@", [numDic objectForKey:@"withdraw_count"]] intValue];
            valuateNum = [[NSString stringWithFormat:@"%@", [numDic objectForKey:@"valuate_count"]] intValue];
            
            [self createUI];
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


#pragma mark --- button点击事件
- (void) taskScrollBtnClick:(UIButton *) btn {
    
    
    NSInteger page = btn.tag - 1001;
    
    // 点击会触发页面滑动事件，从而调用scrollViewDidScroll方法，造成重复加载
    // 解决方法，当点击radioButton的时候，增加标志位，scrollViewDidScroll不应该加载数据
    
    
    NSTimeInterval animationDuration = 0.20f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [dataScroll setContentOffset:CGPointMake(mainScreenWidth*page, 0)];
    
    [UIView commitAnimations];
}


#pragma mark - UIScrollViewDelegate
#pragma mark --- 监听滚动 ---
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = dataScroll.frame.size.width;
    int page = floor(dataScroll.contentOffset.x / pageWidth);
    
    
    UIButton * btn = (UIButton *)[self.view viewWithTag:1001 + page];
    if (btn != notDidSelBtn) {
        
        [notDidSelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(234, 85, 20) forState:UIControlStateNormal];
        
        notDidSelBtn = btn;
    }
    
    
    //    float bigX = scrollView.bounds.size.width / _btnScroll.bounds.size.width;
    float littleX = 200 / (8 * mainScreenWidth);
    
    CGRect frame = _buttomLineView.frame;
    frame.size.width = _myTaskBtn.frame.size.width;
    frame.origin.x = btn.frame.origin.x;
    
    _buttomLineView.frame = frame;
    _btnScroll.contentOffset = CGPointMake(dataScroll.contentOffset.x * littleX, dataScroll.contentOffset.y);
    
    if(page == 0){
    }
    
    // 进行中
    else if (page == 1){
        
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_DOING withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"doing",doingpage]];
    }
    
    // 待评价
    else if (page == 2){
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_UNVALUATION withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"unValuation",undoneJudgePage]];
    }
    
    // 待接受
    else if (page == 3){
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_ORIENT_PRIVATE_WAITING withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"orient_private_waiting",undoneAcceptPage]];
    }

    
    // 已完成
    else if(page == 4) {
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_DONE withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"done",donepage]];

    }
    // 退款中
    else if (page == 5){
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_APPLY_WITHDRAW withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"apply_withdraw",doingRefundPage]];
    }
    

    // 未完成
    else if (page == 6){
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_WITHDRAWED withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"withdrawed",undonepage]];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) return;
    ghuntertaskViewController *ghuntertask = [[ghuntertaskViewController alloc] init];
    NSDictionary *task;
    if(tableView == biddingTableview){
        task = [biddingArray objectAtIndex:indexPath.row - 1];
    }else if(tableView == doingTableView){
        task = [doingArray objectAtIndex:indexPath.row - 1];
    }else if(tableView == undoneJudgeTableView){
        task = [undoneJudgeArray objectAtIndex:indexPath.row - 1];
    }else if(tableView == undoneAcceptTableView){
        task = [undoneAcceptArray objectAtIndex:indexPath.row - 1];
    }else if(tableView == undoneTableView){
        task = [undoneArray objectAtIndex:indexPath.row - 1];
    }else if(tableView == doingRefundTableView){
        task = [doingRefundArray objectAtIndex:indexPath.row - 1];
    }else if(tableView == doneTableView){
        task = [doneArray objectAtIndex:indexPath.row - 1];
    }

    ghuntertask.tid = [task objectForKey:@"tid"];
    
    ghuntertask.callBackBlock = ^{};
    [self.navigationController pushViewController:ghuntertask animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == biddingTableview){
        NSInteger count = [biddingArray count];
        if(count == 0) {
            
            return 0;
        }
        else return count + 1;
    }else if(tableView == doingTableView){
        NSInteger count = [doingArray count];
        if(count == 0) {
            
            return 0;
        }
        else return count + 1;
    }else if(tableView == undoneJudgeTableView){
        NSInteger count = [undoneJudgeArray count];
        if(count == 0) {
            
            return 0;
        }
        else return count + 1;
    }else if (tableView == undoneAcceptTableView){
        NSInteger count = [undoneAcceptArray count];
        if(count == 0) {
            
            return 0;
        }
        else return count + 1;
    }else if (tableView == doneTableView){
        NSInteger count = [doneArray count];
        if(count == 0) {
            
            return 0;
        }
        else return count + 1;
    }else if (tableView == doingRefundTableView){
        NSInteger count = [doingRefundArray count];
        if(count == 0) {

            return 0;
        }
        else return count + 1;
    }else if (tableView == undoneTableView){
        NSInteger count = [undoneArray count];
        if(count == 0) {
            
            return 0;
        }
        else return count + 1;
    }
    
    return 0;
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
    // 竞标中
    if(tableView == biddingTableview){
        if(indexPath.row == 0){
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"descriptionView" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = 0;
            cell.frame = cellFrame;
        } else {
            NSDictionary *biddingDic = [biddingArray objectAtIndex:indexPath.row - 1];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"mytaskCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *taskTitle = (UILabel *)[cell viewWithTag:2];
            OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:3];
            OHAttributedLabel *description = (OHAttributedLabel *)[cell viewWithTag:118];
//            UIImageView *round = (UIImageView *)[cell viewWithTag:7];
            NSString *descriptionStr = [NSString stringWithFormat:@"%@人竞标",[biddingDic objectForKey:@"biddingnum"]];
            [description setText:descriptionStr];
            [taskTitle setText:[biddingDic objectForKey:@"title"]];
            NSString *bountySelf = [biddingDic objectForKey:@"bounty"];
            NSString *bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
            NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
//            [attrStr setFont:[UIFont systemFontOfSize:14.0] range:NSMakeRange([bountySelf length], 1)];
//            [attrStr setFont:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, [bountySelf length])];
            [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0]];
            [bounty setFont:[UIFont systemFontOfSize:12]];
            [bounty setAttributedText:attrStr];
            
            // 线上
            lineOn = (UILabel *)[cell viewWithTag:69];
            lineOn.text = [NSString stringWithFormat:@"%@", [biddingDic objectForKey:@"c_name"]];
            lineOn.font = [UIFont systemFontOfSize:10];
            lineOn.clipsToBounds = YES;
            lineOn.layer.cornerRadius = 3.0;
            [lineOn.layer setBorderWidth:1.0];   //边框宽度
            lineOn.textAlignment = NSTextAlignmentCenter;
        
            NSString * str = [biddingDic objectForKey:@"fcid"];
            [self judgeTextColor:str];

            // 私密或公开
            UILabel * openLb = (UILabel *)[cell viewWithTag:67];
            UILabel * openLbWidth = (UILabel *)[cell viewWithTag:167];
            openLbWidth.layer.cornerRadius = 3;

            UIImageView * imgV = (UIImageView *)[cell viewWithTag:66];
            
            if ([[biddingDic objectForKey:@"type"] isEqualToString:@"0"]) {
                
                openLb.text = @"普通";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[biddingDic objectForKey:@"type"] isEqualToString:@"1"]){
                
                openLb.text = @"公开";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[biddingDic objectForKey:@"type"] isEqualToString:@"2"]) {
                
                openLb.text = @"私密";
                openLb.textColor = RGBCOLOR(204, 204, 204);
                [openLbWidth.layer setBorderColor:RGBCOLOR(204, 204, 204).CGColor];
                imgV.image = [UIImage imageNamed:@"私密"];
            }
            
            openLb.clipsToBounds = YES;
            openLb.layer.cornerRadius = 3.0;
            [openLbWidth.layer setBorderWidth:1.0];
            openLb.textAlignment = NSTextAlignmentRight;
            
            NSString *LENstr = [biddingDic objectForKey:@"c_name"];
            if ([LENstr length] > 1) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 30;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 2) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 40;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 3) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 50;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }

            UIImageView * goldImgV = (UIImageView *)[cell viewWithTag:13];
            
            CGRect bountyFrame = bounty.frame;
            CGRect goldImgFrame = goldImgV.frame;
            CGSize bountySize = [bountyStr sizeWithFont:bounty.font];
            
            bountyFrame.size.width = bountySize.width + 10;
            bountyFrame.origin.x = mainScreenWidth - 10 - bountySize.width;
            goldImgFrame.origin.x = cell.frame.size.width - bountySize.width - 35;
            bountyFrame.origin.y = taskTitle.frame.origin.y + 4;
            
            bounty.frame = bountyFrame;
            goldImgV.frame = goldImgFrame;
            bounty.textAlignment = NSTextAlignmentCenter;
            
            CGRect descFrame = description.frame;
            
            CGSize descSize = [descriptionStr sizeWithFont:description.font];
            
            descFrame.size.width = descSize.width;
            descFrame.origin.x = mainScreenWidth - descSize.width - 10;
            description.textAlignment = NSTextAlignmentRight;
            description.font = [UIFont systemFontOfSize:10];
            
            CGRect celFrame = cell.frame;
            celFrame.size.height = openLb.frame.origin.y + 37;
            cell.frame = celFrame;
            
            descFrame.origin.y = cell.frame.size.height - 23;
            description.frame = descFrame;
            
            CGRect openLbFrameWidth = openLbWidth.frame;
            openLbFrameWidth.origin.y = description.frame.origin.y - 4;
            openLbWidth.frame = openLbFrameWidth;
            
            CGRect openLbFrame = openLb.frame;
            openLbFrame.origin.y = description.frame.origin.y - 3;
            openLb.frame = openLbFrame;
            
            CGRect imgFrame = imgV.frame;
            imgFrame.origin.y = description.frame.origin.y - 3;
            imgV.frame = imgFrame;
            
        }
        return cell;
    }
    // 进行中
    if(tableView == doingTableView){
        if(indexPath.row == 0){
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"descriptionView" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = 0;
            cell.frame = cellFrame;
        } else {
            NSDictionary *doingDic = [doingArray objectAtIndex:indexPath.row - 1];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"mytaskCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *taskTitle = (UILabel *)[cell viewWithTag:2];
            OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:3];
//            UIImageView *catalog = (UIImageView *)[cell viewWithTag:4];
            UIView *bg = (UIView *)[cell viewWithTag:5];
            OHAttributedLabel *description = (OHAttributedLabel *)[cell viewWithTag:118];
            NSString *descriptionStr = [NSString stringWithFormat:@"%@人竞标",[doingDic objectForKey:@"biddingnum"]];
            [description setText:descriptionStr];
            [description setText:descriptionStr];
            [taskTitle setText:[doingDic objectForKey:@"title"]];
            NSString *bountySelf = [doingDic objectForKey:@"bounty"];
            NSString *bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
            NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
            [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0]];
            [bounty setFont:[UIFont systemFontOfSize:12]];
            [bounty setAttributedText:attrStr];
  
            // 线上
            lineOn = (UILabel *)[cell viewWithTag:69];
            lineOn.text = [NSString stringWithFormat:@"%@", [doingDic objectForKey:@"c_name"]];
            lineOn.font = [UIFont systemFontOfSize:10];
            lineOn.clipsToBounds = YES;
            lineOn.layer.cornerRadius = 3.0;
            [lineOn.layer setBorderWidth:1.0];   //边框宽度
            lineOn.textAlignment = NSTextAlignmentCenter;
    
            // 私密或公开
            UILabel * openLb = (UILabel *)[cell viewWithTag:67];
            UILabel * openLbWidth = (UILabel *)[cell viewWithTag:167];
            openLbWidth.layer.cornerRadius = 3;

            UIImageView * imgV = (UIImageView *)[cell viewWithTag:66];
            if ([[doingDic objectForKey:@"type"] isEqualToString:@"0"]) {
                
                openLb.text = @"普通";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[doingDic objectForKey:@"type"] isEqualToString:@"1"]){
                
                openLb.text = @"公开";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[doingDic objectForKey:@"type"] isEqualToString:@"2"]) {
                
                openLb.text = @"私密";
                openLb.textColor = RGBCOLOR(204, 204, 204);
                [openLbWidth.layer setBorderColor:RGBCOLOR(204, 204, 204).CGColor];
                imgV.image = [UIImage imageNamed:@"私密"];
            }
            
            openLb.clipsToBounds = YES;
            openLb.layer.cornerRadius = 3.0;
            [openLbWidth.layer setBorderWidth:1.0];
            openLb.textAlignment = NSTextAlignmentRight;

            [self judgeTextColor:[doingDic objectForKey:@"fcid"]];
           
            
            NSString *LENstr = [doingDic objectForKey:@"c_name"];
            if ([LENstr length] > 1) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 30;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 2) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 40;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 3) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 50;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            

            UIImageView * goldImgV = (UIImageView *)[cell viewWithTag:13];
            
            CGRect bountyFrame = bounty.frame;
            CGRect goldImgFrame = goldImgV.frame;
            CGSize bountySize = [bountyStr sizeWithFont:bounty.font];
            
            bountyFrame.size.width = bountySize.width + 10;
            bountyFrame.origin.x = mainScreenWidth - 10 - bountySize.width;
            goldImgFrame.origin.x = cell.frame.size.width - bountySize.width - 30;
            bountyFrame.origin.y = taskTitle.frame.origin.y + 4;
            
            bounty.frame = bountyFrame;
            goldImgV.frame = goldImgFrame;
            bounty.textAlignment = NSTextAlignmentCenter;
            
            CGRect descFrame = description.frame;
            
            CGSize descSize = [descriptionStr sizeWithFont:description.font];
            
            descFrame.size.width = descSize.width;
            descFrame.origin.x = mainScreenWidth - descSize.width - 10;
            description.textAlignment = NSTextAlignmentRight;
            description.font = [UIFont systemFontOfSize:10];
            
            descFrame.origin.y = cell.frame.size.height - 23;
            description.frame = descFrame;

            CGRect openLbFrameWidth = openLbWidth.frame;
            openLbFrameWidth.origin.y = description.frame.origin.y - 4;
            openLbWidth.frame = openLbFrameWidth;
            
            CGRect openLbFrame = openLb.frame;
            openLbFrame.origin.y = description.frame.origin.y - 3;
            openLb.frame = openLbFrame;
            
            CGRect imgFrame = imgV.frame;
            imgFrame.origin.y = description.frame.origin.y - 3;
            imgV.frame = imgFrame;
        }
        return cell;
    }
    
    // 待评价
    else if(tableView == undoneJudgeTableView) {
        if(indexPath.row == 0){
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"descriptionView" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = 0;
            cell.frame = cellFrame;
        } else {
            NSDictionary *undoneDic = [undoneJudgeArray objectAtIndex:indexPath.row - 1];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"mytaskCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            OHAttributedLabel *status = (OHAttributedLabel *)[cell viewWithTag:1];
            UILabel *taskTitle = (UILabel *)[cell viewWithTag:2];
            OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:3];
            UIImageView *catalog = (UIImageView *)[cell viewWithTag:4];
            UIView *bg = (UIView *)[cell viewWithTag:5];
            UIImageView *round = (UIImageView *)[cell viewWithTag:7];
            
            OHAttributedLabel *description = (OHAttributedLabel *)[cell viewWithTag:118];
            NSString *descriptionStr = [NSString stringWithFormat:@"%@人竞标",[undoneDic objectForKey:@"biddingnum"]];
            [description setText:descriptionStr];
            
            NSString *statusStr = [undoneDic objectForKey:@"statusname"];
            CGSize statusSize = [statusStr sizeWithFont:status.font constrainedToSize:CGSizeMake(status.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect statuFrame = status.frame;
            statuFrame.origin.y = bg.frame.origin.y + 20;
            statuFrame.size.height = statusSize.height;
            [status setFrame:statuFrame];
            [status setText:statusStr];
            
            [taskTitle setText:[undoneDic objectForKey:@"title"]];
            NSString *bountySelf = [undoneDic objectForKey:@"bounty"];
            NSString *bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
            NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];

            [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0]];
            [bounty setFont:[UIFont systemFontOfSize:12]];
            [bounty setAttributedText:attrStr];
            
            [catalog setImage:[UIImage imageNamed:[ghunterRequester getTaskCatalogImg:[undoneDic objectForKey:@"pcid"]]]];
            CGFloat top = 20; // 顶端盖高度
            CGFloat bottom = bg.frame.size.height - top - 1; // 底端盖高度
            CGFloat left = 8; // 左端盖宽度
            CGFloat right = bg.frame.size.width - left - 1; // 右端盖宽度
            UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
            // 指定为拉伸模式，伸缩后重新赋值
            UIImage *image = [UIImage imageNamed:@"task_angle_round"];
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            [round setImage:image];
            
            
            // 线上
            lineOn = (UILabel *)[cell viewWithTag:69];
            lineOn.text = [NSString stringWithFormat:@"%@", [undoneDic objectForKey:@"c_name"]];
            lineOn.font = [UIFont systemFontOfSize:10];
            lineOn.clipsToBounds = YES;
            lineOn.layer.cornerRadius = 3.0;
            [lineOn.layer setBorderWidth:1.0];   //边框宽度
            lineOn.textAlignment = NSTextAlignmentCenter;
            lineOn.textColor = [UIColor redColor];
            [lineOn.layer setBorderColor:[UIColor redColor].CGColor];//边框颜色
            [self judgeTextColor:[undoneDic objectForKey:@"fcid"]];;
            
            
            // 私密或公开
            UILabel * openLb = (UILabel *)[cell viewWithTag:67];
            UILabel * openLbWidth = (UILabel *)[cell viewWithTag:167];
            openLbWidth.layer.cornerRadius = 3;

            UIImageView * imgV = (UIImageView *)[cell viewWithTag:66];
            if ([[undoneDic objectForKey:@"type"] isEqualToString:@"0"]) {
                
                openLb.text = @"普通";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[undoneDic objectForKey:@"type"] isEqualToString:@"1"]){
                
                openLb.text = @"公开";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[undoneDic objectForKey:@"type"] isEqualToString:@"2"]) {
                
                openLb.text = @"私密";
                openLb.textColor = RGBCOLOR(204, 204, 204);
                [openLbWidth.layer setBorderColor:RGBCOLOR(204, 204, 204).CGColor];
                imgV.image = [UIImage imageNamed:@"私密"];
            }
            
            
            openLb.clipsToBounds = YES;
            openLb.layer.cornerRadius = 3.0;
            [openLbWidth.layer setBorderWidth:1.0];
            openLb.textAlignment = NSTextAlignmentRight;
            
            
            NSString *LENstr = [undoneDic objectForKey:@"c_name"];
            if ([LENstr length] > 1) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 30;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 2) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 40;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 3) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 50;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }

            UIImageView * goldImgV = (UIImageView *)[cell viewWithTag:13];
            
            CGRect bountyFrame = bounty.frame;
            CGRect goldImgFrame = goldImgV.frame;
            CGSize bountySize = [bountyStr sizeWithFont:bounty.font];
            
            bountyFrame.size.width = bountySize.width + 10;
            bountyFrame.origin.x = mainScreenWidth - 10 - bountySize.width;
            goldImgFrame.origin.x = cell.frame.size.width - bountySize.width - 35;
            bountyFrame.origin.y = taskTitle.frame.origin.y + 4;
            
            bounty.frame = bountyFrame;
            goldImgV.frame = goldImgFrame;
            bounty.textAlignment = NSTextAlignmentCenter;
            
            CGRect descFrame = description.frame;
            
            CGSize descSize = [descriptionStr sizeWithFont:description.font];
            
            descFrame.size.width = descSize.width;
            descFrame.origin.x = mainScreenWidth - descSize.width - 10;
            description.textAlignment = NSTextAlignmentRight;
            description.font = [UIFont systemFontOfSize:10];
            
            CGRect celFrame = cell.frame;
            celFrame.size.height = openLb.frame.origin.y + 37;
            cell.frame = celFrame;
            
            descFrame.origin.y = cell.frame.size.height - 23;
            description.frame = descFrame;

            CGRect openLbFrameWidth = openLbWidth.frame;
            openLbFrameWidth.origin.y = description.frame.origin.y - 4;
            openLbWidth.frame = openLbFrameWidth;
            //
            CGRect openLbFrame = openLb.frame;
            openLbFrame.origin.y = description.frame.origin.y - 3;
            openLb.frame = openLbFrame;
            
            CGRect imgFrame = imgV.frame;
            imgFrame.origin.y = description.frame.origin.y - 3;
            imgV.frame = imgFrame;
        }
        return cell;
    }
    //待接受
    else if(tableView == undoneAcceptTableView) {
        if(indexPath.row == 0){
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"descriptionView" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = 0;
            cell.frame = cellFrame;
        } else {
            NSDictionary *undoneDic = [undoneAcceptArray objectAtIndex:indexPath.row - 1];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"mytaskCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            OHAttributedLabel *status = (OHAttributedLabel *)[cell viewWithTag:1];
            UILabel *taskTitle = (UILabel *)[cell viewWithTag:2];
            OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:3];
            UIImageView *catalog = (UIImageView *)[cell viewWithTag:4];
            UIView *bg = (UIView *)[cell viewWithTag:5];
            UIImageView *round = (UIImageView *)[cell viewWithTag:7];
            
            OHAttributedLabel *description = (OHAttributedLabel *)[cell viewWithTag:118];
            NSString *descriptionStr = [NSString stringWithFormat:@"%@人竞标",[undoneDic objectForKey:@"biddingnum"]];
            [description setText:descriptionStr];
            
            NSString *statusStr = [undoneDic objectForKey:@"statusname"];
            CGSize statusSize = [statusStr sizeWithFont:status.font constrainedToSize:CGSizeMake(status.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect statuFrame = status.frame;
            statuFrame.origin.y = bg.frame.origin.y + 20;
            statuFrame.size.height = statusSize.height;
            [status setFrame:statuFrame];
            [status setText:statusStr];
            
            [taskTitle setText:[undoneDic objectForKey:@"title"]];
            NSString *bountySelf = [undoneDic objectForKey:@"bounty"];
            NSString *bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
            NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
//            [attrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange([bountySelf length], 1)];
//            [attrStr setFont:[UIFont systemFontOfSize:22.0] range:NSMakeRange(0, [bountySelf length])];
            [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0]];
            [bounty setFont:[UIFont systemFontOfSize:12]];
            [bounty setAttributedText:attrStr];
            
            [catalog setImage:[UIImage imageNamed:[ghunterRequester getTaskCatalogImg:[undoneDic objectForKey:@"pcid"]]]];
            CGFloat top = 20; // 顶端盖高度
            CGFloat bottom = bg.frame.size.height - top - 1; // 底端盖高度
            CGFloat left = 8; // 左端盖宽度
            CGFloat right = bg.frame.size.width - left - 1; // 右端盖宽度
            UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
            // 指定为拉伸模式，伸缩后重新赋值
            UIImage *image = [UIImage imageNamed:@"task_angle_round"];
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            [round setImage:image];
            
            
            // 线上
            lineOn = (UILabel *)[cell viewWithTag:69];
            lineOn.text = [NSString stringWithFormat:@"%@", [undoneDic objectForKey:@"c_name"]];
            lineOn.font = [UIFont systemFontOfSize:10];
            lineOn.clipsToBounds = YES;
            lineOn.layer.cornerRadius = 3.0;
            [lineOn.layer setBorderWidth:1.0];   //边框宽度
            lineOn.textAlignment = NSTextAlignmentCenter;
            lineOn.textColor = [UIColor redColor];
            [lineOn.layer setBorderColor:[UIColor redColor].CGColor];//边框颜色
            [self judgeTextColor:[undoneDic objectForKey:@"fcid"]];;
            
            
            // 私密或公开
            UILabel * openLb = (UILabel *)[cell viewWithTag:67];
            UILabel * openLbWidth = (UILabel *)[cell viewWithTag:167];
            openLbWidth.layer.cornerRadius = 3;

            UIImageView * imgV = (UIImageView *)[cell viewWithTag:66];
            if ([[undoneDic objectForKey:@"type"] isEqualToString:@"0"]) {
                
                openLb.text = @"普通";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[undoneDic objectForKey:@"type"] isEqualToString:@"1"]){
                
                openLb.text = @"公开";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[undoneDic objectForKey:@"type"] isEqualToString:@"2"]) {
                
                openLb.text = @"私密";
                openLb.textColor = RGBCOLOR(204, 204, 204);
                [openLbWidth.layer setBorderColor:RGBCOLOR(204, 204, 204).CGColor];
                imgV.image = [UIImage imageNamed:@"私密"];
            }

            
            openLb.clipsToBounds = YES;
            openLb.layer.cornerRadius = 3.0;
            [openLbWidth.layer setBorderWidth:1.0];
            openLb.textAlignment = NSTextAlignmentRight;
            
            
            NSString *LENstr = [undoneDic objectForKey:@"c_name"];
            if ([LENstr length] > 1) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 30;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 2) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 40;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 3) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 50;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            
            UIImageView * goldImgV = (UIImageView *)[cell viewWithTag:13];
            
            CGRect bountyFrame = bounty.frame;
            CGRect goldImgFrame = goldImgV.frame;
            CGSize bountySize = [bountyStr sizeWithFont:bounty.font];
            
            bountyFrame.size.width = bountySize.width + 10;
            bountyFrame.origin.x = mainScreenWidth - 10 - bountySize.width;
            goldImgFrame.origin.x = cell.frame.size.width - bountySize.width - 35;
            bountyFrame.origin.y = taskTitle.frame.origin.y + 4;
            
            bounty.frame = bountyFrame;
            goldImgV.frame = goldImgFrame;
            bounty.textAlignment = NSTextAlignmentCenter;
            
            CGRect descFrame = description.frame;
            
            CGSize descSize = [descriptionStr sizeWithFont:description.font];
            
            descFrame.size.width = descSize.width;
            descFrame.origin.x = mainScreenWidth - descSize.width - 10;
            description.textAlignment = NSTextAlignmentRight;
            description.font = [UIFont systemFontOfSize:10];
            
            CGRect celFrame = cell.frame;
            celFrame.size.height = openLb.frame.origin.y + 37;
            cell.frame = celFrame;
            
            descFrame.origin.y = cell.frame.size.height - 23;
            description.frame = descFrame;
            
            CGRect openLbFrameWidth = openLbWidth.frame;
            openLbFrameWidth.origin.y = description.frame.origin.y - 4;
            openLbWidth.frame = openLbFrameWidth;
            //
            CGRect openLbFrame = openLb.frame;
            openLbFrame.origin.y = description.frame.origin.y - 3;
            openLb.frame = openLbFrame;
            
            CGRect imgFrame = imgV.frame;
            imgFrame.origin.y = description.frame.origin.y - 3;
            imgV.frame = imgFrame;

        }
        return cell;
    }
    // 已完成
    if(tableView == doneTableView){
        if(indexPath.row == 0){
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"descriptionView" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = 0;
            cell.frame = cellFrame;
        } else {
            NSDictionary *biddingDic = [doneArray objectAtIndex:indexPath.row - 1];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"mytaskCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *taskTitle = (UILabel *)[cell viewWithTag:2];
            OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:3];
            UIImageView *catalog = (UIImageView *)[cell viewWithTag:4];
            UIView *bg = (UIView *)[cell viewWithTag:5];
            OHAttributedLabel *description = (OHAttributedLabel *)[cell viewWithTag:118];
            UIImageView *round = (UIImageView *)[cell viewWithTag:7];
            NSString *descriptionStr = [NSString stringWithFormat:@"%@人竞标",[biddingDic objectForKey:@"biddingnum"]];
            CGSize descriptionSize = [descriptionStr sizeWithFont:description.font constrainedToSize:CGSizeMake(description.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect descriptionFrame = description.frame;
            descriptionFrame.origin.y = bg.frame.origin.y + 10;
            descriptionFrame.size.height = descriptionSize.height + 3;
            //            [description setFrame:descriptionFrame];
            [description setText:descriptionStr];
            [taskTitle setText:[biddingDic objectForKey:@"title"]];
            NSString *bountySelf = [biddingDic objectForKey:@"bounty"];
            NSString *bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
            NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
            [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0]];
            [bounty setFont:[UIFont systemFontOfSize:12]];
            [bounty setAttributedText:attrStr];
            // 任务分类图片
            [catalog setImage:[UIImage imageNamed:[ghunterRequester getTaskCatalogImg:[biddingDic objectForKey:@"pcid"]]]];
            CGFloat top = 20; // 顶端盖高度
            CGFloat bottom = bg.frame.size.height - top - 1; // 底端盖高度
            CGFloat left = 8; // 左端盖宽度
            CGFloat right = bg.frame.size.width - left - 1; // 右端盖宽度
            UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
            // 指定为拉伸模式，伸缩后重新赋值
            UIImage *image = [UIImage imageNamed:@"task_angle_round"];
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            [round setImage:image];
            
            // 线上
            lineOn = (UILabel *)[cell viewWithTag:69];
            lineOn.text = [NSString stringWithFormat:@"%@", [biddingDic objectForKey:@"c_name"]];
            lineOn.font = [UIFont systemFontOfSize:10];
            lineOn.clipsToBounds = YES;
            lineOn.layer.cornerRadius = 3.0;
            [lineOn.layer setBorderWidth:1.0];   //边框宽度
            lineOn.textAlignment = NSTextAlignmentCenter;
            
            [self judgeTextColor:[biddingDic objectForKey:@"fcid"]];
            
            // 私密或公开
            UILabel * openLb = (UILabel *)[cell viewWithTag:67];
            UILabel * openLbWidth = (UILabel *)[cell viewWithTag:167];
            openLbWidth.layer.cornerRadius = 3;

            UIImageView * imgV = (UIImageView *)[cell viewWithTag:66];
            if ([[biddingDic objectForKey:@"type"] isEqualToString:@"0"]) {
                
                openLb.text = @"普通";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[biddingDic objectForKey:@"type"] isEqualToString:@"1"]){
                
                openLb.text = @"公开";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[biddingDic objectForKey:@"type"] isEqualToString:@"2"]) {
                
                openLb.text = @"私密";
                openLb.textColor = RGBCOLOR(204, 204, 204);
                [openLbWidth.layer setBorderColor:RGBCOLOR(204, 204, 204).CGColor];
                imgV.image = [UIImage imageNamed:@"私密"];
            }
            
            openLb.clipsToBounds = YES;
            openLb.layer.cornerRadius = 3.0;
            [openLbWidth.layer setBorderWidth:1.0];
            openLb.textAlignment = NSTextAlignmentRight;
           
            
            NSString *LENstr = [biddingDic objectForKey:@"c_name"];
            if ([LENstr length] > 1) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 30;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 2) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 40;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 3) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 50;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            
            UIImageView * goldImgV = (UIImageView *)[cell viewWithTag:13];
            
            CGRect bountyFrame = bounty.frame;
            CGRect goldImgFrame = goldImgV.frame;
            CGSize bountySize = [bountyStr sizeWithFont:bounty.font];
            
            bountyFrame.size.width = bountySize.width + 10;
            bountyFrame.origin.x = mainScreenWidth - 10 - bountySize.width;
            goldImgFrame.origin.x = cell.frame.size.width - bountySize.width - 35;
            bountyFrame.origin.y = taskTitle.frame.origin.y + 4;
            
            bounty.frame = bountyFrame;
            goldImgV.frame = goldImgFrame;
            bounty.textAlignment = NSTextAlignmentCenter;
            
            CGRect descFrame = description.frame;
            CGSize descSize = [descriptionStr sizeWithFont:description.font];
            
            descFrame.size.width = descSize.width;
            descFrame.origin.x = mainScreenWidth - descSize.width - 10;
            description.textAlignment = NSTextAlignmentRight;
            description.font = [UIFont systemFontOfSize:10];
            
            CGRect celFrame = cell.frame;
            celFrame.size.height = openLb.frame.origin.y + 37;
            cell.frame = celFrame;
            
            descFrame.origin.y = cell.frame.size.height - 23;
            description.frame = descFrame;
            
            CGRect openLbFrameWidth = openLbWidth.frame;
            openLbFrameWidth.origin.y = description.frame.origin.y - 4;
            openLbWidth.frame = openLbFrameWidth;
            //
            CGRect openLbFrame = openLb.frame;
            openLbFrame.origin.y = description.frame.origin.y - 3;
            openLb.frame = openLbFrame;
            
            CGRect imgFrame = imgV.frame;
            imgFrame.origin.y = description.frame.origin.y - 3;
            imgV.frame = imgFrame;
        }
        return cell;
    }
    
    
    // 退款中
    if(tableView == doingRefundTableView){
        if(indexPath.row == 0){
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"descriptionView" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = 0;
            cell.frame = cellFrame;
        } else {
            NSDictionary *biddingDic = [doingRefundArray objectAtIndex:indexPath.row - 1];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"mytaskCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *taskTitle = (UILabel *)[cell viewWithTag:2];
            OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:3];
            UIImageView *catalog = (UIImageView *)[cell viewWithTag:4];
            UIView *bg = (UIView *)[cell viewWithTag:5];
            OHAttributedLabel *description = (OHAttributedLabel *)[cell viewWithTag:118];
            UIImageView *round = (UIImageView *)[cell viewWithTag:7];
            NSString *descriptionStr = [NSString stringWithFormat:@"%@人竞标",[biddingDic objectForKey:@"biddingnum"]];
            CGSize descriptionSize = [descriptionStr sizeWithFont:description.font constrainedToSize:CGSizeMake(description.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect descriptionFrame = description.frame;
            descriptionFrame.origin.y = bg.frame.origin.y + 10;
            descriptionFrame.size.height = descriptionSize.height + 3;
            //            [description setFrame:descriptionFrame];
            [description setText:descriptionStr];
            [taskTitle setText:[biddingDic objectForKey:@"title"]];
            NSString *bountySelf = [biddingDic objectForKey:@"bounty"];
            NSString *bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
            NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
            [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0]];
            [bounty setFont:[UIFont systemFontOfSize:12]];
            [bounty setAttributedText:attrStr];
            // 任务分类图片
            [catalog setImage:[UIImage imageNamed:[ghunterRequester getTaskCatalogImg:[biddingDic objectForKey:@"pcid"]]]];
            CGFloat top = 20; // 顶端盖高度
            CGFloat bottom = bg.frame.size.height - top - 1; // 底端盖高度
            CGFloat left = 8; // 左端盖宽度
            CGFloat right = bg.frame.size.width - left - 1; // 右端盖宽度
            UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
            // 指定为拉伸模式，伸缩后重新赋值
            UIImage *image = [UIImage imageNamed:@"task_angle_round"];
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            [round setImage:image];
            
            
            // 线上
            lineOn = (UILabel *)[cell viewWithTag:69];
            lineOn.text = [NSString stringWithFormat:@"%@", [biddingDic objectForKey:@"c_name"]];
            lineOn.font = [UIFont systemFontOfSize:10];
            lineOn.clipsToBounds = YES;
            lineOn.layer.cornerRadius = 3.0;
            [lineOn.layer setBorderWidth:1.0];   //边框宽度
            lineOn.textAlignment = NSTextAlignmentCenter;
            
            [self judgeTextColor:[biddingDic objectForKey:@"fcid"]];;
            
            // 私密或公开
            UILabel * openLb = (UILabel *)[cell viewWithTag:67];
            UILabel * openLbWidth = (UILabel *)[cell viewWithTag:167];
            openLbWidth.layer.cornerRadius = 3;

            UIImageView * imgV = (UIImageView *)[cell viewWithTag:66];
            if ([[biddingDic objectForKey:@"type"] isEqualToString:@"0"]) {
                
                openLb.text = @"普通";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[biddingDic objectForKey:@"type"] isEqualToString:@"1"]){
                
                openLb.text = @"公开";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[biddingDic objectForKey:@"type"] isEqualToString:@"2"]) {
                
                openLb.text = @"私密";
                openLb.textColor = RGBCOLOR(204, 204, 204);
                [openLbWidth.layer setBorderColor:RGBCOLOR(204, 204, 204).CGColor];
                imgV.image = [UIImage imageNamed:@"私密"];
            }
            
            openLb.clipsToBounds = YES;
            openLb.layer.cornerRadius = 3.0;
            [openLbWidth.layer setBorderWidth:1.0];
            openLb.textAlignment = NSTextAlignmentRight;
            
            
            NSString *LENstr = [biddingDic objectForKey:@"c_name"];
            if ([LENstr length] > 1) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 30;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 2) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 40;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 3) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 50;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            
            UIImageView * goldImgV = (UIImageView *)[cell viewWithTag:13];
            
            CGRect bountyFrame = bounty.frame;
            CGRect goldImgFrame = goldImgV.frame;
            CGSize bountySize = [bountyStr sizeWithFont:bounty.font];
            
            bountyFrame.size.width = bountySize.width+5;
            bountyFrame.origin.x = mainScreenWidth - 12 - bountySize.width;
            goldImgFrame.origin.x = cell.frame.size.width - bountySize.width - 35;
            bountyFrame.origin.y = taskTitle.frame.origin.y + 4;
            
            bounty.frame = bountyFrame;
            goldImgV.frame = goldImgFrame;
            bounty.textAlignment = NSTextAlignmentCenter;
            
            CGRect descFrame = description.frame;
            
            CGSize descSize = [descriptionStr sizeWithFont:description.font];
            
            descFrame.size.width = descSize.width + 10;
            descFrame.origin.x = mainScreenWidth - descSize.width - 15;
            description.textAlignment = NSTextAlignmentRight;
            description.font = [UIFont systemFontOfSize:10];
            
            CGRect celFrame = cell.frame;
            celFrame.size.height = openLb.frame.origin.y + 37;
            cell.frame = celFrame;
            
            descFrame.origin.y = cell.frame.size.height - 23;
            description.frame = descFrame;

            CGRect openLbFrameWidth = openLbWidth.frame;
            openLbFrameWidth.origin.y = description.frame.origin.y - 4;
            openLbWidth.frame = openLbFrameWidth;
            
            //
            CGRect openLbFrame = openLb.frame;
            openLbFrame.origin.y = description.frame.origin.y - 3;
            openLb.frame = openLbFrame;
            
            CGRect imgFrame = imgV.frame;
            imgFrame.origin.y = description.frame.origin.y - 3;
            imgV.frame = imgFrame;
        }
        return cell;
    }
    // 未完成
    if(tableView == undoneTableView){
        if(indexPath.row == 0){
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"descriptionView" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = 0;
            cell.frame = cellFrame;
        } else {
            NSDictionary *biddingDic = [undoneArray objectAtIndex:indexPath.row - 1];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"mytaskCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *taskTitle = (UILabel *)[cell viewWithTag:2];
            OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:3];
            UIImageView *catalog = (UIImageView *)[cell viewWithTag:4];
            UIView *bg = (UIView *)[cell viewWithTag:5];
            OHAttributedLabel *description = (OHAttributedLabel *)[cell viewWithTag:118];
            UIImageView *round = (UIImageView *)[cell viewWithTag:7];
            NSString *descriptionStr = [NSString stringWithFormat:@"%@人竞标",[biddingDic objectForKey:@"biddingnum"]];
            CGSize descriptionSize = [descriptionStr sizeWithFont:description.font constrainedToSize:CGSizeMake(description.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect descriptionFrame = description.frame;
            descriptionFrame.origin.y = bg.frame.origin.y + 10;
            descriptionFrame.size.height = descriptionSize.height + 3;
            //            [description setFrame:descriptionFrame];
            [description setText:descriptionStr];
            [taskTitle setText:[biddingDic objectForKey:@"title"]];
            NSString *bountySelf = [biddingDic objectForKey:@"bounty"];
            NSString *bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
            NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];

            [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0]];
            [bounty setFont:[UIFont systemFontOfSize:12]];
            [bounty setAttributedText:attrStr];
            // 任务分类图片
            [catalog setImage:[UIImage imageNamed:[ghunterRequester getTaskCatalogImg:[biddingDic objectForKey:@"pcid"]]]];
            CGFloat top = 20; // 顶端盖高度
            CGFloat bottom = bg.frame.size.height - top - 1; // 底端盖高度
            CGFloat left = 8; // 左端盖宽度
            CGFloat right = bg.frame.size.width - left - 1; // 右端盖宽度
            UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
            // 指定为拉伸模式，伸缩后重新赋值
            UIImage *image = [UIImage imageNamed:@"task_angle_round"];
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            [round setImage:image];
            
            // 线上
            lineOn = (UILabel *)[cell viewWithTag:69];
            lineOn.text = [NSString stringWithFormat:@"%@", [biddingDic objectForKey:@"c_name"]];
            lineOn.font = [UIFont systemFontOfSize:10];
            lineOn.clipsToBounds = YES;
            lineOn.layer.cornerRadius = 3.0;
            [lineOn.layer setBorderWidth:1.0];   //边框宽度
            lineOn.textAlignment = NSTextAlignmentCenter;
            
            [self judgeTextColor:[biddingDic objectForKey:@"fcid"]];
            
            // 私密或公开
            UILabel * openLb = (UILabel *)[cell viewWithTag:67];
            UILabel * openLbWidth = (UILabel *)[cell viewWithTag:167];
            openLbWidth.layer.cornerRadius = 3;

            UIImageView * imgV = (UIImageView *)[cell viewWithTag:66];
            if ([[biddingDic objectForKey:@"type"] isEqualToString:@"0"]) {
                
                openLb.text = @"普通";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[biddingDic objectForKey:@"type"] isEqualToString:@"1"]){
                
                openLb.text = @"公开";
                openLb.textColor = RGBCOLOR(139, 235, 191);
                [openLbWidth.layer setBorderColor:RGBCOLOR(139, 235, 191).CGColor];
                imgV.image = [UIImage imageNamed:@"公开"];
            }else if ([[biddingDic objectForKey:@"type"] isEqualToString:@"2"]) {
                
                openLb.text = @"私密";
                openLb.textColor = RGBCOLOR(204, 204, 204);
                [openLbWidth.layer setBorderColor:RGBCOLOR(204, 204, 204).CGColor];
                imgV.image = [UIImage imageNamed:@"私密"];
            }
            
            openLb.clipsToBounds = YES;
            openLb.layer.cornerRadius = 3.0;
            [openLbWidth.layer setBorderWidth:1.0];
            openLb.textAlignment = NSTextAlignmentRight;

            NSString *LENstr = [biddingDic objectForKey:@"c_name"];
            if ([LENstr length] > 1) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 30;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 2) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 40;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            if ([LENstr length] > 3) {
                CGRect tabbartxtFrame = lineOn.frame;
                tabbartxtFrame.size.width = 50;
                tabbartxtFrame.origin.x = openLb.frame.size.width + 30;
                tabbartxtFrame.origin.y = description.frame.origin.y + 8;
                lineOn.frame = tabbartxtFrame;
            }
            
            UIImageView * goldImgV = (UIImageView *)[cell viewWithTag:13];
            
            CGRect bountyFrame = bounty.frame;
            CGRect goldImgFrame = goldImgV.frame;
            CGSize bountySize = [bountyStr sizeWithFont:bounty.font];
            
            bountyFrame.size.width = bountySize.width + 10;
            bountyFrame.origin.x = mainScreenWidth - 10 - bountySize.width;
            goldImgFrame.origin.x = cell.frame.size.width - bountySize.width - 35;
            bountyFrame.origin.y = taskTitle.frame.origin.y + 3;
            
            bounty.frame = bountyFrame;
            goldImgV.frame = goldImgFrame;
            bounty.textAlignment = NSTextAlignmentCenter;
            
            CGRect descFrame = description.frame;
            CGSize descSize = [descriptionStr sizeWithFont:description.font];
            
            descFrame.size.width = descSize.width;
            descFrame.origin.x = mainScreenWidth - descSize.width - 10;
            description.textAlignment = NSTextAlignmentRight;
            description.font = [UIFont systemFontOfSize:10];
            
            CGRect celFrame = cell.frame;
            celFrame.size.height = openLb.frame.origin.y + 37;
            cell.frame = celFrame;
            
            descFrame.origin.y = cell.frame.size.height - 23;
            description.frame = descFrame;

            CGRect openLbFrameWidth = openLbWidth.frame;
            openLbFrameWidth.origin.y = description.frame.origin.y - 4;
            openLbWidth.frame = openLbFrameWidth;
            
            //
            CGRect openLbFrame = openLb.frame;
            openLbFrame.origin.y = description.frame.origin.y - 3;
            openLb.frame = openLbFrame;
            
            CGRect imgFrame = imgV.frame;
            imgFrame.origin.y = description.frame.origin.y - 3;
            imgV.frame = imgFrame;
        }
        return cell;
    }
    return cell;
}

#pragma mark - ASIHttpRequest

-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REFRESH_MY_TASK_BIDDING])
    {
        [self endLoad];
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [biddingArray removeAllObjects];
            biddingpage = 2;
            NSArray *array = [dic valueForKey:@"tasks"];
            [biddingArray addObjectsFromArray:array];

            [biddingTableview reloadData];
            
            UIImageView * img = (UIImageView *)[biddingTableview viewWithTag:10086];
            [img removeFromSuperview];
            }else if([dic objectForKey:@"msg"])
        {
            
            if (biddingArray.count == 0) {
                
                [self myTaskDataImg:biddingTableview];
            }
            
        }else
        {
            [ghunterRequester noMsg];
        }
        biddingTableview.pullTableIsRefreshing = NO;
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_MY_TASK_BIDDING])
    {
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            biddingpage++;
            NSArray *array = [dic valueForKey:@"tasks"];
            [biddingArray addObjectsFromArray:array];
            [biddingTableview reloadData];
            
            UIImageView * img = (UIImageView *)[biddingTableview viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (biddingArray.count == 0) {
                
                [self myTaskDataImg:biddingTableview];
            }
        }else
        {
            [ghunterRequester noMsg];
        }
        biddingTableview.pullTableIsLoadingMore = NO;
    }
    
    // 未完成
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REFRESH_MY_TASK_WITHDRAWED])
    {
        [self endLoad];
        notfinishRequested = YES;
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [undoneArray removeAllObjects];
            undonepage = 2;
            NSArray *array = [dic valueForKey:@"tasks"];
            [undoneArray addObjectsFromArray:array];
            [undoneTableView reloadData];

            UIImageView * img = (UIImageView *)[undoneTableView viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (undoneArray.count == 0) {
                
                [self myTaskDataImg:undoneTableView];
            }
        }else
        {
            [ghunterRequester noMsg];
        }
        undoneTableView.pullTableIsRefreshing = NO;
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_MY_TASK_WITHDRAWED])
    {
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            undonepage++;
            NSArray *array = [dic valueForKey:@"tasks"];
            [undoneArray addObjectsFromArray:array];
            [undoneTableView reloadData];
        
            UIImageView * img = (UIImageView *)[undoneTableView viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (undoneArray.count == 0) {
                
                [self myTaskDataImg:undoneTableView];
            }
        }else
        {
            [ghunterRequester noMsg];
        }
        undoneTableView.pullTableIsLoadingMore = NO;
    }
    // 已完成
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REFRESH_MY_TASK_DONE])
    {
        [self endLoad];
        finishRequested = YES;
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [doneArray removeAllObjects];
            donepage = 2;
            NSArray *array = [dic valueForKey:@"tasks"];
            [doneArray addObjectsFromArray:array];

            [doneTableView reloadData];
        
            UIImageView * img = (UIImageView *)[doneTableView viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (doneArray.count == 0) {
                
                [self myTaskDataImg:undoneTableView];
            }
        }else
        {
            [ghunterRequester noMsg];
        }
        doneTableView.pullTableIsRefreshing=NO;
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_MY_TASK_DONE])
    {
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            donepage++;
            NSArray *array = [dic valueForKey:@"tasks"];
            [doneArray addObjectsFromArray:array];
            [doneTableView reloadData];
            
            UIImageView * img = (UIImageView *)[doneTableView viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (doneArray.count == 0) {
                
                [self myTaskDataImg:doneTableView];
            }
        }else
        {
            [ghunterRequester noMsg];
        }
        doneTableView.pullTableIsLoadingMore = NO;
    }
    
    // 进行中
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REFRESH_MY_TASK_DOING])
    {
        [self endLoad];
        finishRequested = YES;
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [doingArray removeAllObjects];
            doingpage = 2;
            NSArray *array = [dic valueForKey:@"tasks"];
        
            [doingArray addObjectsFromArray:array];

            [doingTableView reloadData];
            
            UIImageView * img = (UIImageView *)[doingTableView viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (doingArray.count == 0) {
                
                [self myTaskDataImg:doingTableView];
            }
            
        }else
        {
            [ghunterRequester noMsg];
        }
        doingTableView.pullTableIsRefreshing=NO;
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_MY_TASK_DOING])
    {
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            doingpage++;
            NSArray *array = [dic valueForKey:@"tasks"];
            [doingArray addObjectsFromArray:array];
            [doingTableView reloadData];
            
            UIImageView * img = (UIImageView *)[doingTableView viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (doingArray.count == 0) {
                
                [self myTaskDataImg:doingTableView];
            }
        }else
        {
            [ghunterRequester noMsg];
        }
        doneTableView.pullTableIsLoadingMore = NO;
    }
    
    // 待评价
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REFRESH_MY_TASK_UNVALUATION])
    {
        [self endLoad];
        finishRequested = YES;
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [undoneJudgeArray removeAllObjects];
            undoneJudgePage = 2;
            NSArray *array = [dic valueForKey:@"tasks"];
            [undoneJudgeArray addObjectsFromArray:array];

            [undoneJudgeTableView reloadData];
            
            UIImageView * img = (UIImageView *)[undoneJudgeTableView viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (undoneJudgeArray.count == 0) {
                
                [self myTaskDataImg:undoneJudgeTableView];
            }
        }else
        {
            [ghunterRequester noMsg];
        }
        undoneJudgeTableView.pullTableIsRefreshing=NO;
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_MY_TASK_UNVALUATION])
    {
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            undoneJudgePage++;
            NSArray *array = [dic valueForKey:@"tasks"];
            [undoneJudgeArray addObjectsFromArray:array];
            [undoneJudgeTableView reloadData];
            
            UIImageView * img = (UIImageView *)[undoneJudgeTableView viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (undoneArray.count == 0) {
                
                [self myTaskDataImg:undoneJudgeTableView];
            }
        }else
        {
            [ghunterRequester noMsg];
        }
        undoneJudgeTableView.pullTableIsLoadingMore = NO;
    }
    
    // 待接受
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REFRESH_MY_TASK_ORIENT_PRIVATE_WAITING])
    {
        [self endLoad];
        finishRequested = YES;
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [undoneAcceptArray removeAllObjects];
            donepage = 2;
            NSArray *array = [dic valueForKey:@"tasks"];
            [undoneAcceptArray addObjectsFromArray:array];
            undoneAcceptDescription = [NSString stringWithFormat:@"完成%@件任务,赏金回报￥%@",[dic objectForKey:@"count"],[dic objectForKey:@"all_reward"]];
            [undoneAcceptTableView reloadData];
            
            UIImageView * img = (UIImageView *)[undoneAcceptTableView viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (undoneAcceptArray.count == 0) {
                
                [self myTaskDataImg:undoneAcceptTableView];
            }
        }else
        {
            [ghunterRequester noMsg];
        }
        undoneAcceptTableView.pullTableIsRefreshing=NO;
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_MY_TASK_ORIENT_PRIVATE_WAITING])
    {
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            undoneAcceptPage++;
            NSArray *array = [dic valueForKey:@"tasks"];
            [undoneAcceptArray addObjectsFromArray:array];
            [undoneAcceptTableView reloadData];
            
            UIImageView * img = (UIImageView *)[undoneAcceptTableView viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (undoneAcceptArray.count == 0) {
    
                [self myTaskDataImg:undoneAcceptTableView];
            }
        }else
        {
            [ghunterRequester noMsg];
        }
        undoneAcceptTableView.pullTableIsLoadingMore = NO;
    }
    
    // 退款中
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REFRESH_MY_TASK_APPLY_WITHDRAW])
    {
        [self endLoad];
        finishRequested = YES;
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [doingRefundArray removeAllObjects];
            doingRefundPage = 2;
            NSArray *array = [dic valueForKey:@"tasks"];
            [doingRefundArray addObjectsFromArray:array];

            [doingRefundTableView reloadData];
            
            UIImageView * img = (UIImageView *)[doingRefundTableView viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (doingRefundArray.count == 0) {
                
                [self myTaskDataImg:doingRefundTableView];
            }
        }else
        {
            [ghunterRequester noMsg];
        }
        doingRefundTableView.pullTableIsRefreshing=NO;
    }
    else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_MY_TASK_APPLY_WITHDRAW])
    {
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            doingRefundPage++;
            NSArray *array = [dic valueForKey:@"tasks"];
            [doingRefundArray addObjectsFromArray:array];
            [doingRefundTableView reloadData];
    
            UIImageView * img = (UIImageView *)[doingRefundTableView viewWithTag:10086];
            [img removeFromSuperview];
        }else if([dic objectForKey:@"msg"])
        {
//            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            
            if (doingRefundArray.count == 0) {
                
                [self myTaskDataImg:doingRefundTableView];
            }
        }else
        {
            [ghunterRequester noMsg];
        }
        doingRefundTableView.pullTableIsLoadingMore = NO;
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self endLoad];
    
    undoneTableView.pullTableIsRefreshing = NO;
    biddingTableview.pullTableIsRefreshing = NO;
    doneTableView.pullTableIsRefreshing=NO;
    undoneTableView.pullTableIsRefreshing=NO;
    
    doingTableView.pullTableIsRefreshing = NO;
    undoneAcceptTableView.pullTableIsRefreshing = NO;
    undoneJudgeTableView.pullTableIsRefreshing = NO;
    doingRefundTableView.pullTableIsRefreshing = NO;
    
    biddingTableview.pullTableIsLoadingMore = NO;
    undoneTableView.pullTableIsLoadingMore = NO;
    doneTableView.pullTableIsLoadingMore = NO;
    
    doingRefundTableView.pullTableIsLoadingMore = NO;
    undoneAcceptTableView.pullTableIsLoadingMore = NO;
    undoneJudgeTableView.pullTableIsLoadingMore = NO;
    doingRefundTableView.pullTableIsLoadingMore = NO;
    
    
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
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
    if(dataScroll.contentOffset.x == 0){
        biddingpage = 1;
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_BIDDING withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"bidding",biddingpage]];
    }else if(dataScroll.contentOffset.x == mainScreenWidth * 6){
        undonepage = 1;
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_WITHDRAWED withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"withdrawed",undonepage]];
    }else if(dataScroll.contentOffset.x == mainScreenWidth * 1){
        
        doingpage = 1;
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_DOING withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"doing",doingpage]];
        
        
    }else if(dataScroll.contentOffset.x == mainScreenWidth * 2){
        undoneJudgePage = 1;
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_UNVALUATION withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"unValuation",undoneJudgePage]];
    }else if(dataScroll.contentOffset.x == mainScreenWidth * 3){
        undoneAcceptPage = 1;
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_ORIENT_PRIVATE_WAITING withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"orient_private_waiting",undoneAcceptPage]];
    }else if(dataScroll.contentOffset.x == mainScreenWidth * 4){
        donepage = 1;
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_DONE withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"done",donepage]];
    }else if(dataScroll.contentOffset.x == mainScreenWidth * 5){
        doingRefundPage = 1;
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_REFRESH_MY_TASK_APPLY_WITHDRAW withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"apply_withdraw", doingRefundPage]];
    }

}

- (void)loadMoreDataToTable
{
    if(dataScroll.contentOffset.x == 0){
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_LOADMORE_MY_TASK_BIDDING withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"bidding",biddingpage]];
    }
    else if (dataScroll.contentOffset.x == mainScreenWidth * 6) {
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_LOADMORE_MY_TASK_WITHDRAWED withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"withdrawed",undonepage]];
    }else if(dataScroll.contentOffset.x == mainScreenWidth * 4){
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_LOADMORE_MY_TASK_DONE withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"done",donepage]];
    }else if(dataScroll.contentOffset.x == mainScreenWidth * 1){
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_LOADMORE_MY_TASK_DOING withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"doing",doingpage]];
    }else if(dataScroll.contentOffset.x == mainScreenWidth * 2){
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_LOADMORE_MY_TASK_UNVALUATION withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"unValuation",undoneJudgePage]];
    }else if(dataScroll.contentOffset.x == mainScreenWidth * 3){
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_LOADMORE_MY_TASK_ORIENT_PRIVATE_WAITING withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"orient_private_waiting",undoneAcceptPage]];
    }else if(dataScroll.contentOffset.x == mainScreenWidth * 5){
        [ghunterRequester getwithDelegate:self withUrl:URL_GET_MY_TASK withUserInfo:REQUEST_FOR_LOADMORE_MY_TASK_APPLY_WITHDRAW withString:[NSString stringWithFormat:@"?api_session_id=%@&status=%@&page=%zd",[ghunterRequester getUserInfo:API_SESSION_ID],@"apply_withdrawed",doingRefundPage]];
    }
    
//        biddingTableview.pullTableIsLoadingMore = NO;
    //    undoneTableView.pullTableIsLoadingMore = NO;
    //    doneTableView.pullTableIsLoadingMore = NO;
}

#pragma mark - Custom Methods

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
    self.loadingView = nil;
}


#define mark --- 设置颜色
- (void) judgeTextColor:(NSString *) pcid {
    
    if ([pcid isEqualToString:@"2"]) {
        
        lineOn.textColor = [Monitor colorWithHexString:@"0x00b1cd" alpha:1.0f];
        [lineOn.layer setBorderColor:[Monitor colorWithHexString:@"0x00b1cd" alpha:1.0f].CGColor];//边框颜色
    }
    if ([pcid isEqualToString:@"5"]) {
        
        lineOn.textColor = [Monitor colorWithHexString:@"0xf79736" alpha:1.0f];
        [lineOn.layer setBorderColor:[Monitor colorWithHexString:@"0xf79736" alpha:1.0f].CGColor];//边框颜色
    }
    if ([pcid isEqualToString:@"8"]) {
        
        lineOn.textColor = [Monitor colorWithHexString:@"0x31bd80" alpha:1.0f];
        [lineOn.layer setBorderColor:[Monitor colorWithHexString:@"0x31bd80" alpha:1.0f].CGColor];//边框颜色
    }
    if ([pcid isEqualToString:@"10"]) {
        
         lineOn.textColor = [Monitor colorWithHexString:@"0xd96ce6" alpha:1.0f];
         [lineOn.layer setBorderColor:[Monitor colorWithHexString:@"0xd96ce6" alpha:1.0f].CGColor];//边框颜色
    }
    if ([pcid isEqualToString:@"17"]) {
        
        lineOn.textColor = [Monitor colorWithHexString:@"0x67f3f" alpha:1.0f];
        [lineOn.layer setBorderColor:[Monitor colorWithHexString:@"0x67af3f" alpha:1.0f].CGColor];//边框颜色
    }
    if ([pcid isEqualToString:@"21"]) {
        
        lineOn.textColor = [Monitor colorWithHexString:@"0x1b83d2" alpha:1.0f];
        [lineOn.layer setBorderColor:[Monitor colorWithHexString:@"0x1b83d2" alpha:1.0f].CGColor];//边框颜色
    }
    if ([pcid isEqualToString:@"28"]) {
        
        lineOn.textColor = [Monitor colorWithHexString:@"0xff4e49" alpha:1.0f];
        [lineOn.layer setBorderColor:[Monitor colorWithHexString:@"0xff4e49" alpha:1.0f].CGColor];//边框颜色
    }
    if ([pcid isEqualToString:@"52"]) {
        
        lineOn.textColor = [Monitor colorWithHexString:@"0xf37168" alpha:1.0f];
        [lineOn.layer setBorderColor:[Monitor colorWithHexString:@"0xf37168" alpha:1.0f].CGColor];//边框颜色
    }

}



#pragma mark --- 添加图片
- (void) myTaskDataImg:(UITableView *) table {
    
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth / 3 - 70, mainScreenheight / 2 - 150, 260, 150)];
    imgV.tag = 10086;
    UIImageView * leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 150)];
    
    UIImageView * rightImgV = [[UIImageView alloc] initWithFrame:CGRectMake(130, 0, 130, 150)];
    
    UILabel * dataLb = [[UILabel alloc] initWithFrame:CGRectMake(35,40, 60, 30)];
    dataLb.text = @"暂无数据";
    dataLb.textColor = [UIColor whiteColor];
    dataLb.font = [UIFont systemFontOfSize:14];
    dataLb.textAlignment = NSTextAlignmentCenter;
    
    leftImgV.image = [UIImage imageNamed:@"emptyview_image"];
    rightImgV.image = [UIImage imageNamed:@"emptyview_text"];
    [rightImgV addSubview:dataLb];
    
    [table addSubview:imgV];
    [imgV addSubview:leftImgV];
    [imgV addSubview:rightImgV];
}

@end