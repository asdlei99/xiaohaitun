//
//  JJSearchView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSearchView.h"

@interface JJSearchView ()<UITextFieldDelegate>



@end

@implementation JJSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.textField = [[UITextField alloc]init];
        self.textField.backgroundColor = RGBA(237, 237, 237, 1);
        [self addSubview:self.textField];
        UIImageView *searchGlassView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_glass"]];
        searchGlassView.width = 30;
        searchGlassView.contentMode = UIViewContentModeCenter;
        self.textField.leftView = searchGlassView;
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        self.textField.returnKeyType = UIReturnKeySearch;
        self.textField.enablesReturnKeyAutomatically = YES;
        self.textField.delegate = self;
        [self.textField addTarget:self action:@selector(textFiledAction) forControlEvents:UIControlEventEditingChanged];
        
        self.searchBtn = [[UIButton alloc]init];
        self.searchBtn.hidden = YES;
        [self.searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.searchBtn setTitleColor:RGB(238, 238, 238) forState:UIControlStateDisabled];
        [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [self addSubview:self.searchBtn];
        [self createBordersWithColor:RGBA(253, 253, 253, 1) withCornerRadius:0 andWidth:1];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(31 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(self).with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self).with.offset(-7 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(self).with.offset(-61 * KWIDTH_IPHONE6_SCALE);
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.left.equalTo(self.textField.mas_right);
    }];
    [self.textField layoutIfNeeded];
    NSLog(@"%@",NSStringFromCGRect(self.textField.frame));
    [self.textField createBordersWithColor:[UIColor clearColor] withCornerRadius:self.textField.height / 2 andWidth:0];
}

#pragma mark - UItextFieldDelegate
- (void)textFiledAction {
    NSLog(@"%@",self.textField.text);
    self.searchBtn.hidden = self.textField.text.length > 0 ? NO : YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.delegate searchWithString:textField.text];
    return YES;
}
- (void)searchClick:(UIButton *)btn {
    [self.delegate searchWithString:self.textField.text];
}


//开始编辑文字,即键盘弹出来那下
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"%s  %@  ",__func__,textField.text);
//    self.searchBtn.enabled = textField.text.length > 0 ? YES : NO;
    self.searchBtn.hidden = textField.text.length > 0 ? NO : YES;
    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSLog(@"%s  %@  %@",__func__,string,textField.text);
//    self.searchBtn.enabled = textField.text.length > 0 ? YES : NO;
//    return YES;
//}

@end
