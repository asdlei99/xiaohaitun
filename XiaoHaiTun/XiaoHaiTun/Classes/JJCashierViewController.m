//
//  JJCashierViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJCashierViewController.h"
#import "JJCashierCell.h"
#import "JJCashierHeaderView.h"
#import "JJCashierModel.h"
#import "JJPaySuccessViewController.h"
#import "UIStoryboard+JJEasyCreate.h"
#import "User.h"
#import "MBProgressHUD+gifHUD.h"
#import "Pingpp.h"
#import "UIViewController+Alert.h"
#import "Util.h"
#import <MJExtension.h>

//明天整登陆为model那一部分,还有吧未登录时一些点击请求改为弹出登陆按钮,看看商品是否收藏是否可用,还有给JS调用OC尝试.有时间改改活动页,还有购物车页的编辑
//typedef NS_ENUM(NSInteger, PaymentType) {
//    PaymentTypeCard = 0,//银联
//    PaymentTypeAlipay,//支付宝
//    PaymentTypeWechat//微信
//    
//};

static NSString * const cashierCellIdentifier = @"JJCashierCellIdentifier";

@interface JJCashierViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
//确认支付按钮
@property (nonatomic, strong) UIButton *confirmPayBtn;

//当前选中的model
@property (nonatomic, strong) JJCashierModel *currentSelectedModel;

@property (nonatomic, strong) NSMutableArray<JJCashierModel *> *modelArray;



@end

@implementation JJCashierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    [self basicSet];
    JJCashierModel *model1 = [[JJCashierModel alloc]init];
    model1.iconName = @"BALANCE_Icon";
    model1.payTypeString = @"余额支付";
    model1.payMessageString =[NSString stringWithFormat:@"账户剩余%@元",[User getUserInformation].balance];
    model1.type = PaymentTypeCard;
    model1.isChoose = NO;
    
    JJCashierModel *model2 = [[JJCashierModel alloc]init];
    model2.iconName = @"Alipay_Icon";
    model2.payTypeString = @"支付宝";
    model2.payMessageString = @"安全快捷,支持银行卡支付";
    model2.type = PaymentTypeAlipay;
    model2.isChoose = NO;
    
    JJCashierModel *model3 = [[JJCashierModel alloc]init];
    model3.iconName = @"WX_Icon";
    model3.payTypeString = @"微信支付";
    model3.payMessageString = @"微信安全支付";
    model3.type = PaymentTypeWechat;
    model3.isChoose = NO;
    
    [self.modelArray addObject:model1];
    [self.modelArray addObject:model2];
    [self.modelArray addObject:model3];
}

//基本内容设置
- (void)basicSet {
    self.navigationItem.title = @"收银台";
    self.tableView.backgroundColor = RGBA(238, 238, 238, 1);
    [self.tableView registerClass:[JJCashierCell class] forCellReuseIdentifier:cashierCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
}

//创建基本视图
- (void)initBaseView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.confirmPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (297 * KWIDTH_IPHONE6_SCALE), SCREEN_WIDTH, 42)];
    [self.confirmPayBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_confirmPayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [_confirmPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [_confirmPayBtn setBackgroundColor:NORMAL_COLOR ];
    [_confirmPayBtn addTarget:self action:@selector(confirmPay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmPayBtn];
}

//确认支付
- (void)confirmPay:(UIButton *)btn {
    if(!self.currentSelectedModel) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请选择一个支付平台" hudMode:MBProgressHUDModeText];
        return ;
    }
    [self requestForCharge:self.currentSelectedModel.type];
}

//申请charseRequest
- (void)requestForCharge:(PaymentType)type {
    
    NSString *URL = nil;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_num"] = self.model.order_num;
    //    [params setObject:@"2" forKey:@"source"];//支付来源 2:iOS
    
    if(self.type == 1) {//商品,购物车支付
        NSLog(@"%@",[Util getClientIP]);
         [params setObject:[Util getClientIP] forKey:@"client_ip"];
        URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_ORDER_CART_PAY_CHARGE];
        if (type == PaymentTypeAlipay) {//阿里支付
            [params setObject:@"alipay" forKey:@"channel"];
        } else if (type == PaymentTypeWechat) {//微信支付
            [params setObject:@"wx" forKey:@"channel"];
        } else if (type == PaymentTypeCard) {//余额支付
            params[@"user_id"] = [User getUserInformation].userId;
        }
       
        
    }
    if(self.type == 2) {//活动支付
        URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_ORDER_PAY_CHARGE];
        if (type == PaymentTypeAlipay) {//阿里支付
            [params setObject:@"alipay" forKey:@"channel"];
        } else if (type == PaymentTypeWechat) {//微信支付
            [params setObject:@"wx" forKey:@"channel"];
        } else if(type == PaymentTypeCard) {//余额支付
//            [params setObject:@"balance" forKey:@"channel"];
            params[@"channel"] = @"balance";
            
            
//            [HFNetWork postWithURL:URL params:params success:^(id response) {
//                NSLog(@"sd%@",response);
//            } fail:^(NSError *error) {
//                
//            }];
            
        }

    }
    [self requestToGetChargeWithURL:URL params:params type:type];
    
}

//申请获得charge
- (void)requestToGetChargeWithURL:(NSString *)url params:(NSDictionary *)params type:(PaymentType)type{
   
    [HFNetWork postWithURL:url params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        if (type == PaymentTypeCard) {
            [[NSNotificationCenter defaultCenter]postNotificationName:OrderListRefreshNotification object:nil];
            [self requestToUserData];
            [self gotoPaySuccessVC];
        }else{
            //成功返回
            NSDictionary *charge = [response objectForKey:@"charge"];
            [self pingPlusCharge:charge type:type];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger error_Code = [error code];
        DebugLog(@"error_Code = %ld", (long)error_Code);
    }];
}

//余额支付成功后发出用户资料请求
- (void)requestToUserData {
    NSString * userDataRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_USER_DATA];
    [HFNetWork getNoTipWithURL:userDataRequesturl params:nil success:^(id response) {
        //        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) {
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            //            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        User *user = [User mj_objectWithKeyValues:response[@"user"]];
        user.token = [User getUserInformation].token;
        [User saveUserInformation:user];
    } fail:^(NSError *error) {
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        //        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}


//调用ping++支付方法
- (void)pingPlusCharge:(NSDictionary *)charge type:(PaymentType)paymentType {
    NSString *urlSchemeStr = nil;
    if (paymentType == PaymentTypeWechat) {
        urlSchemeStr = WeiChatAppId;
    } else if (paymentType == PaymentTypeAlipay) {
        
    } else if (paymentType == PaymentTypeCard) {
        
    }
    weakSelf(weakSelf);
    [Pingpp createPayment:charge
           viewController:weakSelf
             appURLScheme:urlSchemeStr
           withCompletion:^(NSString *result, PingppError *error) {
               if ([result isEqualToString:@"success"]) {
                   // 支付成功
                   DebugLog(@"支付成功");
//                   [self showAlertWithTitle:@"支付成功" message:@"" cancelTitle:@"确定"];
                   [self gotoPaySuccessVC];
                   //发出通知让订单列表页刷新
                   [[NSNotificationCenter defaultCenter]postNotificationName:OrderListRefreshNotification object:nil];
               } else {
                   // 支付失败或取消
                   DebugLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                   [self showAlertWithTitle:@"支付失败" message:[error getMsg] cancelTitle:@"确定"];
               }
           }];
}
//前往支付成功页面
- (void)gotoPaySuccessVC {
    JJPaySuccessViewController *paySuccessViewController = [UIStoryboard instantiateInitialViewControllerWithStoryboardName:@"paySuccess"];
    paySuccessViewController.type = self.type;
    paySuccessViewController.model = self.model;
    [self.navigationController pushViewController:paySuccessViewController animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
#warning Incomplete implementation, return the number of rows
//    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJCashierCell *cel = [self.tableView dequeueReusableCellWithIdentifier:cashierCellIdentifier forIndexPath:indexPath];
//    weakSelf(weakSelf)
//    __weak typeof(cel)weakCell = cel;
//    cel.deleteCellBlock = ^{
//        [weakSelf.modelArray removeObject:cel.model];
//        [weakSelf.tableView reloadData];
//    };
//    cel.model = self.modelArray[indexPath.row];
    
    if((self.model.total_fee > [User getUserInformation].balance.floatValue)  &&  (indexPath.row == 0)) {
        JJCashierModel *model = self.modelArray[indexPath.row];
        model.payMessageString = @"余额不足";
        cel.userInteractionEnabled = NO;
    }
    cel.model = self.modelArray[indexPath.row];
    return cel;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JJCashierHeaderView *cashierHeaderView = [JJCashierHeaderView cashierHeaderView];
    cashierHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 83 * KWIDTH_IPHONE6_SCALE);
    cashierHeaderView.payMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf", self.model.total_fee];
    return cashierHeaderView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (83 * KWIDTH_IPHONE6_SCALE);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentSelectedModel.isChoose = NO;
    self.currentSelectedModel = self.modelArray[indexPath.row];
    self.currentSelectedModel.isChoose = YES;
}

#pragma mark - 懒加载

- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}


@end
