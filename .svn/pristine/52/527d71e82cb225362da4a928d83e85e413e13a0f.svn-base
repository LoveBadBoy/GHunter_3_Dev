//
//  ghunterOccupationViewController.m
//  ghunter
//
//  Created by ImGondar on 15/9/25.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import "ghunterOccupationViewController.h"
#import "AFNetworkTool.h"
#import "ProgressHUD.h"
#import "ghunterOccModel.h"

@interface ghunterOccupationViewController ()<backdelegate>

@end

@implementation ghunterOccupationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messint =1;
    self.codeint = 0;
    index = 0;
    mutablearr = [NSMutableArray array];
    toarray = [NSMutableArray array];
    zhiyearr = [NSMutableArray array];
    [self getdata];
    

    self.view.backgroundColor = [UIColor whiteColor];
    self.nav = [[ghunterocc alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    self.nav.delegate = self;
    [self.view addSubview:self.nav];
    
    onetable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 100, mainScreenheight-64)];
    onetable.separatorColor = backgroud_Bg;
    onetable.separatorStyle = UITableViewCellSeparatorStyleNone;
    onetable.dataSource = self;
    onetable.delegate =self;
    [self.view addSubview:onetable];
    
    twotable = [[UITableView alloc]initWithFrame:CGRectMake(100, 64, mainScreenWidth-100, mainScreenheight-64)];
    twotable.backgroundColor = RGBCOLOR(238, 238, 238);
    
    twotable.dataSource = self;
    twotable.delegate =self;
    [self.view addSubview:twotable];
    if ([twotable respondsToSelector:@selector(setSeparatorInset:)]) {
        [twotable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([twotable respondsToSelector:@selector(setLayoutMargins:)]) {
        [twotable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    twotable.separatorColor = RGBCOLOR(255, 255, 255);
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = RGBCOLOR(235, 235, 235);
    [twotable setTableFooterView:view];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)setCodeint:(NSInteger)codeint{
    if (codeint == self.codeint) return;
    _codeint = codeint;
    [onetable reloadData];
}
//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==twotable) {
        return arryer.count;
    }else{
        return mutablearr.count;
    }
}

//设置单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCell = @"Cell";
    ghunterOneCell *cell =(ghunterOneCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ghunterOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    //清楚cell的缓存
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    if (tableView==onetable) {
        if (indexPath.row == self.codeint) {
            //点击
            cell.backgroundColor = RGBCOLOR(238, 238, 238);
            cell.occname.textColor = RGBCOLOR(51, 51, 51);
            [cell.contentView addSubview:cell.redview];
        }else{
        //未点击
            cell.backgroundColor = [UIColor whiteColor];
            cell.occname.textColor = RGBCOLOR(136, 136, 136);
        }

        ghunterOccModel *model = [[ghunterOccModel alloc]init];
        model= mutablearr[indexPath.row];
        cell.occname.text =model.industry;
    
        cell.icontext.backgroundColor = [Monitor colorWithHexString:model.colorstr alpha:1.0f];
        cell.icontext.text = model.wordstr;
        [cell.contentView addSubview:cell.icontext];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 44.3, 100, 0.7)];
        line.backgroundColor = RGBCOLOR(238, 238, 238);
        [cell.contentView addSubview:line];
    }
    else{
        cell.Industry.text =[[arryer objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.backgroundColor = RGBCOLOR(238, 238, 238);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Monitor *hot= [Monitor sharedInstance];
    hot.hots = @"dzy";
    if (tableView==onetable) {
        self.codeint = indexPath.row;
        index = indexPath.row;
        self.messint = 2;
         [self getdata];
        wordstr =[[zhiyearr objectAtIndex:indexPath.row]objectForKey:@"title"];
        jobcol = [[[zhiyearr objectAtIndex:indexPath.row] objectForKey:@"wicon"]objectForKey:@"color"];;
        jobwor = [[[zhiyearr objectAtIndex:indexPath.row] objectForKey:@"wicon"]objectForKey:@"word"];;
    }else{
        ghunterzhiyeViewController *zhiye = [ghunterzhiyeViewController new];
        if ([wordstr isEqualToString:@""]||wordstr ==nil) {
            wordstr =[[zhiyearr objectAtIndex:0]objectForKey:@"title"];
            jobcol = [[[zhiyearr objectAtIndex:0] objectForKey:@"wicon"] objectForKey:@"color"];
            jobwor = [[[zhiyearr objectAtIndex:0] objectForKey:@"wicon"] objectForKey:@"word"];
        }
        
        NSString *industry = wordstr;
        NSString *direction = [[arryer objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        zhiye.industry_new = industry;
        zhiye.direction_new = direction;
        
        zhiye.jobstr = [NSString stringWithFormat:@"%@/%@",wordstr,[[arryer objectAtIndex:indexPath.row]objectForKey:@"title"]];
        
        zhiye.jobid =[[[arryer objectAtIndex:indexPath.row]objectForKey:@"jid"] intValue];
        zhiye.col = jobcol;
        zhiye.wor = jobwor;
        
        [self.navigationController pushViewController:zhiye animated:YES];
    }
}

-(void)getdata{
    [AFNetworkTool httpRequestWithUrl:URL_GET_NOTICE_JOBS params:nil success:^(NSData *data) {
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (self.messint==1) {
            NSArray*  array = [result objectForKey:@"industries"];
            for (NSDictionary *dict in array) {
                dic = [dict objectForKey:@"industry"];
                dic2 = [dict objectForKey:@"directions"];
                ghunterOccModel *provinceModel = [ghunterOccModel messageModelWithDict:dic];
                [mutablearr addObject:provinceModel];
                [toarray addObject:dic2];
                [zhiyearr addObject:dic];
            }
        }
        if (self.messint==2) {
            NSArray*  array = [result objectForKey:@"industries"];
            for (NSDictionary *dict in array) {
                dic2 = [dict objectForKey:@"directions"];
                [toarray addObject:dic2];
            }
        }
        

         arryer = [toarray objectAtIndex:index];
        [onetable reloadData];
        [twotable reloadData];
    }fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
    }];
}

-(void)backbtn:(NSString *)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
