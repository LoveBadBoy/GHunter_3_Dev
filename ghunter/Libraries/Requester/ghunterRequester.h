//
//  ghunterRequester.h
//  ghunter
//
//  Created by Wangmuxiong on 14-3-6.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"
#import "GTMBase64.h"
#import "BMapKit.h"
#import "UIImageView+WebCache.h"
#import "ProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "ghunterLoadingView.h"
#import "AFNetworking.h"
@interface ghunterRequester : NSObject 
//辅助函数*************************************//
+ (void)dismissAlert;
+ (void)showTip:(NSString *)tip;
+ (void)wrongMsg:(NSString *)msg;
+ (void)noMsg;
+ (NSString *)image2String:(UIImage *)image;
+ (UIImage *)string2Image:(NSString *)string;
+ (void)clearCache;
+ (float)folderSizeAtPath:(NSString *)folderPath;
+ (long long)fileSizeAtPath:(NSString *)filePath;
+ (BOOL)isLeapYear:(NSInteger)year;
//根据生日获取年龄
+ (int)getAge:(NSString *)birthday;
//获取当前时间
+ (NSString *)getTimeNow;
//获取之前时间差
+ (double)gettimeInterval:(NSString *)timeBefore;
//根据时间差之前时间描述
+ (NSString *)getTimeDescripton:(NSString *)timeBefore;
//得到现在与以后时间的时间差
+ (double)gettimeIntervalToFuture:(NSString *)timeFuture;
//根据时间差得到以后的时间描述
+ (NSString *)getTimeDescriptionToFuture:(NSString *)timeFuture;
//根据截止时间得到人性化描述
+ (NSString *)getTaskTimeDescription:(NSString *)timeAfter;
//获取时间
+ (NSString *)setNowTimeShow:(NSInteger)timeType;
//根据类型获取缓存时间
+ (NSString *)getCacheTimeWithKey:(NSString *)cacheTimeKey;
//根据类型设置缓存时间
+ (void)setCacheTime:(NSString *)cacheTime withKey:(NSString *)cachetimeKey;
//根据类型获取缓存内容
+ (id)getCacheContentWithKey:(NSString *)cacheContentKey;
//根据类型设置缓存内容
+ (void)setCacheContent:(id)cacheContent withKey:(NSString *)cachecontentKey;
//根据经纬度求出两点之间的距离
+ (NSString *)calculateDistanceWithLatitude:(NSString *)latitude withLongitude:(NSString *)longitude;
//个人信息查询***********************************//
+ (NSString *)getApi_session_id;
+ (NSString *)getPassword;
+ (NSString *)getUserInfo:(NSString *)key;
//个人信息更新**************************************//
+ (void)setApi_session_id:(NSString *)api_session_id;
+ (void)setPassword:(NSString *)password;
+ (void)setUserInfoDic:(NSDictionary *)dic;
+ (void)setUserInfoWithKey:(NSString *)key withValue:(NSString *)value;
//清除个人信息****************************************//
+ (void)clearProfile;
//封装异步请求**********************************************//
//封装POST方法
+ (void)postwithDelegate:(id)delegate withUrl:(NSString *)posturl withUserInfo:(NSString *)info withDictionary:(NSDictionary *)dic;
//+ (void)postwithDelegate:(id)delegate withUrl:(NSString *)posturl withUserInfo:(NSString *)info withDictionary:(NSDictionary *)dic andIndex:(NSIndexPath*)index;
+ (void)postwithUrl:(NSString *)posturl withURL:(NSString *)url withDictionary:(NSDictionary *)dic;
//封装GET方法
+ (void)getwithDelegate:(id)delegate withUrl:(NSString *)posturl withUserInfo:(NSString *)info withString:(NSString *)string;
+ (void)getwithDelegate1:(id)delegate withUrl1:(NSString *)posturl withUserInfo1:(NSString *)info withString1:(NSString *)string;

//异步请求*********************************************//
//根据技能标签刷新或者获取附近的任务
+ (void)refreshsearchtaskWithLongitude:(NSString *)longitude withLatitude:(NSString *)latitude withPage:(NSInteger)page withSkill:(NSString *)skill withDelegate:(id)delegate;
//根据技能标签加载更多附近的任务
+ (void)getsearchtaskWithLongitude:(NSString *)longitude withLatitude:(NSString *)latitude withPage:(NSInteger)page withSkill:(NSString *)skill withDelegate:(id)delegate;
//根据技能标签刷新或者获取附近的猎人
+ (void)refreshsearchhunterWithLongitude:(NSString *)longitude withLatitude:(NSString *)latitude withPage:(NSInteger)page withSkill:(NSString *)skill withDelegate:(id)delegate;
//根据技能标签加载更多附近的猎人
+ (void)getsearchhunterWithLongitude:(NSString *)longitude withLatitude:(NSString *)latitude withPage:(NSInteger)page withSkill:(NSString *)skill withDelegate:(id)delegate;
//获取技能标签
+ (void)getSkillTagWithDelegate:(id)delegate;

//获取技能类型图片
//+ (NSString *)getSkillCatalogImg:(NSString *)cid;
+ (NSString *)getSkillCatalogImg:(NSInteger)fcid;
//获取任务类型图片
+ (NSString *)getTaskCatalogImg:(NSString *)cid;

@end
