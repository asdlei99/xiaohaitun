//
//  JJEarlyEducationViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityBaseViewController.h"
#import "JJActivityDetailViewController.h"
#import "JJActivityTableViewCell.h"
#import "HFNetWork.h"
#import "MBProgressHUD+gifHUD.h"
#import <MJExtension.h>
#import "JJActivityTableViewCellModel.h"
#import <MJExtension.h>

static NSString * const activityCellIdentifier = @"activityCellIdentifier";

@interface JJActivityBaseViewController ()

//模型数组
@property (nonatomic, strong) NSMutableArray<JJActivityTableViewCellModel *> *modelArray;

//最新
@property(nonatomic,assign)NSInteger currentPage;

@end


@implementation JJActivityBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.navigationItem.title = @"相关活动";
    //注册
    [self.tableView registerClass:[JJActivityTableViewCell class] forCellReuseIdentifier:activityCellIdentifier];
    weakSelf(weakSelf);
    //下拉
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![Util isNetWorkEnable]) {//先判断网络状态
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView showNoNetWorkWithTryAgainBlock:^{
                [weakSelf.tableView.mj_header beginRefreshing];
            }];
            return ;
        }
        weakSelf.currentPage = 1;
        [weakSelf.tableView hideNoNetWork];
        [weakSelf requestWithActivity];
    }];
    
    //上拉
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (![Util isNetWorkEnable]) {//先判断网络状态
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        weakSelf.currentPage++;
        [weakSelf loadMorerequestWithActivity];
    }];
//    MJRefreshAutoNormalFooter *mjFooter = self.tableView.mj_footer;
//    [mjFooter setTitle:@"" forState:MJRefreshStateIdle];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [UIView new];
}
//下拉发起活动网络请求
- (void)requestWithActivity {
    //发送活动列表请求
    NSString * activityRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_HOME_ACTIVITY];
    NSDictionary * goodsparams = nil;
    if(self.sortModel.keyWord.length != 0){
        goodsparams = @{@"pageSize":@"10", @"page":@(self.currentPage), @"kw" : self.sortModel.keyWord};
    }else{
        goodsparams = @{@"pageSize":@"10", @"page":@(self.currentPage), @"category_id":self.sortModel.categoryID};
    }
    [HFNetWork postWithURL:activityRequesturl params:goodsparams success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) {
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        self.modelArray = [JJActivityTableViewCellModel mj_objectArrayWithKeyValuesArray:response[@"activitys"]];
        
        for(JJActivityTableViewCellModel *model in self.modelArray) {
            model.picture = [NSString stringWithFormat:@"%@?imageView2/1/w/1000/h/500",model.picture];
        }
         [self.tableView reloadData];
        if(self.modelArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        if(self.modelArray.count == 0){
            weakSelf(weakSelf);
            [self.tableView showNoDateWithImageName:nil title:@"暂无数据" btnName:nil TryAgainBlock:nil];
        }else{
            [self.tableView hideNoDate];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}
//上拉加载更多
- (void)loadMorerequestWithActivity {
    //发送活动列表请求
    NSString * activityRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_HOME_ACTIVITY];
    NSDictionary * goodsparams = nil;
    
    if(self.sortModel.keyWord.length != 0){
        goodsparams = @{@"pageSize":@"10", @"page":@(self.currentPage), @"kw" : self.sortModel.keyWord};
    }else{
        goodsparams = @{@"pageSize":@"10", @"page":@(self.currentPage), @"category_id":self.sortModel.categoryID};
    }
    [HFNetWork postWithURL:activityRequesturl params:goodsparams success:^(id response) {
        
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) {
            [self.tableView.mj_footer endRefreshing];
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        NSArray *moreModelArray = [JJActivityTableViewCellModel mj_objectArrayWithKeyValuesArray:response[@"activitys"]];
        for(JJActivityTableViewCellModel *model in moreModelArray) {
            model.picture = [NSString stringWithFormat:@"%@?imageView2/1/w/1000/h/500",model.picture];
        }

        [self.modelArray addObjectsFromArray:moreModelArray] ;
        [self.tableView reloadData];
        if(moreModelArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        if(self.modelArray.count == 0){
            weakSelf(weakSelf);
            [self.tableView showNoDateWithImageName:nil title:@"暂无数据" btnName:nil TryAgainBlock:nil];
        }else{
            [self.tableView hideNoDate];
        }
    } fail:^(NSError *error) {
        self.currentPage--;
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCellIdentifier forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (SCREEN_WIDTH - 20) * (37.0 / 71) + 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJActivityTableViewCellModel *model = self.modelArray[indexPath.row];
    JJActivityDetailViewController *activiityDetailViewController = [[JJActivityDetailViewController alloc]init];
    activiityDetailViewController.activityID = model.activityID;
    
//    activiityDetailViewController.activityID = self.modelArray[indexPath.row]
    [self.navigationController pushViewController:activiityDetailViewController animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

@end
