//
//  JJApplyRefundController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJApplyRefundController.h"
#import "JJOrderGoodsCell.h"
#import "JJOrderNumberAndPayTypeView.h"
#import "JJApplyRefundCell.h"
#import "JJGoodsOrderModel.h"
#import "JJGoodsWaitModel.h"
#import "MBProgressHUD+gifHUD.h"
#import "UIViewController+Alert.h"

static NSString *OrderGoodsCellIdentifier = @"JJOrderGoodsCellIdentifier";
static NSString *ApplyRefundCellIdentifier = @"JJApplyRefundCellIdentifier";


@interface JJApplyRefundController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JJApplyRefundController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBaseView];
    [self basicSet];
}

//创建视图
- (void)initBaseView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}

//设置基本内容
- (void)basicSet {
    self.navigationItem.title = @"申请退款";
    self.view.backgroundColor = [UIColor whiteColor];
    [self registCell];
}
//注册Cell
- (void)registCell{
    //注册商品cell
    [self.tableView registerClass:[JJOrderGoodsCell class] forCellReuseIdentifier:OrderGoodsCellIdentifier];
    //注册下方提交按钮Cell
    [self.tableView registerClass:[JJApplyRefundCell class] forCellReuseIdentifier:ApplyRefundCellIdentifier];
}

#pragma mark - UITableViewDataSource||UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.goodsWaitModelArray.count;
    }
    if(section == 1){
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
        JJApplyRefundCell * cell =[self.tableView dequeueReusableCellWithIdentifier:ApplyRefundCellIdentifier forIndexPath:indexPath];
        [cell.submitBtn addTarget:self action:@selector(requestToRefund) forControlEvents:UIControlEventTouchUpInside];
        cell.goodsOrderModel = self.goodsOrderModel;
        
        return cell;
    }
    return nil;
}

//退款申请
- (void)requestToRefund {
    NSString * refundURL = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_ORDER_REFUND];
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
        
        //发出通知让订单列表页刷新
        [[NSNotificationCenter defaultCenter]postNotificationName:OrderListRefreshNotification object:nil];
        
        weakSelf(weakself);
        [self showAlertWithTitle:@"成功" message:@"退款申请中" cancelTitle:@"确定" cancelBlock:^{
            [weakself.navigationController popViewControllerAnimated:YES];
            if([self.refundDelegate respondsToSelector:@selector(goodsOrderRefundSuccess)]) {
                [self.refundDelegate goodsOrderRefundSuccess];
            }
            
        }];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        JJOrderNumberAndPayTypeView *orderNumberAndPayTypeView = [[JJOrderNumberAndPayTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 57 * KWIDTH_IPHONE6_SCALE)];
        orderNumberAndPayTypeView.ordersNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",self.goodsOrderModel.order_num];
        switch (self.goodsOrderModel.status) {
            case 0:
                orderNumberAndPayTypeView.waitLabel.text = @"待下单";
                break;
            case 1:
                orderNumberAndPayTypeView.waitLabel.text = @"付款成功";
                break;
            case 2:
                orderNumberAndPayTypeView.waitLabel.text = @"订单取消";
                break;
            case 3:
                orderNumberAndPayTypeView.waitLabel.text = @"待发货";
                break;
            case 4:
                orderNumberAndPayTypeView.waitLabel.text = @"配送中";
                break;
            case 5:
                orderNumberAndPayTypeView.waitLabel.text = @"已完成";
                break;
            case 6:
                orderNumberAndPayTypeView.waitLabel.text = @"退款申请中";
                break;
            case 7:
                orderNumberAndPayTypeView.waitLabel.text = @"退款中";
                break;
            case 8:
                orderNumberAndPayTypeView.waitLabel.text = @"退款成功";
                break;
            case 9:
                orderNumberAndPayTypeView.waitLabel.text = @"等待付款";
                break;
            default:
                break;

        }
        return orderNumberAndPayTypeView;
        //JJOrderNumberAndPayTypeView *orderNumberHeadView = [[JJOrderNumberAndPayTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 57 * KWIDTH_IPHONE6_SCALE)];
        //        return orderNumberHeadView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return 115 * KWIDTH_IPHONE6_SCALE;
    }
    if(indexPath.section == 1){
        return 290 * KWIDTH_IPHONE6_SCALE;
    }
  
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 57 * KWIDTH_IPHONE6_SCALE;

    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
    
}



@end
