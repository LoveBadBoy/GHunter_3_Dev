//
//  DWTagList.h
//  ghunter
//
//  Created by ImGondar on 15/9/25.
//  Copyright © 2015年 ghunter. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Header.h"


@protocol dangbuttondelegate <NSObject>
-(void)dangbtn:(NSString *)text;
@end


@interface DWTagList : UIView
{
    
    UIView *view;
    NSArray *textArray;
    CGSize sizeFit;
    UIColor *lblBackgroundColor;
    UIButton *label;
    BOOL _selset;
}
@property(weak, nonatomic)id<dangbuttondelegate>dangdele;

@property (assign,nonatomic) float totalHeight;
@property (nonatomic, strong) UIView *view;
@property (assign,nonatomic) NSInteger codeint;
@property (nonatomic, strong) NSArray *textArray;
- (void)setLabelBackgroundColor:(UIColor *)color;
- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;

@end
