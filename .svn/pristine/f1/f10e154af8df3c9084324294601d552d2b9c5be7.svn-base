//
//  showTag.m
//  ghunter
//
//  Created by chensonglu on 14-6-2.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import "showTag.h"

#define tagFontSize         12.0f
#define tagFontType         @"Helvetica-Light"
#define tagMargin           4.0f
#define tagHeight           20.0f
#define tagCornerRadius     10.0f
#define tagCloseButton      20.0f

@implementation toshowTagList
@synthesize heightFinal = _heightFinal;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentMode = UIViewContentModeRedraw;
        [self setBackgroundColor:[UIColor clearColor]];
        if(!self.tags){
           self.tags = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (CGFloat)heightFinal{
    return _heightFinal;
}

- (void)setHeightFinal:(CGFloat)heightFinal{
    _heightFinal = heightFinal;
}

- (void)drawRect:(CGRect)rect
{
    [self showTag];
}

- (void)showTag{
    int n = 0;
    float x = 10.0f;
    float y = tagMargin;
    
    for (id v in [self subviews])
        if ([v isKindOfClass:[toshowTag class]])
            [v removeFromSuperview];
    
    for (id tag in self.tags)
    {
        if (x + [tag getTagSize].width + 8.0f > self.frame.size.width) { n = 0; x = 10.0; y += [tag getTagSize].height + tagMargin; }
        else x += (n ? tagMargin : 0.0f);
        
        [tag setFrame:CGRectMake(x, y, [tag getTagSize].width, [tag getTagSize].height)];
        [self addSubview:tag];
        
        x += [tag getTagSize].width;
        n++;
    }
    _heightFinal = y + tagHeight + tagMargin;
}

- (void)generateTagWithDic:(NSDictionary *)dic
{
    toshowTag *tag = [[toshowTag alloc] initWithFrame:CGRectZero];
    NSString *title = [dic objectForKey:@"title"];
    UIColor *titleColor = [dic objectForKey:@"titleColor"];
    UIColor *backgroundColor = [dic objectForKey:@"backgroundColor"];
    UIColor *borderColor = [dic objectForKey:@"borderColor"];
    CGFloat borderWidth = [[dic objectForKey:@"borderWidth"] floatValue];
    [tag setTTitle:(title ? title : @"猎人")];
    [tag setTTitleColor:(titleColor ? titleColor : [UIColor whiteColor])];
    [tag setTBackgroundColor:(backgroundColor ? backgroundColor : RGBA(246, 152, 83, 1.0))];
    [tag setTBorderColor:(borderColor ? borderColor : RGBA(246, 152, 83, 1.0))];
    [tag setBorderWidth:(borderWidth ? borderWidth : 0)];
    tag.borderWidth = borderWidth;
    [self.tags addObject:tag];
}

- (void)addTag:(NSDictionary *)dic
{
    [self generateTagWithDic:dic];
}

- (void)addTags:(NSArray *)tags
{
    for (id tag in tags){
        [self addTag:tag];
    }
    [self showTag];
}

@end

@implementation toshowTag
@synthesize tTitle = _tTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        self.tBackgroundColor = [UIColor colorWithRed:246/255.0 green:152/255.0 blue:83/255.0 alpha:1.000];
        [self setBackgroundColor:[UIColor clearColor]];
        [[self layer] setCornerRadius:tagCornerRadius];
        [[self layer] setMasksToBounds:YES];
    }
    return self;
}

//- (UIColor *)tBackgroundColor {
//    return self.tBackgroundColor;
//}

//- (void)setTBackgroundColor:(UIColor *)tBackgroundColor {
//    self.tBackgroundColor = tBackgroundColor;
//}
//
//- (UIColor *)tTitleColor {
//    return self.tTitleColor;
//}
//
//- (void)setTTitleColor:(UIColor *)tTitleColor {
//    self.tTitleColor = tTitleColor;
//}
//
//- (UIColor *)tBorderColor {
//    return self.tBorderColor;
//}
//
//- (void)setTBorderColor:(UIColor *)tBorderColor {
//    self.tBorderColor = tBorderColor;
//}
//
//- (CGFloat)borderWidth {
//    return self.borderWidth;
//}

//- (void)setBorderWidth:(CGFloat)borderWidth {
//    self.borderWidth = borderWidth;
//}

- (NSString *)tTitle{
    return _tTitle;
}
- (void)setTTitle:(NSString *)tTitle{
    _tTitle = tTitle;
}

- (CGSize)getTagSize
{
    CGSize tSize = [self.tTitle sizeWithFont:[UIFont fontWithName:tagFontType size:tagFontSize]];
    return CGSizeMake(tagMargin + tSize.width + tagMargin, tagHeight);
}

- (void)drawRect:(CGRect)rect
{
    self.layer.backgroundColor = [self.tBackgroundColor CGColor];
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = [self.tBorderColor CGColor];
    CGSize tSize = [self.tTitle sizeWithFont:[UIFont systemFontOfSize:tagFontSize]];
    UILabel *skillNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(tagMargin, ([self getTagSize].height / 2.0f) - (tSize.height / 2.0f), tSize.width, tSize.height)];
    skillNameLabel.textAlignment = NSTextAlignmentCenter;
    skillNameLabel.text = self.tTitle;
    skillNameLabel.textColor = self.tTitleColor;
    skillNameLabel.backgroundColor = [UIColor clearColor];
    skillNameLabel.font = [UIFont fontWithName:tagFontType size:tagFontSize];
    [self addSubview:skillNameLabel];
}

- (void)tagSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toshowTagDidSelectTag:)])
        [self.delegate performSelector:@selector(toshowTagDidSelectTag:) withObject:self];
}
@end

