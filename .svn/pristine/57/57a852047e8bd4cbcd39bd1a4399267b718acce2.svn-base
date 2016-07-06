//
//  DWTagList.m
//  ghunter
//
//  Created by ImGondar on 15/9/25.
//  Copyright © 2015年 ghunter. All rights reserved.
//
#import "DWTagList.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 2.0f
#define LABEL_MARGIN 5.0f
#define BOTTOM_MARGIN 5.0f
#define FONT_SIZE 13.0f
#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING 6.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor].CGColor
#define BORDER_WIDTH 1.0f

@implementation DWTagList{
    NSInteger selectedTag;
}


@synthesize view, textArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:view];
//        self.codeint =1;
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}
//
//-(void)setCodeint:(NSInteger)codeint{
//    if (codeint == self.codeint) return;
//    _codeint = codeint;
//    [self setNeedsDisplay];
//    
//    
////    [self layoutIfNeeded];
//}

- (void)setLabelBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
    [self display];
}
 

- (void)display
{
    for (UIButton *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
     int i = 0;
    _totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (NSString *text in textArray) {
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(self.frame.size.width, 1500) lineBreakMode:UILineBreakModeWordWrap];
        textSize.width += HORIZONTAL_PADDING*2;
        textSize.height += VERTICAL_PADDING*2;
         label = nil;
        if (!gotPreviousFrame) {
            label = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, textSize.width, textSize.height)];
            _totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width) {
                newRect.origin = CGPointMake(10, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                _totalHeight += textSize.height + BOTTOM_MARGIN;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
                
           
            newRect.size = textSize;
            label = [[UIButton alloc] initWithFrame:newRect];
            
        }

        previousFrame = label.frame;
        gotPreviousFrame = YES;
        label.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        label.titleLabel.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = RGBCOLOR(235, 235, 235);

        [label setTitle:text forState:(UIControlStateNormal)];
        [label setTitleColor:TEXT_COLOR forState:(UIControlStateNormal)];
        [label.layer setMasksToBounds:YES];
        label.userInteractionEnabled = YES;
        [label.layer setCornerRadius:CORNER_RADIUS];
        [label.layer setBorderColor:BORDER_COLOR];
        [label.layer setBorderWidth: BORDER_WIDTH];
        i++;
        label.tag = i;
        [label addTarget:self action:@selector(btn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:label];
        
//        if (i ==self.codeint) {
//            label.backgroundColor = [UIColor redColor];
//        }else{
//            label.backgroundColor = [UIColor whiteColor];
//        }

//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImg:)];
//        [label addGestureRecognizer:singleTap];
//        singleTap.view.tag = label.tag;
//        [self addSubview:label];
    
    }
    CGRect fram;
    fram = self.frame;
    fram.size.height = _totalHeight+10;
    self.frame = fram;
    sizeFit = CGSizeMake(self.frame.size.width, _totalHeight + 1.0f);
    NSLog(@"=====%f",_totalHeight);
    
    
}

-(void)btn:(UIButton *)btn{
    NSLog(@"======%ld",(long)btn.tag);
    if (selectedTag) {
        UIButton *lastButton = (UIButton *)[self viewWithTag:selectedTag];
        [lastButton setBackgroundColor:RGBCOLOR(235, 235, 235)];
    }
    
    UIButton * button = (UIButton *)btn;
    button.backgroundColor = Nav_backgroud;
    selectedTag = button.tag;
    NSLog(@"===%ld",(long)selectedTag);
    if (_dangdele && [_dangdele respondsToSelector:@selector(dangbtn:)]) {
        [self.dangdele dangbtn:[textArray objectAtIndex:selectedTag-1]];
    }

}



//-(void)changeImg:(UITapGestureRecognizer *)tap{
//    NSLog(@"1====%ld",(long)tap.view.tag);
////    for (int i = 0; i<textArray.count; i++) {
////        tap.view.tag = i;
//        UILabel * label2 = (UILabel *)tap.view;
//        label2.backgroundColor = [UIColor redColor];
////    }
// 
//
//}
- (CGSize)fittedSize
{
    return sizeFit;
}

@end
