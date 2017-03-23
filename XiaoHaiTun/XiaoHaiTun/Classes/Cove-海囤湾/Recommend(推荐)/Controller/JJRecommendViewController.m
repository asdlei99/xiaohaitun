//
//  JJRecommendViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJRecommendViewController.h"
#import "JJScrollHeaderView.h"
#import "JJRecommendSection1Cell.h"
#import "JJRecommendSection1HeadView.h"
#import "JJRecommendSection0Cell.h"
#import "JJGoodsDetailViewController.h"
#import "JJCity.h"
#import "MBProgressHUD+gifHUD.h"
#import "HFNetWork.h"
#import "JJRecommendADViewModel.h"
#import <MJExtension.h>
#import "User.h"
#import "HFNetWork.h"
#import "MJRefresh.h"
#import "JJADDetailViewController.h"
#import "UIViewController+ModelLogin.h"

#define collectionViewSpace (15 * KWIDTH_IPHONE6_SCALE)
//注册collectionViewHead的标示 (section 0)
static NSString* collectionViewHeaderIndentifierSection0 = @"JJCollectiionViewHeadSection0";
//注册collectionViewCell的标示 (section 0)
static NSString* collectionViewCellIndentifierSection0 = @"JJCollectionViewCellSection0";


//注册collectionViewHead的标示 (section 1)
static NSString* collectionViewHeaderIndentifierSection1 = @"JJCollectiionViewHeadSection1";
//注册collectionViewCell的标示 (section 1)
static NSString* collectionViewCellIndentifierSection1 = @"JJCollectionViewCellSection1";



@interface JJRecommendViewController ()<UICollectionViewDelegateFlowLayout>

////头部滚动轮播图
//@property (nonatomic, strong) JJScrollHeaderView *headView;
//轮播图模型数组
@property (nonatomic, strong)NSArray<JJRecommendADViewModel *> *homeADViewArray;

//商城推荐主题数组
@property (nonatomic, strong) NSArray<JJRecommendSection0CellModel *> *homeThemeArray;

//商品列表数组
@property (nonatomic, strong) NSMutableArray<JJRecommendSection1Model *> *homeGoodsArray;

//轮播图是否请求成功
@property(nonatomic,assign)BOOL ADViewRequestSuccess;
//轮播图是否确定失败
@property(nonatomic,assign)BOOL ADViewRequestFailed;
//首页主题推荐是否请求成功
@property(nonatomic,assign)BOOL ThemeRequestSuccess;
//首页主题推荐是否确定失败
@property(nonatomic,assign)BOOL ThemeRequestFailed;

//3个接口成功的个数
@property(nonatomic,assign)NSInteger successCount;

//最新
@property(nonatomic,assign)NSInteger currentPage;
@end

@implementation JJRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ADViewRequestSuccess = NO;
    self.ThemeRequestSuccess = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];//RGBA(216, 216, 216, 1);
    self.currentPage = 1;
    //注册
    [self regist];
    
    //下拉刷新
    weakSelf(weakSelf);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求
        [weakSelf allRequest];
    }];
    //上拉加载更多
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (![Util isNetWorkEnable]) {//先判断网络状态
            [MBProgressHUD hideHUD];
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            [weakSelf.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            return ;
        }
            self.currentPage++;
            [self loadMoreGoodsRequest];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 网络请求
- (void)allRequest {
    weakSelf(weakSelf);
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD hideHUD];
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        [weakSelf.collectionView.mj_header endRefreshing];
        
        [weakSelf.collectionView showNoNetWorkWithTryAgainBlock:^{
            [weakSelf.collectionView.mj_header beginRefreshing];
        }];
        return ;
    }
     [self.collectionView hideNoNetWork];
    self.currentPage = 1;
    [self ADViewRequest];
    [self ThemeRequest];
    [self goodsRequest];
}
- (void)ADViewRequest {
    //发送轮播请求
    NSString * ADViewRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_HOME_CAROUSEL];
    NSDictionary *params = nil;
    if([User getUserInformation]){
        params = @{@"project_type" : @"1" , @"user_id" : [User getUserInformation].userId};
    }else{
        params = @{@"project_type" : @"1" };
    }
    
    [HFNetWork postNoTipWithURL:ADViewRequesturl params:params success:^(id response) {
        
        if (![response isKindOfClass:[NSDictionary class]]) {
//            [MBProgressHUD hideHUD];
            [HFNetWork cancelAllRequest];
            [MBProgressHUD hideHUD];
            [self.collectionView.mj_header endRefreshing];
            self.successCount = 0;
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            [MBProgressHUD hideHUD];
            [HFNetWork cancelAllRequest];
//            [MBProgressHUD hideHUD];
            [self.collectionView.mj_header endRefreshing];
            self.successCount = 0;
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        self.homeADViewArray = [JJRecommendADViewModel mj_objectArrayWithKeyValuesArray:response[@"carousel"]];
        for(JJRecommendADViewModel *model in self.homeADViewArray) {
            model.picture = [NSString stringWithFormat:@"%@?imageView2/1/w/1000/h/480",model.picture];
        }
        self.successCount += 1;
        if(self.successCount == 3) {
//            NSLog(@"成功成功成功成功成功成功成功成功成功成功成功成功成功成功成功成功成功了");

            [MBProgressHUD hideHUD];
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
            self.successCount = 0;
        }
    } fail:^(NSError *error) {
        [HFNetWork cancelAllRequest];
        //有一个失败就隐藏
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        [self.collectionView.mj_header endRefreshing];
        self.successCount = 0;
    }];
}
- (void)ThemeRequest {
    //发送商城推荐主题请求
    NSString * ThemeRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_HOME_THEME];
    //    NSDictionary * params = @{@"pageSize":@"10", @"page":@"1"};
    [HFNetWork postNoTipWithURL:ThemeRequesturl params:nil success:^(id response) {
        if (![response isKindOfClass:[NSDictionary class]]) {
            [MBProgressHUD hideHUD];
            [HFNetWork cancelAllRequest];
            [self.collectionView.mj_header endRefreshing];
            self.successCount = 0;
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            [MBProgressHUD hideHUD];
            [HFNetWork cancelAllRequest];
            [self.collectionView.mj_header endRefreshing];
            self.successCount = 0;
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        self.homeThemeArray = [JJRecommendSection0CellModel mj_objectArrayWithKeyValuesArray:response[@"themes"]];
        for(JJRecommendSection0CellModel *section0CellModel in self.homeThemeArray) {
            section0CellModel.picture = [NSString stringWithFormat:@"%@?imageView2/1/w/1000/h/500",section0CellModel.picture];
            for(JJRecommendSection1Model *model in section0CellModel.related_goods) {
                model.cover = [NSString stringWithFormat:@"%@?imageView2/1/w/340/h/340",model.cover];
            }
        }
        
        self.successCount += 1;
        if(self.successCount == 3) {
            //            NSLog(@"成功成功成功成功成功成功成功成功成功成功成功成功成功成功成功成功成功了");
            [MBProgressHUD hideHUD];
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
            self.successCount = 0;
            
        }
        
    } fail:^(NSError *error) {
        [HFNetWork cancelAllRequest];
        //有一个失败就隐藏
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        [self.collectionView.mj_header endRefreshing];
        self.successCount = 0;
    }];
}

- (void)goodsRequest {
    //发送商品列表请求
    NSString * goodsRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_HOME_GOODS];
    NSDictionary * goodsparams = @{@"is_recommended" :@"1" , @"pageSize":@"10", @"page":@1};
    [HFNetWork postNoTipWithURL:goodsRequesturl params:goodsparams success:^(id response) {
        
        if (![response isKindOfClass:[NSDictionary class]]) {
            [MBProgressHUD hideHUD];
            [HFNetWork cancelAllRequest];
            [self.collectionView.mj_header endRefreshing];
            self.successCount = 0;
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            [MBProgressHUD hideHUD];
            [HFNetWork cancelAllRequest];
            [self.collectionView.mj_header endRefreshing];
            self.successCount = 0;
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
        
        self.successCount += 1;
        if(self.successCount == 3) {
//            NSLog(@"成功成功成功成功成功成功成功成功成功成功成功成功成功成功成功成功成功了");
            [MBProgressHUD hideHUD];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView reloadData];
            self.successCount = 0;
            return ;
        }

        
    } fail:^(NSError *error) {
        [HFNetWork cancelAllRequest];
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        [self.collectionView.mj_header endRefreshing];
        self.successCount = 0;
    }];
}

//上拉加载更多
- (void)loadMoreGoodsRequest {
    //发送商品列表请求
    NSString * goodsRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_HOME_GOODS];
    NSDictionary * goodsparams = @{@"is_recommended" :@"1" , @"pageSize":@"10", @"page":@(self.currentPage)};
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
        NSArray<JJRecommendSection1Model *> *modelArray = [JJRecommendSection1Model mj_objectArrayWithKeyValuesArray:response[@"items"]];
        if (modelArray.count < 10) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.collectionView.mj_footer endRefreshing];
        }
        
        for(JJRecommendSection1Model *model in modelArray) {
            model.cover = [NSString stringWithFormat:@"%@?imageView2/1/w/500/h/500",model.cover];
        }
        [self.homeGoodsArray addObjectsFromArray:modelArray];
        [self.collectionView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        [self.collectionView.mj_footer endRefreshing];
        self.currentPage--;
    }];
}

//注册
- (void)regist{
    //注册section1的 Cell
    [self.collectionView registerClass:[JJRecommendSection1Cell class] forCellWithReuseIdentifier:collectionViewCellIndentifierSection1];
    //注册section1的 Head
    [self.collectionView registerNib:[UINib nibWithNibName:@"JJRecommendSection1HeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewHeaderIndentifierSection1];
    
    //注册section0的 Head
    [self.collectionView registerClass:[JJScrollHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewHeaderIndentifierSection0];
    //注册section0的 Cell
     [self.collectionView registerClass:[JJRecommendSection0Cell class] forCellWithReuseIdentifier:collectionViewCellIndentifierSection0];
    
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0) {
        return self.homeThemeArray.count;
    } else {
        return self.homeGoodsArray.count;
    }
    
}

//创建collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0) {
        
        JJRecommendSection0Cell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIndentifierSection0 forIndexPath:indexPath];
//        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.model = self.homeThemeArray[indexPath.item];
        return cell;
        
    } else {
        
    JJRecommendSection1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIndentifierSection1 forIndexPath:indexPath];
        DebugLog(@"self.homeGoodsArray.count:%ld",self.homeGoodsArray.count);
        cell.model = self.homeGoodsArray[indexPath.item % self.homeGoodsArray.count];
    return cell;
    }

}

//创建头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0 ){
        JJScrollHeaderView *reusableview = nil;
        if (kind == UICollectionElementKindSectionHeader){
            JJScrollHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewHeaderIndentifierSection0 forIndexPath:indexPath];
            
            [headerView configWithBanners:self.homeADViewArray];
            reusableview = headerView;
        }
        return reusableview;
    } else {
        JJRecommendSection1HeadView *reusableview = nil;
        if (kind == UICollectionElementKindSectionHeader ){
            JJRecommendSection1HeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewHeaderIndentifierSection1 forIndexPath:indexPath];
            reusableview = headerView;
            if(self.homeGoodsArray.count <= 0) {
                headerView.hidden = YES;
            } else {
                headerView.hidden = NO;
            }
        }
    return reusableview;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        
    }else{
        JJGoodsDetailViewController *goodsDetailViewController = [[JJGoodsDetailViewController alloc]init];
        JJRecommendSection1Model *model = self.homeGoodsArray[indexPath.row];
//        goodsDetailViewController.model = model;
        goodsDetailViewController.goodsID = model.GoodsID;
        goodsDetailViewController.name = model.name;
        goodsDetailViewController.picture = model.cover;
//        goodsDetailViewController.is_collect = model.is_collect;
    [self.navigationController pushViewController:goodsDetailViewController animated:YES];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
//itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        CGFloat width = SCREEN_WIDTH ;
        CGFloat height = width * (404.0 / 375);
        return CGSizeMake(width, height);

    } else {
        CGFloat width = (SCREEN_WIDTH - 3 * collectionViewSpace)/2-1;
        CGFloat height = width * (215.0 / 167);
        return CGSizeMake(width, height);

    }
}

//头部size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * (12.0 / 25));
    } else {
//        if(self.successCount != 3){
//            return CGSizeZero;
//        }
        //头部size
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * (58.0 / 375));
    }
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    //    最小行间距
    if (section == 1){
    return collectionViewSpace;
    }
    return 0;
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1){
        return collectionViewSpace;
    }
    return 0;
    //    最小列间距
}

//section间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(section == 1){
        return UIEdgeInsetsMake(0, collectionViewSpace, 0, collectionViewSpace);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
}


#pragma mark - 懒加载
- (NSMutableArray *)homeGoodsArray {
    if (!_homeGoodsArray) {
        _homeGoodsArray = [NSMutableArray array];
    }
    return _homeGoodsArray;
}
@end
