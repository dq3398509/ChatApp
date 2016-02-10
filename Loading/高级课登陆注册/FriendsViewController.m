//
//  FriendsViewController.m
//  高级课登陆注册
//
//  Created by 董强 on 15/12/17.
//  Copyright © 2015年 董强. All rights reserved.
//

#import "FriendsViewController.h"
#import "ChatViewController.h"
#import "AddViewController.h"
#import "AgreeViewController.h"
#import "EaseMob.h"

@interface FriendsViewController ()<UITableViewDataSource, UITableViewDelegate, IChatManagerDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) NSMutableArray *arr;

@property (nonatomic, strong) NSMutableArray *arrayFriend;
@property (nonatomic, strong) NSMutableArray *arrayMessage;
@end

@implementation FriendsViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.arr = [NSMutableArray array];
    
    self.title = @"好友列表";
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(hanleAdd:)];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [self createTableView];
    [self createTableViewSearchBar];

}

// 获取好友列表
- (void)didFetchedBuddyList:(NSArray *)buddyList
                      error:(EMError *)error {
    
    self.arr = buddyList.mutableCopy;
    [self.tableView reloadData];
    NSLog(@"好友列表：%@", self.arr);
    
}
- (void)hanleAdd:(UIBarButtonItem *)add {
    
    AddViewController *addVC = [[AddViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)createTableViewSearchBar
{
    
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    
    search.placeholder = @"搜索";
    
    self.tableView.tableHeaderView = search;
    
    search.delegate = self;
    
    
}




- (void)createTableView
{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。

    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row < [self.arr count]) {
        
            EMError *error = nil;
            // 删除好友
            if (self.arr.count != 0) {
                
                BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:[[self.arr objectAtIndex:indexPath.row] username] removeFromRemote:YES error:&error];
                if (isSuccess && !error) {
                    NSLog(@"删除成功");
                }
            }
            
            [self.arr removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
            [self.tableView reloadData];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {

        return self.arrayFriend.count;
    } else {
        return self.arr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.section == 0) {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell"];

         NSString *newString = [NSString stringWithFormat:@"%@---%@",self.arrayFriend[indexPath.row],self.arrayMessage[indexPath.row]];
        cell1.textLabel.text = newString;
        
        UIButton *btnYes = [UIButton buttonWithType:UIButtonTypeCustom];
        btnYes.frame = CGRectMake(cell.frame.size.width - 70, 0, 60, cell.frame.size.height / 2);
        btnYes.backgroundColor = [UIColor greenColor];
        [btnYes setTitle:@"同意" forState:UIControlStateNormal];
        btnYes.tag = indexPath.row;
        [btnYes addTarget:self action:@selector(addF:) forControlEvents:UIControlEventTouchUpInside];
        [cell1 addSubview:btnYes];

        UIButton *btnNO = [UIButton buttonWithType:UIButtonTypeCustom];
        btnNO.frame = CGRectMake(cell.frame.size.width - 70, cell.frame.size.height / 2, 60, cell.frame.size.height / 2);
        btnNO.backgroundColor = [UIColor redColor];
        [btnNO setTitle:@"拒绝" forState:UIControlStateNormal];
        btnNO.tag = indexPath.row;
        [btnNO addTarget:self action:@selector(noF:) forControlEvents:UIControlEventTouchUpInside];
        [cell1 addSubview:btnNO];
        
        return cell1;
    } else {
        cell.textLabel.text = [[self.arr objectAtIndex:indexPath.row] username];
        
        self.userNames = cell.textLabel.text;
        return cell;
    }
 
}



- (void)addF:(UIButton *)btn {
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:self.arrayFriend[btn.tag] error:&error];
    if (isSuccess && !error) {
        NSLog(@"同意成功");
    }
    [self.tableView reloadData];
}


// 好友请求被接受时的回调
- (void)didAcceptedByBuddy:(NSString *)username {
    NSLog(@"%@", username);
}


// 拒绝添加
- (void)noF:(UIButton *)btn {
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:self.arrayFriend[btn.tag] reason:@"111111" error:&error];
    if (isSuccess && !error) {
        NSLog(@"拒绝成功");
    }
    [self.tableView reloadData];
}


// 好友请求被拒绝时的回调
- (void)didRejectedByBuddy:(NSString *)username {
    NSLog(@"%@", username);
}

#pragma mark - 单例创建VC
+ (instancetype)sharePlayerViewController
{
    static FriendsViewController *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        player = [[FriendsViewController alloc] init];
        
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
    
    if (name != nil && message != nil) {
    
    
    [self.arrayFriend addObject:name];
    [self.arrayMessage addObject:message];
    
    }
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else {
        return 60;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        AgreeViewController *agreeVC = [AgreeViewController sharePlayerViewController];
        [self.navigationController pushViewController:agreeVC animated:YES];

    } else {

        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:[self.arr[indexPath.row] username] conversationType:eConversationTypeChat];
    
        ChatViewController *chat = [[ChatViewController alloc] init];
    
        chat.messageArray = [NSMutableArray array];
        chat.fname = [[self.arr objectAtIndex:indexPath.row] username];
    
        [chat.messageArray setArray:[conversation loadAllMessages]];
    
        [self.navigationController pushViewController:chat animated:YES];
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
