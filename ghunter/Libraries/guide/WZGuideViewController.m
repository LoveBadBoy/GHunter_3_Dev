//
//  WZGuideViewController.m
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import "WZGuideViewController.h"

@interface WZGuideViewController ()
@property(nonatomic,retain)UIPageControl *pageControl;
@end

@implementation WZGuideViewController

@synthesize animating = _animating;

@synthesize pageScroll = _pageScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -

- (CGRect)onscreenFrame
{
	return CGRectMake(0, 0, mainScreenWidth, mainScreenheight);
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	return frame;
}

- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[WZGuideViewController sharedGuide].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.f];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[WZGuideViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideShown
{
	_animating = NO;
}

- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
	[[[WZGuideViewController sharedGuide] view] removeFromSuperview];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

+ (void)show
{
    [[WZGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[WZGuideViewController sharedGuide] showGuide];
}

+ (void)hide
{
	[[WZGuideViewController sharedGuide] hideGuide];
}

#pragma mark - 

+ (WZGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static WZGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton
{
    [checkButton setSelected:!checkButton.selected];
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *imageNameArray = [NSArray arrayWithObjects:@"guide1", @"guide2",@"guide3", @"guide4", nil];
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    _pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.delegate = self;
    // self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageScroll.contentSize = CGSizeMake(mainScreenWidth * imageNameArray.count, mainScreenheight);
    [self.view addSubview:self.pageScroll];
    NSString *imgName = nil;
    UIView *view;
    for (int i = 0; i < imageNameArray.count; i++) {
        imgName = [imageNameArray objectAtIndex:i];
        view = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i), 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [image setImage:[UIImage imageNamed:imgName]];
        [view addSubview:image];
        [self.pageScroll addSubview:view];
        // [self.pageControl setBackgroundColor:[UIColor blackColor]];
        
        if (i == imageNameArray.count - 1) {
            UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 175.f, 35.f)];
            //[enterButton setTitle:@"" forState:UIControlStateNormal];
            //[enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //[enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [enterButton setCenter:CGPointMake(self.view.center.x, mainScreenheight - 60.0)];
            [enterButton setBackgroundImage:[UIImage imageNamed:@"立即体验"] forState:UIControlStateNormal];
            // [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_launch_app"] forState:UIControlStateHighlighted];
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:enterButton];
        }
    }
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [self.pageControl setCenter:CGPointMake(self.view.center.x, mainScreenheight - 20.0)];
    self.pageControl.numberOfPages = [imageNameArray count];
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.pageScroll.frame.size.width;
    int page = floor((self.pageScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.pageControl.currentPage = page;
}

@end
