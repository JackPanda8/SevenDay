//
//  MyMessageCell.m
//  SevenDay
//
//  Created by macbook for test on 16/12/2.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "MyMessageCell.h"

@interface MyMessageCell ()

{
@protected
    __weak id<IMAConversationShowAble> _showItem;
}

@end

@implementation MyMessageCell

- (void) dealloc {
    [self.KVOController unobserveAll];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.KVOController = [FBKVOController controllerWithObserver:self];
    }
    return self;
}

- (void)configCellOnNewMessage:(id<IMAConversationShowAble>)item
{
    _showItem = item;
    
    [self.KVOController unobserveAll];
    
    __weak MyMessageCell *ws = self;
    [self.KVOController observe:item keyPath:@"lastMessage" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws updateCellOnNewMessage];
    }];
    [self.KVOController observe:item keyPath:@"lastMessage.status" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws updateCellOnNewMessage];
    }];
    
    [self.KVOController observe:item keyPath:@"draft" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change){
        [ws updateCellOnNewMessage];
    }];
    
    [self updateCellOnNewMessage];
}

- (void)updateCellOnNewMessage
{
    _content.text = [[self getLastLoverChat] valueForKey:@"Content"];
}

//获取最后一条情侣聊天纪律
- (NSDictionary*)getLastLoverChat {
    NSMutableDictionary* lastLoverChat = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    IMAConversationManager *mgr = [IMAPlatform sharedInstance].conversationMgr;
    NSString* currentLover = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentLover"];

    IMAConversation *currentConversation = [mgr queryConversationWith:[[IMAUser alloc] initWith:currentLover]];
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
                [lastLoverChat setObject:@"[未知类型的消息]" forKey:@"Content"];
                break;
            case EIMAMSG_Text:
                [lastLoverChat setObject:text forKey:@"Content"];
                break;
            case EIMAMSG_Image:
                [lastLoverChat setObject:@"[图片]" forKey:@"Content"];
                break;
            case EIMAMSG_File:
                [lastLoverChat setObject:@"[文件]" forKey:@"Content"];
                break;
            case EIMAMSG_Sound:
                [lastLoverChat setObject:@"[语音]" forKey:@"Content"];
                break;
            case EIMAMSG_Face:
                [lastLoverChat setObject:@"[表情]" forKey:@"Content"];
                break;
            case EIMAMSG_Location:
                [lastLoverChat setObject:@"[位置信息]" forKey:@"Content"];
                break;
            case EIMAMSG_Video:
                [lastLoverChat setObject:@"[视频]" forKey:@"Content"];
                break;
            case EIMAMSG_Custom:
                [lastLoverChat setObject:@"[礼物]" forKey:@"Content"];
                break;
            case EIMAMSG_TimeTip:
                [lastLoverChat setObject:@"[时间提醒]" forKey:@"Content"];
                break;
            case EIMAMSG_GroupTips:
                [lastLoverChat setObject:@"[群提醒]" forKey:@"Content"];
                break;
            case EIMAMSG_GroupSystem:
                [lastLoverChat setObject:@"[群系统消息]" forKey:@"Content"];
                break;
            case EIMAMSG_SNSSystem:
                [lastLoverChat setObject:@"[关键链消息]" forKey:@"Content"];
                break;
            case EIMAMSG_ProfileSystem:
                [lastLoverChat setObject:@"[资料变更]" forKey:@"Content"];
                break;
            case EIMAMSG_InputStatus:
                [lastLoverChat setObject:@"[对方的输入状态]" forKey:@"Content"];
                break;
            case EIMAMSG_SaftyTip:
                [lastLoverChat setObject:@"[消息中包含有敏感词]" forKey:@"Content"];
                break;
            default:
                [lastLoverChat setObject:@"[看到这条消息就是腾讯云出bug了]" forKey:@"Content"];
                break;
        }
        [lastLoverChat setObject:conv.lastMsgTime forKey:@"Time"];
        
    }
    
    return nil;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
