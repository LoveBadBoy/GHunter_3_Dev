//
//  ghunterWordChange.m
//  ghunter
//
//  Created by imgondar on 14/12/10.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import "ghunterWordChange.h"

@implementation ghunterWordChange

+(NSAttributedString*)wordChange:(NSString*)str;
{
    NSString *path=[[NSBundle mainBundle]pathForResource:@"face.plist" ofType:nil];
    NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:path];
    
    //NSLog(@"path:%@",path);
    
    NSString* str1=[[NSString alloc] init];
    //创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSString * pattern = @"\\[[\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re)
    {
        
    }
    //通过正则表达式来匹配字符串
    NSArray *resultArray = [re matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [str substringWithRange:range];
//        NSLog(@"subStr:%@",subStr);
        NSString* imageName=[dic objectForKey:subStr];
        //新建文字附件来存放我们的图片
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        //给附件添加图片
        textAttachment.image=[UIImage imageNamed:imageName];
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        //把图片和图片对应的位置存入字典中
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [imageDic setObject:imageStr forKey:@"image"];
        [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
        //把字典存入数组中
        [imageArray addObject:imageDic];
        
    }
    //从后往前替换
    for (NSInteger i = imageArray.count -1; i >= 0; i--)
    {
        NSRange range;
//        NSLog(@"arr:%@",imageArray);
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    str1=[attributeString string];
    return attributeString;
}


@end
