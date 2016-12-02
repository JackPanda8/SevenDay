//
//  HomeViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/11/26.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
#import <ImSDK/ImSDK.h>

@interface LoginAndRegisterViewController ()

@property(strong, atomic) IMALoginParam* loginParam;
@property(atomic) BOOL isExcutingAutoLogining;
@property(atomic) BOOL isExcutingPullLoginUI;

@end

@implementation LoginAndRegisterViewController

- (void)dealloc
{
    //    _tlsuiwx = nil;
    //    _openQQ = nil;
    
    [_loginParam saveToLocal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isExcutingAutoLogining = NO;
    _isExcutingPullLoginUI = NO;
    
    BOOL isAutoLogin = [IMAPlatform isAutoLogin];
    if (isAutoLogin)
    {
        self.background.hidden = YES;
        self.registerButton.hidden = YES;
        self.loginButton.hidden = YES;
        _loginParam = [IMALoginParam loadFromLocal];
        
    }
    else
    {
        _loginParam = [[IMALoginParam alloc] init];
    }
    
    [IMAPlatform configWith:_loginParam.config];
    
    if (isAutoLogin && [_loginParam isVailed])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self autoLogin];
        });
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pullLoginUI];
        });
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - 重写继承自IMALoginViewController的方法

/**
 *  自动登录
 */
- (void)autoLogin//不知道什么原因autologin会执行两次，所以设置一个flag---isExcutingAutoLogining进行判断
{
    if(!_isExcutingAutoLogining) {
        if ([_loginParam isExpired])
        {
            [[HUDHelper sharedInstance] syncLoading:@"刷新票据。。。"];
            //刷新票据
            [[TLSHelper getInstance] TLSRefreshTicket:_loginParam.identifier andTLSRefreshTicketListener:self];
        }
        else
        {
            [self loginIMSDK];
            _isExcutingAutoLogining = YES;//标志即将执行autologin方法
        }
    } else {
        NSLog(@"重复执行autologin，忽略之");
    }
}

/**
 *  登录IMSDK
 */
- (void)loginIMSDK
{
    //直接登录
    __weak LoginAndRegisterViewController *weakSelf = self;
    [[HUDHelper sharedInstance] syncLoading:@"正在登录"];
    [[IMAPlatform sharedInstance] login:_loginParam succ:^{
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"登录成功"];
        
        [_loginParam saveToLocal];//!!!!!!将登录信息存在本地
        
        [weakSelf enterMainUI];
    } fail:^(int code, NSString *msg) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, msg) delay:2 completion:^{
            [weakSelf pullLoginUI];
        }];
    }];
}

/**
 *  成功登录TLS之后，再登录IMSDK
 *
 *  @param userinfo 登录TLS成功之后回调回来的用户信息
 */
- (void)loginWith:(TLSUserInfo *)userinfo
{
    //    _openQQ = nil;
    //    _tlsuiwx = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (userinfo)
        {
            _loginParam.identifier = userinfo.identifier;
            _loginParam.userSig = [[TLSHelper getInstance] getTLSUserSig:userinfo.identifier];
            _loginParam.tokenTime = [[NSDate date] timeIntervalSince1970];
            
            // 获取本地的登录config
            [self loginIMSDK];
        }
    });
}


#pragma mark - 显示登录按钮
- (void)pullLoginUI//这个和autologin一样会执行两次，同样设置一个flag进行判断---isExcutingPullLoginUI
{
    if(!_isExcutingPullLoginUI) {
        self.background.hidden = NO;
        self.registerButton.hidden = NO;
        self.loginButton.hidden = NO;
        _isExcutingPullLoginUI = YES;
    } else {
        NSLog(@"重复执行pullLoginUI，忽略之");
    }
}

#pragma mark - 进入我的消息界面
- (void)enterMainUI
{
    //    _tlsuiwx = nil;
    //    _openQQ = nil;
    [[AppDelegate sharedAppDelegate] enterMainUI];
    
    [[IMAPlatform sharedInstance] configOnLoginSucc:_loginParam];
}

#pragma mark - 刷新票据代理

- (void)OnRefreshTicketSuccess:(TLSUserInfo *)userInfo
{
    [[HUDHelper sharedInstance] syncStopLoading];
    [self loginWith:userInfo];
}


- (void)OnRefreshTicketFail:(TLSErrInfo *)errInfo
{
    _loginParam.tokenTime = 0;
    NSString *err = [[NSString alloc] initWithFormat:@"刷新票据失败\ncode:%d, error:%@", errInfo.dwErrorCode, errInfo.sErrorTitle];
    
    __weak LoginAndRegisterViewController *ws = self;
    [[HUDHelper sharedInstance] syncStopLoadingMessage:err delay:2 completion:^{
        [ws pullLoginUI];
    }];
    
}


- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
{
    [self OnRefreshTicketFail:errInfo];
}



@end
