//
//  MD5.h
//  SevenDay
//
//  Created by macbook for test on 17/1/23.
//  Copyright © 2017年 JackPanda8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface MD5 : NSObject

+ (NSString*) MD5String:(NSString*) inputString;

@end
