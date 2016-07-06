//
// Copyright (c) 2013 Related Code - http://relatedcode.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//-------------------------------------------------------------------------------------------------------------------------------------------------
//#define sheme_white
#define sheme_black
//-------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define HUD_STATUS_FONT			[UIFont boldSystemFontOfSize:12.0]
//-------------------------------------------------------------------------------------------------------------------------------------------------
#define HUD_STATUS_COLOR		[UIColor whiteColor]
#define HUD_BACKGROUND_COLOR	[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
//-------------------------------------------------------------------------------------------------------------------------------------------------

#define HUD_TIMESHOW_INTVAL 0.8

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface ProgressHUD : UIView
//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (ProgressHUD *)shared;

+ (void)dismiss;
+ (void)show:(NSString *)status;
- (void)hudMake:(NSString *)status imgage:(UIImage *)img spin:(BOOL)spin hide:(BOOL)hide;

@property (atomic, strong) UIWindow *window;
@property (atomic, strong) UIView *hud;
@property (atomic, strong) UILabel *label;

@end
