//
//  ghunterOccModel.m
//  ghunter
//
//  Created by ImGondar on 15/9/25.
//  Copyright © 2015年 ghunter. All rights reserved.
//

#import "ghunterOccModel.h"

@implementation ghunterOccModel
+ (instancetype)messageModelWithDict:(NSDictionary *)dict
{

    ghunterOccModel *message = [[self alloc] init];
    message.industry = [super judge_String_IsNull:dict[@"title"]];
    message.colorstr = [super judge_String_IsNull:dict[@"wicon"][@"color"]];
    message.wordstr = [super judge_String_IsNull:dict[@"wicon"][@"word"]];
    return message;
}


@end
