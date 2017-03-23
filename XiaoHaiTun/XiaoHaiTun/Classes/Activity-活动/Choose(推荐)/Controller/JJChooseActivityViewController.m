//
//  JJChooseActivityViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJChooseActivityViewController.h"
#import "MJRefresh.h"
#import "JJActivityTableViewCell.h"
#import "JJActivityDetailViewController.h"
#import "HFNetWork.h"
#import "MBProgressHUD+gifHUD.h"
#import <MJExtension.h>
#import "JJActivityTableViewCellModel.h"
#import "JJActivityChooseADViewModel.h"

#define headerViewHeight (180 * KWIDTH_IPHONE6_SCALE +  PAGER_HEAD_HEIGHT)

static NSString * const activityCellIdentifier = @"activityCellIdentifier";

@interface JJChooseActivityViewController ()

//模型数组
@property (nonatomic, strong) NSMutableArray<JJActivityTableViewCellModel *> *cellmodelArray;
//轮播图模型数组
@property (nonatomic, strong)NSArray<JJActivityChooseADViewModel *> *activityADViewArray;
//3个接口成功的个数
@property(nonatomic,assign)NSInteger successCount;
@property(nonatomic,assign)NSInteger currentPage;
@end


@implementation JJChooseActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
//    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,headerViewHeight)];
//    headerView.backgroundColor = [UIColor redColor];
    headerView.alpha = 0.3;
    self.tableView.tableHeaderView =headerView;
    //注册
    [self.tableView registerClass:[JJActivityTableViewCell class] forCellReuseIdentifier:activityCellIdentifier];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求
        [self allRequest];
    }];
    weakSelf(weakSelf);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (![Util isNetWorkEnable]) {//先判断网络状态
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        self.currentPage++;
        [self moreRequestWithActivity];
    }];
//    MJRefreshAutoNormalFooter *mjFooter = self.tableView.mj_footer;
//    [mjFooter setTitle:@"" forState:MJRefreshStateIdle];
    //发起请求
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 网络请求
- (void)allRequest {
    
    weakSelf(weakSelf);
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf(weakSelf);
        [self.parentViewController.view showNoNetWorkWithTryAgainBlock:^{
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
        return ;
    }
    self.currentPage = 1;
    [self.parentViewController.view hideNoNetWork];
    [self ADViewRequest];
    [self requestWithActivity];
}

- (void)ADViewRequest {
    //发送轮播请求
    NSString * ADViewRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_HOME_CAROUSEL];
    NSDictionary *params = nil;
    params = @{@"project_type" : @"2" };
    [HFNetWork postNoTipWithURL:ADViewRequesturl params:params success:^(id response) {
        if (![response isKindOfClass:[NSDictionary class]]) {
            [MBProgressHUD hideHUD];
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            [MBProgressHUD hideHUD];
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        NSArray<JJActivityChooseADViewModel *> *modelArray = [JJActivityChooseADViewModel mj_objectArrayWithKeyValuesArray:response[@"carousel"]];
        for(JJActivityChooseADViewModel *adModel in modelArray) {
            adModel.picture = [NSString stringWithFormat:@"%@?imageView2/1/w/1000/h/480",adModel.picture];
        }
//        NSInteger i = arc4random()%3;
//        if(i == 1){
        self.activityADViewArray = modelArray;
//        }else{
//            JJActivityChooseADViewModel *model1 = [[JJActivityChooseADViewModel alloc]init];
//            model1.picture  = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1869402809,2463293159&fm=116&gp=0.jpg";
//            JJActivityChooseADViewModel *model2 = [[JJActivityChooseADViewModel alloc]init];
//            model1.picture  = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1140181115,3778349029&fm=116&gp=0.jpg";
//            self.activityADViewArray = @[model1,model2];
//        }
        self.successCount += 1;
        if(self.successCount == 2) {
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
            if([self.chooseDelegate respondsToSelector:@selector(chooseActivityViewControllerSendRequestAndResultModelArray:)]) {
                [self.chooseDelegate chooseActivityViewControllerSendRequestAndResultModelArray:self.activityADViewArray];
            }
            [self.tableView.mj_header endRefreshing];
            self.successCount = 0;
        }
/*
        
        [self.adView setDataArray:modelArray];
        if(modelArray.count <= 1) {
            [self.adView.pageControl setHidden:YES];
            return;
        }
        [self.adView setUserInteractionEnabled:YES];
        [self.adView perform];
 */
        
    } fail:^(NSError *error) {
        [HFNetWork cancelAllRequest];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        [self.tableView.mj_header endRefreshing];
        self.successCount = 0;
    }];

}

//发起推荐活动网络请求
- (void)requestWithActivity {
    //发送活动列表请求
    NSString * activityRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_HOME_ACTIVITY];
    NSDictionary * goodsparams = @{@"pageSize":@"10", @"page":@"1"};
    [HFNetWork postNoTipWithURL:activityRequesturl params:goodsparams success:^(id response) {
        if (![response isKindOfClass:[NSDictionary class]]) {
                        [MBProgressHUD hideHUD];
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
                        [MBProgressHUD hideHUD];
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        self.cellmodelArray = [JJActivityTableViewCellModel mj_objectArrayWithKeyValuesArray:response[@"activitys"]];
        for(JJActivityTableViewCellModel *model in self.cellmodelArray) {
            model.cover = [NSString stringWithFormat:@"%@?imageView2/1/w/1000/h/500",model.cover];
        }
        if(self.cellmodelArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }

        self.successCount += 1;
        if(self.successCount == 2) {
            //            NSLog(@"成功成功成功成功成功成功成功成功成功成功成功成功成功成功成功成功成功了");
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
            if([self.chooseDelegate respondsToSelector:@selector(chooseActivityViewControllerSendRequestAndResultModelArray:)]) {
                [self.chooseDelegate chooseActivityViewControllerSendRequestAndResultModelArray:self.activityADViewArray];
            }
            [self.tableView.mj_header endRefreshing];
            self.successCount = 0;
        }
    } fail:^(NSError *error) {
        [HFNetWork cancelAllRequest];
                [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        [self.tableView.mj_header endRefreshing];
        self.successCount = 0;
    }];
}

//上拉加载更多
- (void)moreRequestWithActivity {
    //发送活动列表请求
    NSString * activityRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_HOME_ACTIVITY];
    NSDictionary * goodsparams = @{@"pageSize":@"10", @"page":@(self.currentPage)};
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
        NSArray *modelArray =[JJActivityTableViewCellModel mj_objectArrayWithKeyValuesArray:response[@"activitys"]];
        for(JJActivityTableViewCellModel *model in modelArray) {
            model.picture = [NSString stringWithFormat:@"%@?imageView2/1/w/1000/h/500",model.picture];
        }
        if (modelArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.cellmodelArray addObjectsFromArray:modelArray];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        self.currentPage--;
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        [self.tableView.mj_footer endRefreshing];
        
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
    return self.cellmodelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    JJActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCellIdentifier forIndexPath:indexPath];
    cell.descriptLabel.text = [NSString stringWithFormat:@"Choose %ld",indexPath.row];
    
    cell.model = self.cellmodelArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJActivityDetailViewController *activityDetailViewController = [[JJActivityDetailViewController alloc]init];
    JJActivityTableViewCellModel *model = self.cellmodelArray[indexPath.row];
    activityDetailViewController.activityID = model.activityID;
    [self.navigationController pushViewController:activityDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (SCREEN_WIDTH - 20) * (37.0 / 71) + 48;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if([self.chooseDelegate respondsToSelector:@selector(chooseActivityViewControllerscrollViewWillBeginDragging:)]){
        [self.chooseDelegate chooseActivityViewControllerscrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([self.chooseDelegate respondsToSelector:@selector(chooseActivityViewControllerscrollViewDidScroll:)]){
        [self.chooseDelegate chooseActivityViewControllerscrollViewDidScroll:scrollView];
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([self.chooseDelegate respondsToSelector:@selector(chooseActivityViewControllerscrollViewDidEndDecelerating:)]) {
        [self.chooseDelegate chooseActivityViewControllerscrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([self.chooseDelegate respondsToSelector:@selector(chooseActivityViewControllerscrollViewDidEndDragging:willDecelerate:)]) {
        [self.chooseDelegate chooseActivityViewControllerscrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
#pragma mark 懒加载
- (NSMutableArray *)cellmodelArray {
    if(!_cellmodelArray) {
        _cellmodelArray = [NSMutableArray array];
    }
    return _cellmodelArray;
}
@end
