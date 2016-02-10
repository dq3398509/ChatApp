//
//  AddViewController.m
//  高级课登陆注册
//
//  Created by Stephen on 15/12/18.
//  Copyright © 2015年 董强. All rights reserved.
//

#import "AddViewController.h"
#import "CustomTextField.h"
#import "UIImage+MostColor.h"
#import "EaseMob.h"

@interface AddViewController ()
@property (nonatomic, strong) CustomTextField *username;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *ok;
@property (nonatomic, strong) UIButton *noo;
@property (nonatomic, strong) UIButton *remove;

@property (nonatomic, strong) UIView *addView;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBarController.tabBar.hidden = YES;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(hanleAdd:)];
    
    UIImage *img = [UIImage imageNamed:@"yindao2"];
    UIColor *most=[img mostColor];
    // 添加好友的用户名
    self.username = [CustomTextField textFieldWithFrame:CGRectMake(30, 100, self.view.bounds.size.width - 60, 45) borderStyle:4 placeHoder:@"好友用户名" leftImageView:TextFieldLeftImageViewUserName secureTextEntry:NO lineColor:most];
    
    self.username.textField.returnKeyType = UIReturnKeyNext;
    self.username.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.username.textField.keyboardType = UIKeyboardTypeAlphabet;
    //    self.username.textField.delegate = self;
    
    [self.view addSubview:self.username];
    
    self.addView = [[UIView alloc] init];
    self.addView.frame = CGRectMake(30, 165, self.view.bounds.size.width - 60, 65);
    self.addView.backgroundColor = most;
    self.addView.hidden = YES;
    [self.view addSubview:self.addView];
    
//    [self createTfandBtn];
//    [self backFRList];
}
- (void)hanleAdd:(UIBarButtonItem *)add {
    
    if (self.username.textField.text.length != 0) {
    
    UILabel *userN = [[UILabel alloc] init];
//    userN.backgroundColor = [UIColor blueColor];
    userN.frame = CGRectMake(20, 0, self.view.bounds.size.width - 160, 65);
    userN.text = self.username.textField.text;
    userN.textColor = [UIColor whiteColor];
    [self.addView addSubview:userN];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20 + self.view.bounds.size.width - 160 + 10, 0, 60, 65);
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(addF:) forControlEvents:UIControlEventTouchUpInside];
    [self.addView addSubview:btn];
    
    self.addView.hidden = NO;
    } else {
        self.addView.hidden = YES;

    }
}
- (void)addF:(UIButton *)btn {
    EMError *pErr = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:self.username.textField.text message:@"我想加您为好友" error:&pErr];
    if (isSuccess && !pErr) {
        NSLog(@"已发送好友请求");
    }
}
- (void)createTfandBtn {
    UIImage *img = [UIImage imageNamed:@"yindao2"];
    UIColor *most=[img mostColor];
    // 添加好友的用户名
    self.username = [CustomTextField textFieldWithFrame:CGRectMake(30, 100, self.view.bounds.size.width - 60, 45) borderStyle:4 placeHoder:@"好友用户名" leftImageView:TextFieldLeftImageViewUserName secureTextEntry:NO lineColor:most];
    
    self.username.textField.returnKeyType = UIReturnKeyNext;
    self.username.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.username.textField.keyboardType = UIKeyboardTypeAlphabet;
//    self.username.textField.delegate = self;
    
    [self.view addSubview:self.username];
    
    // 添加发送按钮
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(30, 160, self.view.bounds.size.width - 60, 40);
    self.button.backgroundColor = most;
    [self.button setTitle:@"添加" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(addHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.button.layer.cornerRadius = 8;
    [self.view addSubview:self.button];
    
    self.ok = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ok.frame = CGRectMake(30, 210, self.view.bounds.size.width - 60, 40);
    self.ok.backgroundColor = most;
    [self.ok setTitle:@"同意" forState:UIControlStateNormal];
    [self.ok addTarget:self action:@selector(okHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.ok.layer.cornerRadius = 8;
    [self.view addSubview:self.ok];
    
    self.noo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.noo.frame = CGRectMake(30, 260, self.view.bounds.size.width - 60, 40);
    self.noo.backgroundColor = most;
    [self.noo setTitle:@"拒绝" forState:UIControlStateNormal];
    [self.noo addTarget:self action:@selector(nooHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.noo.layer.cornerRadius = 8;
    [self.view addSubview:self.noo];
    
    self.remove = [UIButton buttonWithType:UIButtonTypeCustom];
    self.remove.frame = CGRectMake(30, 310, self.view.bounds.size.width - 60, 40);
    self.remove.backgroundColor = most;
    [self.remove setTitle:@"删除好友" forState:UIControlStateNormal];
    [self.remove addTarget:self action:@selector(removeHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.remove.layer.cornerRadius = 8;
    [self.view addSubview:self.remove];


}
// 获取好友列表
- (void)backFRList {
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            NSLog(@"%@", buddyList);
//            NSLog(@"%@, %ld",[[buddyList firstObject] username], (long)[[buddyList firstObject] followState]);
        }
    } onQueue:nil];
}

// 接收好友申请
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message {
    NSLog(@"%@- 向你发来 -%@", username, message);
}

// 成功添加
- (void)okHandle:(UIButton *)btn {
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:self.username.textField.text error:&error];
    if (isSuccess && !error) {
        NSLog(@"同意成功");
    }
}
// 好友请求被接受时的回调
- (void)didAcceptedByBuddy:(NSString *)username {
    NSLog(@"%@", username);
}
// 拒绝添加
- (void)nooHandle:(UIButton *)btn {
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:self.username.textField.text reason:@"111111" error:&error];
    if (isSuccess && !error) {
        NSLog(@"拒绝成功");
    }
}
// 好友请求被拒绝时的回调
- (void)didRejectedByBuddy:(NSString *)username {
    NSLog(@"%@", username);
}

- (void)removeHandle:(UIButton *)btn {
    EMError *error = nil;
    // 删除好友
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:self.username.textField.text removeFromRemote:YES error:&error];
    if (isSuccess && !error) {
        NSLog(@"删除成功");
    }
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
