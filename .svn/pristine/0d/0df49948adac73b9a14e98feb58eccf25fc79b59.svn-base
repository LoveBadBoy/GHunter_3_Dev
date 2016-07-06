//
//  SkillTag.h
//  ghunter
//
//  Created by chensonglu on 14-4-21.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SkillName;
@protocol SkillTagDelegate <NSObject>

@optional

- (void)skilltagDidSelectTag:(SkillName *)tag;

@end

@interface SkillTag : UIView

@property (nonatomic, weak) id <SkillTagDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic) CGFloat heightFinal;
- (void)addTags:(NSArray *)tags;
@end

@interface SkillName : UIView

@property (nonatomic, weak) id <SkillTagDelegate> delegate;

@property (nonatomic, strong) UIColor *tLabelColor;
@property (nonatomic, strong) UIColor *tBackgroundColor;

@property (nonatomic, retain) NSString *tTitle;

/**
 * Return a tag object size
 *
 * @return return a tag object CGSize size
 */
- (CGSize)getTagSize;

@end
