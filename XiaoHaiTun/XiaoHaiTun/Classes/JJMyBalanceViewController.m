//
//  JJMyBalanceViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMyBalanceViewController.h"
#import "JJMyBalanceCell.h"
#import "JJMyBalanceHeadView.h"
#import "JJCashierNoBalanceViewController.h"
#import "JJMyBalanceModel.h"
#import "UIViewController+ModelLogin.h"
#import "User.h"
#import <MJExtension.h>
#import "MBProgressHUD+gifHUD.h"

static NSString * const MyBalanceCellIdentifier = @"MyBalanceCellIdentifier";

@interface JJMyBalanceViewController ()<JJMyBalanceModelDelegate>

@property (nonatomic, strong) NSArray<JJMyBalanceModel *> *modelArray;


@end

@implementation JJMyBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    为什么要在一开始(我的余额界面)(商品订单详情界面)(活动订单详情界面)  就隐藏一个mbProgressHUD:因为推送的时候如果程序处于关闭杀死状态,点击推送会先跳keywindow的rootViewcontroller然后马上跳到该界面,rootViewcontroller中可能在发送请求还没结束
    [MBProgressHUD hideHUD];
    
    NSString *balance = self.balance;
    self.navigationItem.title = @"我的余额";
//    //如果是modal出来的
//    if(![self isPushWayAppear]) {
//        // 只要覆盖了返回按钮, 系统自带的拖拽返回上一级的功能就会失效
//        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Nav_Back_White"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//        
//
//    }

    [self.tableView registerClass:[JJMyBalanceCell class] forCellReuseIdentifier:MyBalanceCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    JJMyBalanceModel *model0 = [[JJMyBalanceModel alloc]init];
    model0.rechargeMoney = @"0.1";
    model0.rechargeDetail = @"充值1000元送200元";
    JJMyBalanceModel *model1 = [[JJMyBalanceModel alloc]init];
    model1.rechargeMoney = @"500";
    model1.rechargeDetail = @"";
    JJMyBalanceModel *model2 = [[JJMyBalanceModel alloc]init];
    model2.rechargeMoney = @"1000";
    model2.rechargeDetail = @"";
    JJMyBalanceModel *model3 = [[JJMyBalanceModel alloc]init];
    model3.rechargeMoney = @"2000";
    model3.rechargeDetail = @"";
    JJMyBalanceModel *model4 = [[JJMyBalanceModel alloc]init];
    model4.rechargeMoney = @"5000";
    model4.rechargeDetail = @"";
    self.modelArray = @[model1,model2,model3,model4];
    [self requestToUserData];
}

- (void)requestToUserData {
    NSString * userDataRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_USER_DATA];
    [HFNetWork getWithURL:userDataRequesturl params:nil success:^(id response) {
        [MBProgressHUD hideHUD];
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
        self.balance = user.balance;
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
                [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

//dismiss返回
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)basicSet {
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"交易明细" style:UIBarButtonItemStylePlain target:self action:@selector(tradeMessage:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)tradeMessage:(UIButton *)btn {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JJMyBalanceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyBalanceCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate =self;
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JJMyBalanceHeadView *headView = [[JJMyBalanceHeadView alloc]init];
    headView.balance = self.balance;
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 160 * KWIDTH_IPHONE6_SCALE);
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 160 * KWIDTH_IPHONE6_SCALE;
}



#pragma mark - JJMyBalanceModelDelegate
- (void)rechargeBtnClickWithMoney:(NSString *)money {
    JJCashierNoBalanceViewController *cashierVC = [[JJCashierNoBalanceViewController alloc]init];
    cashierVC.amountString = money;
    [self.navigationController pushViewController:cashierVC animated:YES];
}
@end
