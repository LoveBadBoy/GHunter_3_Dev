//
//  RadioButton.h
//  RadioButton
//
//  Created by ohkawa on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  
// 修改 by @idebug QQ群：262091386   12/9/18 
// 增加如下功能：
//  1. 可以设置一个默认选中按钮
//  2. 判断按钮分组，使多个题目选项互不干扰

#import <UIKit/UIKit.h>

@protocol RadioButtonDelegate <NSObject>
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId;
@end

@interface RadioButton : UIView

@property(nonatomic,retain)NSString *groupId;
@property(nonatomic,assign)NSUInteger index;
@property(nonatomic,retain)UIButton *button;
@property(nonatomic,retain)UIImageView *image;
@property(nonatomic,retain)UIImage *normalImage;
@property(nonatomic,retain)UIImage *clickedImage;
@property(nonatomic)BOOL isLeft;
@property(nonatomic)CGSize size;
@property(nonatomic)CGFloat padding;

-(id)initWithGroupId:(NSString*)groupId index:(NSUInteger)index normalImage:(UIImage *)normalimage clickedimage:(UIImage *)clickedimage isLeft:(BOOL)isLeft size:(CGSize)size padding:(CGFloat)padding;
-(void)defaultInitWithnormalImage:(UIImage *)normalImage withClickedImage:(UIImage *)clickedImage isLeft:(BOOL)isLeft size:(CGSize)size padding:(CGFloat)padding;
+(void)addObserverForGroupId:(NSString*)groupId observer:(id)observer;

// 可以设置默认选中项 
- (void) setChecked:(BOOL)isChecked;
@end
