//
//  LoginViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/11/26.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "LoginViewController.h"
#import "IMALoginParam.h"

#define SdkAppId 1400015003
#define AppIdAt3rd @"1400015003"
#define AccountType @"7657"

#define kDaysInSeconds(x)      (x * 24 * 60 * 60)

@interface LoginViewController ()

@property(atomic, strong) IMALoginParam* loginParam;//登录参数

-(NSString*)getUserSigFromServerByPhoneNumber:(NSString*) phoneNumber andPassword:(NSString* )password;//向后台发送登录验证请求，获取UserSig用于向腾讯服务器发送验证

@end

#define kIMAAutoLoginParam @"kIMAAutoLoginParam"


@implementation LoginViewController

- (void)dealloc
{
    //    _tlsuiwx = nil;
    //    _openQQ = nil;
    
    [_loginParam saveToLocal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back2HomeViewController)];
    
    _loginParam = [[IMALoginParam alloc] init];//初始化登录参数
    [IMAPlatform configWith:_loginParam.config];//sdk初始化
   
//    [[TIMManager sharedInstance] initSdk:SdkAppId accountType:AccountType];
//    [[TIMManager sharedInstance] setUserStatusListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - 导航栏左边返回按钮
-(void) back2HomeViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - login and forgetPassword

- (IBAction)login:(id)sender {
    [_loginParam setIdentifier:_phoneNumber.text];
    [_loginParam setSdkAppId:SdkAppId];
    [_loginParam setAccountType:AccountType];
    [_loginParam setAppidAt3rd:AppIdAt3rd];
    [_loginParam setUserSig:[self getUserSigFromServerByPhoneNumber:_phoneNumber.text andPassword:_password.text]];
    
    
    //直接登录
    __weak LoginViewController *weakSelf = self;
    [[HUDHelper sharedInstance] syncLoading:@"正在登录"];
    [[IMAPlatform sharedInstance] login:_loginParam succ:^{
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"登录成功"];
        [_loginParam saveToLocal];//!!!!!!将登录信息存在本地
        [weakSelf enterMainUI];
    } fail:^(int code, NSString *msg) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, msg) delay:2 completion:^{
            NSLog(@"登录失败，错误码：%d, 错误信息：%@", code, msg);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"错误码：%d, 错误信息：%@", code, msg] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
            if(code == 6208) {//6208错误码表示当前账户已被其他设备登录，此时只需要再次尝试登录将其踢下线即可
                NSLog(@"当前账号已在其他设备登录，将再一次尝试登录");
                [self login:nil];
            }

        }];
    }];
    
    
//    [[TIMManager sharedInstance] login:_loginParam succ:^{
//        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"登录成功"];
//
//        [_loginParam saveToLocal];//!!!!!!将登录信息存在本地
//
//        [[AppDelegate sharedAppDelegate] enterMainUI];//进入到主界面
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"登录失败，错误码：%d, 错误信息：%@", code, msg);
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"错误码：%d, 错误信息：%@", code, msg] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//        [alert show];
//        if(code == 6208) {//6208错误码表示当前账户已被其他设备登录，此时只需要再次尝试登录将其踢下线即可
//            NSLog(@"当前账号已在其他设备登录，将再一次尝试登录");
//            [self login:nil];
//        }
//    }];
    
}

- (IBAction)forgetPassword:(id)sender {
    
}

- (IBAction)logout:(id)sender {
//    [[HUDHelper sharedInstance] syncLoading:@"正在退出"];
    [[IMAPlatform sharedInstance] logout:^{
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"退出成功" delay:2 completion:^{
            [[AppDelegate sharedAppDelegate] enterLoginUI];
        }];
        
    } fail:^(int code, NSString *err) {
        NSLog(@"退出失败，错误码：%d,错误信息：%@", code, err);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"退出失败" message:[NSString stringWithFormat:@"退出失败，错误码：%d,错误信息：%@", code, err] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
//        [[AppDelegate sharedAppDelegate] enterLoginUI];

//        [[HUDHelper sharedInstance] syncStopLoadingMessage:[NSString stringWithFormat:@"退出失败，错误码：%d,错误信息：%@", code, err]];
        
//        [[HUDHelper sharedInstance] syncStopLoadingMessage:[NSString stringWithFormat:@"退出失败，错误码：%d,错误信息：%@", code, err] delay:0 completion:^{
//        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, err) delay:2 completion:^{
        
        
//        }];
    }];
    
    
    
//    [[TIMManager sharedInstance] logout:^{
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"退出成功" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//        [alert show];
//    } fail:^(int code, NSString *msg) {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"退出失败" message:[NSString stringWithFormat:@"错误码：%d, 错误信息：%@", code, msg] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//        [alert show];
//    }];
}

#pragma mark - 登录验证
-(NSString*)getUserSigFromServerByPhoneNumber:(NSString*) phoneNumber andPassword:(NSString* )password {
    NSString* userSig;
    
    if([phoneNumber isEqualToString:@"fdb"]) {
        userSig = @"eJxNjd1OgzAARt*ltxgp7RqHyS4YYFTExc1hMCRNoS3pdMBKJW7Gd7chmO32nO-nB7w*ba5ZVbVfjaHm2AlwCyC4GrHiojFKKqEtlLycMOs6xSkzFGt*ke75Bx2VZd4MQugRCPEkxXentKBMmnHMI4QgG5nsIHSv2sYKZFsewhCepVF7MU7OLSMIof8-VVucxi-hQ*TAkA04y7PwMUN8fojLflc93830STeSYXNM0-X7bh9EXaCWsk2Mc58nvl*4-iZKP9fJW4LLg1npm2DF4u1QuEG93Oa1U7j1YgF*-wD3Llb9";
    } else if([phoneNumber isEqualToString:@"user1"]) {
        userSig = @"eJxNjc1Og0AURt*FtZEBOhZNXFhKpaZKxdpCQjKhcIFbKaXDAEXjuzshGN2e8-18KZvV23UUx6emFEz0FSh3ClGuBowJlAJTBC5hUwPXRhFVFSYsEszgyb98nXywQUmmTQghGiXEGCVcKuTAolQMcxqlVJeR0bbAazyVUuiypekGIX9S4BGGSVMyqpuT3z-MJH62363l69wL1e7Gv22FP42sAxi5u4NL5iyeZlgH8TZ97FbFOUef5NNsmVmh6h7n*3zbFgfHRn-x4vXrBw-OoTrbuJ*20ZuuU*yDdbMLunvl*wcYwFl1";
    } else if([phoneNumber isEqualToString:@"user2"]) {
        userSig = @"eJxNjV1PgzAUhv8L10YPhZrOZBc4t0QBEUcyL5Y0uJZ5mBZGywaY-XcbgtHb53k-vp0sWl-nu13VKsNNX0vnzgHnasQopDJYoGwsbLVsyCTyukbBc8O9RvzLa3Hgo7LM9QHApQDeJGVXYyN5XphxzqWUEhuZ7Ek2GitlBbEtl3gAf9LglxwnGRBCbmez3z-cWxwv08XjSjE-CaNSrCRWKQuhu39PaSZ0QoO10P2QF2Gky6jcxwEGb*LFxf5JDEwdy-icfLDM3xyTZ-J5Covq8NAt282g-O3Na3Wez53LD2w4WSU_";
    } else if([phoneNumber isEqualToString:@"user3"]) {
        userSig = @"eJxNjVtPgzAYhv9LbzXaFkiZiRdYyVAUdzYaE1LhAz8PwEoBjfG-ryFb5u3zvIdfsrpbnqksq7vKpOanAXJBKDkdMeZQGSwQtIVdC9rZC9U0mKfKpI7O-*Xb-CMdlWXMpZQyj9JDB74b1JCqwoxzzPM8biN724Nusa6s4LbFuEPpURr8gnHSp5wJ3xeHPywtvg-X8maqsXPF4Osge5ifqASuuXzOo3AR949QvrtR-3IeJeUwW9KnAMOAiRlXcrqKNyBxnWyvPt*yIto2iR9P5AbqxeutrEUl*slwSf52Jb5XWg__";
    } else if([phoneNumber isEqualToString:@"user4"]) {
        userSig = @"eJxNjVtPgzAYhv8Ltxr5SiFzJl6QOWWKWwwgWULSNFDIB3KwtFM0**82BKO3z-Mevq04jK54nve6U0xNg7BuLLAuZ4yF6BSWKKSBehTSXQQfBiwYV4zK4l9*LBo2K8OICwDEA6CLFJ8DSsF4qeY54nmeYyKLPQk5Yt8Z4ZgWcSjAn1TYinnyGhyyWsPq9w8rg5*3yWbn91oFT7HSdw-BlEQvnorq9oCb-GOS*iL1S-7q1thIaAIft76TJpmdtt17ZldE*mNmn6oj3**pPrxhvM7sr139eMzvaZ7ZYQhwa51-APZYWbM_";
    }
    
    return userSig;
}

#pragma - 实现用户状态监听协议方法

-(void) onForceOffline {//强制下线
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"您的账号已在其他设备登录" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}

-(void) onUserSigExpired {//账号的UserSig过期
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"您的账号的UserSig过期" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}

-(void) onReConnFailed:(int)code err:(NSString *)err {//重连失败
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"断线重连失败" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}


//从IMALoginViewController复制过来
- (void)enterMainUI
{
    //    _tlsuiwx = nil;
    //    _openQQ = nil;
    [[AppDelegate sharedAppDelegate] enterMainUI];
    
    [[IMAPlatform sharedInstance] configOnLoginSucc:_loginParam];
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

/**
 *  登录IMSDK
 */
- (void)loginIMSDK
{
    //直接登录
    __weak LoginViewController *weakSelf = self;
    [[HUDHelper sharedInstance] syncLoading:@"正在登录"];
    [[IMAPlatform sharedInstance] login:_loginParam succ:^{
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"登录成功"];
        [weakSelf enterMainUI];
    } fail:^(int code, NSString *msg) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, msg) delay:2 completion:^{
            NSLog(@"登录失败");
            //            [weakSelf pullLoginUI];
        }];
    }];
}


#pragma mark - delegate<TLSUILoginListener>
-(void)TLSUILoginOK:(TLSUserInfo *)userinfo
{
    //回调时已结束登录流程 销毁微信回调对象
    //根据登录结果处理
    [self loginWith:userinfo];
    
}

-(void)TLSUILoginQQOK
{
    //回调时已结束登录流程 销毁微信回调对象
    
    //    [[TLSHelper getInstance] TLSOpenLogin:kQQAccountType andOpenId:_openQQ.openId andAppid:QQ_APP_ID andAccessToken:_openQQ.accessToken andTLSOpenLoginListener:self];
    
}
//已经废弃
-(void)TLSUILoginWXOK:(SendAuthResp*)resp
{
    DebugLog(@"TLSUILoginWXOK");
}

-(void)TLSUILoginWXOK2:(TLSTokenInfo *)tokenInfo
{
    //    [[TLSHelper getInstance] TLSOpenLogin:kWXAccountType andOpenId:tokenInfo.openid andAppid:WX_APP_ID andAccessToken:tokenInfo.accessToken andTLSOpenLoginListener:self];
}
//demo暂不提供微博登录

-(void)TLSUILoginWBOK:(WBAuthorizeResponse *)resp
{
    //    [GlobalData shareInstance].accountHelper = [AccountHelper sharedInstance];
    //    [GlobalData shareInstance].friendshipManager = [FriendshipManager sharedInstance];
    //    NSString *appid = [[NSString alloc] initWithFormat:@"%d",kSdkAppId ];
    //    [[TLSHelper getInstance] TLSOpenLogin:kWXAccountType andOpenId:tokenInfo.openid andAppid:appid andAccessToken:tokenInfo.accessToken andTLSOpenLoginListener:self];
    
}

-(void)TLSUILoginCancel
{
    //回调时已结束登录流程 销毁微信回调对象
}

#pragma mark - TLSOpenLoginListener

//第三方登录成功之后，再次登陆tls换取userinfo
-(void)OnOpenLoginSuccess:(TLSUserInfo *)userinfo
{
    //回调时已结束登录流程 销毁微信回调对象
    //根据登录结果处理
    [self loginWith:userinfo];
}

-(void)OnOpenLoginFail:(TLSErrInfo*)errInfo
{
    DebugLog(@"%@",errInfo);
}

-(void)OnOpenLoginTimeout:(TLSErrInfo*)errInfo
{
    DebugLog(@"%@",errInfo);
}

#pragma mark - Provate Methods


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
    
    __weak LoginViewController *ws = self;
    [[HUDHelper sharedInstance] syncStopLoadingMessage:err delay:2 completion:^{
        NSLog(@"刷新票据失败");
//        [ws pullLoginUI];
    }];
    
}


- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
{
    [self OnRefreshTicketFail:errInfo];
}

@end











