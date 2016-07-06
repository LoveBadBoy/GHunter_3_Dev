//
//  SOLoopView.h
//  SOLoopDemo
//  https://github.com/scfhao/SOLoopView
//
//  Created by scfhao on 15/8/3.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SOLoopView;
@protocol SOLoopViewDelegate <NSObject>

@required
- (NSInteger)countOfImageForSOLoopView:(SOLoopView *)loopView;
- (UIView *)viewForSOLoopView:(SOLoopView *)loopView atIndex:(NSInteger)index;

@optional
- (void)SOLoopView:(SOLoopView *)loopView selectViewAtIndex:(NSInteger)index;

@end

@interface SOLoopView : UIView

@property (weak, nonatomic) IBOutlet id<SOLoopViewDelegate> delegate;

/* 是否在底部显示分页控制器，默认不显示 */
@property (assign, nonatomic) BOOL showPageControlAtBottom;

/* 分页控制器距离imageLoop底部距离，默认10 */
@property (assign, nonatomic) CGFloat bottomMarginForPageControl;

/* 界面切换间隔，默认2 */
@property (assign, nonatomic) NSTimeInterval switchTimeInterval;

/* 刷新数据源 */
- (void)reloadData;

/* 暂停滚动
 */
- (void)pauseTheLoop;

/* 滚动暂停后通过调用此方法恢复到滚动状态 */
- (void)resetTheLoop;

@end
