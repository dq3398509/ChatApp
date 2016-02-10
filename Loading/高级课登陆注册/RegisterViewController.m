//
//  RegisterViewController.m
//  高级课登陆注册
//
//  Created by 董强 on 15/12/14.
//  Copyright © 2015年 董强. All rights reserved.
//

#import "RegisterViewController.h"
#import "CustomTextField.h"
#import "UIImage+MostColor.h"
#import "CoreDataManager.h"
#import "Account.h"
#import <SMS_SDK/SMSSDK.h>
#import "EaseMob.h"


@interface RegisterViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) CustomTextField *username;
@property (nonatomic, strong) CustomTextField *password;
@property (nonatomic, strong) CustomTextField *passwordAg;
@property (nonatomic, strong) CustomTextField *telephone;
@property (nonatomic, strong) CustomTextField *captcha; // 验证码
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *post;
@property (nonatomic, strong) CoreDataManager *manager;

@property (nonatomic, strong) NSMutableArray *fetchArray;

@property (nonatomic, strong) NSTimer *timer; // 定时器
@property (nonatomic, assign) NSInteger timeCount; // 时间

@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"注册用户";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.manager = [CoreDataManager shareCoreDataManager];

    self.view.backgroundColor = [UIColor whiteColor];
    
    // 键盘弹出通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    
    // 键盘回收通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    
  
    [self createTFandBtn];
    
}

// 键盘出现
- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect rect = [[noti.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    
    NSLog(@"%@", noti);

    if (self.captcha.textField.frame.origin.y < self.view.frame.size.height - rect.size.height) {
        self.view.frame = CGRectMake(0, 190 - rect.size.height + 23, self.view.bounds.size.width, self.view.bounds.size.height);
    } else {
//        self.view.frame = CGRectMake(0, 190 - rect.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    }
}

// 键盘回收
- (void)keyboardWillHide:(NSNotification *)noti
{
    
    self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

// 点击空白处键盘回收
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




- (void)createTFandBtn {
    UIImage *img = [UIImage imageNamed:@"yindao2"];
    UIColor *most=[img mostColor];
    
    self.username = [CustomTextField textFieldWithFrame:CGRectMake(30, 100, self.view.bounds.size.width - 60, 45) borderStyle:4 placeHoder:@"账户" leftImageView:TextFieldLeftImageViewUserName secureTextEntry:NO lineColor:most];
    
    self.username.textField.returnKeyType = UIReturnKeyNext;
    self.username.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.username.textField.keyboardType = UIKeyboardTypeAlphabet;
    self.username.textField.delegate = self;
    
    [self.view addSubview:self.username];
    
    self.password = [CustomTextField textFieldWithFrame:CGRectMake(30, 155, self.view.bounds.size.width - 60, 45) borderStyle:4 placeHoder:@"密码" leftImageView:TextFieldLeftImageViewPassword secureTextEntry:YES lineColor:most];
    
    self.password.textField.returnKeyType = UIReturnKeyNext;
    self.password.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.password.textField.keyboardType = UIKeyboardTypeAlphabet;
    self.password.textField.delegate = self;
    
    [self.view addSubview:self.password];
    
    self.passwordAg = [CustomTextField textFieldWithFrame:CGRectMake(30, 210, self.view.bounds.size.width - 60, 45) borderStyle:4 placeHoder:@"确认密码" leftImageView:TextFieldLeftImageViewPassword secureTextEntry:YES lineColor:most];
    
    self.passwordAg.textField.returnKeyType = UIReturnKeyNext;
    self.passwordAg.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.passwordAg.textField.keyboardType = UIKeyboardTypeAlphabet;
    self.passwordAg.textField.delegate = self;
    
    [self.view addSubview:self.passwordAg];
    
    
    // 电话号码
    self.telephone = [CustomTextField textFieldWithFrame:CGRectMake(30, 265, self.view.bounds.size.width - 60, 45) borderStyle:4 placeHoder:@"请输入11位手机号码" leftImageView:TextFieldLeftImageViewPhone secureTextEntry:NO lineColor:most];
    
    self.telephone.textField.returnKeyType = UIReturnKeyNext;
    self.telephone.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.telephone.textField.keyboardType = UIKeyboardTypeAlphabet;
    self.telephone.textField.delegate = self;
    
    [self.view addSubview:self.telephone];
    
    
    
    // 注册按钮
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(30, self.view.bounds.size.height - 100, self.view.bounds.size.width - 60, 40);
    self.button.backgroundColor = most;
    [self.button setTitle:@"注册" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(saveAndSubmitCaptcha:) forControlEvents:UIControlEventTouchUpInside];
    self.button.layer.cornerRadius = 8;
    [self.view addSubview:self.button];
    

    
    // 验证码输入框
    self.captcha = [CustomTextField textFieldWithFrame:CGRectMake(30, 320, self.view.bounds.size.width - 60, 45) borderStyle:4 placeHoder:@"请输入验证码" leftImageView:TextFieldLeftImageViewCaptcha secureTextEntry:NO lineColor:most];
    
    self.captcha.textField.frame = CGRectMake(0, 0, 120, 44);
    
    self.captcha.textField.returnKeyType = UIReturnKeyGo;
    self.captcha.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.captcha.textField.keyboardType = UIKeyboardTypeAlphabet;
    self.captcha.textField.delegate = self;
    
    [self.view addSubview:self.captcha];
    
    // 发送验证码按钮
    self.post = [UIButton buttonWithType:UIButtonTypeCustom];
    self.post.frame = CGRectMake(self.captcha.frame.size.width - 120, 0, 120, 35);
    [self.post setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.post.titleLabel.font = [UIFont systemFontOfSize:15];
    self.post.backgroundColor = [UIColor colorWithRed:0.173 green:0.600 blue:0.075 alpha:1.000];
    [self.post addTarget:self action:@selector(postCaptcha) forControlEvents:UIControlEventTouchUpInside];
    self.post.layer.cornerRadius = 5;
    [self.captcha addSubview:self.post];


    



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
        [self.post setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", (long)self.timeCount] forState:UIControlStateNormal];

    } else if (self.timeCount == 0) {
            
        [self.post setTitle:@"发送验证码" forState:UIControlStateNormal];

        [self.timer invalidate];
        self.timer = nil;
        
        self.post.userInteractionEnabled = YES;
        
        self.post.backgroundColor = [UIColor colorWithRed:0.173 green:0.600 blue:0.075 alpha:1.000];


    }

}

// 发送验证码
- (void)postCaptcha
{
    
    self.post.backgroundColor = [UIColor grayColor];
    
    self.timeCount = 15;
    self.post.userInteractionEnabled = NO;
    
    [self.post setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", (long)self.timeCount] forState:UIControlStateNormal];
    
    [self beganTimer];
    
    
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.telephone.textField.text zone:@"86" customIdentifier:@"aaaa" result:^(NSError *error) {
        
        if (error) {
            NSLog(@"错误描述：%@", error);
        } else {
            NSLog(@"获取验证码成功");
        }
    }];
    
   
}


// 注册按钮事件 并提交验证码验证
- (void)saveAndSubmitCaptcha:(UIButton *)btn
{
    
    [SMSSDK commitVerificationCode:self.captcha.textField.text phoneNumber:self.telephone.textField.text zone:@"86" result:^(NSError *error) {
        
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"验证失败" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
                [alert addAction:actionConfirm];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];

        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"验证成功" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
        
            [alert addAction:actionConfirm];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];

            [self saveUserNameAndPsw];
            [self registerHuanXin];
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

        
    } else if (![self.password.textField.text isEqualToString: self.passwordAg.textField.text]){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"两次输入的密码不正确" preferredStyle:UIAlertControllerStyleAlert];
        
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
- (void)registerHuanXin {
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.username.textField.text password:self.password.textField.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
            
        } else {
            NSLog(@"用户名已存在");
        }
    } onQueue:nil];
}

// 验证
- (void)saveUserNameAndPsw
{
    
    Account *txl = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:self.manager.managedObjectContext];
    
    
    txl.username = self.username.textField.text;
    txl.password = self.password.textField.text;
    txl.telephone = self.telephone.textField.text;
    
    [self.manager saveContext];
    
    NSLog(@"%@", NSHomeDirectory());
    
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:self.manager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSString *tempA = @"username = '";
    NSString *tempB = self.username.textField.text;
    
    NSString *newString = [NSString stringWithFormat:@"%@%@'",tempA,tempB];
    
    NSLog(@"LLLL________>%@", newString);
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:newString];
    
    [fetchRequest setPredicate:predicate];
    
    // 1.name = '奚旺'
    // 2.age > 30
    // 3.age < 20 || name = '奚旺'
    // 4.name like '*强'//* = 任意位
    // 5.name like '?强'//？= 一位
    // 6.name CONTAINS '刘'//任意位包含"刘"的
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.manager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"%@", error);
    }
    for (Account *hope in fetchedObjects) {
        NSLog(@"账号：%@, 密码：%@, 电话：%@", [hope username], [hope password], [hope telephone]);
    }

    
    
    [self.fetchArray setArray:fetchedObjects];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.username.textField) {
        [self.username.textField resignFirstResponder];
        [self.password.textField becomeFirstResponder];
    }else if (textField == self.password.textField) {
        [self.password.textField resignFirstResponder];
        [self.passwordAg.textField becomeFirstResponder];
    }else if (textField == self.passwordAg.textField) {
        [self.passwordAg.textField resignFirstResponder];
        [self.telephone.textField becomeFirstResponder];
    }else if (textField == self.telephone.textField) {
        [self.telephone.textField resignFirstResponder];
        [self.captcha.textField becomeFirstResponder];
    }else if (textField == self.captcha.textField) {
        [self postCaptcha];
    }

    return YES;
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
