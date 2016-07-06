//
//  AOTag.m
//  AOTagDemo
//
//  Created by Loïc GRIFFIE on 16/09/13.
//  Copyright (c) 2013 Appsido. All rights reserved.
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

#import "AOTag.h"

#define tagFontSize         12.0f
#define tagFontType         @"Helvetica-Light"
#define tagMargin           4.0f
#define tagHeight           20.0f
#define tagCornerRadius     10.0f
#define tagCloseButton      20.0f
#define listHeight          305.0f

@implementation AOTagList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        self.tags = [[NSMutableArray alloc] init];
        AOEditTag *editTag = [[AOEditTag alloc] init];
        
        [self.tags addObject:editTag];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self showTag];
}

- (void)showTag{
    int n = 0;
    float x = 10.0f;
    float y = tagMargin;
    
    for (id v in [self subviews])
        if ([v isKindOfClass:[AOTag class]])
            [v removeFromSuperview];
    
    for (id tag in self.tags)
    {
        if([tag isKindOfClass:[AOTag class]]){
            if (x + [tag getTagSize].width + 8.0f > self.frame.size.width) { n = 0; x = 10.0; y += [tag getTagSize].height + tagMargin; }
            else x += (n ? tagMargin : 0.0f);
            
            [tag setFrame:CGRectMake(x, y, [tag getTagSize].width, [tag getTagSize].height)];
            [self addSubview:tag];
            
            x += [tag getTagSize].width;
        }else if ([tag isKindOfClass:[AOEditTag class]]){
            if (x + [tag getEditTagSize].width + 8.0f > self.frame.size.width) { n = 0; x = 10.0; y += [tag getEditTagSize].height + tagMargin; }
            else x += (n ? tagMargin : 0.0f);
            
            [tag setFrame:CGRectMake(x, y, [tag getEditTagSize].width, [tag getEditTagSize].height)];
            [self addSubview:tag];
            
            x += [tag getEditTagSize].width;
        }
        n++;
    }
    
    CGRect r = [self frame];
    r.size.height = y + tagHeight + tagMargin;
    [self setFrame:r];
}

- (void)generateTagWithLabel:(NSString *)tTitle
{
    AOTag *aoTag = [[AOTag alloc] initWithFrame:CGRectZero];
    
    [aoTag setDelegate:self.delegate];
    [aoTag setTTitle:tTitle];
    for (id tag in self.tags) {
        if([tag isKindOfClass:[AOTag class]]){
            if([[tag tTitle] isEqualToString:tTitle]) return;
        }
    }
    if([self.tags count] < 11){
        [self.tags insertObject:aoTag atIndex:[self.tags count] - 1];
    }
}

- (void)addTag:(NSString *)tTitle
{
    [self generateTagWithLabel:(tTitle ? tTitle : @"")];
    [self setNeedsDisplay];
}

- (void)removeTag:(AOTag *)tag
{
    [self.tags removeObject:tag];
    [self setNeedsDisplay];
}

@end

@implementation AOTag

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tBackgroundColor = [UIColor colorWithRed:246/255.0 green:152/255.0 blue:83/255.0 alpha:1.000];
        self.tLabelColor = [UIColor whiteColor];
        
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
    
    return CGSizeMake(tagMargin + tSize.width + tagMargin + tagCloseButton + tagMargin, tagHeight);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.layer.backgroundColor = [self.tBackgroundColor CGColor];
    
    CGSize tSize = [self.tTitle sizeWithFont:[UIFont fontWithName:tagFontType size:tagFontSize]];
    
    [[UIColor whiteColor] set];
    [self.tTitle drawInRect:CGRectMake(tagMargin, ([self getTagSize].height / 2.0f) - (tSize.height / 2.0f), tSize.width + tagMargin, tSize.height) withFont:[UIFont fontWithName:tagFontType size:tagFontSize]];
    AOTagCloseButton *close = [[AOTagCloseButton alloc] initWithFrame:CGRectMake([self getTagSize].width - tagHeight, 0.0, tagHeight, tagHeight)];
    [self addSubview:close];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagSelected:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidAddTag:)])
        [self.delegate performSelector:@selector(tagDidAddTag:) withObject:self];
}

- (void)tagSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidSelectTag:)])
        [self.delegate performSelector:@selector(tagDidSelectTag:) withObject:self];
}

- (void)tagClose:(id)sender
{
    [(AOTagList *)[self superview] removeTag:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidRemoveTag:)])
        [self.delegate performSelector:@selector(tagDidRemoveTag:) withObject:self];
}

@end

@implementation AOTagCloseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 16, 16)];
        [image setImage:[UIImage imageNamed:@"delete_tag"]];
        [self addSubview:image];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClose:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
}

- (void)tagClose:(id)sender
{
    if ([[self superview] respondsToSelector:@selector(tagClose:)])
        [[self superview] performSelector:@selector(tagClose:) withObject:self];
}

@end



@implementation AOEditTag

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tBackgroundColor = [UIColor colorWithRed:228/255.0 green:227/255.0 blue:220/255.0 alpha:1.000];
        self.tTextfiledColor = [UIColor whiteColor];
        self.tText.delegate = self;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        [[self layer] setCornerRadius:tagCornerRadius];
        [[self layer] setMasksToBounds:YES];
        
    }
    return self;
}

- (CGSize)getEditTagSize
{
    NSString *addStr = @"手动添加";
    CGSize tSize = [addStr sizeWithFont:[UIFont fontWithName:tagFontType size:tagFontSize]];
    return CGSizeMake(tagMargin + tSize.width + tagMargin + tagCloseButton + tagMargin, tagHeight);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.layer.backgroundColor = [self.tBackgroundColor CGColor];
    
    NSString *addStr = @"手动添加";
    CGSize tSize = [addStr sizeWithFont:[UIFont fontWithName:tagFontType size:tagFontSize]];
    self.tText = [[UITextField alloc] initWithFrame:CGRectMake(tagMargin, 0, tSize.width + tagMargin, tagHeight)];
    [self.tText setTextColor:[UIColor colorWithRed:89/255.0 green:87/255.0 blue:87/255.0 alpha:1.0]];
    self.tText.font = [UIFont fontWithName:tagFontType size:tagFontSize];
    self.tText.placeholder = @"手动添加";
    self.tText.returnKeyType = UIReturnKeyDone;
    self.tText.delegate = self;
    [self addSubview:self.tText];
    
    AOEditFinishButton *editFinish = [[AOEditFinishButton alloc] initWithFrame:CGRectMake(tSize.width + 3 * tagMargin, 0.0, tagHeight, tagHeight)];
    [self addSubview:editFinish];
}

- (void)editFinish:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addTag:)])
        [self.delegate performSelector:@selector(addTag:) withObject:self];
    if([self.tText.text length] != 0){
        [(AOTagList *)[self superview] addTag:self.tText.text];
        NSLog(@"text:%@",self.tText.text);
    }
    [self.tText endEditing:YES];
}

#pragma mark - UITextfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tText resignFirstResponder];
    return YES;
}

@end

@implementation AOEditFinishButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 16, 16)];
        [image setImage:[UIImage imageNamed:@"define_tag"]];
        [self addSubview:image];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editFinish:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
}

- (void)editFinish:(id)sender
{
    if ([[self superview] respondsToSelector:@selector(editFinish:)])
        [[self superview] performSelector:@selector(editFinish:) withObject:self];
}
@end