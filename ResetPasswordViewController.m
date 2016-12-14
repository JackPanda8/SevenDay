//
//  ResetPasswordViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/12/14.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()

@property(strong, nonatomic) NSString* standardPhoneNum;
@property(strong, nonatomic) NSString* verCodeFromServer;//从后台获取的验证码

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getVerCode:(id)sender {
    //手机号码的格式为国家码-手机号码，如86-155xxxx
    if([self checkPhoneNumber:_phoneNumber.text]) {
        _standardPhoneNum = [NSString stringWithFormat:@"%@", _phoneNumber.text];
        //        [[TLSHelper getInstance] TLSPwdRegAskCode:_standardPhoneNum andTLSPwdRegListener:self];
        [self getVerCodeFromServerWithPhoneNumber:_phoneNumber.text];
    }
}

- (void)getVerCodeFromServerWithPhoneNumber:(NSString*) phoneNum {
    
    _verCodeFromServer = @"123456";
    [[HUDHelper sharedInstance] tipMessage:@"验证码发送成功，请注意查收"];
    
}

//检查手机号的格式
- (BOOL) checkPhoneNumber:(NSString*) number {
    BOOL result = YES;
    if([number isEqualToString:@""]) {
        [HUDHelper alertTitle:@"请先填写手机号码" message:nil cancel:@"好的"];
        result = NO;
    }else {
        if(![RegExpUtil validatePhoneNumber:number]) {
            [HUDHelper alertTitle:@"手机号码格式有误" message:nil cancel:@"好的"];
            result = NO;
        }
    }
    
    return result;
}


- (IBAction)GetItBack:(id)sender {
    if([_verCode.text isEqualToString:@""]){
        [HUDHelper alertTitle:@"验证码不能为空" message:nil cancel:@"好的"];
    } else {
        //        [[TLSHelper getInstance] TLSPwdRegVerifyCode:_verificationCode.text andTLSPwdRegListener:self];
        if(![_verCode.text isEqualToString:_verCodeFromServer]) {
            [[HUDHelper sharedInstance] tipMessage:@"验证码有误，请在30s后重试"];
            //禁用获取验证码按钮，开始倒计时
            
        }else {
            //隐藏键盘
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
            [[HUDHelper sharedInstance] syncLoading:@"重设密码中,请稍后..."];
            //尚未加密
            [self resetPassword:_password.text];
        }
    }
}

- (IBAction)back:(id)sender {
    //跳转到账号密码登录界面
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)resetPassword:(NSString*) password {
    //向后台通信
    
    for(int i = 0; i < 20000; i++) {
        if (i == 19999) {
            break;
        }
    }
    
    [[HUDHelper sharedInstance] syncLoading:@"密码已修改成功"];
    
    //跳转到账号密码登录界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
