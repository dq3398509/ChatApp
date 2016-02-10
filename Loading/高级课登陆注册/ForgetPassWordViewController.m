//
//  ForgetPassWordViewController.m
//  高级课登陆注册
//
//  Created by 董强 on 15/12/14.
//  Copyright © 2015年 董强. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "CustomTextField.h"
#import "UIImage+MostColor.h"
#import "Account.h"
#import "CoreDataManager.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+AddressBookMethods.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK+ExtexdMethods.h>

@interface ForgetPassWordViewController ()

@property (nonatomic, strong) CustomTextField *username;
@property (nonatomic, strong) CustomTextField *captcha;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *post;


@property (nonatomic, strong) CustomTextField *password;
@property (nonatomic, strong) CustomTextField *passwordAg;
@property (nonatomic, strong) CustomTextField *telephone;

@property (nonatomic, strong) CoreDataManager *manager;
@property (nonatomic, strong) NSMutableArray *fetchArray;

@property (nonatomic, strong) UIAlertController *alertC;
@property (nonatomic, strong) UIAlertController *alertB;
@property (nonatomic, strong) UIAlertController *alertA;


@property (nonatomic, strong) NSTimer *timer; // 定时器
@property (nonatomic, assign) NSInteger timeCount; // 时间
@end

@implementation ForgetPassWordViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"忘记密码";
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.manager = [CoreDataManager shareCoreDataManager];
    self.fetchArray = [NSMutableArray array];

    [self createTFandButton];
    
}

- (void)createTFandButton {
    
    // 创建 输入框和按钮
    UIImage *img = [UIImage imageNamed:@"yindao2"];
    UIColor *most=[img mostColor];
    
    self.username = [CustomTextField textFieldWithFrame:CGRectMake(30, 100, self.view.bounds.size.width - 60, 45) borderStyle:4 placeHoder:@"账户" leftImageView:TextFieldLeftImageViewUserName secureTextEntry:NO lineColor:most];
    
    [self.view addSubview:self.username];
    
    self.telephone = [CustomTextField textFieldWithFrame:CGRectMake(30, 155, self.view.bounds.size.width - 60, 45) borderStyle:4 placeHoder:@"请输入预留电话号码" leftImageView:TextFieldLeftImageViewPhone  secureTextEntry:NO lineColor:most];
    
    [self.view addSubview:self.telephone];
    
    self.password = [CustomTextField textFieldWithFrame:CGRectMake(30, 265, self.view.bounds.size.width - 60, 45) borderStyle:4 placeHoder:@"新密码" leftImageView:TextFieldLeftImageViewPassword secureTextEntry:YES lineColor:most];
    
    [self.view addSubview:self.password];
    
    
    // 验证码输入框
    self.captcha = [CustomTextField textFieldWithFrame:CGRectMake(30, 210, self.view.bounds.size.width - 60 - 130 - 20, 45) borderStyle:4 placeHoder:@"请输入验证码" leftImageView:TextFieldLeftImageViewCaptcha secureTextEntry:NO lineColor:most];
    [self.view addSubview:self.captcha];

   
    self.post = [UIButton buttonWithType:UIButtonTypeCustom];
    self.post.frame = CGRectMake(self.view.bounds.size.width - 30 - 120, 220, 120, 40);
    [self.post setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.post.titleLabel.font = [UIFont systemFontOfSize:15];
    self.post.backgroundColor = [UIColor colorWithRed:0.173 green:0.600 blue:0.075 alpha:1.000];
    [self.post addTarget:self action:@selector(postCaptcha) forControlEvents:UIControlEventTouchUpInside];
    self.post.layer.cornerRadius = 5;
    [self.view addSubview:self.post];
    
    // 注册按钮
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(30, self.view.bounds.size.height - 100, self.view.bounds.size.width - 60, 40);
    self.button.backgroundColor = most;
    [self.button setTitle:@"设置新密码" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(submitCaptcha) forControlEvents:UIControlEventTouchUpInside];
    self.button.layer.cornerRadius = 8;
    [self.view addSubview:self.button];
}

// 计时器
- (void)beganTimer
{
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeButtonTitle) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}


- (void)changeButtonTitle
{
    
    if (self.timeCount > 0) {
        
        --self.timeCount;
        [self.post setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", self.timeCount] forState:UIControlStateNormal];
        
    } else if (self.timeCount == 0) {
        
        [self.post setTitle:@"发送验证码" forState:UIControlStateNormal];
        
        [self.timer invalidate];
        self.timer = nil;
        
        self.post.userInteractionEnabled = YES;
        
        self.post.backgroundColor = [UIColor colorWithRed:0.173 green:0.600 blue:0.075 alpha:1.000];
        
        
    }
    
}


- (void)postCaptcha
{
    
    self.post.backgroundColor = [UIColor grayColor];
    
    self.timeCount = 15;
    self.post.userInteractionEnabled = NO;
    
    [self.post setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", self.timeCount] forState:UIControlStateNormal];
    
    [self beganTimer];
    
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.telephone.textField.text zone:@"86" customIdentifier:@"aaaa" result:^(NSError *error) {
        
        if (!error) {
            NSLog(@"获取验证码成功");
        } else {
            NSLog(@"错误描述：%@", error);
        }
    }];
}


- (void)submitCaptcha
{
    
    [SMSSDK commitVerificationCode:self.captcha.textField.text phoneNumber:self.telephone.textField.text zone:@"86" result:^(NSError *error) {
        
        if (error) {
            NSLog(@"验证失败");

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"验证码错误" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            [alert addAction:actionConfirm];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
            
        } else {
            NSLog(@"验证成功");
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"密码修改成功" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            
            [alert addAction:actionConfirm];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];

            
            [self saveDate];
        }
        
    }];
    

    if (self.username.textField.text.length < 5) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"账号长度不足" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alert addAction:actionConfirm];
        
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    } else if (self.password.textField.text.length < 5 || self.passwordAg.textField.text.length < 5){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"密码长度不足" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alert addAction:actionConfirm];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
        
    } else if (!(self.telephone.textField.text.length == 11)){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"手机号输入不正确" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alert addAction:actionConfirm];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    }
    
}

// 数据库
- (void) saveDate {
    
    
    NSLog(@"%@", NSHomeDirectory());
    
    
    // 查询数据库
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:self.manager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSString *tempA = @"username = '";
    NSString *tempB = self.username.textField.text;
    
    NSString *newString = [NSString stringWithFormat:@"%@%@'",tempA,tempB];
    
    
    if (self.username.textField.text.length < 5) {
        NSLog(@"无此用户");
        
        self.alertC = [UIAlertController alertControllerWithTitle:@"此用户名没有注册" message:@"请检查您的用户名" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [self.alertC addAction:alert];
        
        [self presentViewController:self.alertC animated:YES completion:^{
            
        }]; // 正常

    }
    if (self.telephone.textField.text.length < 11){
        self.alertA = [UIAlertController alertControllerWithTitle:@"错误" message:@"手机号码输入不正确" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [self.alertA addAction:alert];
        
        [self presentViewController:self.alertA animated:YES completion:^{
            
        }]; // 正常
    }
    if (self.password.textField.text.length < 5){
        self.alertB = [UIAlertController alertControllerWithTitle:@"错误" message:@"密码长度不足" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [self.alertB addAction:alert];
        
        [self presentViewController:self.alertB animated:YES completion:^{
            
        }];
    } else {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:newString];
    
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.manager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"%@", error);
    }
    for (Account *hope in fetchedObjects) {
        NSLog(@"账号：%@, 密码：%@, 电话：%@", [hope username], [hope password], [hope telephone]);
    }
    
    
    [self.fetchArray setArray:fetchedObjects];
    
// 更新数据库
    
    
    Account *save = self.fetchArray[0];
    
    save.password = self.password.textField.text;
    
    [self.manager saveContext];
    
    NSLog(@"账号：%@, 密码：%@, 电话：%@", [save username], [save password], [save telephone]);
        
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
