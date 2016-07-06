//
//  AFNetworkTool.h
//  AFNetText
//
//  Created by wxxu on 15/1/27.
//  Copyright (c) 2015年 wxxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
//#import "AFNetworkTool.h"

@interface AFNetworkTool : NSObject{
    AFHTTPClient *sharedClient;
}

/**第一种，利用AFJSONRequestOperation**/
+ (void)jsonRequestWithUrl:(NSString *)url success:(void (^)(id json))success fail:(void (^)())fail;

+ (void)jsonRequestWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success fail:(void (^)())fail;

/**第二种方法，利用AFHTTPRequestOperation**/
+ (void)httpRequestWithUrl:(NSString *)url success:(void (^)(NSData *data))success fail:(void (^)())fail;

+ (void)httpRequestWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSData *data))success fail:(void (^)())fail;

/**通过URL获取图片**/
+ (void)imageRequestWithUrl:(NSString *)url success:(void (^)(UIImage *image))success fail:(void (^)())fail;

/**URL获取plist文件**/
+ (void)plistRequestWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *plist))success fail:(void (^)())fail;
+ (void)plistRequestWithUrl:(NSString *)url success:(void (^)(NSDictionary *plist))success fail:(void (^)())fail;

/**URL获取XML数据**/
+ (void)xmlRequestWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSXMLParser *xmlParser))success fail:(void (^)())fail;
+ (void)xmlRequestWithUrl:(NSString *)url success:(void (^)(NSXMLParser *xmlParser))success fail:(void (^)())fail;

/**URL上传图片和其他附加参数**/
+ (void)uploadImage:(NSMutableArray *)imageArr forKey:(NSString *)imgKey andParameters:(NSMutableDictionary *)parameters toApiUrl:(NSString *)apiUrl success:(void (^)(NSData *data))success fail:(void (^)())fail;

+ (AFHTTPClient *)sharedClient;

+ (void)httpPostWithUrl:(NSString *)url andParameters:(NSMutableDictionary *)parameters success:(void (^)(NSData *))success fail:(void (^)())fail;

+(NSString *)getDeviceString;

+(int)getHunterID:(int)codeInt :(int)direction;
// 分享统计
// oid 分享对象OID
// type 分享类型
// data 分享数据
// platform 分享平台： android+weixin
+(void)share_record:(NSString *)oid :(NSString *)type :(NSString *) data :(NSString *)platform;


//
+(NSString *)getIndustryIcon:(NSString *) string;

//
+(void)isInstallQQ;


@end
