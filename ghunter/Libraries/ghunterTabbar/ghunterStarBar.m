//
//  KDStarBar.m
//  kaoder
//
//  Created by Sky on 30/6/13.
//  Copyright (c) 2013 kaoder. All rights reserved.
//

#import "ghunterStarBar.h"

@implementation ghunterStarBar

@synthesize starNum;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        starNum = 0;
        btn1 = [[UIButton alloc] initWithFrame:CGRectMake(80*0, 0, 80, 44)];
        btn2 = [[UIButton alloc] initWithFrame:CGRectMake(80*1, 0, 80, 44)];
        btn3 = [[UIButton alloc] initWithFrame:CGRectMake(80*2, 0, 80, 44)];
        btn4 = [[UIButton alloc] initWithFrame:CGRectMake(80*3, 0, 80, 44)];
        
        star1 = [[UIImageView alloc] initWithFrame:CGRectMake(23, 4, 34, 36)];
        star2 = [[UIImageView alloc] initWithFrame:CGRectMake(80 + 27, 2, 25, 39)];
        star3 = [[UIImageView alloc] initWithFrame:CGRectMake(80*2+23, 5, 34, 34)];
        star4 = [[UIImageView alloc] initWithFrame:CGRectMake(80*3+3, 0, 74, 44)];
        
        [btn1 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
        [btn4 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
        
        [btn1 addTarget:self action:@selector(firstBtnClicked)  forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:self action:@selector(secondBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [btn3 addTarget:self action:@selector(thirdBtnClicked)  forControlEvents:UIControlEventTouchUpInside];
        [btn4 addTarget:self action:@selector(fourthBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn1];
        [self addSubview:btn2];
        [self addSubview:btn3];
        [self addSubview:btn4];
        [self addSubview:star1];
        [self addSubview:star2];
        [self addSubview:star3];
        [self addSubview:star4];
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
    starNum = 1;
    [btn1 setImage:[UIImage imageNamed:@"home_tabbar_clicked"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
    [btn4 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
}
- (void)secondBtnClicked {
    starNum = 2;
    [btn1 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"home_tabbar_clicked"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
    [btn4 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
}
- (void)thirdBtnClicked {
    starNum = 3;
    [btn1 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
    [btn4 setImage:[UIImage imageNamed:@"home_tabbar_clicked"] forState:UIControlStateNormal];
}
- (void)fourthBtnClicked {
    starNum = 4;
    [btn1 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"home_tabbar_normal"] forState:UIControlStateNormal];
    [btn4 setImage:[UIImage imageNamed:@"home_tabbar_clicked"] forState:UIControlStateNormal];
}

@end
