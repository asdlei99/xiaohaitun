//
//  JJAccountSafeViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJAccountSafeViewController.h"
#import "JJAccountSafeCell.h"
#import "User.h"
#import "JJForgetPasswordViewController.h"

static NSString * const AccountSafeCellIdentifier = @"AccountSafeCellIdentifier";

@interface JJAccountSafeViewController ()

@end

@implementation JJAccountSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账号与安全";
    [self.tableView registerClass:[JJAccountSafeCell class] forCellReuseIdentifier:AccountSafeCellIdentifier];
    self.tableView.tableFooterView = [UIView new];

}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JJAccountSafeCell *cel = [self.tableView dequeueReusableCellWithIdentifier:AccountSafeCellIdentifier forIndexPath:indexPath];
    
    
    if(indexPath.row == 0){
        cel.phoneLabel.hidden = YES;
        cel.nameLabel.text = @"修改密码";
    }else{
        User *user = [User getUserInformation];
        NSString *mobile = user.mobile;
        if(mobile.length != 0){
        mobile = [self replaceStringWithAsterisk:mobile startLocation:3 lenght:4];
        cel.nameLabel.text = @"更好手机号";
        cel.detailLabel.text = @"如果您的验证码手机已丢失停用,请立即修改更换";
        cel.phoneLabel.text=mobile;
        }
        
    }
    // Configure the cell...
    
    return cel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0) {
        JJForgetPasswordViewController *forgetPasswordViewController = [[JJForgetPasswordViewController alloc]init];
        [self.navigationController pushViewController:forgetPasswordViewController animated:YES];
    }
}

-(NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght
{
    NSString *newStr = originalStr;
    for (int i = 0; i < lenght; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return newStr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

@end
