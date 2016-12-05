//
//  HomeTabBarController.m
//  SevenDay
//
//  Created by macbook for test on 16/12/5.
//  Copyright © 2016年 JackPanda8. All rights reserved.
//

#import "HomeTabBarController.h"

@interface HomeTabBarController ()

@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    //社区
    CommunityViewController *commVC = [main instantiateViewControllerWithIdentifier:@"CommunityViewController"];
    NavigationViewController *commNVC = [[NavigationViewController alloc] initWithRootViewController:commVC];
    commNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"社区" image:kIconConversationNormal selectedImage:kIconConversationHover];
    
    //消息
    MyMessageTableViewController *mymeVC = [main instantiateViewControllerWithIdentifier:@"MyMessageTableViewController"];
    NavigationViewController *mymeNVC = [[NavigationViewController alloc] initWithRootViewController:mymeVC];
    mymeNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的消息" image:kIconContactsNormal selectedImage:kIconContactsHover];
    
    //恋爱记
    LoveDiaryViewController *loveVC = [main instantiateViewControllerWithIdentifier:@"LoveDiaryViewController"];
    NavigationViewController *loveNVC = [[NavigationViewController alloc] initWithRootViewController:loveVC];
    loveNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"恋爱记" image:kIconSetupNormal selectedImage:kIconSetupHover];
    
    //我
    MyselfViewController *myseVC = [main instantiateViewControllerWithIdentifier:@"MyselfViewController"];
    NavigationViewController *myseNVC = [[NavigationViewController alloc] initWithRootViewController:myseVC];
    myseNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:kIconContactsNormal selectedImage:kIconContactsHover];
    
//    //社区
//    CommunityViewController *commVC = [[CommunityViewController alloc] init];
//    NavigationViewController *commNVC = [[NavigationViewController alloc] initWithRootViewController:commVC];
//    commNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"社区" image:kIconConversationNormal selectedImage:kIconConversationHover];
//    
//    //消息
//    ContainerMyMessageViewController *contVC = [[ContainerMyMessageViewController alloc] init];
//    NavigationViewController *contNVC = [[NavigationViewController alloc] initWithRootViewController:contVC];
//    contNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:kIconContactsNormal selectedImage:kIconContactsHover];
//    
//    //恋爱记
//    LoveDiaryViewController *loveVC = [[LoveDiaryViewController alloc] init];
//    NavigationViewController *loveNVC = [[NavigationViewController alloc] initWithRootViewController:loveVC];
//    loveNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"恋爱记" image:kIconSetupNormal selectedImage:kIconSetupHover];
//    
//    //我
//    MyselfViewController *myseVC = [[MyselfViewController alloc] init];
//    NavigationViewController *myseNVC = [[NavigationViewController alloc] initWithRootViewController:myseVC];
//    myseNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:kIconContactsNormal selectedImage:kIconContactsHover];
    
    self.tabBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    [self setViewControllers:@[commNVC, mymeNVC, loveNVC, myseNVC]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushToChatViewControllerWith:(IMAUser *)user {
    NavigationViewController *curNav = (NavigationViewController *)[[self viewControllers] objectAtIndex:self.selectedIndex];
    
    if (self.selectedIndex == 1)
    {
        // 选的中会话tab
        // 先检查当前栈中是否聊天界面
        NSArray *array = [curNav viewControllers];
        for (UIViewController *vc in array)
        {
            if ([vc isKindOfClass:[IMAChatViewController class]])
            {
                // 有则返回到该界面
                IMAChatViewController *chat = (IMAChatViewController *)vc;
                [chat configWithUser:user];
                //                chat.hidesBottomBarWhenPushed = YES;
                [curNav popToViewController:chat animated:YES];
                return;
            }
        }
#if kTestChatAttachment
        // 无则重新创建
        ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
        ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
        
        if ([user isC2CType])
        {
            TIMConversation *imconv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:user.userId];
            if ([imconv getUnReadMessageNum] > 0)
            {
                [vc modifySendInputStatus:SendInputStatus_Send];
            }
        }
        
        vc.hidesBottomBarWhenPushed = YES;
        [curNav pushViewController:vc withBackTitle:@"返回" animated:YES];
    }
    else
    {
        NavigationViewController *chatNav = (NavigationViewController *)[[self viewControllers] objectAtIndex:0];
        
#if kTestChatAttachment
        // 无则重新创建
        ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
        ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
        vc.hidesBottomBarWhenPushed = YES;
        [chatNav pushViewController:vc withBackTitle:@"返回" animated:YES];
        
        [self setSelectedIndex:1];
        
        if (curNav.viewControllers.count != 0)
        {
            [curNav popToRootViewControllerAnimated:YES];
        }
        
    }

}

@end
