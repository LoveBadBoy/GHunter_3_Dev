//
//  KDTabView.m
//  kaoder
//
//  Created by Sky on 29/6/13.
//  Copyright (c) 2013 kaoder. All rights reserved.
//

#import "ghunterTabView.h"

#import "Header.h"

@implementation ghunterTabView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1.0];
        [self addSubview:line];
        CGFloat width = mainScreenWidth / 4.0;
        firstBtn = [[UIButton alloc] initWithFrame:CGRectMake(width*0, 0, width, 44)];
        secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(width*1, 0, width, 44)];
        thirdBtn = [[UIButton alloc] initWithFrame:CGRectMake(width*2, 0, width, 44)];
        fourthBtn = [[UIButton alloc] initWithFrame:CGRectMake(width*3, 0, width, 44)];
        
        _star1 = [[UIImageView alloc] initWithFrame:CGRectMake((width - 44) / 2.0, 0, 44, 44)];
        self.activity_tip = [[UIImageView alloc] initWithFrame:CGRectMake(width + (width - 30) / 2.0, 10, 30, 24)];
        self.activity_tip.backgroundColor = [UIColor clearColor];
        _star2 = [[UIImageView alloc] initWithFrame:CGRectMake(width + (width - 44) / 2.0, 0, 44, 44)];
        self.tip = [[UIImageView alloc] initWithFrame:CGRectMake(width*2 + (width - 30) / 2.0, 7, 30, 30)];
        self.tip.backgroundColor = [UIColor clearColor];
        self.tip_circle = [[UIImageView alloc] initWithFrame:CGRectMake(width*2 + (width - 30) / 2.0, 10, 30, 24)];
        self.tip_circle.backgroundColor = [UIColor clearColor];
        _star3 = [[UIImageView alloc] initWithFrame:CGRectMake(width*2 + (width - 44) / 2.0, 0, 44, 44)];
        _star4 = [[UIImageView alloc] initWithFrame:CGRectMake(width*3 + (width - 44) / 2.0, 0, 44, 44)];
        _star1.contentMode = UIViewContentModeScaleAspectFit;
        _star2.contentMode = UIViewContentModeScaleAspectFit;
        _star3.contentMode = UIViewContentModeScaleAspectFit;
        _star4.contentMode = UIViewContentModeScaleAspectFit;
        [_star1 setImage:[UIImage imageNamed:@"home_nearby_icon_selected"]];
        [_star2 setImage:[UIImage imageNamed:@"home_discover_icon_normal"]];
        [_star3 setImage:[UIImage imageNamed:@"home_mine_icon_normal"]];
        [_star4 setImage:[UIImage imageNamed:@"home_create_icon_normal"]];
        
        [self addSubview:firstBtn];
        [self addSubview:secondBtn];
        [self addSubview:thirdBtn];
        [self addSubview:fourthBtn];
        [self addSubview:_star1];
        [self addSubview:_star2];
        [self addSubview:self.activity_tip];
        [self addSubview:_star3];
        [self addSubview:self.tip];
        [self addSubview:self.tip_circle];
        [self addSubview:_star4];
        
        [firstBtn addTarget:self action:@selector(firstBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [secondBtn addTarget:self action:@selector(secondBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [thirdBtn addTarget:self action:@selector(thirdBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [fourthBtn addTarget:self action:@selector(fourthBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [firstBtn setSelected:YES];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)firstBtnClicked {
    [firstBtn setSelected:YES];
    [secondBtn setSelected:NO];
    [thirdBtn setSelected:NO];
    [fourthBtn setSelected:NO];
    [_star1 setImage:[UIImage imageNamed:@"home_nearby_icon_selected"]];
    [_star2 setImage:[UIImage imageNamed:@"home_discover_icon_normal"]];
    [_star3 setImage:[UIImage imageNamed:@"home_mine_icon_normal"]];
    [_star4 setImage:[UIImage imageNamed:@"home_create_icon_normal"]];
    [delegate firstBtnClicked];
}
- (void)secondBtnClicked {
    [firstBtn setSelected:NO];
    [secondBtn setSelected:YES];
    [thirdBtn setSelected:NO];
    [fourthBtn setSelected:NO];
    [_star1 setImage:[UIImage imageNamed:@"home_nearby_icon_normal"]];
    [_star2 setImage:[UIImage imageNamed:@"home_discover_icon_selected"]];
    [_star3 setImage:[UIImage imageNamed:@"home_mine_icon_normal"]];
    [_star4 setImage:[UIImage imageNamed:@"home_create_icon_normal"]];
    [delegate secondBtnClicked];
}
- (void)thirdBtnClicked {
    [firstBtn setSelected:NO];
    [secondBtn setSelected:NO];
    [thirdBtn setSelected:YES];
    [fourthBtn setSelected:NO];
    [_star1 setImage:[UIImage imageNamed:@"home_nearby_icon_normal"]];
    [_star2 setImage:[UIImage imageNamed:@"home_discover_icon_normal"]];
    [_star3 setImage:[UIImage imageNamed:@"home_mine_icon_selected"]];
    [_star4 setImage:[UIImage imageNamed:@"home_create_icon_normal"]];
    [delegate thirdBtnClicked];
}
- (void)fourthBtnClicked {
//    [firstBtn setSelected:NO];
//    [secondBtn setSelected:NO];
//    [thirdBtn setSelected:NO];
//    [fourthBtn setSelected:YES];
//    [_star1 setImage:[UIImage imageNamed:@"home_nearby_icon_normal"]];
//    [_star2 setImage:[UIImage imageNamed:@"home_discover_icon_normal"]];
//    [_star3 setImage:[UIImage imageNamed:@"home_mine_icon_normal"]];
//    [_star4 setImage:[UIImage imageNamed:@"home_create_icon_selected"]];
    [delegate fourthBtnClicked];
}

@end
