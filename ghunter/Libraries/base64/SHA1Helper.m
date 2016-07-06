//
//  SHA1Helper.m
//  DianHigh
//
//  Created by SkyJoe on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SHA1Helper.h"

@implementation SHA1Helper

+(NSString *)encode2Base64String:(NSString *)string
{
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    data = [GTMBase64 encodeBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    NSString *result = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    return result;
}       
/*
 -(NSString*) digest:(NSString*)input
 {
 
 NSData *data = [input dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
 uint8_t digest[CC_SHA1_DIGEST_LENGTH];
 CC_SHA1(data.bytes, data.length, digest);
 NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
 
 for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
 [output appendFormat:@"%02x", digest[i]];
 
 return output;
 
 }
 */
@end
