//
//  JJLogisticMessageViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJLogisticMessageViewController.h"
#import "JJGoodsOrderModel.h"
#import "JJgoodsOrderLogisticModel.h"
#import "MBProgressHUD+gifHUD.h"
#import "JJLogisticCell.h"
#import "JJLogisticHeaderCell.h"
#import <MJExtension.h>

static NSString *logisticCellIdentifier = @"JJLogisticCellIdentifier";
static NSString *logisticHeaderCellIdentifier = @"JJLogisticHeaderCellIdentifier";

@interface JJLogisticMessageViewController ()

//快递单号
@property (nonatomic, copy) NSString *logistics_no;
//快递公司
@property (nonatomic, copy) NSString *logistics_company_name;
//快递信息模型数组
@property (nonatomic, strong) NSArray<JJgoodsOrderLogisticModel *> *logistModelArray;

@end

@implementation JJLogisticMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseSet];
    [self registCell];
    weakSelf(weakself);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself logisticMessageRequest];
    }];
    [self.tableView.mj_header beginRefreshing];
//    NSDictionary *response = @{@"logistics_id" : @"5664435432" ,
//                 @"logistics_no": @"g12133212313" , @"logistics_company_name" : @"顺丰" , @"logistics_list" : @[@{@"logistics_id" : @"idididid1" , @"logistics_zone" : @"上海" , @"logistics_remark" : @"已出发，下一站北京市" , @"logistics_time" : @"687897983953"},@{@"logistics_id" : @"idididid1" , @"logistics_zone" : @"上海shang" , @"logistics_remark" : @"已出发，下一站北京市hfsjafyuwyuryeiwwieryiwyriewyriawy" , @"logistics_time" : @"687897983953"}]};
//    NSArray *a = [JJgoodsOrderLogisticModel mj_objectArrayWithKeyValuesArray:response[@"logistics_list"]];
//    self.logistModelArray = a;
//    self.logistics_no = response[@"logistics_no"];
//    self.logistics_company_name = response[@"logistics_company_name"];
}

//基础设置
- (void)baseSet {
    self.navigationItem.title = @"物流信息";
    self.tableView.estimatedRowHeight = 200;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//注册Cell
- (void)registCell {
    [self.tableView registerClass:[JJLogisticCell class ] forCellReuseIdentifier:logisticCellIdentifier];
    [self.tableView registerClass:[JJLogisticHeaderCell class] forCellReuseIdentifier:logisticHeaderCellIdentifier];
}

#pragma mark - 发送物流信息请求
- (void)logisticMessageRequest {
    weakSelf(weakself);
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        [weakself.tableView.mj_header endRefreshing];
        return ;
    }
    //发送物流信息
    NSString * goodsOrderRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_LOGISTICS_MESSAGE];
    NSDictionary * goodsOrderparams = @{@"logistics_no" : self.goodsOrderLogisticModel.logistics_no , @"logistics_company" : self.goodsOrderLogisticModel.logistics_company};
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
        self.logistModelArray = [JJgoodsOrderLogisticModel mj_objectArrayWithKeyValuesArray:response[@"logistics_list"]];
        self.logistics_no = response[@"logistics_no"];
        self.logistics_company_name = response[@"logistics_company_name"];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

#pragma mark - UITableViewDataSource||UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.logistModelArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        JJLogisticHeaderCell *headCell = [self.tableView dequeueReusableCellWithIdentifier:logisticHeaderCellIdentifier forIndexPath:indexPath];
        headCell.orderNumLabel.text = self.goodsOrderModel.order_num;
        headCell.logisticLabel.text = [NSString stringWithFormat:@"%@%@",self.logistics_company_name,self.logistics_no];
        return headCell;
    } else {
        JJLogisticCell *logisticCell = [self.tableView dequeueReusableCellWithIdentifier:logisticCellIdentifier forIndexPath:indexPath];
        logisticCell.orderLogisticModel = self.logistModelArray[indexPath.row];
        logisticCell.topVerticalView.hidden = NO;
        logisticCell.bottomVerticalView.hidden = NO;
        if(indexPath.row == 0) {
            logisticCell.topVerticalView.hidden = YES;
            logisticCell.centerCircleView.backgroundColor = NORMAL_COLOR;
            logisticCell.logisticMessageLabel.textColor = NORMAL_COLOR;
            logisticCell.dateMessageLabel.textColor = NORMAL_COLOR;
            
        } else {
            logisticCell.centerCircleView.backgroundColor = RGBA(238, 238, 238, 1);
            logisticCell.logisticMessageLabel.textColor = RGBA(153, 153, 153, 1);
            logisticCell.dateMessageLabel.textColor = RGBA(153, 153, 153, 1);
        }
        if(indexPath.row == self.logistModelArray.count - 1) {
            logisticCell.bottomVerticalView.hidden = YES;
        }
        return logisticCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return 70 * KWIDTH_IPHONE6_SCALE;
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0){
        return 10;
    }else{
        return 0.01;
    }
}

@end
