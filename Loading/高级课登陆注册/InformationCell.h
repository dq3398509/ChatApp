//
//  InformationCell.h
//  高级课登陆注册
//
//  Created by 董强 on 15/12/17.
//  Copyright © 2015年 董强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMob.h"

@interface InformationCell : UITableViewCell

@property (nonatomic, strong) EMMessage *message;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidth;

@end
