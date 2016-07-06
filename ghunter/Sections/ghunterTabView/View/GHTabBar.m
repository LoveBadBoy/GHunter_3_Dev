//
//  GHTabBar.m
//  ghunter
//
//  Created by ImGondar on 15/3/17.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import "GHTabBar.h"
#import "ghunterReleaseSkillViewController.h"
#import "ghunterReleaseViewController.h"
#import "ghunterTabViewController.h"

@interface GHTabBar ()
@property(nonatomic, weak)UIView *plusBGView;
@property(nonatomic, weak)UIButton *plusButton;

@property(nonatomic, weak)UIView *coverView;
@property(nonatomic, weak)UIButton *coverButton;
@property(nonatomic, weak)UIButton *taskButton;
@property(nonatomic, weak)UIButton *skillButton;

@property(nonatomic, assign)CGFloat buttonWidth;

@property (nonatomic, strong)UIDynamicAnimator *animator;

@end

@implementation GHTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

// 创建加号按钮
- (void)setup{
    UIView *plusBGView = [[UIView alloc] init];
    UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth / 5, 44)];
    [plusButton setImage:[UIImage imageNamed:@"home_create_icon_normal"] forState:UIControlStateNormal];
//    [plusButton setBackgroundImage:[UIImage imageNamed:@"home_create_icon_normal"] forState:UIControlStateNormal];
    [plusButton setImage:[UIImage imageNamed:@"home_create_icon_cancel"] forState:UIControlStateSelected];
    [plusButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
//    CGFloat insets = -(self.frame.size.width / 5 - 100) * 0.5;
    CGFloat insets = 3;
    [plusButton setImageEdgeInsets:UIEdgeInsetsMake(insets, insets, insets, insets)];
    _plusButton = plusButton;
    _plusBGView = plusBGView;
    [_plusBGView addSubview:_plusButton];
    [self addSubview:_plusBGView];
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return _animator;
}

// 发布按钮的点击事件
- (void)plusClick{
    if(!imgondar_islogin) {
//        [ProgressHUD show:@"未登录，请先登录"];
//        [UIView animateWithDuration:0.05f animations:^{
//            _plusButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.05f animations:^{
//                _plusButton.transform = CGAffineTransformMakeScale(1, 1);
//            }];
//        }];
        
        self.plusButton.selected = NO;
        //跳转到下一个控制器
        ghunterLoginViewController *login = [[ghunterLoginViewController alloc] init];
        [login setCallBackBlock:^{
            // self.tabBarController.selectedIndex = 0;
        }];
        //拿出来根控制器
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
        
        [self addPlusButtonToTabBar];
        if (_coverView != nil) {
            [_coverView removeFromSuperview];
            _coverView = nil;
        }
        return;
    }
    if (!_plusButton.selected) {
        self.plusButton.selected = YES;
        
        self.buttonWidth = 50;
        
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        
        if (_coverView == nil) {
            UIView *coverView = [[UIView alloc] init];
            [coverView setFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
            coverView.alpha = 0;
            _coverView = coverView;
            [win addSubview:_coverView];
            
            UIButton *coverButton = [[UIButton alloc] init];
            [coverButton setFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
            [coverButton setBackgroundColor:[UIColor whiteColor]];
            [coverButton setAlpha:0.9];
            [coverButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
            _coverButton = coverButton;
            
            UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"publish_description"]];
            [titleImageView setFrame:CGRectMake(50, 100, 200, 100)];
            titleImageView.center = CGPointMake(mainScreenWidth / 2, titleImageView.center.y);
            [_coverButton addSubview:titleImageView];
            [_coverView addSubview:_coverButton];
            
            CGFloat textSize = 12;
            
            UIButton *taskButton = [[UIButton alloc] init];
            [taskButton setFrame:CGRectMake((mainScreenWidth - 3 * self.buttonWidth) * 0.5, mainScreenheight, self.buttonWidth, self.buttonWidth)];
            [taskButton setImage:[UIImage imageNamed:@"publish_task"] forState:UIControlStateNormal];
            [taskButton addTarget:self action:@selector(releaseTask:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.buttonWidth + 10, self.buttonWidth, 20)];
            [taskLabel setText:@"发布任务"];
            [taskLabel setTextAlignment:NSTextAlignmentCenter];
            [taskLabel setFont:[UIFont systemFontOfSize:textSize]];
            [taskButton addSubview:taskLabel];
            _taskButton = taskButton;
            [_coverView addSubview:_taskButton];
            
            UIButton *skillButton = [[UIButton alloc] init];
            [skillButton setFrame:CGRectMake((mainScreenWidth - 3 * self.buttonWidth) * 0.5 + 2 * self.buttonWidth, mainScreenheight, self.buttonWidth, self.buttonWidth)];
            [skillButton setImage:[UIImage imageNamed:@"publish_skill"] forState:UIControlStateNormal];
            [skillButton addTarget:self action:@selector(releaseSkill:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *skillLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.buttonWidth + 10, self.buttonWidth, 20)];
            [skillLabel setText:@"发布技能"];
            [skillLabel setTextAlignment:NSTextAlignmentCenter];
            [skillLabel setFont:[UIFont systemFontOfSize:textSize]];
            [skillButton addSubview:skillLabel];
            _skillButton = skillButton;
            [_coverView addSubview:_skillButton];
        }
        // 发布视图从屏幕外进入屏幕，动画 UIDynamic
        
        //    [self.animator removeAllBehaviors];
        //    //1.重力行为
        //    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]init];
        //    //（1）设置重力的方向（是一个角度）
        //    //    gravity.angle = (M_PI_2-M_PI_4);
        //    //（2）设置重力的加速度,重力的加速度越大，碰撞就越厉害
        //    gravity.magnitude = 100;
        //    //（3）设置重力的方向（是一个二维向量）
        //    gravity.gravityDirection = CGVectorMake(0, -1);
        //    [gravity addItem:taskButton];
        //    [gravity addItem:skillButton];
        //
        //    //2.碰撞检测行为
        //    UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
        //    [collision addItem:taskButton];
        //    [collision addItem:skillButton];
        //    [collision addBoundaryWithIdentifier:@"line" fromPoint:CGPointMake(0, 300) toPoint:CGPointMake(mainScreenWidth, 300)];
        //    //让参照视图的边框成为碰撞检测的边界
        ////    collision.translatesReferenceBoundsIntoBoundary=YES;
        //    //3.执行仿真
        //    [self.animator addBehavior:gravity];
        //    [self.animator addBehavior:collision];
        
        //    for (UIButton *btn in self.subviews) {
        //        if ([btn isKindOfClass:[UIButton class]]) {
        //            UIButton *dupButton = [btn copy];
        //            [win addSubview:dupButton];
        //            CGRect frame = dupButton.frame;
        //            frame.origin.y = mainScreenheight - frame.size.height;
        //            [dupButton setFrame:frame];
        //            [win bringSubviewToFront:btn];
        //        }
        //    }
        
        
        
        CGRect frame = _plusBGView.frame;
        frame.origin.y = (mainScreenheight - self.frame.size.height);
        [_plusButton setFrame:frame];
        [_coverView addSubview:_plusButton];
        
        // Animation
        _plusButton.transform = CGAffineTransformRotate(_plusButton.transform, -M_PI_4);
        [UIView animateWithDuration:0.3f animations:^{
            [_taskButton setFrame:CGRectMake((mainScreenWidth - 3 * self.buttonWidth) * 0.5, (mainScreenheight - self.buttonWidth) * 0.5, self.buttonWidth, self.buttonWidth)];
            [_skillButton setFrame:CGRectMake((mainScreenWidth - 3 * self.buttonWidth) * 0.5 + 2 * self.buttonWidth, (mainScreenheight - self.buttonWidth) * 0.5, self.buttonWidth, self.buttonWidth)];
            _coverView.alpha = 1;
            _plusButton.transform = CGAffineTransformRotate(_plusButton.transform, M_PI_4);
        }];
    }
    else {
        self.plusButton.selected = NO;
        _plusButton.transform = CGAffineTransformRotate(_plusButton.transform, M_PI_4);
        [UIView animateWithDuration:0.3f animations:^{
            [_taskButton setFrame:CGRectMake((mainScreenWidth - 3 * self.buttonWidth) * 0.5, mainScreenheight, self.buttonWidth, self.buttonWidth)];
            [_skillButton setFrame:CGRectMake((mainScreenWidth - 3 * self.buttonWidth) * 0.5 + 2 * self.buttonWidth, mainScreenheight, self.buttonWidth, self.buttonWidth)];
            _coverView.alpha = 0;
            _plusButton.transform = CGAffineTransformRotate(_plusButton.transform, -M_PI_4);
        } completion:^(BOOL finished) {
            if (_coverView != nil) {
                [_coverView removeFromSuperview];
                _coverView = nil;
            }
        }];
        [self addPlusButtonToTabBar];
    }
}

- (void)addPlusButtonToTabBar {
    CGRect frame = _plusBGView.bounds;
    [_plusButton setFrame:frame];
    [_plusBGView addSubview:_plusButton];
}

- (void)releaseTask:(UIButton *)sender {
    self.plusButton.selected = NO;
    //跳转到下一个控制器
    ghunterReleaseViewController *vc = [[ghunterReleaseViewController alloc] init];
    [vc setCallBackBlock:^{
//        self.tabBarController.selectedIndex = 0;
    }];
    //拿出来根控制器
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    
    [self addPlusButtonToTabBar];
    if (_coverView != nil) {
        [_coverView removeFromSuperview];
        _coverView = nil;
    }
}


- (void)releaseSkill:(UIButton *)sender {
    self.plusButton.selected = NO;
    //跳转到下一个控制器
    ghunterReleaseSkillViewController *vc = [[ghunterReleaseSkillViewController alloc] init];
    [vc setCallBackBlock:^{
//        self.tabBarController.selectedIndex = 0;
    }];
    //拿出来根控制器
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    
    [self addPlusButtonToTabBar];
    if (_coverView != nil) {
        [_coverView removeFromSuperview];
        _coverView = nil;
    }
}

//在这个方法里面设置里面控件的frame
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setFrame:CGRectMake(0, mainScreenheight - TAB_BAR_HEIGHT, mainScreenWidth, TAB_BAR_HEIGHT)];
    
    CGFloat w = self.frame.size.width / 5;
    CGFloat h = self.frame.size.height;
    NSInteger i = 0;
    for (UIView *child in self.subviews) {
        
        //判断一下是不是tabbar
        if ([child isKindOfClass:[UIControl class]]&&![child isKindOfClass:[UIButton class]]) {
            CGFloat buttonX = i * w;
            child.frame = CGRectMake(buttonX, 0, w, h);
            i++;
            if (i == 2) {
                i++;
            }
        }
    }
    
    //设置加号按钮的frame
    [_plusBGView setFrame:CGRectMake(w * 2, 0, w, h)];
    [_plusButton setFrame:CGRectMake(0, 0, w, h)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end