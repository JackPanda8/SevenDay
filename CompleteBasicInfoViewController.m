//
//  CompleteBasicInfoViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/12/12.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//
#import "CompleteBasicInfoViewController.h"
NSString* const SET_USERINFO_URL = @"https://";

@interface CompleteBasicInfoViewController ()

@property (strong, nonatomic) NSMutableDictionary* info;
@property (strong, nonatomic) NSString* standardPhoneNum;


@end

@implementation CompleteBasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _standardPhoneNum = [NSString stringWithFormat:@"%@", _phoneNumber];
//    UIPickerView
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishButton:(id)sender {
    if([self check]) {
        [[HUDHelper sharedInstance] syncLoading:@"提交中..."];
        [self postInfo:_info ofUserPhoneNum:_phoneNumber];
    }
}

//检查输入内容的合法性
- (BOOL)check {
    
    _info = [[NSMutableDictionary alloc] initWithCapacity:6];
    
    return YES;
}

//向后台post数据
- (void)postInfo:(NSMutableDictionary*)info ofUserPhoneNum:(NSString*)phoneNumber {
    AFHTTPSessionManager* sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [sessionManager POST:SET_USERINFO_URL parameters:_info progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[HUDHelper sharedInstance] tipMessage:@"注册成功"];
        //跳转到登录界面
        //    [self performSegueWithIdentifier:@"JumpToLoginVC" sender:nil];
        [[AppDelegate sharedAppDelegate] enterLoginUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[HUDHelper sharedInstance] tipMessage:@"注册失败失败，请重试"];
    }];
}

@end
