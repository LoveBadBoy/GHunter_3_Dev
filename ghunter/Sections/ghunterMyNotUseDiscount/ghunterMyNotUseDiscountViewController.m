//
//  ghunterMyCouponViewController.m
//  ghunter
//
//  Created by ImGondar on 15/12/1.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import "ghunterMyNotUseDiscountViewController.h"
#import "PullTableView.h"
#import "ghunterRequester.h"
#import "ghunterWebViewController.h"

@interface ghunterMyNotUseDiscountViewController ()
{
    
    NSInteger unusedPage;

//    NSMutableArray * dataArray;
    PullTableView * unusedTableView;
    
    NSMutableArray * unusedArray;
    NSString * codeIdString;
    NSInteger selectNum;
    UIImageView * backImgV;
    UILabel * codeLb;
    int c;
    int a;
    int b;
}
@property (strong, nonatomic) IBOutlet UIButton *immediatelyButton;
@end

@implementation ghunterMyNotUseDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
    a = 0;
    b = 0;
    c = 0;
    unusedPage = 1;
    self.immediatelyButton.selected = NO;
    self.immediatelyButton.alpha = 0.7;
    unusedArray = [[NSMutableArray alloc] init];
    
    // 未使用
    unusedTableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight-64-40) style:UITableViewStylePlain];
    unusedTableView.delegate = self;
    unusedTableView.dataSource = self;
    unusedTableView.pullDelegate = self;
    unusedTableView.showsVerticalScrollIndicator = NO;
    unusedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    unusedTableView.backgroundColor = RGBCOLOR(247, 247, 247);
    unusedTableView.tag = 1001;
    [self.view addSubview:unusedTableView];

    
    [self GetMyCouponIsLoading:NO withunusedPage:unusedPage andStatus:@"unused"];
}



- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
}


#pragma mark --- 数据解析
// 未使用
-(void)GetMyCouponIsLoading:(BOOL )isloading withunusedPage:(NSInteger)p andStatus:(NSString *)st{
    if (isloading) {
        [self startLoad];
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:[NSString stringWithFormat:@"%zd", p] forKey:@"page"];
    [parameters setObject:[NSString stringWithFormat:@"%@", st] forKey:@"status"];
    
    [AFNetworkTool httpRequestWithUrl:URL_MY_COUPON params:parameters success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        
        if ([[result objectForKey:@"error"] integerValue] == 0) {
            if (p == 1) {
                [unusedArray removeAllObjects];
                unusedPage = 2;
                NSArray *array = [result valueForKey:@"couponcodes"];
                
                [unusedArray addObjectsFromArray:array];
                [unusedTableView reloadData];
                
                unusedTableView.pullTableIsRefreshing = NO;

                if (unusedArray.count == 0) {
                    
//                    [self myCouponDataImg:unusedTableView];
                    unusedTableView.bounces = NO;
                }else {
                
                    UIView * img = (UIView *)[self.view viewWithTag:10086];
                    
                    [img removeFromSuperview];
                }
                unusedTableView.pullTableIsRefreshing = NO;

            }else{
                unusedPage++;
                NSArray *array = [result valueForKey:@"couponcodes"];
                [unusedArray addObjectsFromArray:array];
                [unusedTableView reloadData];
                
                unusedTableView.pullTableIsLoadingMore = NO;
            }
        }else{
            
//            [ProgressHUD show:[result objectForKey:@"msg"]];
            if (unusedArray.count == 0) {
                
                [self myCouponDataImg:unusedTableView];
            }
            unusedTableView.pullTableIsLoadingMore = NO;
        }
    } fail:^{

        if (isloading) {
            [self endLoad];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)immediatelyButtonAction:(id)sender {
    if (c == 0) {
        
    }else{
        NSString *str = codeLb.text;
        self.blockImmediately(str);
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (c == 0) {
        UITableViewCell *cell = [unusedTableView cellForRowAtIndexPath:indexPath];
        //    cell.backgroundColor = [UIColor redColor];
        UIImageView *image= (UIImageView *)[cell viewWithTag:13];
        image.image = [UIImage imageNamed:@"选中优惠券"] ;
        c = 1;
        self.immediatelyButton.alpha = 1;
        
    }
    else
    {
        UITableViewCell *cell = [unusedTableView cellForRowAtIndexPath:indexPath];
        //    cell.backgroundColor = [UIColor redColor];
        UIImageView *image= (UIImageView *)[cell viewWithTag:13];
        image.image = [UIImage imageNamed:@"未使用"] ;
        c = 0;
        self.immediatelyButton.alpha = 0.7;
    }
    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        NSInteger count = [unusedArray count];
        if(count == 0) {
            return 0;
        }
        else return count + 1;
    
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
        if(indexPath.row == 0){
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"descriptionView" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = 0;
            cell.frame = cellFrame;
        } else {
            NSDictionary * unusedDic = [unusedArray objectAtIndex:indexPath.row - 1];
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"discount" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CGSize width = CGSizeMake(self.view.frame.size.width,cell.frame.size.height);
            CGRect  cellframe = cell.frame;
            cellframe.size.width = width.width;
            cell.frame = cellframe;
            // 标题
            UILabel * titleLb = (UILabel *)[cell viewWithTag:10];
            titleLb.text = [unusedDic objectForKey:@"title"];
        
            // 时间
            UILabel * endTimeLb = (UILabel *)[cell viewWithTag:11];
            endTimeLb.text = [NSString stringWithFormat:@"有效期至: %@", [unusedDic objectForKey:@"endtime"]];
            
            // 券码
            codeLb = (UILabel *)[cell viewWithTag:12];
            codeLb.text = [unusedDic objectForKey:@"code"];
            codeLb.font = [UIFont systemFontOfSize:13];
            codeLb.textColor = [UIColor redColor];
            
            // 背景图和二维码
            backImgV = (UIImageView *)[cell viewWithTag:13];
            backImgV.image = [UIImage imageNamed:@"未使用"];
            
            UIImageView * codeImgV = (UIImageView *)[cell viewWithTag:14];
            codeImgV.image = [UIImage imageNamed:@""];
        }
        
        return cell;
   }


- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
    self.loadingView = nil;
}


#pragma mark --- btn按钮点击
- (void) myTaskBtnClick:(UIButton *) btn {
    
    NSInteger pages = btn.tag - 1001;
    
    NSTimeInterval animationDuration = 0.20f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    [UIView commitAnimations];
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
- (void)refreshTable
{
    unusedPage = 1;
    [unusedArray removeAllObjects];
    [self GetMyCouponIsLoading:NO withunusedPage:unusedPage andStatus:@"unused"];
    unusedTableView.pullTableIsRefreshing = NO;
}

- (void)loadMoreDataToTable
{
    [self GetMyCouponIsLoading:NO withunusedPage:unusedPage andStatus:@"unused"];
    if (unusedArray.count != 0) {
        UIImageView * imgV = (UIImageView *)[unusedTableView viewWithTag:10086];
        [imgV removeFromSuperview];
    }
}

#pragma mark --- 添加没有数据的动画
- (void) myCouponDataImg:(UITableView *) table {
    
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth / 3 - 70, mainScreenheight / 2 - 150, 260, 150)];
    imgV.tag = 10086;
    UIImageView * leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 150)];
    
    UIImageView * rightImgV = [[UIImageView alloc] initWithFrame:CGRectMake(130, 0, 130, 150)];
    
    UILabel * dataLb = [[UILabel alloc] initWithFrame:CGRectMake(25,40, 70, 30)];
    dataLb.text = @"没有更多了";
    dataLb.textColor = [UIColor whiteColor];
    dataLb.font = [UIFont systemFontOfSize:13];
    dataLb.textAlignment = NSTextAlignmentCenter;
    
    leftImgV.image = [UIImage imageNamed:@"emptyview_image"];
    rightImgV.image = [UIImage imageNamed:@"emptyview_text"];
    [rightImgV addSubview:dataLb];
    
    [imgV addSubview:leftImgV];
    [imgV addSubview:rightImgV];
    [table addSubview:imgV];
}


- (void) judgeCodeDetails {
    
    
//    NSString * url = [NSString stringWithFormat:@"%@?codeid=%@", URL_MY_COUPONDETAIL, codeIdString];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:[NSString stringWithFormat:@"%@", codeIdString] forKey:@"codeid"];
    
    NSLog(@"%@", parameters);
    
    [AFNetworkTool httpRequestWithUrl:URL_MY_CODEIDDETAIL params:parameters success:^(NSData *data) {
        
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSLog(@"result ========= %@", result);
        
        if ([[result objectForKey:@"error"] integerValue] == 0) {
            
            NSArray *array = [result valueForKey:@"couponcodes"];
        }
    } fail:^{
//        if (isloading) {
//            [self endLoad];
//        }
    }];
}




- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
