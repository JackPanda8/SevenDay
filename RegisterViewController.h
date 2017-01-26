//
//  RegisterViewController.h
//  SevenDay
//
//  Created by macbook for test on 16/12/12.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TLSSDK/TLSAccountHelper.h>
#import <TLSSDK/TLSPwdRegListener.h>
#import "RegExpUtil.h"
#import "SetPasswordViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "DBCountDownButton.h"
#import <ReactiveObjC.h>

@interface RegisterViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet DBCountDownButton *countDownButton;

- (IBAction)getVerificaitonCode:(id)sender;
- (IBAction)nextStep:(id)sender;

@end
