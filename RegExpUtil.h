//  正则表达式工具类
//  RegExpUtil.h
//  SevenDay
//
//  Created by macbook for test on 16/12/13.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegExpUtil : NSObject

+(BOOL) validatePhoneNumber:(NSString*) number;//验证手机号格式

+(BOOL) validatePassword:(NSString*) password;//验证密码格式

@end
