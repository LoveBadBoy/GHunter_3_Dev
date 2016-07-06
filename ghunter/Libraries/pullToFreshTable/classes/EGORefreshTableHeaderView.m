//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
        isLoading = NO;
        
        CGFloat midY = frame.size.height - PULL_AREA_HEIGTH/2;
        /* Config activity indicator */
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:DEFAULT_ACTIVITY_INDICATOR_STYLE];
		view.frame = CGRectMake((mainScreenWidth - 20.0) / 2.0,midY - 8, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;		
		
		[self setState:EGOOPullNormal];
        
        /* Configure the default colors and arrow image */
        [self setBackgroundColor:nil textColor:nil arrowImage:nil];
    }
    return self;
}


#pragma mark -
#pragma mark Setters

- (void)setState:(EGOPullState)aState{
	switch (aState) {
		case EGOOPullPulling:
//            [_activityView startAnimating];
			break;
		case EGOOPullNormal:
            
			break;
		case EGOOPullLoading:
			
			break;
		default:
			break;
	}
	_state = aState;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *) textColor arrowImage:(UIImage *) arrowImage
{
    self.backgroundColor = backgroundColor? backgroundColor : DEFAULT_BACKGROUND_COLOR;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	if (_state == EGOOPullLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, PULL_AREA_HEIGTH);
        UIEdgeInsets currentInsets = scrollView.contentInset;
        currentInsets.top = offset;
        scrollView.contentInset = currentInsets;
	} else if (scrollView.isDragging) {
		if (_state == EGOOPullPulling && scrollView.contentOffset.y > -PULL_TRIGGER_HEIGHT && scrollView.contentOffset.y < 0.0f && !isLoading) {
			[self setState:EGOOPullNormal];
		} else if (_state == EGOOPullNormal && scrollView.contentOffset.y < -PULL_TRIGGER_HEIGHT && !isLoading) {
			[self setState:EGOOPullPulling];
		}
		if (scrollView.contentInset.top != 0) {
            UIEdgeInsets currentInsets = scrollView.contentInset;
            currentInsets.top = 0;
            scrollView.contentInset = currentInsets;
		}
    }
}

- (void)startAnimatingWithScrollView:(UIScrollView *) scrollView {
    isLoading = YES;
    
    [self setState:EGOOPullLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    UIEdgeInsets currentInsets = scrollView.contentInset;
    currentInsets.top = PULL_AREA_HEIGTH;
    scrollView.contentInset = currentInsets;
    [UIView commitAnimations];
    if(scrollView.contentOffset.y == 0){
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -PULL_TRIGGER_HEIGHT) animated:YES];
    }    
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y <= - PULL_TRIGGER_HEIGHT && !isLoading) {
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }
        [self startAnimatingWithScrollView:scrollView];
	}
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    isLoading = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    UIEdgeInsets currentInsets = scrollView.contentInset;
    currentInsets.top = 0;
    scrollView.contentInset = currentInsets;
	[UIView commitAnimations];
	[self setState:EGOOPullNormal];
}

- (void)egoRefreshScrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_activityView startAnimating];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate=nil;
	[_activityView release];
    [super dealloc];
}
@end