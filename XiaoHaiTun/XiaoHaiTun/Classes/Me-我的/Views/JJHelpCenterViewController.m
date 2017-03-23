//
//  JJHelpCenterViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJHelpCenterViewController.h"
#import "JJHelpCenterTableViewCell.h"
#import "HFNetWork.h"
#import "MBProgressHUD+gifHUD.h"
#import "JJHelpCellModel.h"
#import <MJExtension.h>
#import "JJHelpDetailViewController.h"

static NSString * const JJHelpCenterTableViewCellIdentifier = @"JJHelpCenterTableViewCellCellIdentifier";



@interface JJHelpCenterViewController ()

@property (nonatomic, strong) NSArray<JJHelpCellModel *>* modelArray;


@end

@implementation JJHelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助中心";
    [self.tableView registerClass:[JJHelpCenterTableViewCell class] forCellReuseIdentifier:JJHelpCenterTableViewCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    [self helpRequest];
}

//获取帮助中心列表
- (void)helpRequest {
    NSString * helpRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_HELP];
    
    [HFNetWork getWithURL:helpRequesturl params:nil success:^(id response) {
        DebugLog(@"%@",response);
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        self.modelArray = [JJHelpCellModel mj_objectArrayWithKeyValuesArray:response[@"helps"]];
        [self.tableView reloadData];
        
        if(self.modelArray.count == 0){
            weakSelf(weakSelf);
            [self.tableView showNoDateWithImageName:nil title:@"暂无数据" btnName:nil TryAgainBlock:nil];
        }else{
            [self.tableView hideNoDate];
        }
        
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJHelpCenterTableViewCell *cel = [self.tableView dequeueReusableCellWithIdentifier:JJHelpCenterTableViewCellIdentifier forIndexPath:indexPath];
    cel.helpCellModel = self.modelArray[indexPath.row];
    return cel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJHelpDetailViewController *helpDetailVC = [[JJHelpDetailViewController alloc]init];
    helpDetailVC.model = self.modelArray[indexPath.row];
    [self.navigationController pushViewController:helpDetailVC animated:YES];
}
@end
