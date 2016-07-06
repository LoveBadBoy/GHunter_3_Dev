//
//  YcKeyBoardView.h
//  KeyBoardAndTextView
//
#define kStartLocation 20
#import "Monitor.h"
#import <UIKit/UIKit.h>
#import "ghunterSkillViewController.h"
@class YcKeyBoardView;
@protocol YcKeyBoardViewDelegate <NSObject>

-(void)keyBoardViewHide:(YcKeyBoardView *)keyBoardView textView:(UITextView *)contentView;
@end


@interface YcKeyBoardView : UIView
{
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
}

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,assign) id<YcKeyBoardViewDelegate> delegate;


@end
