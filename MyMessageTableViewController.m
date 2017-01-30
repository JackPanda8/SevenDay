//
//  MyMessageTableViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/12/2.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "MyMessageTableViewController.h"

NSString* const GET_HAS_PARTNER_URL = @"";
NSString* const GET_SYSTEM_MESSAGE_URL = @"";
NSString* const GET_PARTNER_REQUEST_URL = @"";
NSString* const GET_TASK_MESSAGE_URL = @"";
NSString* const GET_GUIDE_URL = @"";
NSString* const GET_AVATER_URL = @"";
NSString* const GET_CURRENT_LOVER_URL = @"";

@interface MyMessageTableViewController ()

@property(nonatomic) AFHTTPSessionManager* sessionManager;
@end

@implementation MyMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//解决tableviewcell被顶部导航栏遮挡的问题
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉多余的行
    
    _sessionManager =  [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [self getPartner];//从本地读取是否有此状态的数据，没有再从后台读取当前状态是配对前还是配对后，然后存在preference里面
    [self requestData];//从后台读取数据
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc {
//    [self.KVOController unobserveAll];
//}

- (void)getPartner {
    _hasPartner = [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"HasPartner"]];
    _currentLover = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentLover"];
    if(!_hasPartner) {
        [_sessionManager GET:GET_HAS_PARTNER_URL parameters:[TokensUtil getUserID] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            _hasPartner = responseObject;
            [[NSUserDefaults standardUserDefaults] setValue:_hasPartner forKey:@"HasPartner"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求是否已配对状态出错，%@", [error localizedDescription]);
        }];
        
    }
    if(!_currentLover) {
        [_sessionManager GET:GET_CURRENT_LOVER_URL parameters:[TokensUtil getUserID] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            _currentLover = responseObject;
            [[NSUserDefaults standardUserDefaults] setValue:_currentLover forKey:@"CurrentLover"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求当前情侣出错，%@", [error localizedDescription]);
        }];
    }
    
}

- (void)requestData {
    if(_hasPartner.boolValue == YES) {
        [_sessionManager GET:GET_TASK_MESSAGE_URL
                 parameters:[TokensUtil getUserID]
                   progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        _taskMessage = responseObject;
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"请求任务消息出错，%@", [error localizedDescription]);
                    }];
    } else {
        [_sessionManager GET:GET_PARTNER_REQUEST_URL
                 parameters:[TokensUtil getUserID]
                   progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        _parterRequest = responseObject;
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"请求情侣添加消息出错，%@", [error localizedDescription]);
                    }];
    }
    
    [_sessionManager GET:GET_SYSTEM_MESSAGE_URL
              parameters:[TokensUtil getUserID]
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     _systemMessage = responseObject;
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"请求系统消息出错，%@", [error localizedDescription]);
                 }];

    [_sessionManager GET:GET_GUIDE_URL
              parameters:[TokensUtil getUserID]
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     _guide = responseObject;
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"请求攻略指南消息出错，%@", [error localizedDescription]);
                 }];

}

//获取最后一条情侣聊天纪律
- (NSDictionary*)getLastLoverChat {
    NSMutableDictionary* lastLoverChat = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    IMAConversationManager *mgr = [IMAPlatform sharedInstance].conversationMgr;
    IMAConversation *currentConversation = [mgr queryConversationWith:[[IMAUser alloc] initWith:_currentLover]];
    id<IMAConversationShowAble> conv = currentConversation;
#if kTestChatAttachment
    NSAttributedString *attributeDraft = [conv attributedDraft];
    NSAttributedString *attributedText = attributeDraft.length ? attributeDraft : [conv lastAttributedMsg];
#else
    NSString *draft = [conv attributedDraft];
    NSString* text = draft.length ? draft : [conv lastMsg];
#endif

    
    //    NSUInteger index = [conversationList indexOfObject:currentConversation];
    //    id<IMAConversationShowAble> conv = [conversationList objectAtIndex:index];
    if(!currentConversation) {//当前会话不为空
        IMAMsg* message = [[IMAMsg alloc] init];
        message = currentConversation.lastMessage;//这里不太确定直接取_lastMessage是否是最新的，后面还要进行实际测试
        switch (message.type) {
            case EIMAMSG_Unknown:
                [lastLoverChat setValue:@"[未知类型的消息]" forKey:@"Content"];
                break;
            case EIMAMSG_Text:
                [lastLoverChat setValue:text forKey:@"Content"];
                break;
            case EIMAMSG_Image:
                [lastLoverChat setValue:@"[图片]" forKey:@"Content"];
                break;
            case EIMAMSG_File:
                [lastLoverChat setValue:@"[文件]" forKey:@"Content"];
                break;
            case EIMAMSG_Sound:
                [lastLoverChat setValue:@"[语音]" forKey:@"Content"];
                break;
            case EIMAMSG_Face:
                [lastLoverChat setValue:@"[表情]" forKey:@"Content"];
                break;
            case EIMAMSG_Location:
                [lastLoverChat setValue:@"[位置信息]" forKey:@"Content"];
                break;
            case EIMAMSG_Video:
                [lastLoverChat setValue:@"[视频]" forKey:@"Content"];
                break;
            case EIMAMSG_Custom:
                [lastLoverChat setValue:@"[礼物]" forKey:@"Content"];
                break;
            case EIMAMSG_TimeTip:
                [lastLoverChat setValue:@"[时间提醒]" forKey:@"Content"];
                break;
            case EIMAMSG_GroupTips:
                [lastLoverChat setValue:@"[群提醒]" forKey:@"Content"];
                break;
            case EIMAMSG_GroupSystem:
                [lastLoverChat setValue:@"[群系统消息]" forKey:@"Content"];
                break;
            case EIMAMSG_SNSSystem:
                [lastLoverChat setValue:@"[关键链消息]" forKey:@"Content"];
                break;
            case EIMAMSG_ProfileSystem:
                [lastLoverChat setValue:@"[资料变更]" forKey:@"Content"];
                break;
            case EIMAMSG_InputStatus:
                [lastLoverChat setValue:@"[对方的输入状态]" forKey:@"Content"];
                break;
            case EIMAMSG_SaftyTip:
                [lastLoverChat setValue:@"[消息中包含有敏感词]" forKey:@"Content"];
                break;
            default:
                [lastLoverChat setValue:@"[看到这条消息就是腾讯云出bug了]" forKey:@"Content"];
                break;
        }
        [lastLoverChat setValue:conv.lastMsgTime forKey:@"Time"];
        

//        //注册kvo,已被下放到cell的m文件里面执行了
//        [self.KVOController unobserveAll];
//        _weak MyMessageTableViewController *ws = self;
//
//        [self.KVOController observe:conv keyPath:@"lastMessage" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
//            [ws updateFirstCellOnNewMessage];
//        }];
//        [self.KVOController observe:conv keyPath:@"lastMessage.status" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
//            [ws updateFirstCellOnNewMessage];
//        }];
//        
//        [self.KVOController observe:conv keyPath:@"draft" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change){
//            [ws updateFirstCellOnNewMessage];
//        }];
//        
//        [self updateFirstCellOnNewMessage];
    }
    
    return nil;
}

//- (void) updateFirstCellOnNewMessage {//收到新消息时，实时刷新消息页面的第一个cell的content(最后一条消息的内容)的值
//    NSIndexPath* indexOfFirstCell = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:@[indexOfFirstCell] withRowAnimation:UITableViewRowAnimationNone];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSLog(@"footer height %ld", (long)section);
    if(section == 3) {
        return 0;
    }
    return 7.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSLog(@"header height %ld", (long)section);

    if(section == 0) {
        return 0;
    }
    return 7.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (MyMessageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyMessageCellID";
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MyMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //圆形头像
    cell.image.layer.masksToBounds = YES;
    cell.image.layer.cornerRadius = cell.image.frame.size.height/2;
    
    NSInteger section = [indexPath section];
    switch (section) {
        case 0:
            cell.title.text = @"情侣聊天";
            if(_hasPartner.boolValue == YES) {
                [cell.image sd_setImageWithURL:[NSURL URLWithString:GET_AVATER_URL]];
                cell.content.text = [[self getLastLoverChat] valueForKey:@"Content"];
                cell.time.text = [[self getLastLoverChat] valueForKey:@"Time"];
            } else {
                cell.image.image = [UIImage imageNamed:@"message"];
                cell.content.hidden = YES;
                cell.time.hidden = YES;
            }
            break;
        case 1:
            cell.title.text = @"消息通知";
            cell.image.image = [UIImage imageNamed:@"notice"];
            cell.content.text = [_systemMessage valueForKey:@"Content"];
            cell.time.text = [_systemMessage valueForKey:@"Time"];
            break;
        case 2:
            if(_hasPartner.boolValue == YES) {
                cell.title.text = @"任务消息";
                cell.content.text = [_taskMessage valueForKey:@"Content"];
                cell.time.text = [_taskMessage valueForKey:@"time"];
                cell.image.image = [UIImage imageNamed:@"task"];
            } else {
                cell.title.text = @"匹配请求";
                cell.image.image = [UIImage imageNamed:@"love_red"];
                cell.content.text = [_parterRequest valueForKey:@"Content"];
                cell.time.text = [_parterRequest valueForKey:@"Time"];
            }
            break;
        case 3:
            cell.title.text = @"攻略指南";
            cell.image.image = [UIImage imageNamed:@"bulb"];
            cell.content.text = [_guide valueForKey:@"Content"];
            cell.time.text = [_guide valueForKey:@"Time"];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    switch (row) {
        case 0:
        {
            NSString* curUID = [IMAPlatform sharedInstance].host.userId;
            if([curUID isEqualToString:@"fdb"]) {
                IMAUser* lover = [[IMAUser alloc] initWith:@"user1"];
                lover.nickName = @"小绵羊";
                //        lover.remark = @"honey";
                //lover.icon = @"";
                [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:lover];
            } else if([curUID isEqualToString:@"user1"]) {
                IMAUser* lover = [[IMAUser alloc] initWith:@"fdb"];
                lover.nickName = @"龙卷风";
                lover.remark = @"亲爱的";
                //lover.icon = @"";
                [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:lover];
            }
            break;
        }
        case 1: {
            
            break;
        }
        case 2: {
            
            break;
        }
        case 3: {
            
            break;
        }
        default:
            break;
    }
    
}

@end
