//
//  SOLoopView.m
//  SOLoopViewDemo
//  https://github.com/scfhao/SOLoopView
//
//  Created by scfhao on 15/8/3.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SOLoopView.h"

@interface SOLoopView ()<UIScrollViewDelegate>

//  Indexs
@property (assign, nonatomic, readonly) NSInteger leftIndex;
@property (assign, nonatomic, readonly) NSInteger rightIndex;
@property (assign, nonatomic, readwrite) NSInteger currentIndex;

//  View
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

//  cache
@property (strong, nonatomic) NSMutableDictionary *viewDictionary;

@end

@implementation SOLoopView {
    NSTimer *_timer;
}

#pragma mark - Initer

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _bottomMarginForPageControl = 1;
    _switchTimeInterval = 2;
    _viewDictionary = [[NSMutableDictionary alloc]init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    [self creatScrollView];
    [self creatPageControl];
}

#pragma mark - Creat SubView
- (void)creatScrollView
{
    if (_scrollView) {
        return;
    }
    _scrollView = [UIScrollView new];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_scrollView];
    NSMutableArray *constraints = [NSMutableArray array];
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_scrollView);
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:nil views:viewsDictionary]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:constraints];
}

- (void)creatPageControl
{
    if (_pageControl) {
        return;
    }
    _pageControl = [UIPageControl new];
    _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.enabled = NO;
    _pageControl.hidden = !self.showPageControlAtBottom;
    [self addSubview:_pageControl];
    
    NSString *visualFormat = [NSString stringWithFormat:@"V:[_pageControl(30)]-%.0f-|", self.bottomMarginForPageControl];
    
    NSMutableArray *constraints = [NSMutableArray array];
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_pageControl);
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:viewsDictionary]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pageControl]|" options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:constraints];
}

#pragma mark - Layout 

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self reloadData];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self stopTimer];
    }
}

- (void)reloadData
{
    [self.viewDictionary removeAllObjects];
    _pageControl.numberOfPages = [self.delegate countOfImageForSOLoopView:self];
    self.scrollView.scrollEnabled = _pageControl.numberOfPages > 1;
    self.currentIndex = 0;
    [self resetTimer];
}

- (void)refreshScrollContent
{
    CGFloat scrollWidth = _scrollView.bounds.size.width;
    [[_scrollView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (![self.delegate countOfImageForSOLoopView:self]) return;
    
    UIView *leftView = [self itemViewAtIndex:self.leftIndex];
    UIView *centerView = [self itemViewAtIndex:self.currentIndex];
    UIView *rightView = [self itemViewAtIndex:self.rightIndex];
    
//    leftView.contentMode = UIViewContentModeScaleToFill;
//    centerView.contentMode = UIViewContentModeScaleToFill;
//    rightView.contentMode = UIViewContentModeScaleToFill;
    
    [_scrollView addSubview:leftView];
    [_scrollView addSubview:centerView];
    [_scrollView addSubview:rightView];
    
    leftView.translatesAutoresizingMaskIntoConstraints = NO;
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    rightView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *constraints = [NSMutableArray array];
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(leftView, centerView, rightView, _scrollView);
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[leftView(==_scrollView)]|" options:0 metrics:nil views:viewsDictionary]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[centerView(==_scrollView)]|" options:0 metrics:nil views:viewsDictionary]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rightView(==_scrollView)]|" options:0 metrics:nil views:viewsDictionary]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[leftView(==_scrollView)][centerView(==_scrollView)][rightView(==_scrollView)]|" options:0 metrics:nil views:viewsDictionary]];
    [_scrollView addConstraints:constraints];
    
    _scrollView.contentOffset = CGPointMake(scrollWidth, 0);
}

#pragma mark - Public Interface

- (void)pauseTheLoop
{
    _timer.fireDate = [NSDate distantFuture];
}

- (void)resetTheLoop
{
    if (_timer) {
        _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.switchTimeInterval];
    } else {
        [self resetTimer];
    }
}

#pragma mark - Handle Timer

- (void)resetTimer
{
    if (_timer) {
        [_timer invalidate];
    }
    if (self.scrollView.scrollEnabled) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.switchTimeInterval target:self selector:@selector(toNextPage) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer
{
    if (_timer) {
        [_timer invalidate];
    }
}

- (void)toNextPage
{
    CGFloat scrollWidth = _scrollView.bounds.size.width;
    [_scrollView scrollRectToVisible:CGRectMake(scrollWidth * 2, 0, scrollWidth, 2) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self handleScrollForScrollView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self handleScrollForScrollView:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self pauseTheLoop];
}

#pragma mark Handle Scroll

- (void)handleScrollForScrollView:(UIScrollView *)scrollView
{
    CGFloat scrollWidth = scrollView.bounds.size.width;
    NSInteger viewCount = [self.delegate countOfImageForSOLoopView:self];
    NSInteger delta = (NSInteger)(scrollView.contentOffset.x / scrollWidth - 1);
    [self resetTheLoop];
    self.currentIndex = (self.currentIndex + delta + viewCount) % viewCount;
}

#pragma mark - Handle Tap

- (void)tapAction
{
    if ([self.delegate respondsToSelector:@selector(SOLoopView:selectViewAtIndex:)]) {
        [self.delegate SOLoopView:self selectViewAtIndex:self.currentIndex];
    }
}

#pragma mark - Property Accessor

- (NSInteger)leftIndex
{
    NSInteger count = [self.delegate countOfImageForSOLoopView:self];
    return (count + self.currentIndex - 1) % count;
}

- (NSInteger)rightIndex
{
    NSInteger count = [self.delegate countOfImageForSOLoopView:self];
    return (self.currentIndex + 1) % count;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    if (self.pageControl) {
        self.pageControl.currentPage = currentIndex;
    }
    [self refreshScrollContent];
}

- (void)setShowPageControlAtBottom:(BOOL)showPageControlAtBottom
{
    if (_showPageControlAtBottom == showPageControlAtBottom) {
        return;
    }
    _showPageControlAtBottom = showPageControlAtBottom;
    self.pageControl.hidden = !showPageControlAtBottom;
}

- (void)setBottomMarginForPageControl:(CGFloat)bottomMarginForPageControl
{
    if (_bottomMarginForPageControl != bottomMarginForPageControl) {
        _bottomMarginForPageControl = bottomMarginForPageControl;
        //  ..修改约束
        for (NSLayoutConstraint *constraint in [self constraints]) {
            if (constraint.firstItem == self && constraint.secondItem == self.pageControl && constraint.firstAttribute == NSLayoutAttributeBottom) {
                constraint.constant = bottomMarginForPageControl;
                break;
            }
        }
    }
}

#pragma mark - 缓存逻辑

- (UIView *)itemViewAtIndex:(NSInteger)index
{
//    UIView *view = self.viewDictionary[@(index)];
//    if (!view) {
//        view = [self.delegate viewForSOLoopView:self atIndex:index];
//        self.viewDictionary[@(index)] = view;
//    }
//    return view;
    return [self.delegate viewForSOLoopView:self atIndex:index];
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"SOLoopView dealloc");
#endif
}

@end
