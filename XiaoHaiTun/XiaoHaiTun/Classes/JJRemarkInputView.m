//
//  JJRemarkInputView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJRemarkInputView.h"


@interface JJRemarkInputView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation JJRemarkInputView

+ (instancetype)remarkInputView {
    
    return [[NSBundle mainBundle]loadNibNamed:@"JJRemarkInput" owner:nil options:nil][0];
}
- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
- (void)awakeFromNib{
    self.inputRemarkTextField.delegate = self;
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}



@end
