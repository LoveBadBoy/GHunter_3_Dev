//
//  ghunterschoolViewController.m
//  ghunter
//
//  Created by chensonglu on 14-10-1.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//选择学校

#import "ghunterschoolViewController.h"
// #import "ghunterTableViewCell.h"
@interface ghunterschoolViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *searchTable;

@property (strong, nonatomic) IBOutlet UIView *bg;
@end

@implementation ghunterschoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 _bg.backgroundColor = Nav_backgroud;
    dataArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init];
    
    [self didGetHotUniversitiesIsloading:YES];
    
    _searchTable.dataSource = self;
    _searchTable.delegate = self;
    _searchTable.showsVerticalScrollIndicator = NO;
    _searchTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _searchTable.separatorColor = RGBCOLOR(235, 235, 235);
    [_searchTable setBackgroundColor:[UIColor whiteColor]];
    _searchTable.layer.cornerRadius = Radius;
    
    _searchField.delegate = self;
    _searchField.placeholder = @"请输入关键字搜索";
    _searchBtn.userInteractionEnabled = NO;
    _searchField.returnKeyType = UIReturnKeySearch;
    //[_searchTable registerNib:[UINib nibWithNibName:@"ghunterTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    // 隐藏横线
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    [_searchTable setTableFooterView:view];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    // ghunterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *schoolDic = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.text = [schoolDic objectForKey:@"university_name"];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

#pragma mark - UITaleview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *school;
    school = [dataArray objectAtIndex:indexPath.row];
    
    NSNotification *notification = [NSNotification notificationWithName:@"addschool" object:school userInfo:nil];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSString *keyword = [_searchField text];
    if (keyword.length == 0) {
        return YES;
    }
    if ( [ChineseInclude isIncludeChineseInString:keyword] ) {
        [self didSearchUniversitiesIsloading:YES withKeyword:keyword];
    }else{
        [ProgressHUD show:@"请输入中文关键字"];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // [stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 去除两边的空格
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length == 0) {
        _searchBtn.userInteractionEnabled  = NO;
    }else{
        _searchBtn.userInteractionEnabled = YES;
    }
    return YES;
}

- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}

// 获取热门学校
-(void)didGetHotUniversitiesIsloading:(BOOL )isloading{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:URL_GET_HOT_UNIVERSITIES params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            [dataArray removeAllObjects];
            NSArray *array = [result valueForKey:@"universities"];
            [dataArray addObjectsFromArray:array];
            
            // searchResults = [[NSMutableArray alloc] init];
            [searchResults addObjectsFromArray:array];
            
            [_searchTable reloadData];
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

// 获取热门学校
-(void)didSearchUniversitiesIsloading:(BOOL )isloading withKeyword:(NSString *)keyword{
    if (isloading) {
        [self startLoad];
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:keyword forKey:@"keyword"];
    [AFNetworkTool httpRequestWithUrl:URL_SEARCH_UNIVERSITIES params:parameters success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            [dataArray removeAllObjects];
            NSArray *array = [result valueForKey:@"universities"];
            [dataArray addObjectsFromArray:array];
            
            [_searchTable reloadData];
        }else{
            [ProgressHUD show:@"未搜索到相关学校"];
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}

//    searchResults = [[NSMutableArray alloc]init];
//    dataArray = [[NSMutableArray alloc] initWithArray:tmpArray];
//    // [searchResults addObjectsFromArray:dataArray];
//    
//    if (mySearchBar.text.length>0 && ![ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
//        
//    } else if (mySearchBar.text.length>0 && [ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
//        for (NSDictionary *tempDic in dataArray) {
//            NSRange titleResult = [[tempDic objectForKey:@"university_name"] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
//            if (titleResult.length>0) {
//                [searchResults addObject:tempDic];
//            }
//        }
//    }

@end
