//
//  AOTag.h
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

#import <UIKit/UIKit.h>

@class AOTag;
@class AOEditTag;

@protocol AOTagDelegate <NSObject>

@optional

- (void)tagDidAddTag:(AOTag *)tag;
- (void)tagDidRemoveTag:(AOTag *)tag;
- (void)tagDidSelectTag:(AOTag *)tag;
- (void)tagDidEdited:(AOEditTag *)editTag;

@end

@interface AOTagList : UIView

@property (nonatomic, weak) id <AOTagDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *tags;

/**************************
 * Methods to load tags with bundle images
 **************************/

/**
 * Create a new tag object
 *
 * @param tTitle the NSString tag label
 * @param tImage the NSString tag image named
 */
- (void)addTag:(NSString *)tTitle;

/**************************
 * Common methods for tags
 **************************/

/**
 * Remove the given tag from the tag list view
 *
 * @param tag the AOTag instance to be removed
 */
- (void)removeTag:(AOTag *)tag;

@end

@interface AOTag : UIView

@property (nonatomic, weak) id <AOTagDelegate> delegate;

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

@interface AOTagCloseButton : UIView

- (id)initWithFrame:(CGRect)frame;

@end

@interface AOEditTag : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id <AOTagDelegate> delegate;

@property (nonatomic, strong) UIColor *tTextfiledColor;
@property (nonatomic, strong) UIColor *tBackgroundColor;
@property (nonatomic, strong) UITextField *tText;

- (CGSize)getEditTagSize;
@end

@interface AOEditFinishButton : UIView

- (id)initWithFrame:(CGRect)frame;

@end