//
//  QuickLoginViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/12/12.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//
#import "IMALoginParam.h"
#import "QuickLoginViewController.h"

#define SdkAppId 1400015003
#define AppIdAt3rd @"1400015003"
#define AccountType @"7657"

#define kDaysInSeconds(x)      (x * 24 * 60 * 60)
#define kIMAAutoLoginParam @"kIMAAutoLoginParam"

@interface QuickLoginViewController ()

@property(atomic, strong) IMALoginParam* loginParam;//登录参数
@property(strong, nonatomic) NSString* standardPhoneNum;//标准格式的手机号码
@property(strong, nonatomic) NSString* verCodeFromServer;//从后台获取的验证码

-(NSString*)getUserSigFromServerByIdentifier:(NSString*) phoneNumber;//向后台发送登录验证请求，获取UserSig用于向腾讯服务器发送验证

@end

@implementation QuickLoginViewController

- (void)dealloc
{
    //    _tlsuiwx = nil;
    //    _openQQ = nil;
    
    [_loginParam saveToLocal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _loginParam = [[IMALoginParam alloc] init];//初始化登录参数
    [IMAPlatform configWith:_loginParam.config];//sdk初始化
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)getVerCode:(id)sender {
    //手机号码的格式为国家码-手机号码，如86-155xxxx
    if([self checkPhoneNumber:_phoneNumber.text]) {
        _standardPhoneNum = [NSString stringWithFormat:@"86-%@", _phoneNumber.text];
//        [[TLSHelper getInstance] TLSSmsAskCode:_standardPhoneNum andTLSSmsLoginListener:self];
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
//    if([number isEqualToString:@""]) {
//        [HUDHelper alertTitle:@"请先填写手机号码" message:nil cancel:@"好的"];
//        result = NO;
//    }else {
//        if(![RegExpUtil validatePhoneNumber:number]) {
//            [HUDHelper alertTitle:@"手机号码格式有误" message:nil cancel:@"好的"];
//            result = NO;
//        }
//    }
    
    return result;
}


- (IBAction)login:(id)sender {
    if([_verCode.text isEqualToString:@""]){
        [HUDHelper alertTitle:@"验证码不能为空" message:nil cancel:@"好的"];
    } else {
//        [[TLSHelper getInstance] TLSSmsVerifyCode:_standardPhoneNum andCode:_verCode.text andTLSSmsLoginListener:self];
        if(![_verCode.text isEqualToString:_verCodeFromServer]) {
            [[HUDHelper sharedInstance] tipMessage:@"验证码有误，请在30s后重试"];
            //禁用获取验证码按钮，开始倒计时
            
        }else {
           
            //隐藏键盘
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
            
            //        _standardPhoneNum = [NSString stringWithFormat:@"86-%@", _phoneNumber.text];
            _standardPhoneNum = [NSString stringWithFormat:@"%@", _phoneNumber.text];
            //向腾讯TLS服务器发送登录请求
            //    [[TLSHelper getInstance] TLSPwdLogin:_standardPhoneNum andPassword:_password.text andTLSPwdLoginListener:self];
            
            [_loginParam setIdentifier:_standardPhoneNum];
            [_loginParam setSdkAppId:SdkAppId];
            [_loginParam setAccountType:AccountType];
            [_loginParam setAppidAt3rd:AppIdAt3rd];
            
            //后台获取userSig,密码不能明文传递，后面要改成加密方式
            NSString* userSig = [self getUserSigFromServerByIdentifier:_standardPhoneNum];
            [_loginParam setUserSig:userSig];
            
            //直接登录
            __weak QuickLoginViewController *weakSelf = self;
            [[HUDHelper sharedInstance] syncLoading:@"正在登录"];
            [[IMAPlatform sharedInstance] login:_loginParam succ:^{
                [[HUDHelper sharedInstance] syncStopLoadingMessage:@"登录成功"];
                //        [_loginParam saveToLocal];//!!!!!!将登录信息存在本地
                [weakSelf enterMainUI];
            } fail:^(int code, NSString *msg) {
                [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, msg) delay:2 completion:^{
                    
                    NSLog(@"登录失败，错误码：%d, 错误信息：%@", code, msg);
//                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"错误码：%d, 错误信息：%@", code, msg] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//                    [alert show];
                    [HUDHelper alertTitle:@"登录失败" message:[NSString stringWithFormat:@"错误码：%d, 错误信息：%@", code, msg]
                                    cancel:@"好的"];
                    
                    
                    [[AppDelegate sharedAppDelegate] enterLoginUI];
                    
                    if(code == 6208) {//6208错误码表示当前账户已被其他设备登录，此时只需要再次尝试登录将其踢下线即可
                        NSLog(@"当前账号已在其他设备登录，将再一次尝试登录");
                        [self login:nil];
                    }
                    
                }];
            }];

        }
    }
}

//检查手机号的格式
- (BOOL) checkPhoneNumber:(NSString*) number andPassword:(NSString*) password{
    BOOL result = YES;
    if([number isEqualToString:@""]) {
        [HUDHelper alertTitle:@"手机号码不能为空" message:nil cancel:@"好的"];
        result = NO;
    }else {
        if(![RegExpUtil validatePhoneNumber:number]) {
            [HUDHelper alertTitle:@"手机号码格式有误" message:nil cancel:@"好的"];
            result = NO;
        }
    }
    
    return result;
}

//点击背景隐藏键盘
- (IBAction)hideKeyboard:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(NSString*)getUserSigFromServerByIdentifier:(NSString*) phoneNumber{//向后台发送登录验证请求，获取UserSig用于向腾讯服务器发送验证
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
    } else {
        userSig = nil;
    }
    
    return userSig;
}


#pragma TLSSmsLoginListener method

/**
 *  请求短信验证码成功
 *
 *  @param reaskDuration 下次请求间隔
 *  @param expireDuration 验证码有效期
 */
-(void) OnSmsLoginAskCodeSuccess:(int)reaskDuration andExpireDuration:(int)expireDuration {
    //禁用获取验证码button，开始30s倒计时，验证码发送成功提示
    
//    [[HUDHelper sharedInstance] tipMessage:@"验证码已发送，请注意查收"];

}

/**
 *  刷新短信验证码请求成功
 *
 *  @param reaskDuration 下次请求间隔
 *  @param expireDuration 验证码有效期
 */
-(void)	OnSmsLoginReaskCodeSuccess:(int)reaskDuration andExpireDuration:(int)expireDuration {
    
}

/**
 *  验证短信验证码成功
 */
-(void)	OnSmsLoginVerifyCodeSuccess{
//    [[TLSHelper getInstance] TLSSmsLogin:_standardPhoneNum andTLSSmsLoginListener:self];
}

/**
 *  短信登陆成功
 *
 *  @param userInfo 用户信息
 */
-(void)	OnSmsLoginSuccess:(TLSUserInfo *) userInfo{
//    [HUDHelper alertTitle:@"登录成功" message:nil cancel:@"好的"];
//    NSString* userSig = [[TLSLoginHelper getInstance] getTLSUserSig:userInfo.identifier];
//    NSLog(@"userSig = %@", userSig);
}

/**
 *  短信登陆失败
 *
 *  @param errInfo 错误信息
 */
-(void)	OnSmsLoginFail:(TLSErrInfo *) errInfo{
//    [HUDHelper alertTitle:[NSString stringWithFormat:@"%@", errInfo.sErrorMsg] message:nil cancel:@"好的"];
}

/**
 *  短信登陆超时
 *
 *  @param errInfo 错误信息
 */
-(void)	OnSmsLoginTimeout:(TLSErrInfo *)errInfo{
//    [HUDHelper alertTitle:@"网络请求超时" message:@"请重试" cancel:@"好的"];
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


#pragma - 从IMALoginViewController复制过来

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
            NSLog(@"!!!!!!!!!!!!%@", _loginParam.userSig);
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
    __weak QuickLoginViewController *weakSelf = self;
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

#pragma mark - 拉起登陆框
- (void)pullLoginUI
{
    //    TLSUILoginSetting *setting = [[TLSUILoginSetting alloc] init];
    //    _openQQ = [[TencentOAuth alloc]initWithAppId:QQ_APP_ID andDelegate:self];
    //    [setting setOpenQQ:_openQQ];
    //    setting.qqScope = nil;
    //    setting.wxScope = @"snsapi_userinfo";
    //    setting.enableWXExchange = YES;
    //    setting.enableGuest = YES;
    //    _setting.needBack = YES;
    //demo暂不提供微博登录
    //    tlsSetting.wbScope = nil;
    //    tlsSetting.wbRedirectURI = @"https://api.weibo.com/oauth2/default.html";
    //    _tlsuiwx = TLSUILogin(self, setting);
    //    TLSUILogin(self, setting);
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
    
    //    __weak LoginViewController *ws = self;
    [[HUDHelper sharedInstance] syncStopLoadingMessage:err delay:2 completion:^{
        NSLog(@"刷新票据失败");
        [[AppDelegate sharedAppDelegate] enterLoginUI];
    }];
    
}

- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
{
    [self OnRefreshTicketFail:errInfo];
}

@end
