//
//  ChatViewController.m
//  高级课登陆注册
//
//  Created by 董强 on 15/12/17.
//  Copyright © 2015年 董强. All rights reserved.
//

#import "ChatViewController.h"
#import "InformationCell.h"
#import "CustomTextField.h"
#import "EaseMob.h"
#import "SelfInformationCell.h"

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, IChatManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) CustomTextField *customTextField;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGRect getMessageRect;
@property (nonatomic, strong) NSString *myUser;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];


    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];

    
    [self createTableView];
    [self createTextField];
    
    [self reloadMessage];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.myUser = [user objectForKey:@"lidi"];
    
}


/**
 *   判断数组长度 滚动到最后一条信息
 */
- (void)reloadMessage
{
    if (self.messageArray.count != 0) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
    }
}


/**
 *   输入框
 */
- (void)createTextField
{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width, 49)];
    backImage.image = [UIImage imageNamed:@"chatinputbg"];
    backImage.userInteractionEnabled = YES;
    [self.view addSubview:backImage];
    
    self.customTextField = [CustomTextField textFieldWithFrame:CGRectMake(10, 8, self.view.bounds.size.width - 90, 35) borderStyle:3 placeHoder:@"请输入消息..." leftImageView:TextFieldLeftImageViewNone secureTextEntry:NO lineColor:nil];
    
    [backImage addSubview:self.customTextField];
    
    
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sendBtn.frame = CGRectMake(self.view.bounds.size.width - 70, 8, 60, 33);
    self.sendBtn.layer.cornerRadius = 5;
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    self.sendBtn.backgroundColor = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000];
    [self.sendBtn addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backImage addSubview:self.sendBtn];
}


/**
 *  发送按钮事件
 *
 *  @param btn
 */
- (void)sendButtonAction:(UIButton *)btn
{

    
    EMChatText *txtChat = [[EMChatText alloc] initWithText:self.customTextField.textField.text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:self.fname bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    //message.messageType = eConversationTypeGroupChat;// 设置为群聊消息
    //message.messageType = eConversationTypeChatRoom;// 设置为聊天室消息

    [[EaseMob sharedInstance].chatManager sendMessage:message progress:nil error:nil];
    
    [self.messageArray addObject:message];
    
    [self.tableView reloadData];
    [self reloadMessage];
    

    self.customTextField.textField.text = @"";

}

/*!
 @method
 @brief 异步方法, 发送一条消息
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改. 在发送过程中, willSendMessage:error:和didSendMessage:error:这两个回调会被触发
 @param message  消息对象(包括from, to, body列表等信息)
 @param progress 发送多媒体信息时的progress回调对象
 @result 发送的消息对象(因为是异步方法, 不能作为发送完成或发送成功失败与否的判断)
 */
- (EMMessage *)asyncSendMessage:(EMMessage *)message
                       progress:(id<IEMChatProgressDelegate>)progress
{
    
    NSLog(@"异步发送%@", message);
    
    return message;
}




// 收到消息的回调，带有附件类型的消息可以用SDK提供的下载附件方法下载（后面会讲到）
-(void)didReceiveMessage:(EMMessage *)message
{
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            NSLog(@"收到的文字是 txt -- %@",txt);
        
    
            [self.messageArray addObject:message];
            [self.tableView reloadData];
            [self reloadMessage];
        }
            break;
            
        default:
            break;
    }
}

// 会话列表
- (void)didUpdateConversationList:(NSArray *)conversationList
{
    NSLog(@"会话列表:%@", conversationList);
}



- (void)createTableView
{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 49 - 64) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    UINib *nib = [UINib nibWithNibName:@"InformationCell" bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    UINib *selfNib = [UINib nibWithNibName:@"SelfInformationCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:selfNib forCellReuseIdentifier:@"cell1"];
    
    
    
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    

}



- (void)keyboardWillShow:(NSNotification *)noti
{
    
    
    CGRect rect = [[noti.userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    
    self.view.frame = CGRectMake(0, 0 - rect.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

/**
 *  cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMMessage *message = [self.messageArray objectAtIndex:indexPath.row];
    NSArray *arr = message.messageBodies;
    
    EMTextMessageBody *body = [arr firstObject];
    
    
    CGRect rect = [body.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 112 - 16, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];


    if ([message.from isEqualToString:self.myUser]) {
        
        SelfInformationCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];

        cell1.labelWidth.constant = rect.size.width + 20;
        cell1.message = message;

        return cell1;
    } else {

        InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        cell.labelWidth.constant = rect.size.width + 20;
        cell.message = message;
        
        return cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMMessage *message = [self.messageArray objectAtIndex:indexPath.row];

    NSArray *arr = message.messageBodies;
    
    EMTextMessageBody *body = [arr firstObject];
    
    
    self.rect = [body.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 112 - 16, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
    
    return self.rect.size.height + 30;
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
