//
//  KDLoadingView.m
//  kaoder
//
//  Created by Sky on 17/7/13.
//  Copyright (c) 2013 kaoder. All rights reserved.
//

#import "ghunterLoadingView.h"

@implementation ghunterLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithSuperView:(UIView *)superView withGif:(NSString *)gif withIndicator:(NSString *)indicator{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, mainScreenWidth, mainScreenheight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        CGSize size = CGSizeMake(32, 32);
        self.gif = [[GifView alloc] initWithFrame:CGRectMake((mainScreenWidth - size.width)/2, (mainScreenheight - size.height)/2, size.width, size.height) filePath:[[NSBundle mainBundle] pathForResource:gif ofType:@"gif"]];
        [self addSubview:self.gif];
        [superView addSubview:self];
        self.hidden = YES;
    }
    return self;
}

- (void)startAnimition {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.hidden = NO;
    [UIView commitAnimations];
}
- (void)inValidate {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.hidden = YES;
    [UIView commitAnimations];
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
