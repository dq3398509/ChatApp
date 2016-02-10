//
//  InformationCell.m
//  高级课登陆注册
//
//  Created by 董强 on 15/12/17.
//  Copyright © 2015年 董强. All rights reserved.
//

#import "InformationCell.h"

@interface InformationCell ()




@end


@implementation InformationCell


- (void)layoutSubviews
{
    
    if (self.message) {
        
        NSArray *arr = self.message.messageBodies;
        
        EMTextMessageBody *body = [arr firstObject];
        self.contentLabel.text = body.text;
        self.contentLabel.numberOfLines = 0;
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
