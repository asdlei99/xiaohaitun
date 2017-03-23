//
//  JJShopCartViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJShopCartViewController.h"
//#import "MXNavigationBarManager.h"
#import "JJShopCarCell.h"
#import "JJShopCarCellModel.h"
#import "JJShopCartPayView.h"
#import "JJShopCartHeadView.h"
#import "JJSettingViewController.h"
#import "UIStoryboard+JJEasyCreate.h"
#import <ReactiveCocoa.h>
#import "JJGoodsOrderConfirmViewController.h"
#import "USer.h"
#import "HFNetWork.h"
#import <MJExtension.h>
#import "MBProgressHUD+gifHUD.h"
#import "JJShopCarCellModel.h"
#import "UIViewController+ModelLogin.h"
#import "MJRefresh.h"
#import "JJNavigationController.h"
#import "JJLoginViewController.h"
#import "UINavigationBar+Awesome.h"
#import "JJTabBarController.h"
#import "JJGoodsDetailViewController.h"

static NSString * const JJShopCarCellIdentifier = @"JJShopCarCellIdentifier";

@interface JJShopCartViewController ()<UITableViewDataSource,UITableViewDelegate>

//tableView
@property (nonatomic, strong) UITableView *tableView;
//结算view
@property (nonatomic, strong) JJShopCartPayView *shopCartPayView;
//头视图
@property (nonatomic, strong) JJShopCartHeadView *headView;

//全部model
@property (nonatomic, strong) NSMutableArray<JJShopCarCellModel *> *modelArray;
//选中的model数组
@property (nonatomic, strong) NSMutableArray<JJShopCarCellModel *> *selectedModelArray;
//批量删除的model数组
@property (nonatomic, strong) NSMutableArray<JJShopCarCellModel *> *selectedToDeleteModelArray;

//总金额
@property (nonatomic, assign) CGFloat countMoney;

//登陆控制器
@property (nonatomic, weak) JJLoginViewController *loginViewController;

//是否已经model出登陆界面
@property(nonatomic,assign)BOOL isAlreadyModelLoginVC;
@end

@implementation JJShopCartViewController

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    if (![User getUserInformation]) {
//        [self modelToLoginVC];
//    }else{
//        [self.tableView.mj_header beginRefreshing];
//    }
//}

//- (void)presentToLoginViewController {
//    JJLoginViewController *loginViewController = [[JJLoginViewController alloc]init];
//    JJNavigationController *loginNavigationViewController = [[JJNavigationController alloc]initWithRootViewController:loginViewController];
//    self.loginViewController = loginViewController;
//    [self presentViewController:loginNavigationViewController animated:YES completion:nil];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:NORMAL_COLOR];
    if (![User getUserInformation] && !self.isAlreadyModelLoginVC ) {
        [self modelToLoginVC];
        self.isAlreadyModelLoginVC = YES;
        return;
    }
    self.isAlreadyModelLoginVC = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAlreadyModelLoginVC = NO;
    [self setupNavigationBar];
    [self initBaseView];
    [self addNotificate];
    if (![User getUserInformation]) {
//        [self modelToLoginVC];
    }else{
    [self.tableView.mj_header beginRefreshing];
    }
    
}

#pragma mark - setupNavigationBar
- (void)setupNavigationBar {
    self.navigationItem.title = @"购物车";
    UIBarButtonItem *editButton= [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtn:)];
        self.navigationItem.rightBarButtonItem =editButton;
//    [MXNavigationBarManager managerWithController:self];
//    [MXNavigationBarManager setBarColor:NORMAL_COLOR];
}

#pragma mark - 基本视图设置
- (void)initBaseView {
    @weakify(self)
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"JJShopCarCell" bundle:nil] forCellReuseIdentifier:JJShopCarCellIdentifier];
    [self.view addSubview:self.shopCartPayView];
    [self.shopCartPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49);
        make.bottom.equalTo(self.view);
    }];

//    [self.shopCartPayView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.tableView);
//        make.height.equalTo(@49);
//    }];
    
    //点击去结算按钮
    [self.shopCartPayView.gotoPayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headView = [JJShopCartHeadView shopCartHeadView];
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.tableView.tableHeaderView =self.headView;
    
    //点击全选按钮操作
     weakSelf(weakSelf)
    self.headView.block = ^(BOOL selected){
        for(JJShopCarCellModel * model in weakSelf.modelArray){
            if(selected == YES){//若是全选
                //先去除全选选上
                [weakSelf.selectedModelArray removeAllObjects];
                [weakSelf.selectedModelArray addObjectsFromArray:weakSelf.modelArray];
                [weakSelf.selectedToDeleteModelArray removeAllObjects];
                [weakSelf.selectedToDeleteModelArray addObjectsFromArray:weakSelf.modelArray];
                
                if(model.selected == NO){
                    weakSelf.shopCartPayView.totalPrice = (model.number * model.price) + weakSelf.shopCartPayView.totalPrice;
                    DebugLog(@"countMoney%lf",self.countMoney);
                }
            }else{//若是全不选
                if(model.selected == YES){
                    //全部去除
                    [weakSelf.selectedModelArray removeAllObjects];
                    [weakSelf.selectedToDeleteModelArray removeAllObjects];
                    weakSelf.shopCartPayView.totalPrice = weakSelf.shopCartPayView.totalPrice - (model.number * model.price) ;
                    DebugLog(@"countMoney%lf",self.countMoney);
                }
            }
            model.selected = selected;
        }
        [weakSelf.tableView reloadData];
    };
    
    //下拉刷新
    weakSelf(wealSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![Util isNetWorkEnable]) {//先判断网络状态
            self.shopCartPayView.hidden = YES;
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            [wealSelf.tableView.mj_header endRefreshing];
            [wealSelf.tableView showNoNetWorkWithTryAgainBlock:^{
                [wealSelf.tableView.mj_header beginRefreshing];
            }];
            return ;
        }
        [wealSelf.tableView hideNoNetWork];
        [wealSelf cartRequest];
    }];
}

#pragma mark - 按钮点击
//结算/删除按钮点击
- (void)btnClick:(UIButton *)btn {
    DebugLog(@"%@",btn.titleLabel.text);
    if([btn.titleLabel.text isEqualToString:@"去结算"]) {
        //执行结算操作
        [self payBtnClick];
    } else {
        //执行删除操作
        [self deleteBtnClick];
    }
}


//点击结算按钮
- (void)payBtnClick {

    if(![User getUserInformation]){
        [self modelToLoginVC];
        self.isAlreadyModelLoginVC = YES;
    }else{
        if(self.selectedModelArray.count == 0) {
            [MBProgressHUD showHUDWithDuration:1.0 information:@"请选择支付商品" hudMode:MBProgressHUDModeText];
        }else{
            JJGoodsOrderConfirmViewController *goodsOrderConfirmViewController =    [[JJGoodsOrderConfirmViewController alloc]init];
            goodsOrderConfirmViewController.selectedModelArray = [self.selectedModelArray copy];
            goodsOrderConfirmViewController.allPayMoney = self.shopCartPayView.totalPrice;
            [self.navigationController pushViewController:goodsOrderConfirmViewController animated:YES];
        }
    }
}


//点击删除按钮
- (void)deleteBtnClick {
    if(![User getUserInformation]){
        [self modelToLoginVC];
        self.isAlreadyModelLoginVC = YES;
    }else{
        if(self.selectedModelArray.count == 0) {
            [MBProgressHUD showHUDWithDuration:1.0 information:@"请选择待删除商品" hudMode:MBProgressHUDModeText];
        }else{
            [self deleteBatchRequest];
        }
    }
}

//点击编辑按钮
- (void)editBtn:(UIBarButtonItem *)item {
    DebugLog(@"%@",item.title);
    item.title = [item.title isEqualToString:@"编辑"]? @"完成" : @"编辑";
    if([item.title isEqualToString:@"编辑"]) {
        //若是结算
        self.shopCartPayView.totalPriceLabel.hidden = NO;
        self.shopCartPayView.totalPriceNameLabel.hidden = NO;
        [self.shopCartPayView.gotoPayBtn setTitle:@"去结算" forState:UIControlStateNormal];
//        [self.shopCartPayView.gotoPayBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        //若是批量删除
        self.shopCartPayView.totalPriceNameLabel.hidden = YES;
        self.shopCartPayView.totalPriceLabel.hidden = YES;
        [self.shopCartPayView.gotoPayBtn setTitle:@"删除" forState:UIControlStateNormal];
//        [self.shopCartPayView.gotoPayBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
}


#pragma mark - 添加通知
- (void)addNotificate {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noTipCartRequest) name:ShopCartNotification object:nil];
}


#pragma mark - UITableViewDataSource & UITableViewDlegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.modelArray.count > 0){
        self.headView.hidden = NO;
        self.shopCartPayView.hidden = NO;
    }else{
        self.headView.hidden = YES;
        self.shopCartPayView.hidden = YES;
    }
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JJShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:JJShopCarCellIdentifier forIndexPath:indexPath];
    if(indexPath.row == self.modelArray.count-1) {
        cell.whiteLineView.hidden = YES;
    }
    
    weakSelf(weakself);
    cell.addMoneyBlock = ^(CGFloat addMoney){
        DebugLog(@"%lf  %lf",addMoney,weakself.shopCartPayView.totalPrice);
        weakself.shopCartPayView.totalPrice = addMoney + weakself.shopCartPayView.totalPrice;
        DebugLog(@"countMoney%lf",self.countMoney);

    };
    cell.reduceMoneyBlock = ^(CGFloat reduceMoney){
        DebugLog(@"%lf  %lf",reduceMoney,weakself.shopCartPayView.totalPrice);
        weakself.shopCartPayView.totalPrice = weakself.shopCartPayView.totalPrice - reduceMoney ;
        DebugLog(@"countMoney%lf",self.countMoney);

    };
    
    __weak typeof(cell)weakcell = cell;
    cell.chooseBtnBlock = ^(BOOL selected) {
        if(selected == NO) {
            //移除
            [weakself.selectedModelArray removeObject:weakcell.model];
            [weakself.selectedToDeleteModelArray removeObject:weakcell.model];
            weakself.headView.allSelectedBtn.selected = NO;
            DebugLog(@"countMoney%lf",self.countMoney);
        }
        if(selected == YES) {
            //添加
            [weakself.selectedModelArray addObject:weakcell.model];
            [weakself.selectedToDeleteModelArray addObject:weakcell.model];
            DebugLog(@"countMoney%lf",self.countMoney);
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.modelArray[indexPath.row];
    //    cel.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    //    cel.contentView.backgroundColor = [UIColor purpleColor];
//    cell.separatorInset = UIEdgeInsetsMake(50, 50, 0, 0);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 123;
}

//加上以下代码支持删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![User getUserInformation]){
        [self modelToLoginVC];
        self.isAlreadyModelLoginVC = YES;
        return ;
    }

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteRequestWithIndexPath:indexPath];
    }
}
//点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJGoodsDetailViewController *goodsDetailViewController = [[JJGoodsDetailViewController alloc]init];
    JJShopCarCellModel *model = self.modelArray[indexPath.row];
    goodsDetailViewController.goodsID = model.goodsID;
    goodsDetailViewController.name = model.name;
    goodsDetailViewController.picture = model.cover;
    //        goodsDetailViewController.is_collect = model.is_collect;
    [self.navigationController pushViewController:goodsDetailViewController animated:YES];
}

#pragma mark - 单个删除请求
- (void)deleteRequestWithIndexPath:(NSIndexPath *)indexPath {
    //发送购物车删除请求
    NSString * deleteCartRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_CART_DELETE];
    JJShopCarCellModel *model = self.modelArray[indexPath.row];
    NSDictionary * params = @{@"user_id" : [User getUserInformation].userId , @"item_id" : model.goodsID};
    [HFNetWork postWithURL:deleteCartRequesturl params:params success:^(id response) {
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
        [MBProgressHUD showHUDWithDuration:1.0 information:@"删除成功" hudMode:MBProgressHUDModeText];
        [self deleteModelAndCellWithIndexPath:indexPath];
        
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

//执行删除工作
- (void)deleteModelAndCellWithIndexPath:(NSIndexPath *)indexPath {
    //将对应的model去除
    JJShopCarCellModel *model = self.modelArray[indexPath.row];
    if(model.selected == YES){
        self.shopCartPayView.totalPrice -= (model.number * model.price);
        DebugLog(@"countMoney%lf",self.countMoney);
    }
    [self.modelArray removeObjectAtIndex:indexPath.row];
    [self.selectedModelArray removeObject:model];
    [self.selectedToDeleteModelArray removeObject:model];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if(self.modelArray.count == 0){
        weakSelf(weakSelf);
        [self.tableView showNoDateWithImageName:@"NO_CART_GOODS" title:@"您的购物车还空着呢,快去挑选商品吧" btnName:@"去逛逛" TryAgainBlock:^{
            [weakSelf gotoGoods];
        }];
        
    }else{
        [self.tableView hideNoDate];
        [self.tableView reloadData];
    }

}

#pragma mark - 多个删除请求
- (void)deleteBatchRequest {
    //发送购物车删除请求
    NSString * deleteCartRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_CART_BATCH_DELETE];
    NSMutableArray *item_list = [NSMutableArray array];
    for (JJShopCarCellModel *model in self.selectedToDeleteModelArray) {
        [item_list addObject:model.goodsID];
    }
    NSDictionary * params = @{@"user_id" : [User getUserInformation].userId , @"item_list" : [Util arrayToJson:item_list]};
    [HFNetWork postWithURL:deleteCartRequesturl params:params success:^(id response) {
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
        [MBProgressHUD showHUDWithDuration:1.0 information:@"删除成功" hudMode:MBProgressHUDModeText];
        [self deleteBatchModelAndCell];
        
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}
//执行删除操作
- (void)deleteBatchModelAndCell {
    //将对应的model去除
    for(JJShopCarCellModel *model in self.selectedToDeleteModelArray) {
        if(model.selected == YES){
            self.shopCartPayView.totalPrice -= (model.number * model.price);
            DebugLog(@"countMoney%lf",self.countMoney);
        }
    }
    [self.modelArray removeObjectsInArray:self.selectedToDeleteModelArray];
    [self.selectedModelArray removeAllObjects];
    [self.selectedToDeleteModelArray removeAllObjects];
    [self.tableView reloadData];
    if(self.modelArray.count == 0){
        weakSelf(weakSelf);
        [self.tableView showNoDateWithImageName:@"NO_CART_GOODS" title:@"您的购物车还空着呢,快去挑选商品吧" btnName:@"去逛逛" TryAgainBlock:^{
            [weakSelf gotoGoods];
        }];
        
    }else{
        [self.tableView hideNoDate];
        
    }

}

#pragma mark - 发起购物车列表网络请求
- (void)cartRequest {
    //发请求前先检查是否登陆
    if(![User getUserInformation]){
        [self modelToLoginVC];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    //发送购物车列表请求
    NSString * cartQueryRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_CART_QUERY];
    NSDictionary *params = nil;
    if([User getUserInformation].userId){
        params = @{@"user_id" : [User getUserInformation].userId};
    }
    [HFNetWork postWithURL:cartQueryRequesturl params:params success:^(id response) {
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
        self.modelArray = [JJShopCarCellModel mj_objectArrayWithKeyValuesArray:response[@"items"]];
        for(JJShopCarCellModel *model in self.modelArray) {
            model.cover = [NSString stringWithFormat:@"%@?imageView2/1/w/192/h/192",model.cover];
        }
        self.headView.allSelectedBtn.selected = NO;
        [self.selectedModelArray removeAllObjects];
        [self.selectedToDeleteModelArray removeAllObjects];
        self.shopCartPayView.totalPrice = 0;
        [self.tableView reloadData];
        if(self.modelArray.count == 0){
            weakSelf(weakSelf);
            [self.tableView showNoDateWithImageName:@"NO_CART_GOODS" title:@"您的购物车还空着呢,快去挑选商品吧" btnName:@"去逛逛" TryAgainBlock:^{
                [weakSelf gotoGoods];
            }];
            
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
#pragma mark - 发起购物车列表网络请求(无提示的,接收到通知时会调用)
- (void)noTipCartRequest {
    [self.modelArray removeAllObjects];
    [self.selectedModelArray removeAllObjects];
    [self.selectedToDeleteModelArray removeAllObjects];
    [self.tableView reloadData];
    
        //发送购物车列表请求
    NSString * cartQueryRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_CART_QUERY];
    NSDictionary *params = nil;
    if([User getUserInformation].userId){
        params = @{@"user_id" : [User getUserInformation].userId};
    }
    [HFNetWork postNoTipWithURL:cartQueryRequesturl params:params success:^(id response) {
        [self.tableView.mj_header endRefreshing];
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
        self.modelArray = [JJShopCarCellModel mj_objectArrayWithKeyValuesArray:response[@"items"]];
        self.headView.allSelectedBtn.selected = NO;
        [self.selectedModelArray removeAllObjects];
        [self.selectedToDeleteModelArray removeAllObjects];
        self.shopCartPayView.totalPrice = 0;
        if(self.modelArray.count == 0){
            weakSelf(weakSelf);
            [self.tableView showNoDateWithImageName:@"NO_CART_GOODS" title:@"您的购物车还空着呢,快去挑选商品吧" btnName:@"去逛逛" TryAgainBlock:^{
                [weakSelf gotoGoods];
            }];
            
        }else{
            [self.tableView hideNoDate];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}


//前往商城首页
- (void)gotoGoods {
    JJTabBarController *tabbarController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarController setSelectedIndex:0];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
    
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT_64, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT_64 - TABAR_HEIGHT_49 ) style:UITableViewStyleGrouped];
//        _tableView.backgroundColor = RandomColor;
//        _tableView.sep
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (JJShopCartPayView *)shopCartPayView {
    if(!_shopCartPayView) {
         DebugLog(@"%lf",self.view.height);
        _shopCartPayView = [JJShopCartPayView shopCartView];
        
//        _shopCartPayView.frame = CGRectMake(0,  SCREEN_HEIGHT - 49-49, SCREEN_WIDTH, 49);
//        [self.view addSubview:_shopCartPayView];
    }
    return _shopCartPayView;
}
- (NSMutableArray *)modelArray{
    if(!_modelArray){
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
- (NSMutableArray *)selectedModelArray{
    if(!_selectedModelArray){
        _selectedModelArray = [NSMutableArray array];
    }
    return _selectedModelArray;
}
- (NSMutableArray *)selectedToDeleteModelArray {
    if(!_selectedToDeleteModelArray) {
        _selectedToDeleteModelArray = [NSMutableArray array];
    }
    return _selectedToDeleteModelArray;
}

- (CGFloat)countMoney {
    _countMoney = 0.0;
    for(JJShopCarCellModel *model in self.selectedModelArray) {
        _countMoney += (model.price * model.number);
    }
    return _countMoney;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
