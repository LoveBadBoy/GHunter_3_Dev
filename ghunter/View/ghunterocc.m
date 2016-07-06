//
//  ghunterocc.m
//  ghunter
//
//  Created by ImGondar on 15/9/25.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import "ghunterocc.h"
#import "Header.h"
@implementation ghunterocc
-(instancetype)initWithFrame:(CGRect)frame{
    //    self = [super init];
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        self.backgroundColor = Nav_backgroud;
        UIButton *backbtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 30, 45)];
        [backbtn setImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
        backbtn.backgroundColor = [UIColor clearColor];
        [backbtn addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:backbtn];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, mainScreenWidth, 30)];
        label.text = @"选择行业/方向";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
    }
    return self;
}

-(void)back:(UIButton *)btn{
    [self.delegate backbtn:@"back"];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
