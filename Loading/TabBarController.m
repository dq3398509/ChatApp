//
//  TabBarController.m
//  高级课登陆注册
//
//  Created by 董强 on 15/12/23.
//  Copyright © 2015年 董强. All rights reserved.
//

#import "TabBarController.h"
#import "FriendsViewController.h"
#import "SetUpViewController.h"
#import "SpeakViewController.h"


@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 会话页面
    SpeakViewController *speak = [[SpeakViewController alloc]init];
    UINavigationController *speakNav = [[UINavigationController alloc]initWithRootViewController:speak];
    UIImage *img1 = [UIImage imageNamed:@"duihuakuang"];
    speakNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"会话" image:img1 tag:1003];
    
    /**
     *  好友列表
     */
    FriendsViewController *friends = [FriendsViewController sharePlayerViewController];
    UINavigationController *friendsNav = [[UINavigationController alloc] initWithRootViewController:friends];
    UIImage *img2 = [UIImage imageNamed:@"haoyou"];
    friendsNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"好友" image:img2 tag:100];
    
    /**
     *  设置页面
     */
    SetUpViewController *my = [[SetUpViewController alloc]init];
    UINavigationController *navMy = [[UINavigationController alloc]initWithRootViewController:my];
    UIImage *img3 = [UIImage imageNamed:@"chilun"];
    navMy.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"设置" image:img3 tag:1003];
    
    self.viewControllers = @[speakNav, friendsNav, navMy];

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
