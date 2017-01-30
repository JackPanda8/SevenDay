//
//  MyMessageTableViewController.h
//  SevenDay
//
//  Created by macbook for test on 16/12/2.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMessageCell.h"
#import "AppDelegate.h"
#import "IMAPlatform.h"
//#import <AFNetworking.h>
#import "TokensUtil.h"
#import "FBKVOController.h"

@interface MyMessageTableViewController : UITableViewController

@property (strong, atomic) NSNumber* hasPartner;//是否已配对
@property (strong, atomic) NSString* currentLover;//当前已配对的情侣的ID
@property (strong, atomic) NSDictionary* lastLoverChat;//最后一条情侣聊天消息
@property (weak, nonatomic) NSDictionary* systemMessage;//系统消息通知
@property (weak, nonatomic) NSDictionary* parterRequest;//新情侣申请
@property (weak, nonatomic) NSDictionary* taskMessage;//任务消息
@property (weak, nonatomic) NSDictionary* guide;//攻略指南消息

- (NSDictionary*)getLastLoverChat;//获取最后一条情侣聊天纪律

@end
