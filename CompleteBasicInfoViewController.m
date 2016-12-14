//
//  CompleteBasicInfoViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/12/12.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "CompleteBasicInfoViewController.h"

@interface CompleteBasicInfoViewController ()

@property (strong, nonatomic) NSMutableDictionary* info;
@property (strong, nonatomic) NSString* standardPhoneNum;


@end

@implementation CompleteBasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _standardPhoneNum = [NSString stringWithFormat:@"%@", _phoneNumber];
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
    for(int i = 0; i < 20000; i++) {
        if (i == 19999) {
            break;
        }
    }
    
    [[HUDHelper sharedInstance] syncLoading:@"提交成功"];
    //跳转到登录界面
//    [self performSegueWithIdentifier:@"JumpToLoginVC" sender:nil];
      [[AppDelegate sharedAppDelegate] enterLoginUI];
}

@end
