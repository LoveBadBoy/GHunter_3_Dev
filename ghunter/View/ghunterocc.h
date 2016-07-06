//
//  ghunterocc.h
//  ghunter
//
//  Created by ImGondar on 15/9/25.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol backdelegate <NSObject>
-(void)backbtn:(NSString *)back;
@end

@interface ghunterocc : UIView
@property (weak,nonatomic)id<backdelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame;

@end

