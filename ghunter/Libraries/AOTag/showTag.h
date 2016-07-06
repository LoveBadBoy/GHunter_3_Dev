//
//  showTag.h
//  ghunter
//
//  Created by chensonglu on 14-6-2.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class toshowTag;

@protocol toshowTagDelegate <NSObject>

@optional

- (void)toshowTagDidSelectTag:(toshowTag *)tag;

@end

@interface toshowTagList : UIView
@property (nonatomic, weak) id <toshowTagDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *tags;
@property (nonatomic) CGFloat heightFinal;
- (void)addTag:(NSDictionary *)dic;
- (void)addTags:(NSArray *)tags;
@end

@interface toshowTag : UIView
@property (nonatomic, weak) id <toshowTagDelegate> delegate;
@property (nonatomic, strong) UIColor *tBackgroundColor;
@property (nonatomic, strong) UIColor *tTitleColor;
@property (nonatomic, strong) UIColor *tBorderColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic, retain) NSString *tTitle;
- (CGSize)getTagSize;

@end