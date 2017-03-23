//
//  JJCashierViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJCashierNoBalanceViewController.h"
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

//明天整登陆为model那一部分,还有吧未登录时一些点击请求改为弹出登陆按钮,看看商品是否收藏是否可用,还有给JS调用OC尝试.有时间改改活动页,还有购物车页的编辑
//typedef NS_ENUM(NSInteger, PaymentType) {
//    PaymentTypeCard = 0,//银联
//    PaymentTypeAlipay,//支付宝
//    PaymentTypeWechat//微信
//
//};

static NSString * const cashierCellIdentifier = @"JJCashierCellIdentifier";

@interface JJCashierNoBalanceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
//确认支付按钮
@property (nonatomic, strong) UIButton *confirmPayBtn;

//当前选中的model
@property (nonatomic, strong) JJCashierModel *currentSelectedModel;

@property (nonatomic, strong) NSMutableArray<JJCashierModel *> *modelArray;



@end

@implementation JJCashierNoBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    [self basicSet];
    
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
    params[@"amount"] = @(self.amountString.floatValue);
    params[@"user_id"] = [User getUserInformation].userId;
    //    [params setObject:@"2" forKey:@"source"];//支付来源 2:iOS
    if (type == PaymentTypeAlipay) {
        [params setObject:@"alipay" forKey:@"channel"];
    } else if (type == PaymentTypeWechat) {
        [params setObject:@"wx" forKey:@"channel"];
    }
    URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_RECHARGE];
        [params setObject:[Util getClientIP] forKey:@"client_ip"];
    [HFNetWork postWithURL:URL params:params success:^(id response) {
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
        //成功返回
        NSDictionary *charge = [response objectForKey:@"charge"];
        [self pingPlusCharge:charge type:type];
        
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger error_Code = [error code];
        DebugLog(@"error_Code = %ld", (long)error_Code);
    }];
    
}

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
                   
                   User *user = [User getUserInformation];
                   user.balance = @(user.balance.floatValue + self.amountString.floatValue).stringValue;
                   [User saveUserInformation:user];
                   
                   JJPaySuccessViewController *paySuccessViewController = [UIStoryboard instantiateInitialViewControllerWithStoryboardName:@"paySuccess"];
                   paySuccessViewController.type = 3;
//                   paySuccessViewController.model = self.model;
                   [self.navigationController pushViewController:paySuccessViewController animated:YES];
               } else {
                   // 支付失败或取消
                   DebugLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                   [self showAlertWithTitle:@"支付失败" message:[error getMsg] cancelTitle:@"确定"];
               }
           }];
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
    cel.model = self.modelArray[indexPath.row];
    
    return cel;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JJCashierHeaderView *cashierHeaderView = [JJCashierHeaderView cashierHeaderView];
    cashierHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 83 * KWIDTH_IPHONE6_SCALE);
    cashierHeaderView.payMoneyLabel.text = [NSString stringWithFormat:@"¥%@", self.amountString];
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
