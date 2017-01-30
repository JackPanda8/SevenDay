//
//  TokensUtil.h
//  SevenDay
//
//  Created by macbook for test on 17/1/23.
//  Copyright © 2017年 JackPanda8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokensUtil : NSObject

+(NSMutableDictionary*) getTokens;
+(void) setTokens:(NSMutableDictionary*) tokens;
+(NSString*) getLoginToken;
+(NSString*) getAccessToken;
+(NSString*) getUserSig;
+(NSString*) getUserID;
+(void) setLoginToken:(NSString*) loginToken;
+(void) setAccessToken:(NSString*) accessToken;
+(void) setUserSig:(NSString*) userSig;
+(void)setUserID:(NSString*) userID;

@end
