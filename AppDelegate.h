//
//  AppDelegate.h
//  SevenDay
//
//  Created by macbook for test on 16/11/24.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "IMAAppDelegate.h"
#import "LoginAndRegisterViewController.h"
#import "ContainerMyMessageViewController.h"

@interface AppDelegate : IMAAppDelegate

//@property (strong, nonatomic) UIWindow *window;

- (void)pushToChatViewControllerWith:(IMAUser *)user;//进入到聊天视图

@end

