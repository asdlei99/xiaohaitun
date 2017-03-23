//
//  JJMyActivityViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMyActivityViewController.h"
#import "JJActivityCell.h"
#import "JJMyActivityModel.h"
#import "JJActivityOrderDeatilViewController.h"
#import "USer.h"
#import "HFNetWork.h"
#import "MBProgressHUD+gifHUD.h"
#import <MJExtension.h>
#import "JJTabBarController.h"

static NSString * const ActivityCellIdentifier = @"JJActivityCellIdentifier";

@interface JJMyActivityViewController ()<JJActivityOrderDeatilDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<JJMyActivityModel *> *modelArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JJMyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"我的活动";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBA(238, 238, 238, 1);

    [self.tableView registerClass:[JJActivityCell class] forCellReuseIdentifier:ActivityCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    
    //下拉刷新
    weakSelf(wealSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![Util isNetWorkEnable]) {//先判断网络状态
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            [wealSelf.tableView.mj_header endRefreshing];
            
            [wealSelf.tableView showNoNetWorkWithTryAgainBlock:^{
                [wealSelf.tableView.mj_header beginRefreshing];
            }];
            return ;
        }
         [wealSelf.tableView hideNoNetWork];
        [wealSelf myActyvityOrderListRequest];
        
    }];
    JJMyActivityModel *model1 = [[JJMyActivityModel alloc]init];
    model1.order_num = @"7843782324";
    model1.pic = @"http://pic.58pic.com/58pic/14/10/60/92F58PICR6y_1024.jpg";
    model1.name = @"哈哦啊胡搜啊好好哦啊哦啊好哦啊好";
    model1.address = @"山海-仁川-上海5天";
    model1.status = 0;
    
    JJMyActivityModel *model2 = [[JJMyActivityModel alloc]init];
    model2.order_num = @"7843782324";
    model2.pic = @"http://pic.58pic.com/58pic/14/10/60/92F58PICR6y_1024.jpg";
    model2.name = @"哈哦啊胡搜啊好好哦啊哦哦啊胡搜啊好好哦啊哦啊好哦啊好";
    model2.address = @"山海-仁川-上海5天";
    model2.status = 1;
    
    JJMyActivityModel *model3 = [[JJMyActivityModel alloc]init];
    model3.order_num = @"7843782324";
    model3.pic = @"http://pic.58pic.com/58pic/14/10/60/92F58PICR6y_1024.jpg";
    model3.name = @"哈哦啊胡搜啊好好哦啊哦哦啊胡搜啊好好哦啊哦啊好哦啊好";
    model3.address = @"山海-仁川-上海5天";
    model3.status = 2;
    
    JJMyActivityModel *model4 = [[JJMyActivityModel alloc]init];
    model4.order_num = @"7843782324";
    model4.pic = @"http://pic.58pic.com/58pic/14/10/60/92F58PICR6y_1024.jpg";
    model4.name = @"哈哦啊胡搜啊好好哦啊哦哦啊胡搜啊好好哦啊哦啊好哦啊好";
    model4.address = @"山海-仁川-上海5天";
    model4.status = 3;
    
    JJMyActivityModel *model5 = [[JJMyActivityModel alloc]init];
    model5.order_num = @"7843782324";
    model5.pic = @"http://pic.58pic.com/58pic/14/10/60/92F58PICR6y_1024.jpg";
    model5.name = @"哈哦啊胡搜啊好好哦啊哦哦啊胡搜啊好好哦啊哦啊好哦啊好";
    model5.address = @"山海-仁川-上海5天";
    model5.status = 4;
    
    JJMyActivityModel *model6 = [[JJMyActivityModel alloc]init];
    model6.order_num = @"7843782324";
    model6.pic = @"http://pic.58pic.com/58pic/14/10/60/92F58PICR6y_1024.jpg";
    model6.name = @"哈哦啊胡搜啊好好哦啊哦哦啊胡搜啊好好哦啊哦啊好哦啊好";
    model6.address = @"山海-仁川-上海5天";
    model6.status = 5;
    
    JJMyActivityModel *model7 = [[JJMyActivityModel alloc]init];
    model7.order_num = @"7843782324";
    model7.pic = @"http://pic.58pic.com/58pic/14/10/60/92F58PICR6y_1024.jpg";
    model7.name = @"哈哦啊胡搜啊好好哦啊哦哦啊胡搜啊好好哦啊哦啊好哦啊好";
    model7.address = @"山海-仁川-上海5天";
    model7.status = 6;
    JJMyActivityModel *model8 = [[JJMyActivityModel alloc]init];
    model8.order_num = @"7843782324";
    model8.pic = @"http://pic.58pic.com/58pic/14/10/60/92F58PICR6y_1024.jpg";
    model8.name = @"哈哦啊胡搜啊好好哦啊哦哦啊胡搜啊好好哦啊哦啊好哦啊好";
    model8.address = @"山海-仁川-上海5天";
    model8.status = 7;
//    [self.modelArray addObject:model1];
//    [self.modelArray addObject:model2];
//    [self.modelArray addObject:model3];
//    [self.modelArray addObject:model4];
//    [self.modelArray addObject:model5];
//    [self.modelArray addObject:model6];
//    [self.modelArray addObject:model7];
//    [self.modelArray addObject:model8];
    [self.tableView.mj_header beginRefreshing];
    
    //监听通知刷新tableView
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewHeadBegineRefresh) name:OrderListRefreshNotification object:nil];
}

- (void)tableViewHeadBegineRefresh {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 我的活动列表网络申请
- (void)myActyvityOrderListRequest {
    NSString * deleteCartRequesturl = [NSString stringWithFormat:@"%@%@%@",DEVELOP_BASE_URL, API_ACTIVITY_ORDER_LIST,[User getUserInformation].userId];
//    NSDictionary * params = @{@"user_id" : [User getUserInformation].userId};
    [HFNetWork getWithURL:deleteCartRequesturl params:nil success:^(id response) {
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
        self.modelArray = [JJMyActivityModel mj_objectArrayWithKeyValuesArray:response[@"value"]];
        [self.tableView reloadData];
        if(self.modelArray.count == 0){
            weakSelf(weakSelf);
            [self.tableView showNoDateWithImageName:@"NO_ACTIVITY_ORDER" title:@"您还没有相关活动订单" btnName:@"去逛逛" TryAgainBlock:^{
                [weakSelf gotoActivity];
            }];
            
        }else{
            [self.tableView hideNoDate];
            
        }

        
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        [self.tableView.mj_header endRefreshing];
    }];
}

//前往活动首页
- (void)gotoActivity {
    JJTabBarController *tabbarController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarController setSelectedIndex:1];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJActivityCell *cel = [self.tableView dequeueReusableCellWithIdentifier:ActivityCellIdentifier forIndexPath:indexPath];
//    cel.backgroundColor = RandomColor;
    cel.model = self.modelArray[indexPath.row];
    return cel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 187 * KWIDTH_IPHONE6_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJActivityCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    JJActivityOrderDeatilViewController * activityOrderDeatilViewController = [[JJActivityOrderDeatilViewController alloc]init];
    activityOrderDeatilViewController.refundDelegate = self;
    activityOrderDeatilViewController.model = self.modelArray[indexPath.row];
    [self.navigationController pushViewController:activityOrderDeatilViewController animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (UITableView *)tableView{
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT_64) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - JJActivityOrderDeatilDelegate
- (void)refundSuccess {
    [self.tableView.mj_header beginRefreshing];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
