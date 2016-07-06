//
//  ghunterAddCatalogViewController.m
//  ghunter
//
//  Created by chensonglu on 14-4-22.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//任务分类

#import "ghunterAddCatalogViewController.h"
#import "AFNetworkTool.h"

@interface ghunterAddCatalogViewController ()
@property (strong, nonatomic) IBOutlet UIView *bg;

@end

@implementation ghunterAddCatalogViewController

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
    // Do any additional setup after loading the view from its nib.
    
    catalogs = (NSArray *)[ghunterRequester getCacheContentWithKey:TASK_CATALOG];
    [self didGetCatalogIsloading:YES];
    NSInteger count = 8;
    if (catalogs) {
        count = [catalogs count];
    }
    
    parentNum = 0;
    childNum = 0;
    
    isSelected = NO;
    selectedSection = 0;
    selectedCol = 0;
    sectionNum = 1;
    
    colNum = 4;
    lastRowColNum = count % colNum;
    if(lastRowColNum == 0){
        rowNum = count/colNum;
    }else{
        rowNum = count/colNum + 1;
    }
    catalogTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, mainScreenWidth , mainScreenheight) style:UITableViewStylePlain];
    catalogTable.showsVerticalScrollIndicator = NO;
    catalogTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    catalogTable.delegate = self;
    catalogTable.dataSource = self;
    catalogTable.clipsToBounds = YES;
//    catalogTable.layer.cornerRadius = Radius;
    [self.view addSubview:catalogTable];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didSelectCatalog{
    if(!isSelected){
        [ghunterRequester showTip:@"请选择任务分类"];
        return;
    }
    NSMutableDictionary *addCatalogDic = [[NSMutableDictionary alloc] init];
    
    NSString *cid = [[[[catalogs objectAtIndex:parentNum] objectForKey:@"child"]objectAtIndex:childNum] objectForKey:@"cid"];
    NSString *fcid = [[[catalogs objectAtIndex:parentNum] objectForKey:@"parent"] objectForKey:@"cid"];
    NSString *title = [[[[catalogs objectAtIndex:parentNum] objectForKey:@"child"]objectAtIndex:childNum] objectForKey:@"title"];
    
    [addCatalogDic setObject:cid forKey:@"cid"];
    [addCatalogDic setObject:title forKey:@"title"];
    [addCatalogDic setObject:fcid forKey:@"fcid"];
    
    NSNotification *notification = [NSNotification notificationWithName:GHUNTERADDCATALOG object:addCatalogDic userInfo:nil];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:false];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  UITableViewDatasource
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return rowNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == selectedSection){
        return sectionNum;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else {
        while ([cell.contentView.subviews lastObject]) {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat width = 70.0;
    CGFloat space = (mainScreenWidth - 20 - 20 - 4 * width) / 3.0;
    UIGridViewCell *gridViewCell;
    if(lastRowColNum == 0 || (lastRowColNum != 0 && indexPath.section < (rowNum - 1))){
        if(indexPath.row == 0){
            for(NSUInteger i = 0;i < 4;i++){
                gridViewCell = [[UIGridViewCell alloc] initWithFrame:CGRectMake(25 + i%colNum * (width + space), 0, width, width)];
                [gridViewCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                gridViewCell.sectionIndex = indexPath.section;
                gridViewCell.colIndex = i%colNum;
                [gridViewCell addTarget:self action:@selector(cellPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 40, 50)];
                [cView setBackgroundColor:[UIColor clearColor]];
                UIImageView *catalogImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                
                UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 60, 10)];
                [textLabel setTextColor:[UIColor colorWithRed:89/255.0 green:87/255.0 blue:87/255.0 alpha:1.0f]];
                [textLabel setFont:[UIFont systemFontOfSize:11.0f]];
                textLabel.textAlignment = NSTextAlignmentLeft;
                [cView addSubview:catalogImage];
                [cView addSubview:textLabel];
                
                NSInteger order = (gridViewCell.sectionIndex * 4 + gridViewCell.colIndex)%8;
                // NSString *cid = [[[catalogs objectAtIndex:order] objectForKey:@"parent"] objectForKey:@"cid"];
                NSString *title = [[[catalogs objectAtIndex:order] objectForKey:@"parent"] objectForKey:@"title"];
                NSString *imageUrl = [[[catalogs objectAtIndex:order] objectForKey:@"parent"] objectForKey:@"icon"];
                textLabel.text = title;
                // 版本兼容问题，V2.01中的catalogs每一icon这个字段, 而V2.02有
                if (imageUrl) {
                    [catalogImage sd_setImageWithURL:[[NSURL alloc] initWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"avatar"]];
                }else{
                    NSString *cid = [[[catalogs objectAtIndex:order] objectForKey:@"parent"] objectForKey:@"cid"];
                    [catalogImage setImage:[UIImage imageNamed:[ghunterRequester getTaskCatalogImg:cid]]];
                }
                [gridViewCell addSubview:cView];
                [cell.contentView addSubview:gridViewCell];
            }
            cell.frame = CGRectMake(0, 0, mainScreenWidth - 20, width);
            return cell;
        }
        if(selectedSection == indexPath.section && indexPath.row == 1){
            return [self insertSecondCell];
        }
    }else{
        if(indexPath.row == 0){
            for(NSUInteger i = 0;i < lastRowColNum;i++){
                gridViewCell = [[UIGridViewCell alloc] initWithFrame:CGRectMake(10 + i%colNum * (width + space), 0, width, width)];
                [gridViewCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                gridViewCell.sectionIndex = indexPath.section;
                gridViewCell.colIndex = i%colNum;
                
                [gridViewCell addTarget:self action:@selector(cellPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 40, 50)];
                [cView setBackgroundColor:[UIColor clearColor]];
                UIImageView *catalogImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                
                UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 40, 10)];
                [textLabel setTextColor:[UIColor colorWithRed:89/255.0 green:87/255.0 blue:87/255.0 alpha:1.0f]];
                [textLabel setFont:[UIFont systemFontOfSize:11.0f]];
                textLabel.textAlignment = NSTextAlignmentCenter;
                [cView addSubview:catalogImage];
                [cView addSubview:textLabel];
                
                NSInteger order = (gridViewCell.sectionIndex * 4 + gridViewCell.colIndex)%8;
                // NSString *cid = [[[catalogs objectAtIndex:order] objectForKey:@"parent"] objectForKey:@"cid"];
                NSString *title = [[[catalogs objectAtIndex:order] objectForKey:@"parent"] objectForKey:@"title"];
                NSString *imageUrl = [[[catalogs objectAtIndex:order] objectForKey:@"parent"] objectForKey:@"icon"];
                textLabel.text = title;
                // 版本兼容问题，V2.01中的catalogs每一icon这个字段, 而V2.02有
                // 非常重要
                if (imageUrl) {
                    [catalogImage sd_setImageWithURL:[[NSURL alloc] initWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"avatar"]];
                }else{
                    NSString *cid = [[[catalogs objectAtIndex:order] objectForKey:@"parent"] objectForKey:@"cid"];
                    [catalogImage setImage:[UIImage imageNamed:[ghunterRequester getTaskCatalogImg:cid]]];
                }
                [gridViewCell addSubview:cView];
                [cell.contentView addSubview:gridViewCell];
            }
            cell.frame = CGRectMake(0, 0, mainScreenWidth - 20, width);
            return cell;
        }
        if(selectedSection == indexPath.section && indexPath.row == 1){
            return [self insertSecondCell];
        }
    }
    return cell;
}

- (UITableViewCell *)insertSecondCell{
    CGFloat width = 70.0;
    CGFloat space = (mainScreenWidth - 20 - 20 - 4 * width) / 3.0;
    UITableViewCell *insertCell = [[UITableViewCell alloc] init];
    UIImageView *up = [[UIImageView alloc] initWithFrame:CGRectMake(10 + selectedCol * (space + width) + (width - 14) / 2.0, 2, 14, 7)];
    [up setImage:[UIImage imageNamed:@"point_up"]];
    [insertCell addSubview:up];
    NSDictionary *catalog = [catalogs objectAtIndex:selectedSection * 4 + selectedCol];
    NSArray *child = [catalog objectForKey:@"child"];
    if ([child count]%3 == 0) {
        UIView *cellBg = [[UIView alloc] initWithFrame:CGRectMake(20, 8, mainScreenWidth-40, [child count]/3*50.0)];
        [cellBg setBackgroundColor:[UIColor colorWithRed:247.0/255 green:248.0/255 blue:248.0/255 alpha:1.0]];
        cellBg.clipsToBounds = YES;
        cellBg.layer.cornerRadius = Radius;
        [insertCell.contentView addSubview:cellBg];
    }else{
        UIView *cellBg = [[UIView alloc] initWithFrame:CGRectMake(20, 8, mainScreenWidth-40, ([child count]/3+1)*50.0)];
        [cellBg setBackgroundColor:[UIColor colorWithRed:247.0/255 green:248.0/255 blue:248.0/255 alpha:1.0]];
        cellBg.clipsToBounds = YES;
        cellBg.layer.cornerRadius = Radius;
        [insertCell.contentView addSubview:cellBg];
    }
    CGFloat length = (mainScreenWidth - 40) / 3.0;
    CGFloat padding = 15.0;
    for (NSUInteger i = 0; i < [child count]; i++) {
        UIGridViewCell *gridViewCell = [[UIGridViewCell alloc] initWithFrame:CGRectMake(i%3 * length, i/3*50, length, 50)];
        gridViewCell.sectionIndex = selectedSection;
        gridViewCell.sectionColIndex = selectedCol;
        gridViewCell.rowIndex = i/3;
        gridViewCell.colIndex = i%3;
        UILabel *child_catalog = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (length - 50 + padding), 50)];
        [child_catalog setTextAlignment:NSTextAlignmentRight];
        [child_catalog setBackgroundColor:[UIColor clearColor]];
        [child_catalog setTextColor:[UIColor colorWithRed:89.0/255 green:87.0/255 blue:87.0/255 alpha:1.0]];
        [child_catalog setFont:[UIFont systemFontOfSize:12.0]];
        NSDictionary *childDic = [child objectAtIndex:gridViewCell.rowIndex * 3 + gridViewCell.colIndex];
        [child_catalog setText:[childDic objectForKey:@"title"]];
        [gridViewCell addSubview:child_catalog];
        RadioButton *rb = [[RadioButton alloc] initWithGroupId:[NSString stringWithFormat:@"%zd",selectedSection * 4 + selectedCol] index:i normalImage:[UIImage imageNamed:@"catalog_radio_normal"] clickedimage:[UIImage imageNamed:@"define_tag"] isLeft:NO size:CGSizeMake(length, 50) padding:padding];
        if(i == 0){
            [rb setChecked:YES];
        }
        rb.frame = CGRectMake(i%3 * length, i/3*50, length, 50);
        [insertCell.contentView addSubview:gridViewCell];
        [insertCell.contentView addSubview:rb];
    }
    [RadioButton addObserverForGroupId:[NSString stringWithFormat:@"%zd",selectedSection * 4 + selectedCol] observer:self];
    insertCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([child count]%3 == 0) {
        insertCell.frame = CGRectMake(10, 0, mainScreenWidth - 40, [child count]/3*50.0);
    }else{
        insertCell.frame = CGRectMake(10, 0, mainScreenWidth - 40, ([child count]/3+1)*50.0);
    }
    return insertCell;
}
/**
 *  UITableViewDelegate
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)cellPressed:(UIGridViewCell *)sender{
    
    parentNum = sender.sectionIndex * 4 + sender.colIndex;
    childNum = 0;
    if(!isSelected){
        isSelected = YES;
        selectedSection = sender.sectionIndex;
        selectedCol = sender.colIndex;
        sectionNum++;
        NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
        NSIndexPath *indexPathToInsert = [NSIndexPath indexPathForRow:1 inSection:selectedSection];
        [rowToInsert addObject:indexPathToInsert];
        [catalogTable insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationMiddle];
    }else{
        if(sender.sectionIndex == selectedSection && sender.colIndex == selectedCol){
            isSelected = NO;
            sectionNum--;
            NSMutableArray* rowToDelete = [[NSMutableArray alloc] init];
            NSIndexPath *indexPathToDelete = [NSIndexPath indexPathForRow:1 inSection:selectedSection];
            [rowToDelete addObject:indexPathToDelete];
            [catalogTable deleteRowsAtIndexPaths:rowToDelete withRowAnimation:UITableViewRowAnimationMiddle];
        }else{
            if(sender.sectionIndex == selectedSection && sender.colIndex != selectedCol){
                selectedSection = sender.sectionIndex;
                selectedCol = sender.colIndex;
                NSMutableArray* rowArray = [[NSMutableArray alloc] init];
                NSIndexPath *indexPathToDelete = [NSIndexPath indexPathForRow:1 inSection:selectedSection];
                [rowArray addObject:indexPathToDelete];
                [catalogTable reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationMiddle];
            }else{
                sectionNum--;
                NSMutableArray* rowArray = [[NSMutableArray alloc] init];
                NSIndexPath *indexPathToDelete = [NSIndexPath indexPathForRow:1 inSection:selectedSection];
                [rowArray addObject:indexPathToDelete];
                
                selectedSection = sender.sectionIndex;
                selectedCol = sender.colIndex;
                
                [catalogTable deleteRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationMiddle];
                
                [self performSelector:@selector(insertCell) withObject:nil afterDelay:0.2];
            }
        }
    }
}

- (void)insertCell{
    sectionNum++;
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    NSIndexPath *indexPathToInsert = [NSIndexPath indexPathForRow:1 inSection:selectedSection];
    [rowToInsert addObject:indexPathToInsert];
    [catalogTable insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationMiddle];
}

#pragma RadioButton delegate
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    parentNum = [groupId intValue];
    childNum = index;
    
    [self didSelectCatalog];
}

// 获取任务分类
-(void)didGetCatalogIsloading:(BOOL )isloading{
    if (isloading) {
        // [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:URL_GET_TASK_CATALOG params:nil success:^(NSData *data) {
        if (isloading) {
            // [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            catalogs = [result objectForKey:@"catalogs"];
            
            
            [catalogTable reloadData];
            
            [ghunterRequester setCacheTime:[ghunterRequester getTimeNow] withKey:TASK_CATALOG_TIME];
            [ghunterRequester setCacheContent:[result objectForKey:@"catalogs"] withKey:TASK_CATALOG];
        }else{
            
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            // [self endLoad];
        }
    }];
}

@end
