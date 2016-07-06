//
//  ghunterRequester.m
//  ghunter
//
//  Created by Wangmuxiong on 14-3-6.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import "ghunterRequester.h"

@implementation ghunterRequester

//辅助函数*********************************************************//
+ (void)dismissAlert {
    [ProgressHUD dismiss];
}

+ (void)showTip:(NSString *)tip {
    [ProgressHUD show:tip];
    [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:1.0];
}
+ (void)wrongMsg:(NSString *)msg{
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:msg waitUntilDone:false];
}
+ (void)noMsg{
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络异常" waitUntilDone:false];
}
+ (NSString *)image2String:(UIImage *)image {
    NSData *pictureData = UIImageJPEGRepresentation(image, 0.5);
    NSString *pictureDataString = [GTMBase64 stringByEncodingData:pictureData];
    return pictureDataString;
}

+ (UIImage *)string2Image:(NSString *)string {
    UIImage *image = [UIImage imageWithData:[GTMBase64 decodeString:string]];
    return image;
}

+ (void)clearCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *cacheDierecory = [libraryDirectory stringByAppendingPathComponent:@"Caches/com.hackemist.SDWebImageCache.default"];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:cacheDierecory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[cacheDierecory stringByAppendingPathComponent:filename] error:NULL];
    }
}
+ (float)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/(1024.0*1024.0);
}
+ (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//根据生日获取年龄
+ (int)getAge:(NSString *)birthday{
    int age = 0;
    NSString* date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    date = [formatter stringFromDate:[NSDate date]];
    NSRange yearRange = NSMakeRange(0, 4);
    NSRange monthRange = NSMakeRange(5, 2);
    NSRange dayRange = NSMakeRange(8, 2);
    
    NSInteger yearNow= [[date substringWithRange:yearRange] integerValue];
    NSInteger monthNow = [[date substringWithRange:monthRange] integerValue];
    NSInteger dayNow = [[date substringWithRange:dayRange] integerValue];
    
    NSInteger yearBirthday = [[birthday substringWithRange:yearRange] integerValue];
    NSInteger monthBirthday = [[birthday substringWithRange:monthRange] integerValue];
    NSInteger dayBirthday = [[birthday substringWithRange:dayRange] integerValue];
    
    if(yearNow > yearBirthday){
        age = yearNow - yearBirthday - 1;
        if (monthNow > monthBirthday) {
            age++;
        }else if(monthNow == monthBirthday){
            if(dayNow >= dayBirthday){
                age++;
            }
        }
    }else{
        age = yearNow - yearBirthday;
    }
    return age;
}
//获取当前时间
+ (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    return date;
}
//得到与之前时间的时间差
+ (double)gettimeInterval:(NSString *)timeBefore{
    double timeDiff = 0.0;
    NSDateFormatter *formbefore = [[NSDateFormatter alloc]init];
    [formbefore setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *datebefore = [formbefore dateFromString:timeBefore];
    
    NSDateFormatter *formnow= [[NSDateFormatter alloc]init];
    [formnow setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *datenow = [formnow dateFromString:[self getTimeNow]];
    
    timeDiff = [datenow timeIntervalSinceDate:datebefore];
    //单位秒
    return timeDiff;
}
//根据时间差得到之前的时间描述
+ (NSString *)getTimeDescripton:(NSString *)timeBefore{
    NSString *timeDescription;
    double timeDiff = [self gettimeInterval:timeBefore];
    if(timeDiff < 0){
        timeDescription = @"刚刚";
    }else if (timeDiff < ONE_MINUTE){
        timeDescription = @"刚刚";
    }else if (timeDiff < ONE_HOUR){
        timeDescription = [NSString stringWithFormat:@"%i分钟前",(int)timeDiff/60];
    }else if (timeDiff < ONE_DAY){
        timeDescription = [NSString stringWithFormat:@"%i小时前",(int)timeDiff/(60*60)];
    }else if (timeDiff < ONE_MONTH){
        timeDescription = [NSString stringWithFormat:@"%i天前",(int)timeDiff/(24*60*60)];
    }else if (timeDiff < ONE_YEAR){
        timeDescription = [NSString stringWithFormat:@"%i个月前",(int)timeDiff/(30*24*60*60)];
    }else{
        timeDescription = [NSString stringWithFormat:@"%i年前",(int)timeDiff/(12*30*24*60*60)];
    }
    return timeDescription;
}
//得到现在与以后时间的时间差
+ (double)gettimeIntervalToFuture:(NSString *)timeFuture {
    double timeDiff = 0.0;
    NSDateFormatter *formbefore = [[NSDateFormatter alloc]init];
    [formbefore setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateFuture = [formbefore dateFromString:timeFuture];
    
    NSDateFormatter *formnow= [[NSDateFormatter alloc]init];
    [formnow setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [formnow dateFromString:[self getTimeNow]];
    timeDiff = [dateFuture timeIntervalSinceDate:datenow];
    //单位秒
    return timeDiff;
}
//根据时间差得到以后的时间描述
+ (NSString *)getTimeDescriptionToFuture:(NSString *)timeFuture {
    NSString *timeDescription;
    double timeDiff = [self gettimeIntervalToFuture:timeFuture];
    if(timeDiff < 0){
        timeDescription = @"马上";
    }else if (timeDiff < ONE_MINUTE){
        timeDescription = @"1分钟后";
    }else if (timeDiff < ONE_HOUR){
        timeDescription = [NSString stringWithFormat:@"%i分钟后",(int)timeDiff/60];
    }else if (timeDiff < ONE_DAY){
        timeDescription = [NSString stringWithFormat:@"%i小时后",(int)timeDiff/(60*60)];
    }else if (timeDiff < ONE_MONTH){
        timeDescription = [NSString stringWithFormat:@"%i天后",(int)timeDiff/(24*60*60)];
    }else if (timeDiff < ONE_YEAR){
        timeDescription = [NSString stringWithFormat:@"%i个月后",(int)timeDiff/(30*24*60*60)];
    }else{
        timeDescription = [NSString stringWithFormat:@"%i年后",(int)timeDiff/(12*30*24*60*60)];
    }
    return timeDescription;
}
//根据截止时间得到人性化描述
+ (NSString *)getTaskTimeDescription:(NSString *)timeAfter{
    double timeDiff = 0.0;
    NSString *taskTime;
    NSDateFormatter *formAfter = [[NSDateFormatter alloc]init];
    [formAfter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateAfter = [formAfter dateFromString:timeAfter];
    
    NSDateFormatter *formnow= [[NSDateFormatter alloc]init];
    [formnow setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeNowStr = [self getTimeNow];
    NSDate *datenow = [formnow dateFromString:timeNowStr];
    timeDiff = [dateAfter timeIntervalSinceDate:datenow];
    NSArray *timeAfterArray = [timeAfter componentsSeparatedByString:@" "];
    NSString *timeAfter_year_month_day = [timeAfterArray objectAtIndex:0];
    NSArray *timeAfterFrontArray = [timeAfter_year_month_day componentsSeparatedByString:@"-"];
    NSUInteger timeAfterYear = [[timeAfterFrontArray objectAtIndex:0] integerValue];
    NSUInteger timeAfterMonth = [[timeAfterFrontArray objectAtIndex:1] integerValue];
    NSUInteger timeAfterDay = [[timeAfterFrontArray objectAtIndex:2] integerValue];
    NSString *timeAfter_hour_minute = [timeAfterArray objectAtIndex:1];
    NSArray *timeAfterNextArray = [timeAfter_hour_minute componentsSeparatedByString:@":"];
    NSUInteger timeAfterHour = [[timeAfterNextArray objectAtIndex:0] integerValue];
    NSUInteger timeAfterminute = [[timeAfterNextArray objectAtIndex:1] integerValue];
    NSArray *timeNowArray = [timeNowStr componentsSeparatedByString:@" "];
    NSString *timeNow_year_month_day = [timeNowArray objectAtIndex:0];
    NSArray *timeNowFrontArray = [timeNow_year_month_day componentsSeparatedByString:@"-"];
    NSUInteger timeNowYear = [[timeNowFrontArray objectAtIndex:0] integerValue];
    NSUInteger timeNowMonth = [[timeNowFrontArray objectAtIndex:1] integerValue];
    NSUInteger timeNowDay = [[timeNowFrontArray objectAtIndex:2] integerValue];
    if(timeDiff <= 0){
        taskTime = [NSString stringWithFormat:@"%@ 已过期",timeAfter];
    }else if(timeAfterYear == timeNowYear && timeAfterMonth == timeNowMonth && timeAfterDay == timeNowDay){
        taskTime = [NSString stringWithFormat:@"今天%d:%d 前完成",timeAfterHour,timeAfterminute];
    }else if (timeAfterYear == timeNowYear && timeAfterMonth == timeNowMonth && timeAfterDay == (timeNowDay + 1)){
       taskTime = [NSString stringWithFormat:@"明天%d:%d 前完成",timeAfterHour,timeAfterminute];
    }else{
        taskTime = [NSString stringWithFormat:@"%d月%d日%d:%d 前完成",timeAfterMonth,timeAfterDay,timeAfterHour,timeAfterminute];
    }
    return taskTime;
}

//设置现在时间
+ (NSString *)setNowTimeShow:(NSInteger)timeType
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    switch (timeType) {
        case 0:
        {
            NSRange range = NSMakeRange(0, 4);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString;
        }
            break;
        case 1:
        {
            NSRange range = NSMakeRange(4, 2);
            NSString *monthString = [dateString substringWithRange:range];
            return monthString;
        }
            break;
        case 2:
        {
            NSRange range = NSMakeRange(6, 2);
            NSString *dayString = [dateString substringWithRange:range];
            return dayString;
        }
            break;
        case 3:
        {
            NSRange range = NSMakeRange(8, 2);
            NSString *hourString = [dateString substringWithRange:range];
            return hourString;
        }
            break;
        case 4:
        {
            NSRange range = NSMakeRange(10, 2);
            NSString *minuteString = [dateString substringWithRange:range];
            return minuteString;
        }
            break;
        default:
            break;
    }
    return @"00";
}

//根据类型获取缓存时间
+ (NSString *)getCacheTimeWithKey:(NSString *)cacheTimeKey{
    return [[NSUserDefaults standardUserDefaults] objectForKey:cacheTimeKey];
}
//根据类型设置缓存时间
+ (void)setCacheTime:(NSString *)cacheTime withKey:(NSString *)cachetimeKey{
    [[NSUserDefaults standardUserDefaults] setObject:cacheTime forKey:cachetimeKey];
}
//根据类型获取缓存内容
+ (id)getCacheContentWithKey:(NSString *)cacheContentKey{
    return [[NSUserDefaults standardUserDefaults] objectForKey:cacheContentKey];
}
//根据类型设置缓存内容
+ (void)setCacheContent:(id)cacheContent withKey:(NSString *)cachecontentKey{
    [[NSUserDefaults standardUserDefaults] setObject:cacheContent forKey:cachecontentKey];
}
//根据年份判断是否为闰年
+ (BOOL)isLeapYear:(NSInteger)year{
    BOOL isleapYear = NO;
    if(year%4 == 0){
        if(year%100 != 0){
            isleapYear = YES;
        }
    }else if (year%400 == 0){
        isleapYear = YES;
    }
    return isleapYear;
}

//根据经纬度求出两点之间的距离
+ (NSString *)calculateDistanceWithLatitude:(NSString *)latitude withLongitude:(NSString *)longitude{
    CLLocationCoordinate2D CLLocationA = CLLocationCoordinate2DMake([[self getUserInfo:LATITUDE] floatValue], [[self getUserInfo:LONGITUDE] floatValue]);
    BMKMapPoint pointA = BMKMapPointForCoordinate(CLLocationA);
    CLLocationCoordinate2D CLLocationB = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    BMKMapPoint pointB = BMKMapPointForCoordinate(CLLocationB);
    CLLocationDistance locationdistance = BMKMetersBetweenMapPoints(pointA,pointB);
    int distance = (int)(locationdistance);
    NSString *distanceStr;
    if (distance < 1000) {
        distanceStr = [NSString stringWithFormat:@"%dm",distance];
    }else if(distance >= 1000){
        distanceStr = [NSString stringWithFormat:@"%.1fkm",distance/1000.0];
    }
    return distanceStr;
}

//个人信息查询********************************************//
+ (NSString *)getApi_session_id{
    NSString *api_session_id = [[NSUserDefaults standardUserDefaults] objectForKey:API_SESSION_ID];
    if(!api_session_id)
            return @"";
        else
            return api_session_id;
}

+ (NSString *)getPassword{
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD];
    if(!password) return @"";
    else return password;
}
+ (NSString *)getUserInfo:(NSString *)key{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFODIC];
    return [dic objectForKey:key] ? [dic objectForKey:key] : @"";
}
//个人信息更新********************************************//
+ (void)setApi_session_id:(NSString *)api_session_id{
    [[NSUserDefaults standardUserDefaults] setObject:api_session_id forKey:API_SESSION_ID];
}
+ (void)setPassword:(NSString *)password{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:PASSWORD];
}
+ (void)setUserInfoDic:(NSDictionary *)dic{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dic forKey:USERINFODIC];
    [defaults synchronize];
}
+ (void)setUserInfoWithKey:(NSString *)key withValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:USERINFODIC];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [tempDic setValue:value forKey:key];
    [defaults setObject:tempDic forKey:USERINFODIC];
    [defaults synchronize];
}
//清除个人信息*******************************************************//
+ (void)clearProfile{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:PASSWORD];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:API_SESSION_ID];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USERINFODIC];
    
}
//封装POST方法**************************************************************//
+ (void)postwithDelegate:(id)delegate withUrl:(NSString *)posturl withUserInfo:(NSString *)info withDictionary:(NSDictionary *)dic{
    
    NSURL *url = [NSURL URLWithString:posturl];
    //创建http请求
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:HTTP_METHOD_POST];
    [request setPostValue:API_TOKEN_NUM forKey:API_TOKEN];
    // 提交版本号
    [request setPostValue:VERSION_VALUE forKey:VERSION_KEY];
    
    if([self getApi_session_id]) {
        [request setPostValue:[self getApi_session_id] forKey:@"api_session_id"];
    }
    for (id key in [dic allKeys]) {
        [request setPostValue:[dic objectForKey:key] forKey:key];
    }
    [request setDelegate:delegate];
    request.userInfo = [NSDictionary dictionaryWithObject:info forKey:REQUEST_TYPE];
    [request startAsynchronous];
    
}
//+ (void)postwithUrl:(NSString *)posturl withURL:(NSString *)url withDictionary:(NSDictionary *)dic
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *str = [url stringByAppendingString:posturl];
//    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"网络请求成功");
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error:%@",error);
//    }];
//}
//封装GET方法****************************************************************//
+ (void)getwithDelegate:(id)delegate withUrl:(NSString *)posturl withUserInfo:(NSString *)info withString:(NSString *)string{
    
    NSString *urlString = [posturl stringByAppendingString:string];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",@"api_token",API_TOKEN_NUM]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",VERSION_KEY, VERSION_VALUE]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSURL *url =[NSURL URLWithString:urlString];
        
    //创建http请求
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = delegate;
    request.userInfo = [NSDictionary dictionaryWithObject:info forKey:REQUEST_TYPE];
    [request setRequestMethod:HTTP_METHOD_GET];
    [request startAsynchronous];
}
//封装GET方法****************************************************************//
+ (void)getwithDelegate1:(id)delegate withUrl1:(NSString *)posturl withUserInfo1:(NSString *)info withString1:(NSString *)string{
    NSString *urlString = [posturl stringByAppendingString:string];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@&api_session_id=%@",@"api_token",API_TOKEN_NUM,[self getApi_session_id]]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *url =[NSURL URLWithString:urlString];
   
    //创建http请求
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = delegate;
    request.userInfo = [NSDictionary dictionaryWithObject:info forKey:REQUEST_TYPE];
    [request setRequestMethod:HTTP_METHOD_GET];
    [request startAsynchronous];
}
//异步请求*******************************************************//
//根据技能标签刷新或者获取附近的任务
+ (void)refreshsearchtaskWithLongitude:(NSString *)longitude withLatitude:(NSString *)latitude withPage:(NSInteger)page withSkill:(NSString *)skill withDelegate:(id)delegate{
    NSURL *url = [NSURL URLWithString:URL_SEARCH_TASK];
    //创建http请求
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: url];
    [request setRequestMethod:HTTP_METHOD_POST];
    [request setPostValue:skill forKey:@"skill"];
    [request setPostValue:longitude forKey:LONGITUDE];
    [request setPostValue:latitude forKey:LATITUDE];
    [request setPostValue:[NSString stringWithFormat:@"%d",page] forKey:PAGE];
    [request setPostValue:API_TOKEN_NUM forKey:API_TOKEN];
    [request setPostValue:[self getApi_session_id] forKey:API_SESSION_ID];
    [request setDelegate:delegate];
    request.userInfo = [NSDictionary dictionaryWithObject:REQUEST_FOR_REFRESH_SEARCH_TASK forKey:REQUEST_TYPE];
    [request startAsynchronous];
}
//根据技能标签加载更多附近的任务
+ (void)getsearchtaskWithLongitude:(NSString *)longitude withLatitude:(NSString *)latitude withPage:(NSInteger)page withSkill:(NSString *)skill withDelegate:(id)delegate{
    NSURL *url = [NSURL URLWithString:URL_SEARCH_TASK];
    //创建http请求
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: url];
    [request setRequestMethod:HTTP_METHOD_POST];
    [request setPostValue:skill forKey:@"skill"];
    [request setPostValue:longitude forKey:LONGITUDE];
    [request setPostValue:latitude forKey:LATITUDE];
    [request setPostValue:[NSString stringWithFormat:@"%d",page] forKey:PAGE];
    [request setPostValue:API_TOKEN_NUM forKey:API_TOKEN];
    [request setPostValue:[self getApi_session_id] forKey:API_SESSION_ID];
    [request setDelegate:delegate];
    request.userInfo = [NSDictionary dictionaryWithObject:REQUEST_FOR_LOADMORE_SEARCH_TASK forKey:REQUEST_TYPE];
    [request startAsynchronous];
}
//根据技能标签刷新或者获取附近的猎人
+ (void)refreshsearchhunterWithLongitude:(NSString *)longitude withLatitude:(NSString *)latitude withPage:(NSInteger)page withSkill:(NSString *)skill withDelegate:(id)delegate{
    NSURL *url = [NSURL URLWithString:URL_SEARCH_HUNTER];
    //创建http请求
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: url];
    [request setRequestMethod:HTTP_METHOD_POST];
    [request setPostValue:skill forKey:@"skill"];
    [request setPostValue:longitude forKey:LONGITUDE];
    [request setPostValue:latitude forKey:LATITUDE];
    [request setPostValue:[NSString stringWithFormat:@"%d",page] forKey:PAGE];
    [request setPostValue:API_TOKEN_NUM forKey:API_TOKEN];
    [request setPostValue:[self getApi_session_id] forKey:API_SESSION_ID];
    [request setDelegate:delegate];
    request.userInfo = [NSDictionary dictionaryWithObject:REQUEST_FOR_REFRESH_SEARCH_HUNTER forKey:REQUEST_TYPE];
    [request startAsynchronous];
}
//根据技能标签加载更多附近的猎人
+ (void)getsearchhunterWithLongitude:(NSString *)longitude withLatitude:(NSString *)latitude withPage:(NSInteger)page withSkill:(NSString *)skill withDelegate:(id)delegate{
    NSURL *url = [NSURL URLWithString:URL_SEARCH_HUNTER];
    //创建http请求
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: url];
    [request setRequestMethod:HTTP_METHOD_POST];
    [request setPostValue:skill forKey:@"skill"];
    [request setPostValue:longitude forKey:LONGITUDE];
    [request setPostValue:latitude forKey:LATITUDE];
    [request setPostValue:[NSString stringWithFormat:@"%d",page] forKey:PAGE];
    [request setPostValue:API_TOKEN_NUM forKey:API_TOKEN];
    [request setPostValue:[self getApi_session_id] forKey:API_SESSION_ID];
    [request setDelegate:delegate];
    request.userInfo = [NSDictionary dictionaryWithObject:REQUEST_FOR_LOADMORE_SEARCH_HUNTER forKey:REQUEST_TYPE];
    [request startAsynchronous];
}
//获取技能标签
+ (void)getSkillTagWithDelegate:(id)delegate{
    NSURL *url = [NSURL URLWithString:URL_GET_SKILL_TAG];
    //创建http请求
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: url];
    [request setRequestMethod:HTTP_METHOD_POST];
    [request setPostValue:API_TOKEN_NUM forKey:API_TOKEN];
    [request setPostValue:[self getApi_session_id] forKey:API_SESSION_ID];
    [request setDelegate:delegate];
    request.userInfo = [NSDictionary dictionaryWithObject:REQUEST_FOR_GET_SKILL_TAG forKey:REQUEST_TYPE];
    [request startAsynchronous];
}

// 获取技能分类图片
+ (NSString *)getSkillCatalogImg:(NSInteger)fcid{
    if (fcid == 27) {
        return @"skill_classify_27";
    }else if(fcid == 3) {
        return @"skill_classify_3";
    }else if(fcid == 10) {
        return @"skill_classify_10";
    }else if(fcid == 4) {
        return @"skill_classify_4";
    }else if(fcid == 31){
        return @"skill_classify_31";
    }else if(fcid == 35) {
        return @"skill_classify_35";
    }else if(fcid == 52){
        return @"skill_classify_52";
    }else if(fcid == 40){
        return @"skill_classify_40";
    }
    return @"skill_classify_3";
}


// 获取任务分类图片
+ (NSString *)getTaskCatalogImg:(NSString *)cid{
    if ([cid isEqualToString:@"21"]) {
        return @"catalog_activity";
    }else if([cid isEqualToString:@"17"]){
        return @"catalog_coach";
    }else if([cid isEqualToString:@"52"]){
        return @"catalog_leg";
    }else if([cid isEqualToString:@"28"]){
        return @"catalog_love";
    }else if([cid isEqualToString:@"2"]){
        return @"catalog_online";
    }else if([cid isEqualToString:@"10"]){
        return @"catalog_partner";
    }else if([cid isEqualToString:@"5"]){
        return @"catalog_parttime";
    }else if([cid isEqualToString:@"8"]){
        return @"catalog_study";
    }
    return @"catalog_leg";
}

@end
