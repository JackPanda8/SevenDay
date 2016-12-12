//
//  RegisterViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/12/12.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back2HomeViewController)];

}

#pragma - Buttons

-(void) back2HomeViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getVerificaitonCode:(id)sender {
    //手机号码的格式为国家码-手机号码，如86-155xxxx
    [[TLSHelper getInstance] TLSSmsRegAskCode:[NSString stringWithFormat:@"86-%@", _phoneNumber.text] andTLSSmsRegListener:self];
}

- (IBAction)nextStep:(id)sender {
}

#pragma - TLSSmsRegListener delegate method

/**
*  请求短信验证码成功
*
*  @param reaskDuration 下次请求间隔
*  @param expireDuration 验证码有效期
*/
-(void)	OnSmsRegAskCodeSuccess:(int)reaskDuration andExpireDuration:(int) expireDuration {
    
}

/**
 *  刷新短信验证码请求成功
 *
 *  @param reaskDuration 下次请求间隔
 *  @param expireDuration 验证码有效期
 */
-(void)	OnSmsRegReaskCodeSuccess:(int)reaskDuration andExpireDuration:(int)expireDuration {
    
}

/**
 *  验证短信验证码成功
 */
-(void)	OnSmsRegVerifyCodeSuccess {
    
}

/**
 *  提交注册成功
 *
 *  @param userInfo 用户信息
 */
-(void)	OnSmsRegCommitSuccess:(TLSUserInfo *)userInfo {
    
}

/**
 *  短信注册失败
 *
 *  @param errInfo 错误信息
 */
-(void)	OnSmsRegFail:(TLSErrInfo *) errInfo{
    
}

/**
 *  短信注册超时
 *
 *  @param errInfo 错误信息
 */
-(void)	OnSmsRegTimeout:(TLSErrInfo *) errInfo{
    
}

@end
