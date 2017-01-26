//
//  MD5.m
//  SevenDay
//
//  Created by macbook for test on 17/1/23.
//  Copyright © 2017年 JackPanda8. All rights reserved.
//

#import "MD5.h"

@implementation MD5

+ (NSString*) MD5String:(NSString*) inputString {
    const char* utf8String = [inputString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5(utf8String, strlen(utf8String), result);/*
                                                    extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)
                                                    官方封装好的加密方法
                                                    把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
                                                    */
    NSMutableString* set;
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [set appendFormat:@"%02X", result[i]];
    }/*
      x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
      NSLog("%02X", 0x888);  //888
      NSLog("%02X", 0x4); //04
      */
    return (NSString*)set;
}

@end
