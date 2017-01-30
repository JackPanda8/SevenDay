//
//  MyMessageCell.h
//  SevenDay
//
//  Created by macbook for test on 16/12/2.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) id<IMAConversationShowAble> _showItem;

- (void)configCellOnNewMessage:(id<IMAConversationShowAble>)item;

@end
