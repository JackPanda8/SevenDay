//
//  HomeTabBarController.h
//  SevenDay
//
//  Created by macbook for test on 16/12/5.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityViewController.h"
#import "MyMessageTableViewController.h"
#import "LoveDiaryViewController.h"
#import "MyselfViewController.h"

@interface HomeTabBarController : UITabBarController

- (void)pushToChatViewControllerWith:(IMAUser *)user;

@end
