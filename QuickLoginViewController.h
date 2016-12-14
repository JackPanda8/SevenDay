//
//  QuickLoginViewController.h
//  SevenDay
//
//  Created by macbook for test on 16/12/12.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TLSSDK/TLSLoginHelper.h>
#import "RegExpUtil.h"


#import <ImSDK/ImSDK.h>
#import "AppDelegate.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

#import "IMALoginViewController.h"
#import "TLSUI/TLSUI.h"
#import <TLSSDK/TLSHelper.h>
#import <TLSSDK/TLSPwdLoginListener.h>
#import <TLSSDK/TLSLoginHelper.h>
#import "TLSSDK/TLSRefreshTicketListener.h"
#import "TLSSDK/TLSOpenLoginListener.h"

@interface QuickLoginViewController : IMALoginViewController 

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verCode;
- (IBAction)getVerCode:(id)sender;
- (IBAction)login:(id)sender;

- (IBAction)hideKeyboard:(id)sender;//隐藏键盘

@end
