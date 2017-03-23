//
//  JJUpdateNameController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJUpdateNameController.h"
#import <Masonry.h>
#import "UIView+FrameExpand.h"
#import "UITextField+LimitLength.h"

@interface JJUpdateNameController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;


@end

@implementation JJUpdateNameController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"修改名称";
    //创建视图
    [self setView];
    
}

- (void)setView{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(changeCenter)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UITextField *textfiel = [[UITextField alloc]init];
    textfiel.placeholder = self.name;
    [textfiel xp_limitTextLength:10 block:^(NSString *text) {
        
    }];
    textfiel.delegate = self;
    self.textField=textfiel;
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.view).with.offset(90);
        make.height.equalTo(@33);
    }];
    [self.textField createBordersWithColor:NORMAL_COLOR withCornerRadius:0 andWidth:1];
}

- (void)changeCenter{
    [self.navigationController popViewControllerAnimated:YES];
    self.updateBlock(self.textField.text);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if ([string isEqualToString:@"\n"]) {
//        return YES;
//    }
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if ([toBeString length] > 5) {
//            textField.text = [toBeString substringToIndex:5];
//            return NO;
//    }
//
//    return YES;
//}

@end
