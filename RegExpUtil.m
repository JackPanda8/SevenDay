//  正则表达式工具类
//  RegExpUtil.m
//  SevenDay
//
//  Created by macbook for test on 16/12/13.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "RegExpUtil.h"
#define PhoneNumber @"^1[3|4|5|7|8][0-9]\\d{8}$"
#define Password @"^([A-Z]|[a-z]|[0-9]|[`~!@#$%^&*()+=|{}':;',\\\\[\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]){6,20}$"//密码必须由6~20位数字字母或符号组成
#define Username @"^[a-zA-Z]\w{4,16}$"//用户名必须由4~16位字母数字或下划线组成且不能以数字开头

@implementation RegExpUtil

+(BOOL) validatePhoneNumber:(NSString*) number{//验证手机号
    BOOL result;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PhoneNumber];
    result = [predicate evaluateWithObject:number];

    return result;
}

+(BOOL) validatePassword:(NSString*) password{//验证密码格式
    BOOL result;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Password];
    result = [predicate evaluateWithObject:password];
    
    return result;

}

@end
