//
//  aaaViewController.m
//  高级课登陆注册
//
//  Created by 董强 on 15/12/14.
//  Copyright © 2015年 董强. All rights reserved.
//

#import "aaaViewController.h"
#import "CustomTextField.h"
#import "UIImage+MostColor.h"
#import "RegisterViewController.h"
#import "ForgetPassWordViewController.h"
#import "EaseMob.h"
#import "FriendsViewController.h"
#import "TabBarController.h"

@interface aaaViewController ()<UITextFieldDelegate,IChatManagerDelegate>

@property (nonatomic, strong) CustomTextField *userTextField;
@property (nonatomic, strong) CustomTextField *pswTextField;

@property (nonatomic, strong) UIButton *registerBtn;  // 注册
@property (nonatomic, strong) UIButton *forgetBtn; // 忘记密码
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIColor *most;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation aaaViewController


- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    // 背景图
    self.backImageView.image = [UIImage imageNamed:@"yindao2"];
    self.backImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.backImageView];
    
    /**
     毛玻璃图
     */
    UIVisualEffectView *visurl = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visurl.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    visurl.alpha = 0.7;
    [self.backImageView addSubview:visurl];
    
    
    UIImage *img = [UIImage imageNamed:@"yindao2"];
    self.most=[img mostColor];
    
    self.userTextField = [CustomTextField textFieldWithFrame:CGRectMake(30, self.view.bounds.size.height - 300, self.view.bounds.size.width - 60, 45) borderStyle:4 placeHoder:@"账户" leftImageView:TextFieldLeftImageViewUserName secureTextEntry:NO lineColor:self.most];
    self.userTextField.textField.returnKeyType = UIReturnKeyNext;
    self.userTextField.textField.delegate = self;
    [self.view addSubview:self.userTextField];
    
    
    self.pswTextField = [CustomTextField textFieldWithFrame:CGRectMake(30, self.view.bounds.size.height - 240, self.view.bounds.size.width - 60, 45) borderStyle:4 placeHoder:@"密码" leftImageView:TextFieldLeftImageViewPassword secureTextEntry:YES lineColor:self.most];
    self.pswTextField.textField.returnKeyType = UIReturnKeyGo;
    self.pswTextField.textField.delegate = self;
    [self.view addSubview:self.pswTextField];
    
    
    // 键盘弹出通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    
    // 键盘回收通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];

    
    [self createButton];
    [self createSubmitBtn];
}

// 键盘出现
- (void)keyboardWillShow:(NSNotification *)noti
{
    
    CGRect rect = [[noti.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    
    
    self.view.frame = CGRectMake(0, 190 - rect.size.height, self.view.bounds.size.width, self.view.bounds.size.height);

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


/**
 *  登陆按钮
 */
- (void)createSubmitBtn
{
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(30, self.view.bounds.size.height - 100, self.view.bounds.size.width - 60, 40);
    [self.submitBtn setTitle:@"登    陆" forState:UIControlStateNormal];
    self.submitBtn.backgroundColor = self.most;
    self.submitBtn.layer.cornerRadius = 8;
    
    [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.submitBtn];
    
    
}


- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    
    NSLog(@"%@", error);
    
}


- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    
    FriendsViewController *friends = [[FriendsViewController alloc] init];
    
    [self.navigationController pushViewController:friends animated:YES];
}

- (void)submitAction
{

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:self.userTextField.textField.text forKey:@"lidi"];
    
    
    // 手动登录
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.userTextField.textField.text password:self.pswTextField.textField.text completion:^(NSDictionary *loginInfo, EMError *error) {
        
        if (!error && loginInfo) {

            NSLog(@"登录成功");
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];

            /**
             跳转 tabbarController
             */
            TabBarController *tabbarCon = [[TabBarController alloc] init];
            tabbarCon.selectedIndex = 1;
            [self.navigationController pushViewController:tabbarCon animated:YES];
            

            
            
        } else {
            
            NSLog(@"登录失败");
        }
        
    } onQueue:nil];


    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userTextField.textField) {
        
        [self.userTextField.textField resignFirstResponder];
        [self.pswTextField.textField becomeFirstResponder];

    } else {
        
        [self.view endEditing:YES];
        
        /**
         *  登陆按钮事件
         */
        [self submitAction];
    }
    

    return YES;
}


- (void)createButton
{
    
    UIView *btnBackView = [[UIView alloc] initWithFrame:CGRectMake(100, self.view.bounds.size.height - 180, self.view.bounds.size.width - 200, 30)];
    [self.backImageView addSubview:btnBackView];

    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.registerBtn.frame = CGRectMake(0, 0, btnBackView.bounds.size.width / 2, 30);
    [self.registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(regosterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.registerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [btnBackView addSubview:self.registerBtn];
    
    
    self.forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.forgetBtn.frame = CGRectMake(btnBackView.bounds.size.width / 2 + 1, 0, btnBackView.bounds.size.width / 2, 30);
    [self.forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetBtn addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.forgetBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [btnBackView addSubview:self.forgetBtn];
    
    
    UIView *lingView = [[UIView alloc] initWithFrame:CGRectMake(btnBackView.bounds.size.width / 2 , 5, 1, btnBackView.bounds.size.height - 10)];
    lingView.backgroundColor = self.most;
    [btnBackView addSubview:lingView];
    
}

/**
 *  注册按钮
 */
- (void)regosterAction:(UIButton *)btn
{
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

/**
 *  忘记密码按钮
 */
- (void)forgetAction:(UIButton *)btn
{
    
    
    ForgetPassWordViewController *forgetPsw = [[ForgetPassWordViewController alloc] init];
    
    [self.navigationController pushViewController:forgetPsw animated:YES];
    
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
