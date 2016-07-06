//
//  ghunterAddCatalogViewController.h
//  ghunter
//
//  Created by chensonglu on 14-4-22.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"
#import "ghunterRequester.h"
#import "RadioButton.h"

@interface ghunterAddCatalogViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,RadioButtonDelegate>{
    UITableView *catalogTable;
    NSArray *catalogs;
    //用于求出有多少section
    NSInteger rowNum;
    NSInteger colNum;
    NSInteger lastRowColNum;
    //确定点击的section
    BOOL isSelected;
    NSInteger selectedSection;
    NSInteger selectedCol;
    NSInteger sectionNum;
    //确定最终选择了哪个父分类下的子分类
    NSInteger parentNum;
    NSInteger childNum;
}
@end
