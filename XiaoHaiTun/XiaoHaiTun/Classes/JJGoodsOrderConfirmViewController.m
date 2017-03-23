//
//  JJGoodsOrderConfirmViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJGoodsOrderConfirmViewController.h"
#import "JJOrderGoodsCell.h"
#import "JJStoreTypeView.h"
#import "JJRemarkInputView.h"
#import "UIView+XPKit.h"
#import "UIViewController+KeyboardCorver.h"
#import "JJDefaultAddressCell.h"
#import "JJExpendCell.h"
#import "JJSubmitMenuView.h"
#import <ReactiveCocoa.h>
#import "JJCashierViewController.h"
#import "JJShopCarCellModel.h"
#import "JJGoodsWaitModel.h"
#import "User.h"
#import "MBProgressHUD+gifHUD.h"
#import "JJReceiveAddressModel.h"
#import <MJExtension.h>
#import "JJReceiveAddressViewController.h"

static NSString * const orderGoodsCellIdentifier = @"JJorderGoodsCellIdentifier";
static NSString * const defaultAddressCellIdentifier = @"JJdefaultAddressCellIdentifier";
static NSString * const expendCellIdentifier = @"JJExpendCellIdentifier";

@interface JJGoodsOrderConfirmViewController ()<UITableViewDataSource,UITableViewDelegate,JJChooseAddressModelDelegate>


@property (nonatomic, strong) UITableView *tableView;
//订单备注
@property (nonatomic, strong) JJRemarkInputView *remarkInputView;
//提交订单
@property (nonatomic, strong) JJSubmitMenuView *submitMenuView;
//收货地址模型
@property (nonatomic, strong) JJReceiveAddressModel *receiveAddressModel;



@end

@implementation JJGoodsOrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    [self basicSet];
    //发送收货地址请求
    [self requestWithShippingAddress];
}

//创建视图
- (void)initBaseView {
    @weakify(self);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBA(237, 237, 237, 1);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.submitMenuView = [JJSubmitMenuView submitMenuView];
    [self.view addSubview:self.submitMenuView];
    [self.submitMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    [[self.submitMenuView.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self)
        if(!self.receiveAddressModel){
            [MBProgressHUD showHUDWithDuration:1.0 information:@"请选择或添写收货地址" hudMode:MBProgressHUDModeText];
        }else{
            //下单
            [self applicationFinishedRestoringStateCartOrder];
        }
    }];
    
}

//设置基本内容
- (void)basicSet {
    self.navigationItem.title = @"订单确认";
    self.view.backgroundColor = [UIColor whiteColor];
    self.submitMenuView.allMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2lf",self.allPayMoney];
    [self registCell];
    [self addNotification];
}

#pragma mark 发送收货地址请求,获得默认收货地址
//请求收货地址列表
- (void)requestWithShippingAddress {
    // 发送收货地址请求
   
    NSString * ThemeRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_SHIPPING_ADDRESS];
    
    [HFNetWork getWithURL:ThemeRequesturl params:nil success:^(id response) {
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
        NSArray<JJReceiveAddressModel *> *addressModelArray = [JJReceiveAddressModel mj_objectArrayWithKeyValuesArray:response[@"shippingaddress"]];
        //默认收货地址
        for(JJReceiveAddressModel *addressModel in addressModelArray) {
            if(addressModel.is_default.boolValue == YES) {
                self.receiveAddressModel = addressModel;
                self.receiveAddressModel.isSelected = YES;
                break;
            }
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

#pragma mark - 购物车下单
- (void)applicationFinishedRestoringStateCartOrder {
    NSString * createCartOrderRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_CART_CREAATE_ORDER];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *shopArray = [NSMutableArray array];
    params[@"user_id" ] = [User getUserInformation].userId;
    for(JJShopCarCellModel *shopCartModel in self.selectedModelArray) {
        NSMutableDictionary *shopDict = [NSMutableDictionary dictionary];
        shopDict[@"goods_id"] = shopCartModel.goodsID;
        shopDict[@"goods_sku_id"] = shopCartModel.goods_sku_id;
        shopDict[@"num"] = @(shopCartModel.number);
        [shopArray addObject:shopDict];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:shopArray options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *shopString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    params[@"goods_relateds"] = shopString;
    params[@"address_id"] = self.receiveAddressModel.addressID;
    
    params[@"note"] = self.remarkInputView.inputRemarkTextField.text;
    
    [HFNetWork postWithURL:createCartOrderRequesturl params:params success:^(id response) {
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

        JJCashierViewController * cashierViewController = [[JJCashierViewController alloc]init];
        JJOrderModel *orderModel = [[JJOrderModel alloc]init];
        orderModel.order_num = response[@"order_num"];
        orderModel.total_fee = self.allPayMoney;
        cashierViewController.type = 1;
        cashierViewController.model = orderModel;
        //发出通知购物车刷新
        [[NSNotificationCenter defaultCenter]postNotificationName:ShopCartNotification object:nil];
        [self.navigationController pushViewController:cashierViewController animated:YES];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

//注册Cell
- (void)registCell{
    //注册商品cell
    [self.tableView registerClass:[JJOrderGoodsCell class] forCellReuseIdentifier:orderGoodsCellIdentifier];
    //注册联系人Cell
    [self.tableView registerClass:[JJDefaultAddressCell class] forCellReuseIdentifier: defaultAddressCellIdentifier];
    //注册运费商品总额Cell
    [self.tableView registerClass:[JJExpendCell class] forCellReuseIdentifier:expendCellIdentifier];
}


#pragma mark - UITableViewDataSource||UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.selectedModelArray.count;
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
        JJOrderGoodsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:orderGoodsCellIdentifier forIndexPath:indexPath];
        JJShopCarCellModel *shopCartModel = self.selectedModelArray[indexPath.row];
        JJGoodsWaitModel *goodsModel = [[JJGoodsWaitModel alloc]init];
        goodsModel.goods_id = shopCartModel.goodsID;
        goodsModel.goods_cover = shopCartModel.cover;
        goodsModel.goods_name = shopCartModel.name;
        goodsModel.goods_price = @(shopCartModel.price).stringValue;
        goodsModel.goods_num = shopCartModel.number;
        goodsModel.goods_sku_str = shopCartModel.goods_sku_str;
        cell.model = goodsModel;
        return cell;
    }
    if(indexPath.section == 1) {
        JJDefaultAddressCell * cell =[self.tableView dequeueReusableCellWithIdentifier:defaultAddressCellIdentifier forIndexPath:indexPath];
        
        cell.receiveAddressModel = self.receiveAddressModel;
        return cell;
    }
    if(indexPath.section == 2){
        JJExpendCell *cell = [self.tableView dequeueReusableCellWithIdentifier:expendCellIdentifier forIndexPath:indexPath];
        cell.allOrderMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2lf",self.allPayMoney];
        cell.freightMoneyLabel.text = @"免运费";
        return cell;
    }
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        JJStoreTypeView *storeTypeView = [JJStoreTypeView storeTypeView];
        storeTypeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40 * KWIDTH_IPHONE6_SCALE);
        return storeTypeView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 0){
        JJRemarkInputView *remarkInputView = [JJRemarkInputView remarkInputView];
        self.remarkInputView = remarkInputView;
        return remarkInputView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return 129 * KWIDTH_IPHONE6_SCALE;
    }
    if(indexPath.section == 1){
        return 88 * KWIDTH_IPHONE6_SCALE;
    }
    if(indexPath.section == 2){
        return 70 * KWIDTH_IPHONE6_SCALE;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        //        return 57 * KWIDTH_IPHONE6_SCALE;
        return 40 * KWIDTH_IPHONE6_SCALE;
    }
    if(section == 1) {
        return 10;
    }
    if(section == 2) {
        return 10;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0) {
        return (40 * KWIDTH_IPHONE6_SCALE);
    }
//    if(section == 2){
//        return 49;
//    }
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        JJReceiveAddressViewController *receiveAddressViewController = [[JJReceiveAddressViewController alloc]init];
        receiveAddressViewController.isHideChooseImage = NO;
        receiveAddressViewController.selectedModelId = self.receiveAddressModel.addressID;
        receiveAddressViewController.selecteDelegate = self;
        [self.navigationController pushViewController:receiveAddressViewController animated:YES];
    }
}

#pragma mark - JJChooseAddressDelegate
- (void)chooseAddressModel:(JJReceiveAddressModel *)addressModel {
    self.receiveAddressModel = addressModel;
    self.receiveAddressModel.isSelected = YES;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)dealloc
{
    [self clearNotificationAndGesture];
}

@end
