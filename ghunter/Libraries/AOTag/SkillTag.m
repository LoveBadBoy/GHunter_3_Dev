//
//  SkillTag.m
//  ghunter
//
//  Created by chensonglu on 14-4-21.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import "SkillTag.h"

#define tagFontSize         12.0f
#define tagFontType         @"Helvetica-Light"
#define tagMargin           4.0f
#define tagHeight           20.0f
#define tagCornerRadius     10.0f

@implementation SkillTag
@synthesize heightFinal = _heightFinal;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentMode = UIViewContentModeRedraw;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        self.tags = [[NSMutableArray alloc] init];
    }
    return self;
}

- (CGFloat)heightFinal{
    return _heightFinal;
}

- (void)setHeightFinal:(CGFloat)heightFinal{
    _heightFinal = heightFinal;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
//    [super drawRect:rect];
    [self showTag];
}

- (void)showTag{
    int n = 0;
    float x = 10.0f;
    float y = tagMargin;
    
    for (id v in [self subviews])
        if ([v isKindOfClass:[SkillName class]])
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
    
//    CGRect r = [self frame];
//    r.size.height = y + tagHeight + tagMargin;
//    [self setFrame:r];
    _heightFinal = y + tagHeight + tagMargin;
}


- (SkillName *)generateTagWithLabel:(NSString *)tTitle
{
    SkillName *tag = [[SkillName alloc] initWithFrame:CGRectZero];
    
    [tag setDelegate:self.delegate];
    [tag setTTitle:tTitle];
    
    [self.tags addObject:tag];
    
    return tag;
}

- (void)addTag:(NSString *)tTitle
{
    [self generateTagWithLabel:(tTitle ? tTitle : @"")];
//    [self setNeedsDisplay];
}

- (void)addTags:(NSArray *)tags
{
    for (NSDictionary *tag in tags)
        [self addTag:[tag objectForKey:@"title"]];
    [self showTag];
}

@end

@implementation SkillName

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tBackgroundColor = [UIColor colorWithRed:246/255.0 green:152/255.0 blue:83/255.0 alpha:1.000];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        [[self layer] setCornerRadius:tagCornerRadius];
        [[self layer] setMasksToBounds:YES];
        
    }
    return self;
}

- (CGSize)getTagSize
{
    CGSize tSize = [self.tTitle sizeWithFont:[UIFont fontWithName:tagFontType size:tagFontSize]];
    
    return CGSizeMake(tagMargin + tSize.width + tagMargin, tagHeight);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.layer.backgroundColor = [self.tBackgroundColor CGColor];
    
    CGSize tSize = [self.tTitle sizeWithFont:[UIFont fontWithName:tagFontType size:tagFontSize]];
    
    UILabel *skillNameLable = [[UILabel alloc] initWithFrame:CGRectMake(tagMargin, ([self getTagSize].height / 2.0f) - (tSize.height / 2.0f), tSize.width, tSize.height)];
    skillNameLable.textAlignment = NSTextAlignmentCenter;
    skillNameLable.text = self.tTitle;
    skillNameLable.textColor = [UIColor whiteColor];
    skillNameLable.backgroundColor = [UIColor clearColor];
    skillNameLable.font = [UIFont fontWithName:tagFontType size:tagFontSize];
    [self addSubview:skillNameLable];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagSelected:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
}

- (void)tagSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(skilltagDidSelectTag:)])
        [self.delegate performSelector:@selector(skilltagDidSelectTag:) withObject:self];
}
@end
