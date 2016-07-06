//
//  ghunterAccountHistoryViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-25.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//我的金库

#import "ghunterMyGoldViewController.h"

@interface ghunterMyGoldViewController ()
@property (strong, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UILabel *historyTitle;
@end

@implementation ghunterMyGoldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
     _bg.backgroundColor = Nav_backgroud;
    // Do any additional setup after loading the view from its nib.
    page = 1;
    history = [[NSMutableArray alloc] init];
    self.table = [[PullTableView alloc]initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 44 - 20) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.pullDelegate = self;
    self.table.showsVerticalScrollIndicator = NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    if(self.type == 0){
        [self.historyTitle setText:@"充值记录"];
        [ghunterRequester postwithDelegate:self withUrl:URL_GET_RECHARGE_HISTORY withUserInfo:REQUEST_FOR_GET_RECHARGE_HISTORY withDictionary:dic];
    }else if (self.type == 1){
        [self.historyTitle setText:@"提现记录"];
        [ghunterRequester postwithDelegate:self withUrl:URL_GET_WITHDRAW_HISTORY withUserInfo:REQUEST_FOR_GET_WITHDRAW_HISTORY withDictionary:dic];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [history count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *historyDic = [history objectAtIndex:indexPath.row];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"accountHistoryView" owner:self options:nil];
    cell = [nibs objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    UIImageView *icon = (UIImageView *)[cell viewWithTag:1];
    UILabel *dateline = (UILabel *)[cell viewWithTag:2];
    UILabel *type = (UILabel *)[cell viewWithTag:3];
    if(self.type == 0){
        [dateline setText:[historyDic objectForKey:@"dateline"]];
        [type setText:[NSString stringWithFormat:@"充值￥%@",[historyDic objectForKey:@"total_fee"]]];
    }else if (self.type == 1){
        UILabel *rechargeResult = (UILabel *)[cell viewWithTag:4];
        [dateline setText:[historyDic objectForKey:@"dateline"]];
        [type setText:[historyDic objectForKey:@"status"]];
        [rechargeResult setText:[NSString stringWithFormat:@"提现:%@",[historyDic objectForKey:@"amount"]]];
    }
    UIView *bg = (UIView *)[cell viewWithTag:5];
    bg.clipsToBounds = YES;
//    bg.layer.cornerRadius = Radius;
    return cell;
}

#pragma mark - UITaleview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - ASIHttpRequest

-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_GET_RECHARGE_HISTORY]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [history removeAllObjects];
            page = 2;
            NSArray *array = [dic valueForKey:@"records"];
            [history addObjectsFromArray:array];
            [self.table reloadData];
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_RECHARGE_HISTORY]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            page++;
            NSArray *array = [dic valueForKey:@"records"];
            [history addObjectsFromArray:array];
            [self.table reloadData];
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
        self.table.pullTableIsLoadingMore = NO;
    }else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_GET_WITHDRAW_HISTORY]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [history removeAllObjects];
            page = 2;
            NSArray *array = [dic valueForKey:@"records"];
            [history addObjectsFromArray:array];
            [self.table reloadData];
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }else if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_LOADMORE_WITHDRAW_HISTORY]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            page++;
            NSArray *array = [dic valueForKey:@"records"];
            [history addObjectsFromArray:array];
            [self.table reloadData];
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
        self.table.pullTableIsLoadingMore = NO;
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.table.pullTableIsLoadingMore = NO;
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
    //    NSError *error = [request error];

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
    page = 1;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    if(self.type == 0){
        [ghunterRequester postwithDelegate:self withUrl:URL_GET_RECHARGE_HISTORY withUserInfo:REQUEST_FOR_GET_RECHARGE_HISTORY withDictionary:dic];
    }else if (self.type == 1){
        [ghunterRequester postwithDelegate:self withUrl:URL_GET_WITHDRAW_HISTORY withUserInfo:REQUEST_FOR_GET_WITHDRAW_HISTORY withDictionary:dic];
    }
    self.table.pullTableIsRefreshing = NO;
}

- (void)loadMoreDataToTable
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    if(self.type == 0){
        [ghunterRequester postwithDelegate:self withUrl:URL_GET_RECHARGE_HISTORY withUserInfo:REQUEST_FOR_LOADMORE_RECHARGE_HISTORY withDictionary:dic];
    }else if (self.type == 1){
        [ghunterRequester postwithDelegate:self withUrl:URL_GET_WITHDRAW_HISTORY withUserInfo:REQUEST_FOR_LOADMORE_WITHDRAW_HISTORY withDictionary:dic];
    }
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
