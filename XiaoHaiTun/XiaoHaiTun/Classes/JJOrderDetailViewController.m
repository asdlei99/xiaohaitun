//
//  JJOrderDetailViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//
#import "JJOrderDetailViewController.h"
#import "JJOrderGoodsCell.h"
#import "JJOrderNumberAndPayTypeView.h"
#import "JJAddressAndOrderRemarkCell.h"
#import "JJOrderPayMondyCell.h"
#import "JJImmediratePayView.h"
#import "JJConfirmReceiveView.h"
#import "JJApplyRefundView.h"
#import "JJOrderNumberAndPayTypeAndAddressView.h"
#import <ReactiveCocoa.h>
#import "JJApplyRefundController.h"
#import "UIView+XPKit.h"
#import "JJLogisticMessageViewController.h"
#import "JJGoodsWaitModel.h"
#import "JJGoodsOrderModel.h"
#import "MBProgressHUD+gifHUD.h"
#import "JJgoodsOrderLogisticModel.h"
#import <MJExtension.h>
#import "JJCashierViewController.h"
#import "JJOrderModel.h"
#import "UIViewController+Alert.h"
#import "UIViewController+ModelLogin.h"
#import "MQChatViewManager.h"
#import "MQChatDeviceUtil.h"
//#import "DevelopViewController.h"
#import <MeiQiaSDK/MeiQiaSDK.h>
#import "NSArray+MQFunctional.h"
#import "MQBundleUtil.h"
#import "MQAssetUtil.h"
#import "MQImageUtil.h"
#import "MQToast.h"
#import "JJGoodsDetailViewController.h"

static NSString *OrderGoodsCellIdentifier = @"JJOrderGoodsCellIdentifier";
static NSString *AddressAndOrderRemarkCellIdentifier = @"JJAddressAndOrderRemarkCellIdentifier";
static NSString *OrderPayMondyCellIdentifier =@"JJOrderPayMondyCell";

@interface JJOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,JJGoodsOrderRefundDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JJOrderNumberAndPayTypeAndAddressView *headView;

//立即支付
@property (nonatomic, strong) JJImmediratePayView *immediratePayView;
//确认收货
@property (nonatomic, strong) JJConfirmReceiveView *confirmReceiveView;
//申请退款
@property (nonatomic, strong) JJApplyRefundView *applyReFundView;
//客服
@property (nonatomic, strong) UIButton *servicePeopleBtn;
//快递model
@property (nonatomic, strong) JJgoodsOrderLogisticModel *orderLogisticModel;
//订单model
@property (nonatomic, strong) JJGoodsOrderModel *goodsOrderModel;
//订单中的商品数组
@property (nonatomic, strong) NSArray<JJGoodsWaitModel *> *goodsWaitModelArray;

@end

@implementation JJOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    为什么要在一开始(我的余额界面)(商品订单详情界面)(活动订单详情界面)  就隐藏一个mbProgressHUD:因为推送的时候如果程序处于关闭杀死状态,点击推送会先跳keywindow的rootViewcontroller然后马上跳到该界面,rootViewcontroller中可能在发送请求还没结束
    [MBProgressHUD hideHUD];

    [self initBaseView];
    [self basicSet];
    weakSelf(weakself);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself goodsOrderDetailRequest];
        
    }];
    [self.tableView.mj_header beginRefreshing];
}

//创建视图
- (void)initBaseView {
    //如果是modal出来的
    if(![self isPushWayAppear]) {
        // 只要覆盖了返回按钮, 系统自带的拖拽返回上一级的功能就会失效
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Nav_Back_White"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
       
    @weakify(self);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.servicePeopleBtn = [[UIButton alloc]init];
    [self.servicePeopleBtn setImage:[UIImage imageNamed:@"Service_People"] forState:UIControlStateNormal];
    [self.servicePeopleBtn addTarget:self action:@selector(presentServicePeople) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.servicePeopleBtn];
    [self.servicePeopleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self.view).with.offset(-59 *KWIDTH_IPHONE6_SCALE);
        make.width.height.equalTo(@(46 * KWIDTH_IPHONE6_SCALE));
    }];
}

- (void)presentServicePeople {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:NO];
    [chatViewManager.chatViewStyle setEnableRoundAvatar:YES];
    
    [chatViewManager setClientInfo:@{@"name":@"updated"} override:YES];
    [chatViewManager.chatViewStyle setNavBarTintColor:[UIColor whiteColor]];
    
    [chatViewManager presentMQChatViewControllerInViewController:self];
    
    //    [chatViewManager setLoginCustomizedId:@"xxxxjjxjjx"];
    //  [chatViewManager setPreSendMessages:@[@"message1"]];
    //   [chatViewManager setScheduledAgentId:@"f60d269236231a6fa5c1b0d4848c4569"];
    //[chatViewManager setScheduleLogicWithRule:MQChatScheduleRulesRedirectNone];
    //    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];
    //    [self removeIndecatorForView:basicFunctionBtn];
    
    [chatViewManager setRecordMode:MQRecordModeDuckOther];
    [chatViewManager setPlayMode:MQPlayModeMixWithOther];


}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置基本内容
- (void)basicSet {
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.goodsWaitModelArray = self.orderModel.goods_relateds;
    [self registCell];
}
//注册Cell
- (void)registCell{
    //注册商品cell
    [self.tableView registerClass:[JJOrderGoodsCell class] forCellReuseIdentifier:OrderGoodsCellIdentifier];
    //注册配送地址和订单备注Cell
    [self.tableView registerClass:[JJAddressAndOrderRemarkCell class] forCellReuseIdentifier:AddressAndOrderRemarkCellIdentifier];
    //注册支付信息cell
    [self.tableView registerClass:[JJOrderPayMondyCell class] forCellReuseIdentifier:OrderPayMondyCellIdentifier];
    
}

//发送商品订单详情请求
- (void)goodsOrderDetailRequest {
    weakSelf(weakself);
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        [self.tableView.mj_header endRefreshing];
        return ;
    }
    //发送商品订单详情请求
    NSString * goodsOrderRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_GOODS_ORDER_DETAIL];
    NSDictionary * goodsOrderparams = @{@"order_num" : self.orderModel.order_num };
    [HFNetWork postWithURL:goodsOrderRequesturl params:goodsOrderparams success:^(id response) {
        DebugLog(@"%@",response);
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
        self.goodsWaitModelArray = [JJGoodsWaitModel mj_objectArrayWithKeyValuesArray:response[@"goods_relateds"]];
        NSDictionary *logisticsDic = response[@"logistics"];
//        NSDictionary *logisticsDic = @{@"logistics_id" : @"567878" , @"logistics_no" : @"快递单号", @"logistics_company" : @"sf" , @"logistics_company_name" : @"顺丰" , @"logistics_zone" : @"北京" , @"logistics_remark" : @"已出发，下一站北京市" , @"logistics_time" :@"687897983953"};
        if(logisticsDic.count != 0){
            JJgoodsOrderLogisticModel *orderLogisticModel = [JJgoodsOrderLogisticModel mj_objectWithKeyValues:response[@"logistics"]];
            self.orderLogisticModel = orderLogisticModel;
        }
        self.goodsOrderModel = [JJGoodsOrderModel mj_objectWithKeyValues:response[@"order"]];
        [self.tableView reloadData];
        switch (self.goodsOrderModel.status) {
            case 9:
            {
                self.immediratePayView.hidden = NO;
                self.confirmReceiveView.hidden = YES;
                self.applyReFundView.hidden = YES;
            break;
            }
            case 4:
            {
                self.confirmReceiveView.hidden = NO;
                self.immediratePayView.hidden = YES;
                self.applyReFundView.hidden = YES;
            break;
            }
            case 1:
            {
                self.applyReFundView.hidden = NO;
                self.confirmReceiveView.hidden = YES;
                self.immediratePayView.hidden = YES;
            break;
            }
            case 5:
            {
                self.applyReFundView.hidden = NO;
                self.confirmReceiveView.hidden = YES;
                self.immediratePayView.hidden = YES;
                break;
            }
            default:
            {
                self.immediratePayView.hidden = YES;
                self.confirmReceiveView.hidden = YES;
                self.applyReFundView.hidden = YES;
            }
            break;
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}
//发送确认收货请求
- (void)confirmRequest {
    NSString * refundURL = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_ORDER_CONFIRM];
    NSDictionary * params = @{@"order_num" : self.goodsOrderModel.order_num};
    [HFNetWork postWithURL:refundURL params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        DebugLog(@"%@",response);
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) {
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:OrderListRefreshNotification object:nil];
        weakSelf(weakself);
        [self showAlertWithTitle:@"成功" message:@"用户已确认收货" cancelTitle:@"确定" cancelBlock:^{
            [weakself.tableView.mj_header beginRefreshing];
            }];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];

}


#pragma mark - UITableViewDataSource||UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.goodsWaitModelArray.count;
    }
    if(section == 1){
        return 1;
    }
    if(section == 2){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath .section == 0){
        JJOrderGoodsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:OrderGoodsCellIdentifier forIndexPath:indexPath];
        cell.model = self.goodsWaitModelArray[indexPath.row];
        return cell;
    }
    if(indexPath.section == 1) {
        JJAddressAndOrderRemarkCell * cell =[self.tableView dequeueReusableCellWithIdentifier:AddressAndOrderRemarkCellIdentifier forIndexPath:indexPath];
        cell.goodsOrderModel = self.goodsOrderModel;
        return cell;
    }
    if(indexPath.section == 2){
        JJOrderPayMondyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:OrderPayMondyCellIdentifier forIndexPath:indexPath ];
        cell.goodsOrderModel = self.goodsOrderModel;
        return cell;
    }
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        JJOrderNumberAndPayTypeAndAddressView *orderNumberAndPayTypeAndAddressView = [[JJOrderNumberAndPayTypeAndAddressView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 148 * KWIDTH_IPHONE6_SCALE)];
        self.headView = orderNumberAndPayTypeAndAddressView;
        orderNumberAndPayTypeAndAddressView.clipsToBounds = YES;
        weakSelf(weakSelf);
        orderNumberAndPayTypeAndAddressView.goodsOrderModel = self.goodsOrderModel;
        orderNumberAndPayTypeAndAddressView.goodsOrderLogisticModel = self.orderLogisticModel;
        
        [orderNumberAndPayTypeAndAddressView.bottomView whenTouchedUp:^{
            JJLogisticMessageViewController *logisticsInformationViewController = [[JJLogisticMessageViewController alloc]init];
            logisticsInformationViewController.goodsOrderLogisticModel = weakSelf.orderLogisticModel;
            logisticsInformationViewController.goodsOrderModel = weakSelf.goodsOrderModel;
            [weakSelf.navigationController pushViewController:logisticsInformationViewController animated:YES];
        }];
        return orderNumberAndPayTypeAndAddressView;
        //JJOrderNumberAndPayTypeView *orderNumberHeadView = [[JJOrderNumberAndPayTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 57 * KWIDTH_IPHONE6_SCALE)];
//        return orderNumberHeadView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JJGoodsWaitModel *goodModel = self.goodsWaitModelArray[indexPath.row];
        JJGoodsDetailViewController *goodsDetailVC = [[JJGoodsDetailViewController alloc]init];
        goodsDetailVC.name = goodModel.goods_name;
        goodsDetailVC.goodsID = goodModel.goods_id;
        goodsDetailVC.picture = goodModel.goods_cover;
        [self.navigationController pushViewController:goodsDetailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return 115 * KWIDTH_IPHONE6_SCALE;
    }
    if(indexPath.section == 1){
        return 165 * KWIDTH_IPHONE6_SCALE;
    }
    if(indexPath.section == 2){
        return 180 * KWIDTH_IPHONE6_SCALE;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        if(self.orderLogisticModel){
            self.headView.bottomView.hidden = NO;
            return 148 * KWIDTH_IPHONE6_SCALE;
        }
        else{
            self.headView.bottomView.hidden = YES;
            return 57 * KWIDTH_IPHONE6_SCALE;
        }
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 2){
        return 49;
    }
        return 0.1;
}

#pragma mark - JJGoodsOrderRefundDelegate
- (void)goodsOrderRefundSuccess {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 懒加载lazyLoad
- (JJImmediratePayView *)immediratePayView {
    if(_immediratePayView == nil) {
        _immediratePayView = [JJImmediratePayView immediratePayView];
        @weakify(self);
        _immediratePayView.hidden = YES;
        [[_immediratePayView.immediratePayBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            @strongify(self);
            JJCashierViewController *cashierViewController = [[JJCashierViewController alloc]init];
            cashierViewController.type = 1;
            JJOrderModel *model = [[JJOrderModel alloc]init];
            model.order_num = self.goodsOrderModel.order_num;
            model.total_fee = self.goodsOrderModel.real_fee.floatValue;
            cashierViewController.model = model;
            [self.navigationController pushViewController:cashierViewController animated:YES];
        }];
        [self.view addSubview:_immediratePayView];
        _immediratePayView.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
//        [_immediratePayView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.left.right.equalTo(self.view);
//            make.height.equalTo(@49);
//        }];
    }
    return _immediratePayView;
}
- (JJConfirmReceiveView *)confirmReceiveView {
    if(_confirmReceiveView == nil) {
        _confirmReceiveView = [JJConfirmReceiveView confirmReceiveView];
        _confirmReceiveView.hidden = YES;
        @weakify(self);
        [[_confirmReceiveView.confirmReceiveBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            @strongify(self);
            [self confirmRequest];
        }];
        [self.view addSubview:_confirmReceiveView];
        [_confirmReceiveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.height.equalTo(@49);
        }];
        
    }
    return _confirmReceiveView;
}
- (JJApplyRefundView *)applyReFundView {
    if(_applyReFundView == nil) {
        _applyReFundView = [JJApplyRefundView applyRefundView];
        _applyReFundView.hidden = YES;
        @weakify(self);
        [[_applyReFundView.applyRefundViewBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            @strongify(self);
            JJApplyRefundController *applyRefundController = [[JJApplyRefundController alloc]init];
            applyRefundController.refundDelegate = self;
            applyRefundController.goodsWaitModelArray = self.goodsWaitModelArray;
            applyRefundController.goodsOrderModel = self.goodsOrderModel;
            [self.navigationController pushViewController:applyRefundController animated:YES];
        }];
    
        [self.view addSubview:_applyReFundView];
        [_applyReFundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.height.equalTo(@49);
        }];
        
    }
    return _applyReFundView;
}

- (void)dealloc {

}
@end
