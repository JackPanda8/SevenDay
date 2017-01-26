//
//  TokensUtil.m
//  SevenDay
//
//  Created by macbook for test on 17/1/23.
//  Copyright © 2017年 JackPanda8. All rights reserved.
//

#import "TokensUtil.h"

@implementation TokensUtil

+(NSMutableDictionary*) getTokens {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ThreeTokensFromServer"];
}

+(void) setTokens:(NSMutableDictionary*) tokens {
    [[NSUserDefaults standardUserDefaults] setObject:tokens forKey:@"ThreeTokensFromServer"];
}

+(NSString*) getLoginToken {
    NSMutableDictionary* tokens = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThreeTokensFromServer"];
    return [tokens valueForKey:@"LoginToken"];
}
+(NSString*) getAccessToken {
    NSMutableDictionary* tokens = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThreeTokensFromServer"];
    return [tokens valueForKey:@"AccessToken"];
}
+(NSString*) getUserSig {
    NSMutableDictionary* tokens = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThreeTokensFromServer"];
    return [tokens valueForKey:@"UserSig"];
}
+(void) setLoginToken:(NSString*) loginToken {
    NSMutableDictionary* tokens = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThreeTokensFromServer"];
    [tokens setValue:loginToken forKey:@"LoginToken"];
    [[NSUserDefaults standardUserDefaults] setObject:tokens forKey:@"ThreeTokensFromServer"];
}
+(void) setAccessToken:(NSString*) accessToken {
    NSMutableDictionary* tokens = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThreeTokensFromServer"];
    [tokens setValue:accessToken forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:tokens forKey:@"ThreeTokensFromServer"];

}
+(void) setUserSig:(NSString*) userSig {
    NSMutableDictionary* tokens = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThreeTokensFromServer"];
    [tokens setValue:userSig forKey:@"UserSig"];
    [[NSUserDefaults standardUserDefaults] setObject:tokens forKey:@"ThreeTokensFromServer"];

}

@end
