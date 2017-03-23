//
//  JJNearActivityViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJNearActivityViewController.h"
#import "JJActivityTableViewCell.h"
#import "JJActivityDetailViewController.h"
#import "HFNetWork.h"
#import "MBProgressHUD+gifHUD.h"
#import <MJExtension.h>
#import "JJActivityTableViewCellModel.h"
#import <MJExtension.h>
#import <CoreLocation/CoreLocation.h>

//背景滑动scrollerView高度
#define SCROLL_HEIGHT (SCREEN_HEIGHT - PAGER_HEAD_HEIGHT - NAVIGATION_HEIGHT_64 - TABAR_HEIGHT_49)

#define headerViewHeight (180 * KWIDTH_IPHONE6_SCALE +  PAGER_HEAD_HEIGHT )


static NSString * const activityCellIdentifier = @"activityCellIdentifier";

@interface JJNearActivityViewController ()

//模型数组
@property (nonatomic, strong) NSMutableArray<JJActivityTableViewCellModel *> *modelArray;
//无网络提示
@property (nonatomic, strong) UIView *notLocationView;
//无数据提示
@property (nonatomic, strong) UIView *notDataNitificatView;


//用户是否允许定位
@property(nonatomic,assign)BOOL isEnableLocate;
//用户当前位置
@property (nonatomic, strong) CLLocation *location;
//最新
@property(nonatomic,assign)NSInteger currentPage;
@end


@implementation JJNearActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
//    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,headerViewHeight )];
//    headerView.backgroundColor = [UIColor redColor];
    headerView.alpha = 0.3;
    self.tableView.tableHeaderView =headerView;
    self.tableView.tableFooterView = [UIView new];
    //注册
    [self.tableView registerClass:[JJActivityTableViewCell class] forCellReuseIdentifier:activityCellIdentifier];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotification:) name:LocationNotificatiion object:nil];
    DebugLog(@"size:%@",NSStringFromCGSize( self.tableView.contentSize));
    weakSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![Util isNetWorkEnable]) {//先判断网络状态
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            [weakSelf.tableView.mj_header endRefreshing];
            weakSelf(weakSelf);
            [self.parentViewController.view showNoNetWorkWithTryAgainBlock:^{
                [weakSelf.tableView.mj_header beginRefreshing];
            }];

            return ;
        }
        [self.parentViewController.view hideNoNetWork];
        if(weakSelf.isEnableLocate){
            self.currentPage = 1;
            [weakSelf requestWithRefreshHaveMBProgressHUDActivityWithLocation:weakSelf.location];
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (![Util isNetWorkEnable]) {//先判断网络状态
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        if(weakSelf.isEnableLocate){
            weakSelf.currentPage++;
            [weakSelf moreRequestWithRefreshHaveMBProgressHUDActivityWithLocation:weakSelf.location];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
//    MJRefreshAutoNormalFooter *mjFooter = self.tableView.mj_footer;
//    [mjFooter setTitle:@"" forState:MJRefreshStateIdle];
    
}
//接收到通知后做的处理
- (void)receiveNotification:(NSNotification *)notification
{
    NSDictionary* userInfo=notification.userInfo;
    if(userInfo == nil) {
        self.notLocationView.hidden = NO;
        self.modelArray = nil;
        [self.tableView reloadData];
        self.isEnableLocate = NO;
    }else{
        [self requestWithActivityWithLocation:userInfo[@"location"]];
        self.location = userInfo[@"location"];
        self.notLocationView.hidden = YES;
        self.isEnableLocate = YES;
    }
}

//发起附近活动网络请求(无MBProgress)
- (void)requestWithActivityWithLocation:(CLLocation *)location {
    //发送活动列表请求
    NSString * activityRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_HOME_ACTIVITY];
    NSDictionary * goodsparams = @{@"pageSize":@"10", @"page":@(self.currentPage) , @"lat" : @(location.coordinate.latitude).stringValue , @"lng" : @(location.coordinate.longitude).stringValue};
    [HFNetWork postNoTipWithURL:activityRequesturl params:goodsparams success:^(id response) {
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        self.modelArray = [JJActivityTableViewCellModel mj_objectArrayWithKeyValuesArray:response[@"activitys"]];
        for(JJActivityTableViewCellModel *model in self.modelArray) {
            model.picture = [NSString stringWithFormat:@"%@?imageView2/1/w/1000/h/500",model.picture];
        }
        [self.tableView reloadData];
        if (self.modelArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.modelArray.count == 0) {
            self.notDataNitificatView.hidden = NO;
        }else{
            self.notDataNitificatView.hidden = YES;
        }
    } fail:^(NSError *error) {
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}
//发起附近活动网络请求(有MBProgress)
- (void)requestWithRefreshHaveMBProgressHUDActivityWithLocation:(CLLocation *)location {
    //发送活动列表请求
    
    NSString * activityRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_HOME_ACTIVITY];
    NSDictionary * goodsparams = @{@"pageSize":@"10", @"page":@(self.currentPage) , @"lat" : @(location.coordinate.latitude).stringValue , @"lng" : @(location.coordinate.longitude).stringValue};
    [HFNetWork postWithURL:activityRequesturl params:goodsparams success:^(id response) {
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
        self.modelArray = [JJActivityTableViewCellModel mj_objectArrayWithKeyValuesArray:response[@"activitys"]];
        for(JJActivityTableViewCellModel *model in self.modelArray) {
            model.picture = [NSString stringWithFormat:@"%@?imageView2/1/w/1000/h/500",model.picture];
        }
        if (self.modelArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {
         [self.tableView.mj_header endRefreshing];
                [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

//上拉加载更多
- (void)moreRequestWithRefreshHaveMBProgressHUDActivityWithLocation:(CLLocation *)location {
    //发送活动列表请求
   
    NSString * activityRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_HOME_ACTIVITY];
    NSDictionary * goodsparams = @{@"pageSize":@"10", @"page":@(self.currentPage) , @"lat" : @(location.coordinate.latitude).stringValue , @"lng" : @(location.coordinate.longitude).stringValue};
    [HFNetWork postWithURL:activityRequesturl params:goodsparams success:^(id response) {
        
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            [self.tableView.mj_footer endRefreshing];
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        NSArray<JJActivityTableViewCellModel *> *array =[JJActivityTableViewCellModel mj_objectArrayWithKeyValuesArray:response[@"activitys"]];
        for(JJActivityTableViewCellModel *model in array) {
            model.picture = [NSString stringWithFormat:@"%@?imageView2/1/w/710/h/430",model.picture];
        }
        if (array.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.modelArray addObjectsFromArray:array];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        self.currentPage--;
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}


- (void)refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    });
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DebugLog(@"%ld",self.modelArray.count);
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCellIdentifier forIndexPath:indexPath];
    cell.distanceImageView.hidden = NO;
    cell.distanceLabel.hidden = NO;
    cell.descriptLabel.text = [NSString stringWithFormat:@"near %ld",indexPath.row];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (SCREEN_WIDTH - 20) * (37.0 / 71) + 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJActivityDetailViewController *activityDetailViewController = [[JJActivityDetailViewController alloc]init];
    JJActivityTableViewCellModel *model = self.modelArray[indexPath.row];
    activityDetailViewController.activityID = model.activityID;
    [self.navigationController pushViewController:activityDetailViewController animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if([self.nearDelegate respondsToSelector:@selector(nearActivityViewControllerscrollViewWillBeginDragging:)]){
        [self.nearDelegate nearActivityViewControllerscrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([self.nearDelegate respondsToSelector:@selector(nearActivityViewControllerscrollViewDidScroll:)]){
        [self.nearDelegate nearActivityViewControllerscrollViewDidScroll:self.tableView];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([self.nearDelegate respondsToSelector:@selector(nearActivityViewControllerscrollViewDidEndDecelerating:)]) {
        [self.nearDelegate nearActivityViewControllerscrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([self.nearDelegate respondsToSelector:@selector(nearActivityViewControllerscrollViewDidEndDragging:willDecelerate:)]) {
        [self.nearDelegate nearActivityViewControllerscrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


- (void)viewDidLayoutSubviews {
    CGFloat contextSizeHeight = self.tableView.contentSize.height;
    if(contextSizeHeight < (SCROLL_HEIGHT + headerViewHeight)) {
        self.tableView.contentSize = CGSizeMake(0, (SCROLL_HEIGHT + headerViewHeight));
    }
    
}

- (UIView *)notLocationView {
    if(!_notLocationView) {
        _notLocationView = [[UIView alloc]initWithFrame:CGRectMake(0, headerViewHeight, SCREEN_WIDTH, SCROLL_HEIGHT)];
        _notLocationView.backgroundColor = [UIColor whiteColor];
        [self.tableView addSubview:_notLocationView];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4, 10, SCREEN_WIDTH /2 , SCREEN_WIDTH / 2)];
        [_notLocationView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"common_empty_data"];
        imageView.hidden = YES;
        UILabel *label = [[UILabel alloc]init];
        label.text = @"您未开启定位服务，该功能不可用，请在‘设置’-‘隐私’-‘定位服务’中开启。";
        label.numberOfLines = 0;
        label.contentMode = UIViewContentModeCenter;
        [_notLocationView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).with.offset(10);
            make.left.equalTo(_notLocationView).with.offset(30);
            make.right.equalTo(_notLocationView).with.offset(-30);
        }];
    }
    return _notLocationView;
}

//无数据时
- (UIView *)notDataNitificatView {
    if (!_notDataNitificatView) {
        _notDataNitificatView = [[UIView alloc]initWithFrame:CGRectMake(0, headerViewHeight, SCREEN_WIDTH, SCROLL_HEIGHT)];
        [self.tableView addSubview:_notDataNitificatView];
        _notDataNitificatView.backgroundColor = RGBA(238, 238, 238, 1);
        UIImageView *noInternetImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NO_CART_GOODS"]];
        [_notDataNitificatView addSubview:noInternetImageView];
        [noInternetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(160 * KWIDTH_IPHONE6_SCALE));
            make.centerX.equalTo(_notDataNitificatView.mas_centerX);
            make.top.equalTo(_notDataNitificatView).with.offset(128 * KWIDTH_IPHONE6_SCALE);
        }];
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.font = [UIFont systemFontOfSize:14];
        tipLabel.textColor = RGBA(53, 53, 53, 1);
        tipLabel.text = @"暂无数据";
        [_notDataNitificatView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_notDataNitificatView);
            make.top.equalTo(noInternetImageView.mas_bottom).with.offset(26 *KWIDTH_IPHONE6_SCALE);
        }];
    }
    return _notDataNitificatView;
}


#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
@end
