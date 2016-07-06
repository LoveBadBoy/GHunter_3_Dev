//
//  TQStarRatingView.h
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(TQStarRatingView *)view score:(float)score;

@end

@interface TQStarRatingView : UIView

@property(nonatomic,readwrite)float score;
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number withBack:(NSString *)backImage withFore:(NSString *)foreImage;
- (void)setScore:(float)score;
- (void)setuserInteractionEnabled:(BOOL)userInteractionEnabled;
@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

@end
