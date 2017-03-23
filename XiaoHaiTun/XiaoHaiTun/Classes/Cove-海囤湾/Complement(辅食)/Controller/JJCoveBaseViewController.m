//
//  JJRecommendViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJCoveBaseViewController.h"
#import "MBProgressHUD+gifHUD.h"
#import "JJScrollHeaderView.h"
#import "JJGoodsDetailViewController.h"
#import "JJRecommendSection1Cell.h"
#import "JJRecommendSection1HeadView.h"
#import "JJRecommendSection0Cell.h"
#import "JJRecommendSection1Model.h"
#import "HFNetWork.h"
#import <MJExtension.h>

#define collectionViewSpace (15 * KWIDTH_IPHONE6_SCALE)


static NSString* collectionViewCellIndentifierSection1 = @"JJCollectionViewCellSection1";

@interface JJCoveBaseViewController()<UICollectionViewDelegateFlowLayout>

//模型数组
@property (nonatomic, strong) NSMutableArray<JJRecommendSection1Model *> *homeGoodsArray;
//新的
@property(nonatomic,assign)NSInteger currentPage;

@end

@implementation JJCoveBaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.sortModel.name;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.currentPage = 1;
    weakSelf(weakSelf);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![Util isNetWorkEnable]) {//先判断网络状态
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView showNoNetWorkWithTryAgainBlock:^{
                [weakSelf.collectionView.mj_header beginRefreshing];
            }];
            return ;
        }
        weakSelf.currentPage = 1;
        [weakSelf.collectionView hideNoNetWork];
        [weakSelf goodsRequest];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (![Util isNetWorkEnable]) {//先判断网络状态
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            [weakSelf.collectionView.mj_footer endRefreshing];
            return ;
        }
        weakSelf.currentPage++;
        [weakSelf loadMoreGoodsRequest];
    }];
    //注册
    [self regist];
    [self.collectionView.mj_header beginRefreshing];
    
}

- (void)goodsRequest {
    //发送商品列表请求
    NSString * goodsRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_HOME_GOODS];
    NSMutableDictionary * goodsparams = [NSMutableDictionary dictionary];
    goodsparams[@"pageSize"] = @"10";
    goodsparams[@"page"] = @1;
    if (self.searchString.length == 0) {
        goodsparams[@"category_id"] = self.sortModel.categoryID;
    } else {
        goodsparams[@"query_str"] = self.searchString;
    }
  
    [HFNetWork postWithURL:goodsRequesturl params:goodsparams success:^(id response) {
        [self.collectionView.mj_header endRefreshing];
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
        self.homeGoodsArray = [JJRecommendSection1Model mj_objectArrayWithKeyValuesArray:response[@"items"]];
        for(JJRecommendSection1Model *model in self.homeGoodsArray) {
            model.cover = [NSString stringWithFormat:@"%@?imageView2/1/w/500/h/500",model.cover];
        }
        
        if (self.homeGoodsArray.count < 10) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
           
            [self.collectionView.mj_footer resetNoMoreData];
        }
        
        if(self.homeGoodsArray.count == 0){
            weakSelf(weakSelf);
            [self.collectionView showNoDateWithImageName:nil title:@"暂无数据" btnName:nil TryAgainBlock:nil];
            
        }else{
            [self.collectionView hideNoDate];
        }

        [self.collectionView reloadData];
    } fail:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
    
}
//上拉加载更多
- (void)loadMoreGoodsRequest {
    //发送商品列表请求
    NSString * goodsRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_HOME_GOODS];
    NSMutableDictionary * goodsparams = [NSMutableDictionary dictionary];
    goodsparams[@"pageSize"] = @"10";
    goodsparams[@"page"] = @(self.currentPage);
    if (self.searchString.length == 0) {
        goodsparams[@"category_id"] = self.sortModel.categoryID;
    } else {
        goodsparams[@"query_str"] = self.searchString;
    }
    
    [HFNetWork postWithURL:goodsRequesturl params:goodsparams success:^(id response) {
        
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            [self.collectionView.mj_footer endRefreshing];
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            [self.collectionView.mj_footer endRefreshing];
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        NSArray<JJRecommendSection1Model *> *moreHomeGoodsArray = [JJRecommendSection1Model mj_objectArrayWithKeyValuesArray:response[@"items"]];
        if (moreHomeGoodsArray.count < 10) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.collectionView.mj_footer endRefreshing];
        }
        for(JJRecommendSection1Model *model in moreHomeGoodsArray) {
            model.cover = [NSString stringWithFormat:@"%@?imageView2/1/w/500/h/500",model.cover];
        }
        [self.homeGoodsArray addObjectsFromArray:moreHomeGoodsArray];
        [self.collectionView reloadData];
    } fail:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        self.currentPage--;
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}


//注册
- (void)regist{
    //注册section1的 Cell
    [self.collectionView registerClass:[JJRecommendSection1Cell class] forCellWithReuseIdentifier:collectionViewCellIndentifierSection1];
}

#pragma mark - <UICollectionViewDataSource>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JJGoodsDetailViewController *goodsDetailViewController = [[JJGoodsDetailViewController alloc]init];
    JJRecommendSection1Model *model = self.homeGoodsArray[indexPath.row];
//    goodsDetailViewController.model = model;
    goodsDetailViewController.goodsID = model.GoodsID;
    goodsDetailViewController.name = model.name;
    goodsDetailViewController.picture = model.cover;
//    goodsDetailViewController.is_collect = model.is_collect;
    [self.navigationController pushViewController:goodsDetailViewController animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.homeGoodsArray.count;
}

//创建collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JJRecommendSection1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIndentifierSection1 forIndexPath:indexPath];
    cell.model = self.homeGoodsArray[indexPath.item];
    return cell;
    
}


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [self.navigationController pushViewController:[[UIViewController alloc]init] animated:YES];
//}

#pragma mark - <UICollectionViewDelegateFlowLayout>
//itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (SCREEN_WIDTH - 3 * collectionViewSpace)/2-1;
    CGFloat height = width * (215.0 / 167);
    
    return CGSizeMake(width, height);
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    //    最小行间距
    return collectionViewSpace;
    
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    //    if (section == 1){
    return collectionViewSpace;
    //    }
    //    return 0;
    //    最小列间距
}

//section间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(collectionViewSpace, collectionViewSpace, collectionViewSpace, collectionViewSpace);
    
}

#pragma mark - 懒加载
- (NSMutableArray *)homeGoodsArray {
    if(!_homeGoodsArray){
        _homeGoodsArray = [NSMutableArray array];
    }
    return _homeGoodsArray;
}

@end
