//
//  FriendsViewController.h
//  高级课登陆注册
//
//  Created by 董强 on 15/12/17.
//  Copyright © 2015年 董强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController
@property (nonatomic, copy) NSString *userNames;
+ (instancetype)sharePlayerViewController;
- (void)passValue:(NSString *)name message:(NSString *)message;
@end
