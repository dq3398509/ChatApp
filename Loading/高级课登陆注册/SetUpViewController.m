//
//  SetUpViewController.m
//  高级课登陆注册
//
//  Created by 李迪 on 15/12/21.
//  Copyright © 2015年 董强. All rights reserved.
//

#import "SetUpViewController.h"
#import "EaseMob.h"
#import "aaaViewController.h"

@interface SetUpViewController ()

@end

@implementation SetUpViewController

- (IBAction)outButton:(id)sender {
    
    EMError *error = nil;
    NSDictionary *info = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:&error];
    if (!error && info) {
        NSLog(@"退出成功");
    }
    
    aaaViewController *friends = [[aaaViewController alloc]init];
    
    
    [self.navigationController pushViewController:friends animated:YES];

//    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
