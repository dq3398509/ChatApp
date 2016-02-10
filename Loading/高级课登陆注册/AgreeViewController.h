//
//  AgreeViewController.h
//  高级课登陆注册
//
//  Created by Stephen on 15/12/21.
//  Copyright © 2015年 董强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreeViewController : UIViewController
+ (instancetype)sharePlayerViewController;
- (void)passValue:(NSString *)name message:(NSString *)message;
@end
