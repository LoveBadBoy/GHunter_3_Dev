//
//  Monitor.h
//  ghunter
//
//  Created by ImGondar on 15/8/28.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//
//
//#import <Foundation/Foundation.h>
//
//@interface Monitor : NSObject
//@property (strong,nonatomic) NSString *Identify;
//+(Monitor *)shardedinstance;
//@end

#import <Foundation/Foundation.h>

@interface Monitor : NSObject
@property(strong,nonatomic) NSString *plbante;
@property(strong,nonatomic) NSString *Identify;
@property (strong,nonatomic) NSString *remark;
@property(strong,nonatomic) NSString *fenzhi;
@property (strong,nonatomic) NSString *ggzhi;
@property (strong,nonatomic) NSString *addres;
@property (strong,nonatomic) NSString *biaoqing;
@property (strong,nonatomic) NSString *zhaopian;
@property (strong,nonatomic) NSString *shouqi;
@property (strong,nonatomic) NSString *alter;
@property (strong,nonatomic) NSString *hots;
@property (strong,nonatomic) NSString *monstr;
+(Monitor*)sharedInstance;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
