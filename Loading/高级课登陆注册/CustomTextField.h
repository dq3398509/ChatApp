//
//  CustomTextField.h
//  高级课登陆注册
//
//  Created by 董强 on 15/12/14.
//  Copyright © 2015年 董强. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, CustomTextFieldBorderStyle) {
    
    CustomTextFieldBorderStyleNone,
    CustomTextFieldBorderStyleLine,
    CustomTextFieldBorderStyleBezel,
    CustomTextFieldBorderStyleRoundedRect,
    CustomTextFieldBorderStyleUnderLine
    
};



typedef NS_ENUM(NSInteger, TextFieldLeftImageView) {
    
    TextFieldLeftImageViewNone,
    TextFieldLeftImageViewUserName,
    TextFieldLeftImageViewPassword,
    TextFieldLeftImageViewPhone,
    TextFieldLeftImageViewCaptcha
    
};


@interface CustomTextField : UIView


@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *lineView;


+ (instancetype)textFieldWithFrame:(CGRect)frame
                       borderStyle:(CustomTextFieldBorderStyle)borderStyle
                        placeHoder:(NSString *)placeHoder
                     leftImageView:(TextFieldLeftImageView)leftImageView
                   secureTextEntry:(BOOL)securTextEntry
                         lineColor:(UIColor *)lineColor;




@end
