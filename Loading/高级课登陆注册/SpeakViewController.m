//
//  SpeakViewController.m
//  高级课登陆注册
//
//  Created by 李迪 on 15/12/21.
//  Copyright © 2015年 董强. All rights reserved.
//

#import "SpeakViewController.h"
#import "EaseMob.h"
#import "ChatViewController.h"

@interface SpeakViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *Tab;
@property (nonatomic, strong)NSMutableArray *array;


@end

@implementation SpeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    

    self.array = [NSMutableArray array];
    for (EMConversation *str in conversations) {
        [self.array addObject:str.chatter];
    }
    
    [self createTab];

}

- (void)createTab{
    
    self.Tab = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds  style:UITableViewStylePlain];
    
    self.Tab.delegate = self;
    self.Tab.dataSource = self;
    self.Tab.rowHeight = 100;
    
    [self.Tab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LidiCell"];
    
    [self.view addSubview:self.Tab];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LidiCell"];
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   NSString *str = [self.array objectAtIndex:indexPath.row];
    
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:str conversationType:eConversationTypeChat];
    
    ChatViewController *chat = [[ChatViewController alloc] init];
    
    chat.messageArray = [NSMutableArray array];
    
    chat.fname = str;
    
    [chat.messageArray setArray:[conversation loadAllMessages]];
    
    [self.navigationController pushViewController:chat animated:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
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
