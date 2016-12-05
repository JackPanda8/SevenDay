//
//  LoginViewController.h
//  SevenDay
//
//  Created by macbook for test on 16/11/26.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImSDK/ImSDK.h>
#import "AppDelegate.h"
#import "IMALoginViewController.h"
#import "TLSUI/TLSUI.h"
#import "TLSSDK/TLSRefreshTicketListener.h"
#import "TLSSDK/TLSOpenLoginListener.h"

@interface LoginViewController : UIViewController
//<TIMUserStatusListener,TLSUILoginListener,TLSRefreshTicketListener,TLSOpenLoginListener>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(id)sender;
- (IBAction)forgetPassword:(id)sender;

- (IBAction)hideKeyboard:(id)sender;//隐藏键盘
@end
