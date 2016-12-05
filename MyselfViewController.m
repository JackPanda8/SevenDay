//
//  MyselfViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/12/5.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "MyselfViewController.h"

@interface MyselfViewController ()

@end

@implementation MyselfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logout:(id)sender {
//    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"退出登录" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    
        
        [[HUDHelper sharedInstance] syncLoading:@"正在退出"];
        [[IMAPlatform sharedInstance] logout:^{
            [[HUDHelper sharedInstance] syncStopLoadingMessage:@"退出成功" delay:2 completion:^{
                [[AppDelegate sharedAppDelegate] enterLoginUI];
            }];
            
        } fail:^(int code, NSString *err) {
            [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, err) delay:2 completion:^{
                [[AppDelegate sharedAppDelegate] enterLoginUI];
            }];
        }];
        
        
        
        
//        //    [[HUDHelper sharedInstance] syncLoading:@"正在退出"];
//        [[IMAPlatform sharedInstance] logout:^{
//            [[HUDHelper sharedInstance] syncStopLoadingMessage:@"退出成功" delay:2 completion:^{
//                [[AppDelegate sharedAppDelegate] enterLoginUI];
//            }];
//            
//        } fail:^(int code, NSString *err) {
//            NSLog(@"退出失败，错误码：%d,错误信息：%@", code, err);
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"退出失败" message:[NSString stringWithFormat:@"退出失败，错误码：%d,错误信息：%@", code, err] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            //        [[AppDelegate sharedAppDelegate] enterLoginUI];
            
            //        [[HUDHelper sharedInstance] syncStopLoadingMessage:[NSString stringWithFormat:@"退出失败，错误码：%d,错误信息：%@", code, err]];
            
            //        [[HUDHelper sharedInstance] syncStopLoadingMessage:[NSString stringWithFormat:@"退出失败，错误码：%d,错误信息：%@", code, err] delay:0 completion:^{
            //        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, err) delay:2 completion:^{
            
            
            //        }];
//        }];
        
        
        
        //    [[TIMManager sharedInstance] logout:^{
        //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"退出成功" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        //        [alert show];
        //    } fail:^(int code, NSString *msg) {
        //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"退出失败" message:[NSString stringWithFormat:@"错误码：%d, 错误信息：%@", code, msg] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        //        [alert show];
        //    }];
        
        
//    }];
//    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alertController addAction:actionOK];
//    [alertController addAction:actionCancel];
//
//    [self presentViewController:alertController animated:YES completion:nil];
}
@end
