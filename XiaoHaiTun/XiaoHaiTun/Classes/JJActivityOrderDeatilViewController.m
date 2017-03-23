//
//  JJActivityOrderDeatilViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityOrderDeatilViewController.h"
#import "JJOrderNumberAndPayTypeView.h"
#import "JJActivityOrderGoodsCell.h"
#import "JJActivityOrderCodeCell.h"
#import "JJActivityOrderMessageTableViewCell.h"
#import "JJActivityOrderPayMondyCell.h"
#import "JJImmediratePayView.h"
#import <ReactiveCocoa.h>
#import "JJApplyRefundController.h"
#import "MBProgressHUD+gifHUD.h"
#import "HFNetWork.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "JJActivityOrderCodeAlreadyUseCell.h"
#import "JJCashierViewController.h"
#import "JJOrderModel.h"
#import "NSString+XPKit.h"
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
#import "JJActivityDetailViewController.h"



static NSString *ActivityOrderGoodsCellIdentifier = @"JJActivityOrderGoodsCellIdentifier";
static NSString *ActivityOrderCodeCellIdentifier = @"JJActivityOrderCodeCellIdentifier";
static NSString *ActivityOrderCodeAlreadyUseCellIdentifier = @"JJActivityOrderCodeAlreadyUseCellIdentifier";
static NSString *ActivityOrderMessageTableViewCelllIdentifier = @"JJActivityOrderMessageTableViewCelllIdentifier";
static NSString *ActivityOrderPayMondyCellIdentifier = @"JJActivityOrderPayMondyCellIdentifier";


@interface JJActivityOrderDeatilViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JJImmediratePayView *immediratePayView;
//客服
@property (nonatomic, strong) UIButton *servicePeopleBtn;

//订单的最新模型
@property (nonatomic, strong) JJMyActivityModel *lastNewModel;

@end

@implementation JJActivityOrderDeatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    为什么要在一开始(我的余额界面)(商品订单详情界面)(活动订单详情界面)  就隐藏一个mbProgressHUD:因为推送的时候如果程序处于关闭杀死状态,点击推送会先跳keywindow的rootViewcontroller然后马上跳到该界面,rootViewcontroller中可能在发送请求还没结束
    [MBProgressHUD hideHUD];
    
    // Do any additional setup after loading the view.
    [self initBaseView];
    [self basicSet];
    [self actyvityOrderDetailRequest];
//    self.lastNewModel = [[JJMyActivityModel alloc]init];
//    self.lastNewModel.name = @"去泰山";
//    self.lastNewModel.pic = @"http://h.hiphotos.baidu.com/image/h%3D200/sign=fc55a740f303918fc8d13aca613c264b/9213b07eca80653893a554b393dda144ac3482c7.jpg";
//    self.lastNewModel.category = @"亲子游";
//    self.lastNewModel.price = @"112元";
//    self.lastNewModel.start_time = @"2012年3月";
//    self.lastNewModel.address = @"广东省,上头时";
//    self.lastNewModel.order_num = @"4636576879780";
//    self.lastNewModel.status = self.model.status;
    
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
    
    self.immediratePayView = [JJImmediratePayView immediratePayView];
    self.immediratePayView.hidden = YES;
//    [[self.immediratePayView.immediratePayBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
//        @strongify(self);
//        JJApplyRefundController *applyRefundController = [[JJApplyRefundController alloc]init];
//        [self.navigationController pushViewController:applyRefundController animated:YES];
//    }];
    [self.view addSubview:self.immediratePayView];
    [self.immediratePayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    self.servicePeopleBtn = [[UIButton alloc]init];
    [self.servicePeopleBtn setImage:[UIImage imageNamed:@"Service_People"] forState:UIControlStateNormal];
    [self.view addSubview:self.servicePeopleBtn];
    [self.servicePeopleBtn addTarget:self action:@selector(presentServicePeople) forControlEvents:UIControlEventTouchUpInside];
    [self.servicePeopleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self.immediratePayView.mas_top).with.offset(-10 *KWIDTH_IPHONE6_SCALE);
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

//dismiss返回
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置基本内容
- (void)basicSet {
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self registCell];
    
}

#pragma mark - 活动订单详情请求
- (void)actyvityOrderDetailRequest {
    NSString * actyvityOrderDetailUrl = [NSString stringWithFormat:@"%@%@%@",DEVELOP_BASE_URL, API_ACTIVITY_ORDER_DETAIL,self.model.order_num];
//        NSDictionary * params = @{@"user_id" : [User getUserInformation].userId};
    [HFNetWork getWithURL:actyvityOrderDetailUrl params:nil success:^(id response) {
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
        self.lastNewModel = [JJMyActivityModel mj_objectWithKeyValues:response[@"value"]];
        [self reloadView];

    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

//刷新界面
- (void)reloadView{
    [self.tableView reloadData];
    [self setImmederatePayViewData];
}
//刷新下方支付menu
- (void)setImmederatePayViewData {
    if(self.lastNewModel.status == 0){
        self.immediratePayView.hidden = NO;
        [self.immediratePayView.immediratePayBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [self.immediratePayView.immediratePayBtn addTarget:self action:@selector(pushToCashierViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    if(self.lastNewModel.status == 1){
        self.immediratePayView.hidden = NO;
        [self.immediratePayView.immediratePayBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        [self.immediratePayView.immediratePayBtn addTarget:self action:@selector(requestToRefund) forControlEvents:UIControlEventTouchUpInside];
    }
}

//跳转到收银台  若是等待付款
- (void)pushToCashierViewController {
    JJCashierViewController *cashierViewController = [[JJCashierViewController alloc]init];
    cashierViewController.type = 2;
    JJOrderModel *orderModel = [[JJOrderModel alloc]init];
    orderModel.order_num = self.lastNewModel.order_num;
    orderModel.total_fee = self.lastNewModel.total_fee;
    cashierViewController.model = orderModel;
    [self.navigationController pushViewController:cashierViewController animated:YES];
}

//若是已经付款,则发送退款请求
//退款申请
- (void)requestToRefund {
    NSString * refundURL = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_ORDER_REFUND];
    NSDictionary * params = @{@"order_num" : self.model.order_num};
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
        
        //发出通知让订单列表刷新
        [[NSNotificationCenter defaultCenter]postNotificationName:OrderListRefreshNotification object:nil];
        
        weakSelf(weakself);
        [self showAlertWithTitle:@"成功" message:@"退款申请中" cancelTitle:@"确定" cancelBlock:^{
            [weakself.navigationController popViewControllerAnimated:YES];
            if([self.refundDelegate respondsToSelector:@selector(refundSuccess)]) {
                [self.refundDelegate refundSuccess];
            }
        }];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}



//注册Cell
- (void)registCell{
    //注册活动cell
    [self.tableView registerClass:[JJActivityOrderGoodsCell class] forCellReuseIdentifier:ActivityOrderGoodsCellIdentifier];
    //注册二维码cell
    [self.tableView registerClass:[JJActivityOrderCodeCell class] forCellReuseIdentifier:ActivityOrderCodeCellIdentifier];
    [self.tableView registerClass:[JJActivityOrderCodeAlreadyUseCell class] forCellReuseIdentifier:ActivityOrderCodeAlreadyUseCellIdentifier];
    //注册出发日期Cell
    [self.tableView registerClass:[JJActivityOrderMessageTableViewCell class] forCellReuseIdentifier:ActivityOrderMessageTableViewCelllIdentifier];
    //注册订单金额cell
    [self.tableView registerClass:[JJActivityOrderPayMondyCell class] forCellReuseIdentifier:ActivityOrderPayMondyCellIdentifier];
    
}

#pragma mark - UITableViewDataSource||UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        if(self.lastNewModel.q_code.length == 0){
            return 1;
        }
        return 2;
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
        if(indexPath.row == 0){
            JJActivityOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityOrderGoodsCellIdentifier forIndexPath:indexPath];
            [cell.activityIcon sd_setImageWithURL:[NSURL URLWithString:self.lastNewModel.pic] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
            cell.descriptLabel.text = self.lastNewModel.name;
            cell.addressLabel.text =[NSString stringWithFormat:@"地址:%@", self.lastNewModel.address];
            return cell;
        }
        if(indexPath.row == 1){
            if(self.lastNewModel.is_used ) {
                JJActivityOrderCodeAlreadyUseCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityOrderCodeAlreadyUseCellIdentifier forIndexPath:indexPath];
                [cell.codeIcon sd_setImageWithURL:[NSURL URLWithString:self.lastNewModel.q_code] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
                cell.codeLabel.text = [NSString stringWithFormat:@"验证码:%@已使用",self.lastNewModel.code];
                cell.useTimeLabel.text = [self.lastNewModel.used_time stringChangeToDate:@"yyyy年MM月dd日HH mm已使用"];
                return cell;
            }else{
                JJActivityOrderCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityOrderCodeCellIdentifier forIndexPath:indexPath];
                cell.codeLabel.text = [NSString stringWithFormat:@"验证码:%@",self.lastNewModel.code];
                [cell.codeIcon sd_setImageWithURL:[NSURL URLWithString:self.lastNewModel.q_code] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
//                cell.codeLabel.text = [NSString stringWithFormat:@"验证码:%@",self.lastNewModel.code];
                return cell;

            }
        }
    }
    
    if(indexPath.section == 1){
        JJActivityOrderMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityOrderMessageTableViewCelllIdentifier forIndexPath:indexPath];
        cell.goDateLabel.text = [self.lastNewModel.start_time stringChangeToDate:nil];
        cell.typeLabel.text = self.lastNewModel.category;
        cell.payMoneyLabel.text =[NSString stringWithFormat:@"¥ %@", @(self.lastNewModel.price).stringValue];
        cell.remarkStringLabel.text = self.lastNewModel.note;
        return cell;
    }
    if(indexPath.section == 2){
        JJActivityOrderPayMondyCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityOrderPayMondyCellIdentifier forIndexPath:indexPath];
        cell.actualMoneyLabel.text =[NSString stringWithFormat:@"¥ %@", @(self.lastNewModel.total_fee).stringValue];
        cell.freightMoneyLabel.text =[NSString stringWithFormat:@"¥ %@", @(self.lastNewModel.freight).stringValue];
        cell.favourableMoneyLabel.text =[NSString stringWithFormat:@"¥ %@", @(self.lastNewModel.benefit).stringValue];
        cell.allOrderMoneyLabel.text =[NSString stringWithFormat:@"¥ %@", @(self.lastNewModel.total_fee).stringValue];
        return cell;

    }
    
//    if(indexPath.section == 1) {
//        JJAddressAndOrderRemarkCell * cell =[self.tableView dequeueReusableCellWithIdentifier:AddressAndOrderRemarkCellIdentifier forIndexPath:indexPath];
//        return cell;
//    }
//    if(indexPath.section == 2){
//        JJOrderPayMondyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:OrderPayMondyCellIdentifier forIndexPath:indexPath ];
//        return cell;
//    }
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        JJOrderNumberAndPayTypeView *orderNumberAndPayTypeView = [[JJOrderNumberAndPayTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 57 * KWIDTH_IPHONE6_SCALE)];
        orderNumberAndPayTypeView.ordersNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",self.lastNewModel.order_num];
        switch (self.lastNewModel.status) {
            case JJMyActivityWaitPay:
                orderNumberAndPayTypeView.waitLabel.text = @"等待付款";
                break;
            case JJMyActivitySuccessPay:
                orderNumberAndPayTypeView.waitLabel.text = @"付款成功";
                break;
            case JJMyActivityCancleOrder:
                orderNumberAndPayTypeView.waitLabel.text = @"订单取消";
                break;
            case JJMyActivityApplySuccess:
                orderNumberAndPayTypeView.waitLabel.text = @"报名成功";
                break;
            case JJMyActivityOrderRefoundApplying:
                orderNumberAndPayTypeView.waitLabel.text = @"退款申请中";
                break;
            case JJMyActivityOrderRefounding:
                orderNumberAndPayTypeView.waitLabel.text = @"退款中";
                break;
            case JJMyActivityOrderRefoundSuccess:
                orderNumberAndPayTypeView.waitLabel.text = @"退款成功";
            case JJMyActivityOrderComplete:
                orderNumberAndPayTypeView.waitLabel.text = @"已参加";
                break;
            case JJMyActivityOrderRefoundFail:
                orderNumberAndPayTypeView.waitLabel.text = @"退款失败";
                break;
            case JJMyActivityPayMent:
                orderNumberAndPayTypeView.waitLabel.text = @"支付中";
                break;
            default:
                break;
        }
        weakSelf(weakSelf)
        return orderNumberAndPayTypeView;
        
        //JJOrderNumberAndPayTypeView *orderNumberHeadView = [[JJOrderNumberAndPayTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 57 * KWIDTH_IPHONE6_SCALE)];
        //        return orderNumberHeadView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击活动进入活动详情
    if (indexPath.section == 0 && indexPath.row == 0) {
        JJActivityDetailViewController *activityDetailVC = [[JJActivityDetailViewController alloc]init];
        activityDetailVC.activityID = self.lastNewModel.activity_id;
        [self.navigationController pushViewController:activityDetailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath .row == 0){
            return 130 * KWIDTH_IPHONE6_SCALE;
        }
        if(indexPath.row == 1){
            return 151 * KWIDTH_IPHONE6_SCALE;
        }

    }
    if(indexPath.section == 1){
        return 193 * KWIDTH_IPHONE6_SCALE;
    }
    if(indexPath.section == 2){
        return 128 * KWIDTH_IPHONE6_SCALE;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
                return 57 * KWIDTH_IPHONE6_SCALE;
//        return 148 * KWIDTH_IPHONE6_SCALE;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 2){
        return 49;
    }
    return 0.1;
    
}


@end
