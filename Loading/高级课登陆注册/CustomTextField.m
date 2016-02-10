//
//  CustomTextField.m
//  高级课登陆注册
//
//  Created by 董强 on 15/12/14.
//  Copyright © 2015年 董强. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self createSubviews];
        
    }
    return self;
}


// 自定义风格的下划线
- (void)createLineView:(UIColor *)color
{
    // 下划线
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];

    self.lineView.backgroundColor = color;

    
    [self addSubview:self.lineView];
}


// textfield
- (void)createSubviews
{
    // textField 布局
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 1)];

    
    [self addSubview:self.textField];
}

+ (instancetype)textFieldWithFrame:(CGRect)frame
                       borderStyle:(CustomTextFieldBorderStyle)borderStyle
                        placeHoder:(NSString *)placeHoder
                     leftImageView:(TextFieldLeftImageView)leftImageView
                   secureTextEntry:(BOOL)securTextEntry
                         lineColor:(UIColor *)lineColor
{

    CustomTextField *ctfView = [[CustomTextField alloc] initWithFrame:frame];

    
    // textField 风格
    switch (borderStyle) {
        case 0:
            
            ctfView.textField.borderStyle = 0;
            break;
            
        case 1:
            
            ctfView.textField.borderStyle = 1;
            break;
            
        case 2:
            
            ctfView.textField.borderStyle = 2;
            break;
            
        case 3:
            
            ctfView.textField.borderStyle = 3;
            break;
            
        case 4:
            
            ctfView.textField.borderStyle = 0;
            
            [ctfView createLineView:lineColor];
            
        default:
            break;
    }
    
    
    // textField 占位符
    ctfView.textField.placeholder = placeHoder;

    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    switch (leftImageView) {
        case 0:
            
            break;
            
        case 1:
            
            iconImgView.image = [UIImage imageNamed:@"iconfont-wodezhanghao"];
            ctfView.textField.leftView = iconImgView;
            ctfView.textField.leftViewMode = UITextFieldViewModeAlways;
            break;
            
        case 2:
            
            iconImgView.image = [UIImage imageNamed:@"iconfont-mima"];
            ctfView.textField.leftView = iconImgView;
            ctfView.textField.leftViewMode = UITextFieldViewModeAlways;
            break;
            
        case 3:
            
            iconImgView.image = [UIImage imageNamed:@"iconfont-unie64f"];
            ctfView.textField.leftView = iconImgView;
            ctfView.textField.leftViewMode = UITextFieldViewModeAlways;
            break;
            
        case 4:
            
            iconImgView.image = [UIImage imageNamed:@"iconfont-yanzhengma-3"];
            ctfView.textField.leftView = iconImgView;
            ctfView.textField.leftViewMode = UITextFieldViewModeAlways;
            break;
            
        default:
            break;
    }
    
    
    
    // 密文
    if (securTextEntry) {
        
        ctfView.textField.secureTextEntry = YES;
    } else {
        
        ctfView.textField.secureTextEntry = NO;
    }
    
    // 修改 placeholder 颜色
    [ctfView.textField setValue:[UIColor colorWithWhite:0.498 alpha:1.000] forKeyPath:@"_placeholderLabel.textColor"];
    
    // 字体
//    [textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];


    return ctfView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
