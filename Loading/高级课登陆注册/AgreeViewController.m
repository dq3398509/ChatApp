//
//  AgreeViewController.m
//  高级课登陆注册
//
//  Created by Stephen on 15/12/21.
//  Copyright © 2015年 董强. All rights reserved.
//

#import "AgreeViewController.h"
#import "EaseMob.h"
@interface AgreeViewController ()<UITableViewDataSource, UITableViewDelegate, IChatManagerDelegate,UISearchBarDelegate, EMChatManagerDelegateBase>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayFriend;
@property (nonatomic, strong) NSMutableArray *arrayMessage;
@property (nonatomic, copy) NSString *who;
@end

@implementation AgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self createTableView];
}
#pragma mark - 单例创建VC
+ (instancetype)sharePlayerViewController
{
    static AgreeViewController *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        player = [[AgreeViewController alloc] init];
        
    });
    
    return player;
}

#pragma mark - 接收AppDelegate传来的值
- (void)passValue:(NSString *)name message:(NSString *)message {
    static int a = 0;
    if (a == 0) {
        self.arrayFriend = [NSMutableArray array];
        self.arrayMessage = [NSMutableArray array];
    }
    a++;
    if (self.arrayFriend.count != 0 && self.arrayMessage.count != 0) {
    
    [self.arrayFriend addObject:name];
    [self.arrayMessage addObject:message];
    
    NSLog(@"-----%@------%@", self.arrayFriend[0], self.arrayMessage[0]);
    }
    [self.tableView reloadData];
}

- (void)createTableView
{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.arrayFriend.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [self.arrayFriend objectAtIndex:indexPath.row];

    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        AgreeViewController *agreeVC = [[AgreeViewController alloc] init];
//        [self.navigationController pushViewController:agreeVC animated:YES];
//    } else {
//        
//        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"dongqiang" conversationType:eConversationTypeChat];
//        
//        ChatViewController *chat = [[ChatViewController alloc] init];
//        
//        chat.messageArray = [NSMutableArray array];
//        
//        [chat.messageArray setArray:[conversation loadAllMessages]];
//        
//        [self.navigationController pushViewController:chat animated:YES];
//    }
}


// 成功添加
- (void)okHandle:(UIButton *)btn {
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:self.who error:&error];
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
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:self.who reason:@"111111" error:&error];
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
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:self.who removeFromRemote:YES error:&error];
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
