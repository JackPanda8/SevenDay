//
//  TestViewController.m
//  SevenDay
//
//  Created by macbook for test on 16/12/2.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//进入到C2C聊天视图
- (void)pushToChatViewControllerWith:(IMAUser *)user {
    NavigationViewController *curNav = (NavigationViewController *)self;
//    NavigationViewController *curNav = [[NavigationViewController alloc] initWithRootViewController:self];
    
#if kTestChatAttachment
    // 无则重新创建
    ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
    ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
    vc.hidesBottomBarWhenPushed = YES;
    [curNav pushViewController:vc withBackTitle:@"返回" animated:YES];
    
    if (curNav.viewControllers.count != 0)
    {
        [curNav popToRootViewControllerAnimated:YES];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chatButton:(id)sender {
    IMAUser* lover = [[IMAUser alloc] initWith:@"fdb"];
    lover.nickName = @"龙卷风";
    lover.remark = @"亲爱的";
    //lover.icon = @"";
    [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:lover];
}
@end
