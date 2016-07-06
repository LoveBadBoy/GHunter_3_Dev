//
//  ghunterOneCell.m
//  ghunter
//
//  Created by ImGondar on 15/9/25.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import "ghunterOneCell.h"
#import "Header.h"
@implementation ghunterOneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _occname = [[UILabel alloc]initWithFrame:CGRectMake(30, 8, 70, 25)];
        _occname.font = [UIFont systemFontOfSize:16];
        [self addSubview:_occname];
        _icontext = [[UILabel alloc]initWithFrame:CGRectMake(10, 14, 15, 15)];
        _icontext.layer.cornerRadius = 0.2;
        _icontext.textColor = [UIColor whiteColor];
        _icontext.textAlignment = NSTextAlignmentCenter;
        _icontext.font = [UIFont systemFontOfSize:10];

        
        _Industry = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 120, 25)];
        _Industry.font = [UIFont systemFontOfSize:16];
        [self addSubview:_Industry];
        _redview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 45)];
        _redview.backgroundColor = Nav_backgroud;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
