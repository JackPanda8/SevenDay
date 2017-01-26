//
//  SetPasswordViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/12/12.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "SetPasswordViewController.h"
NSString* const SET_PASSWORD_URL = @"https://";

@interface SetPasswordViewController ()

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextStep:(id)sender {
    if([self checkPwd]) {
        [[HUDHelper sharedInstance] syncLoading:@"注册中..."];
        [self postPassword:_inputPwd.text ofUserPhoneNum:_phoneNumber];
//        [[TLSHelper getInstance] TLSPwdRegCommit:_inputPwd.text andTLSPwdRegListener:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"JumpToInfoVC"]) {
        CompleteBasicInfoViewController* comInfoVC = [[CompleteBasicInfoViewController alloc] init];
        comInfoVC.phoneNumber = _phoneNumber;
    }
}

- (BOOL)checkPwd {
    if([_inputPwd.text isEqualToString:@""] || [_inputPwdAgain.text isEqualToString:@""]) {
        [[HUDHelper sharedInstance] tipMessage:@"密码不能为空"];
        return NO;
    } else {
        if(![_inputPwdAgain.text isEqualToString:_inputPwd.text]) {
            [[HUDHelper sharedInstance] tipMessage:@"两次输入的密码不一致"];
            return NO;
        } else {
            if(!( [RegExpUtil validatePassword:_inputPwd.text] && [RegExpUtil validatePassword:_inputPwdAgain.text] )) {
                [[HUDHelper sharedInstance] tipMessage:@"密码必须由6~20位数字字母或符号组成"];
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma 与后台通信，传递用户名和md5密码

- (void)postPassword:(NSString*)password ofUserPhoneNum:(NSString*) identifier {
    AFHTTPSessionManager* sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:_phoneNumber forKey:@"UserName"];
    [dic setValue:[MD5 MD5String:_inputPwd.text] forKey:@"Password"];
    [sessionManager POST:SET_PASSWORD_URL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[HUDHelper sharedInstance] tipMessage:@"密码设置成功"];
        //跳转到完善信息界面
        [self performSegueWithIdentifier:@"JumpToInfoVC" sender:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[HUDHelper sharedInstance] tipMessage:@"密码设置失败，请重试"];
    }];
    
}

#pragma - TLSPwdRegListener delegate method

/**
 *  请求短信验证码成功
 *
 *  @param reaskDuration 下次请求间隔
 *  @param expireDuration 验证码有效期
 */
-(void)	OnPwdRegAskCodeSuccess:(int)reaskDuration andExpireDuration:(int) expireDuration {
    
}

/**
 *  刷新短信验证码请求成功
 *
 *  @param reaskDuration 下次请求间隔
 *  @param expireDuration 验证码有效期
 */
-(void)	OnPwdRegReaskCodeSuccess:(int)reaskDuration andExpireDuration:(int)expireDuration {
    
}

/**
 *  验证短信验证码成功
 */
-(void)	OnPwdRegVerifyCodeSuccess {
    
}

/**
 *  提交注册成功
 *
 *  @param userInfo 用户信息
 */
-(void)	OnPwdRegCommitSuccess:(TLSUserInfo *)userInfo {
//    [[HUDHelper sharedInstance] syncLoading:@"注册完成"];
//    //跳转到完善信息界面
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self performSegueWithIdentifier:@"JumpToInfoVC" sender:nil];
//    });
}

/**
 *  短信注册失败
 *
 *  @param errInfo 错误信息
 */
-(void)	OnPwdRegFail:(TLSErrInfo *) errInfo{
//    [HUDHelper alertTitle:@"网络请求超时" message:@"请重试" cancel:@"好的"];

}

/**
 *  短信注册超时
 *
 *  @param errInfo 错误信息
 */
-(void)	OnPwdRegTimeout:(TLSErrInfo *) errInfo{
//    [HUDHelper alertTitle:@"网络请求超时" message:@"请重试" cancel:@"好的"];

}

@end
