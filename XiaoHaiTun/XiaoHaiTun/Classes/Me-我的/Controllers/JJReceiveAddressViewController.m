//
//  JJReceiveAddressViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReceiveAddressViewController.h"
#import "JJReceiveAddressCell.h"
#import "JJReceiveAddressModel.h"
#import "JJEditReceiveAddressViewController.h"
#import "JJAddNewReceiveAddressViewController.h"
#import "User.h"
#import "HFNetWork.h"
#import "MBProgressHUD+gifHUD.h"
#import <MJExtension.h>
#import "MJRefresh.h"
#import "UIViewController+Alert.h"
#import "JJTabBarController.h"

static NSString * const ReceiveAddressCellIdentifier = @"JJReceiveAddressCellIdentifier";

@interface JJReceiveAddressViewController ()<UITableViewDataSource,UITableViewDelegate>

//tableView
@property (nonatomic, strong) UITableView *tableView;
//新增地址按钮
@property (nonatomic, strong) UIButton *addAddressBtn;
//地址数组
@property (nonatomic, strong) NSMutableArray<JJReceiveAddressModel *> *modelArray;

//默认选中地址model
@property(nonatomic, strong)JJReceiveAddressModel *defaultModel;

@end

@implementation JJReceiveAddressViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    [self basicSet];
    //请求收货地址列表
    //    [self requestWithShippingAddress];
    [self.tableView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
}

//基本内容设置
- (void)basicSet {
    if (self.isHideChooseImage) {
        self.navigationItem.title = @"管理收货地址";
    } else {
        self.navigationItem.title = @"选择收货地址";
    }
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = RGBA(238, 238, 238, 1);
    [self.tableView registerClass:[JJReceiveAddressCell class] forCellReuseIdentifier:ReceiveAddressCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    //下拉
    weakSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (![Util isNetWorkEnable]) {//先判断网络状态
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView showNoNetWorkWithTryAgainBlock:^{
                [weakSelf.tableView.mj_header beginRefreshing];
            }];
            return ;
        }
        [weakSelf.tableView hideNoNetWork];
        [weakSelf requestWithShippingAddress];
    }];
}

//创建基本视图
- (void)initBaseView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT_64, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT_64 - 45) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
   
    [self.view addSubview:self.tableView];
    
    self.addAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 45)];
    [_addAddressBtn setTitle:@"+ 新增地址" forState:UIControlStateNormal];
    [_addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [_addAddressBtn setBackgroundColor:NORMAL_COLOR ];
    [_addAddressBtn addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addAddressBtn];
}

#pragma mark 发送请求
//请求收货地址列表
- (void)requestWithShippingAddress {
    // 发送收货地址请求
    NSString * ThemeRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_SHIPPING_ADDRESS];
    
    [HFNetWork getWithURL:ThemeRequesturl params:nil success:^(id response) {
        //            self.ThemeRequestSuccess = YES;
        //            if(self.ADViewRequestSuccess == YES) {
        //                //两者都成功则隐藏
        [MBProgressHUD hideHUD];
        //            }
        [self.tableView.mj_header endRefreshing];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        
        self.modelArray = [JJReceiveAddressModel mj_objectArrayWithKeyValuesArray:response[@"shippingaddress"]];
        if(self.modelArray.count == 0){
            weakSelf(weakSelf);
            [self.tableView showNoDateWithImageName:@"NO_ADDRESS" title:@"您还没有收货地址" btnName:@"新增收货地址" TryAgainBlock:^{
                [weakSelf addAddress:nil];
            }];
        }else{
            if(self.selectedModelId.length != 0) {
                for(JJReceiveAddressModel *model in self.modelArray) {
                    if([model.addressID isEqualToString:self.selectedModelId] ) {
                        model.isSelected = YES;
                        break;
                    }
                }
            }
            [self.tableView hideNoDate];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 添加新收货地址
- (void)addAddress:(UIButton *)btn{
    JJAddNewReceiveAddressViewController *newReceiveAddressController = [[JJAddNewReceiveAddressViewController alloc]init];
    //新增收货地址回调
    weakSelf(weakSelf);
    newReceiveAddressController.addBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:newReceiveAddressController animated:YES];
}

#pragma mark - UITableViewDataSource||UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.modelArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJReceiveAddressCell *cel = [self.tableView dequeueReusableCellWithIdentifier:ReceiveAddressCellIdentifier forIndexPath:indexPath];
    cel.chooseImage.hidden = self.isHideChooseImage;
    weakSelf(weakSelf)
    __weak typeof(cel)weakCell = cel;
    cel.deleteCellBlock = ^{
        [weakSelf.modelArray removeObject:weakCell.model];
        [weakSelf.tableView reloadData];
    };
    cel.model = self.modelArray[indexPath.row];

    return cel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112 * KWIDTH_IPHONE6_SCALE;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    weakSelf(weakSelf);
    if([self.selecteDelegate respondsToSelector:@selector(chooseAddressModel:)]) {
        
        [self showAlertWithTitle:@"更换收货地址" message:@"是否要使用该地址为本次订单收货地址" cancelBlock:^{
            
        } certainBlock:^{
            [weakSelf.selecteDelegate chooseAddressModel:self.modelArray[indexPath.row]];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
    }
}

- (void)dealloc {
    DebugLog(@"收货地址销毁");
}

#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

@end
