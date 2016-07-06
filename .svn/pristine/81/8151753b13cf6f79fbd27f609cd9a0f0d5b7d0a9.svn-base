//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "TQStarRatingView.h"

@interface TQStarRatingView ()
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;
@end


@implementation TQStarRatingView

@synthesize score = _score;

- (void)setScore:(float)score{
    _score = score;
    float rate = score/_numberOfStar;
//    if (rate < 0) rate = 0;
//    if (rate > 1) rate = 1;
    float width = rate * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, width, self.frame.size.height);
}

- (float)score{
    return _score;
}

- (id)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        self.starBackgroundView = [self buidlStarViewWithImageName:@"foregroundStar"];
        self.starForegroundView = [self buidlStarViewWithImageName:@"backgroundStar"];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number withBack:(NSString *)backImage withFore:(NSString *)foreImage
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        self.starBackgroundView = [self buidlStarViewWithImageName:foreImage];
        self.starForegroundView = [self buidlStarViewWithImageName:backImage];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
    }
    return self;
}

- (void)setuserInteractionEnabled:(BOOL)userInteractionEnabled{
    if(userInteractionEnabled){
        self.userInteractionEnabled = YES;
    }else{
        self.userInteractionEnabled = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak TQStarRatingView * weekSelf = self;
    
    [UIView transitionWithView:self.starForegroundView
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^
     {
         [weekSelf changeStarForegroundViewWithPoint:point];
     }
                    completion:^(BOOL finished)
     {
    
     }];
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, frame.size.width / self.numberOfStar, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}

- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    else if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.1f",p.x / self.frame.size.width];
    float score = [str floatValue];
    p.x = score * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
    {
        [self.delegate starRatingView:self score:score];
    }
}

@end
