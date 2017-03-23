//
//  JJInPutTextField.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/4.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JJInPutTextField : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *eyeBtn;

+ (instancetype)inputTextFieldWithFrame:(CGRect) frame WithPlaceholder:(NSString *)placeholder delegate:(id)delegate;

@end
