//
//  JJWaitPayViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJWaitPayViewController.h"
#import "JJGoodsWaitCell.h"
#import "JJGoodsWaitModel.h"
#import "JJOrderDetailViewController.h"
#import "JJCashierViewController.h"
#import "User.h"
#import "MBProgressHUD+gifHUD.h"
#import <MJExtension.h>
#import "JJGoodsOrderModel.h"
#import "JJTabBarController.h"

//#import "JJAccountSafeCell.h"
//static NSString * const AccountSafeCellIdentifier = @"AccountSafeCellIdentifier";


static NSString * const GoodsWaitCellIdentifier = @"JJGoodsWaitCellIdentifier";

@interface JJWaitPayViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<JJGoodsOrderModel *> *modelArray;
@property (nonatomic, strong) UITableView *tableView;

//最新
@property(nonatomic,assign)NSInteger currentPage;

@end

@implementation JJWaitPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBA(238, 238, 238, 1);
    switch (self.goodsWaitType) {
        case 10:
        self.navigationItem.title = @"我的订单";
        break;
        case 9:
        self.navigationItem.title = @"待付款";
        break;
        case 3:
        self.navigationItem.title = @"待发货";
        break;
        case 4:
        self.navigationItem.title = @"待收货";
        break;
        default:
        break;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[JJGoodsWaitCell class] forCellReuseIdentifier:GoodsWaitCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    weakSelf(weakself);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself goodsOrderRequest];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself moreGoodsOrderRequest];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //监听通知刷新tableView
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewHeadBegineRefresh) name:OrderListRefreshNotification object:nil];
}

- (void)tableViewHeadBegineRefresh {
    [self.tableView.mj_header beginRefreshing];
}

//发送请求
- (void)goodsOrderRequest {
    weakSelf(weakself);
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView showNoNetWorkWithTryAgainBlock:^{
            [weakself.tableView.mj_header beginRefreshing];
        }];
        return ;
    }
    self.currentPage = 1;
    [self.tableView hideNoNetWork];
    //发送商品订单列表请求
    NSString *goodsOrderRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_GOODS_ORDER_LIST];
    NSDictionary * goodsOrderparams = nil;
    if (self.goodsWaitType == 10) {
        goodsOrderparams = @{@"user_id" : [User getUserInformation].userId , @"pageSize" : @"10", @"page" : @(self.currentPage) };
    } else {
        goodsOrderparams = @{@"user_id" : [User getUserInformation].userId , @"pageSize" : @"10", @"page" : @(self.currentPage) , @"status" : @(self.goodsWaitType)};
    }
    [HFNetWork postWithURL:goodsOrderRequesturl params:goodsOrderparams success:^(id response) {
        [self.tableView.mj_header endRefreshing];
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
        NSArray *goodsOrderModelArray = [JJGoodsOrderModel mj_objectArrayWithKeyValuesArray:response[@"orders"]];
        self.modelArray = goodsOrderModelArray;
        [self.tableView reloadData];
        if(self.modelArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer resetNoMoreData];
        }
        if(self.modelArray.count == 0){
            weakSelf(weakSelf);
            [self.tableView showNoDateWithImageName:@"NO_GOODS_ORDER" title:@"您还没有相关订单" btnName:@"去逛逛" TryAgainBlock:^{
                [weakSelf gotoGoods];
            }];
        }else{
            [self.tableView hideNoDate];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

//上拉加载更多
- (void)moreGoodsOrderRequest {
    weakSelf(weakself);
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        [weakself.tableView.mj_footer endRefreshing];
        return ;
    }
    self.currentPage++;
    //发送商品订单列表请求
    NSString *goodsOrderRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_GOODS_ORDER_LIST];
    NSDictionary * goodsOrderparams = nil;
    if (self.goodsWaitType == 10){
        goodsOrderparams = @{@"user_id" : [User getUserInformation].userId , @"pageSize" : @"10", @"page" : @(self.currentPage) };
    } else {
        goodsOrderparams = @{@"user_id" : [User getUserInformation].userId , @"pageSize" : @"10", @"page" : @(self.currentPage) , @"status" : @(self.goodsWaitType)};
    }
    [HFNetWork postWithURL:goodsOrderRequesturl params:goodsOrderparams success:^(id response) {
        
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        NSArray *goodsOrderModelArray = [JJGoodsOrderModel mj_objectArrayWithKeyValuesArray:response[@"orders"]];
        if (goodsOrderModelArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.modelArray addObjectsFromArray:goodsOrderModelArray] ;
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        self.currentPage--;
        [self.tableView.mj_footer endRefreshing];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}


//前往商城首页
- (void)gotoGoods {
    JJTabBarController *tabbarController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarController setSelectedIndex:0];
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJGoodsWaitCell *cel = [self.tableView dequeueReusableCellWithIdentifier:GoodsWaitCellIdentifier forIndexPath:indexPath];
//    cel.backgroundColor = RandomColor;
    JJGoodsOrderModel *goodsOrderModel =self.modelArray[indexPath.row];
    cel.model = goodsOrderModel;
    
//    [cel.payButton addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cel;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250 * KWIDTH_IPHONE6_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJOrderDetailViewController *orderDetailViewController = [[JJOrderDetailViewController alloc]init];
    orderDetailViewController.orderModel = self.modelArray[indexPath.row];
    [self.navigationController pushViewController:orderDetailViewController animated:YES];
}
#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
- (UITableView *)tableView{
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT_64) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
