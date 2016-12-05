//
//  MyMessageTableViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/12/2.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "MyMessageTableViewController.h"

@interface MyMessageTableViewController ()

@end

@implementation MyMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//解决tableviewcell被顶部导航栏遮挡的问题
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉多余的行
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (MyMessageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyMessageCellID";
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MyMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    if(row == 0) {
        cell.title.text = @"情侣聊天";
    } else if( row == 1) {
        cell.title.text = @"系统消息";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    if(row == 0) {
        /*IMAUser* lover = [[IMAUser alloc] initWith:@"fdb"];
        lover.nickName = @"龙卷风";
        lover.remark = @"亲爱的";
        //lover.icon = @"";
        [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:lover];*/
        
        
        IMAUser* lover = [[IMAUser alloc] initWith:@"user1"];
        lover.nickName = @"小绵羊";
//        lover.remark = @"honey";
        //lover.icon = @"";
        [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:lover];
    } else if(row == 1) {
        //进入到系统消息界面
    }
}

@end
