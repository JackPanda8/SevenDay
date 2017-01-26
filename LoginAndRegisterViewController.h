//
//  HomeViewController.h
//  SevenDay
//
//  Created by macbook for test on 16/11/26.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TokensUtil.h"
#import "IMALoginViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD.h"

@interface LoginAndRegisterViewController : IMALoginViewController

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
