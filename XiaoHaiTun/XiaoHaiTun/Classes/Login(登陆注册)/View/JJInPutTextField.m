//
//  JJInPutTextField.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/4.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJInPutTextField.h"

@implementation JJInPutTextField

+ (instancetype)inputTextFieldWithFrame:(CGRect) frame WithPlaceholder:(NSString *)placeholder delegate:(id)delegate{
    JJInPutTextField *inputTextField = [[JJInPutTextField alloc]initWithFrame:frame];
    
    UITextField *phoneTextField = [[UITextField alloc]init];
    phoneTextField.delegate = delegate;
    inputTextField.textField = phoneTextField;
    phoneTextField.font = [UIFont systemFontOfSize:16];
    phoneTextField.placeholder = placeholder;
    [inputTextField addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(inputTextField);
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBA(238, 238, 238, 1);
    [inputTextField addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(inputTextField);
        make.height.equalTo(@1);
    }];
    UIButton *eyeBtn = [[UIButton alloc]init];
    inputTextField.eyeBtn = eyeBtn;
    eyeBtn.hidden = YES;
    [eyeBtn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [inputTextField addSubview:eyeBtn];
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@42);
        make.right.top.bottom.equalTo(inputTextField);
    }];
    [eyeBtn addTarget:inputTextField action:@selector(eyeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return inputTextField;
}

- (void)eyeBtnClick {
    self.textField.secureTextEntry = !self.textField.secureTextEntry;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
       
    }
    return self;
}

@end
