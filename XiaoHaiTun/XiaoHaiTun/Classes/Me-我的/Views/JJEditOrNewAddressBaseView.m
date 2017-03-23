//
//  JJEditOrNewAddressBaseView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJEditOrNewAddressBaseView.h"

@interface JJEditOrNewAddressBaseView ()<UITextFieldDelegate>

@end

@implementation JJEditOrNewAddressBaseView

- (void)awakeFromNib{
    self.textField.delegate =self;
}

+ (instancetype)editOrNewAddressBaseView {
    return [[NSBundle mainBundle]loadNibNamed:@"JJEditOrNewAddressBaseView" owner:nil options:nil][0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
