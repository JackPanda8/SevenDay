//
//  RegisterViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/12/12.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "RegisterViewController.h"
NSString* const GET_VERCODE_URL = @"https://";

@interface RegisterViewController ()

@property(strong, nonatomic) NSString* standardPhoneNum;
@property(strong, nonatomic) NSString* verCodeFromServer;//从后台获取的验证码

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back2HomeViewController)];
    _countDownButton = [DBCountDownButton buttonWithType:UIButtonTypeCustom];
    _countDownButton.autoControlButtonEnable = YES;
}

#pragma - Buttons

-(void) back2HomeViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getVerificaitonCode:(id)sender {
    //手机号码的格式为国家码-手机号码，如86-155xxxx
    if([self checkPhoneNumber:_phoneNumber.text]) {
        _standardPhoneNum = [NSString stringWithFormat:@"%@", _phoneNumber.text];
        
        //禁用获取验证码按钮，开始30s倒计时
        [_countDownButton countDownChanging:^NSString *(DBCountDownButton *countDownButton, NSUInteger second) {
            return [NSString stringWithFormat:@"%lu秒重新获取",(unsigned long)second];
        }];
        [_countDownButton countDownFinished:^NSString *(DBCountDownButton *countDownButton, NSUInteger second) {
            //  倒计时结束设置button title
            return @"获取验证码";
        }];
        @weakify(_countDownButton);
        [[_countDownButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(_countDownButton)
            
            [_countDownButton startCountDownWithSecond:30];
        }];
        [self getVerCodeFromServerWithPhoneNumber:_standardPhoneNum];
    }
}

- (void)getVerCodeFromServerWithPhoneNumber:(NSString*) phoneNum {
    //向后台发送验证码请求
    AFHTTPSessionManager* sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [sessionManager GET:GET_VERCODE_URL parameters:_standardPhoneNum progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[HUDHelper sharedInstance] tipMessage:@"验证码发送成功，请注意查收"];
        _verCodeFromServer = responseObject;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[HUDHelper sharedInstance] tipMessage:@"验证码发送失败，请重试"];
    }];
    
    
//    _verCodeFromServer = @"123456";
//    [[HUDHelper sharedInstance] tipMessage:@"验证码发送成功，请注意查收"];

}

//检查手机号的格式
- (BOOL) checkPhoneNumber: number {
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

- (IBAction)nextStep:(id)sender {
    if([_verificationCode.text isEqualToString:@""]){
        [HUDHelper alertTitle:@"验证码不能为空" message:nil cancel:@"好的"];
    } else {
//        [[TLSHelper getInstance] TLSPwdRegVerifyCode:_verificationCode.text andTLSPwdRegListener:self];
        if(![_verificationCode.text isEqualToString:_verCodeFromServer]) {
            [[HUDHelper sharedInstance] tipMessage:@"验证码有误"];
        }else {
            //隐藏键盘
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
            [self performSegueWithIdentifier:@"JumpToPwdVC" sender:nil];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"JumpToPwdVC"]) {
        CompleteBasicInfoViewController* comInfoVC = [[CompleteBasicInfoViewController alloc] init];
        comInfoVC.phoneNumber = _phoneNumber.text;
    }
}

#pragma - TLSPwdRegListener delegate method

/**
*  请求短信验证码成功
*
*  @param reaskDuration 下次请求间隔
*  @param expireDuration 验证码有效期
*/
-(void)	OnPwdRegAskCodeSuccess:(int)reaskDuration andExpireDuration:(int) expireDuration {
    //禁用获取验证码button，开始30s倒计时，验证码发送成功提示
    
    [[HUDHelper sharedInstance] tipMessage:@"验证码已发送，请注意查收"];
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
    //界面的跳转只能由主线程来处理
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"JumpToPwdVC" sender:nil];
    });
}

/**
 *  提交注册成功
 *
 *  @param userInfo 用户信息
 */
-(void)	OnPwdRegCommitSuccess:(TLSUserInfo *)userInfo {
    
}

/**
 *  短信注册失败
 *
 *  @param errInfo 错误信息
 */
-(void)	OnPwdRegFail:(TLSErrInfo *) errInfo{
    [HUDHelper alertTitle:[NSString stringWithFormat:@"%@", errInfo.sErrorMsg] message:nil cancel:@"好的"];
}

/**
 *  短信注册超时
 *
 *  @param errInfo 错误信息
 */
-(void)	OnPwdRegTimeout:(TLSErrInfo *) errInfo{
    [HUDHelper alertTitle:@"网络请求超时" message:@"请重试" cancel:@"好的"];
}

@end
