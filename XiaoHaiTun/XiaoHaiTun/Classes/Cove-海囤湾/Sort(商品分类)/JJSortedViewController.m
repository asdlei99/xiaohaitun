//
//  JJSortedViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/5.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSortedViewController.h"
#import "JJSortedCollectionViewCell.h"
#import "JJSortedListViewController.h"
#import "UIView+FrameExpand.h"
#import "HFNetWork.h"
#import "MBProgressHUD+gifHUD.h"
#import <MJExtension.h>
#import "JJSortedCellModel.h"
#import "JJSearchView.h"
#import "UIViewController+KeyboardCorver.h"

static NSString * const sortSearchHeader = @"sortSearchHeaderIdentifier";
static NSString * const sortCellIdentifier = @"sortCellIdentifier";

@interface JJSortedViewController ()<UICollectionViewDelegateFlowLayout , UICollectionViewDataSource,UICollectionViewDelegate,JJSearchViewDelegate>

@property (nonatomic, strong) NSArray *modelArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JJSortedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    DebugLog(@"self.navigationController.navigationBar.subviews:%ld",self.navigationController.navigationBar.subviews.count);
    UIView *v =self.navigationController.navigationBar.subviews[0];
    DebugLog(@"--%@--%@--%@",v,v.backgroundColor,v.layer);
    for(UIView *vi in v.subviews) {
    DebugLog(@"--%@--%@--%@",vi,vi.backgroundColor,vi.layer);
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    DebugLog(@"%@",[Util getClientIP]);
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"分类";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //注册
    [self regist];
    UITextField *textField = 
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestApply];
    }];
    [self.collectionView.mj_header beginRefreshing];
    [self addNotification];
}


//注册
- (void)regist{
    [self.collectionView registerClass:[JJSortedCollectionViewCell class] forCellWithReuseIdentifier:sortCellIdentifier];
    [self.collectionView registerClass:[JJSearchView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sortSearchHeader];
    
}

- (void)requestApply {
    if (![Util isNetWorkEnable]) {//先判断网络状态
        DebugLog(@"%@   %@   ",NSStringFromUIEdgeInsets( self.collectionView.contentInset),NSStringFromCGPoint(self.collectionView.contentOffset));
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        [self.collectionView.mj_header endRefreshing];
        weakSelf(weakSelf);
        [self.collectionView showNoNetWorkWithTryAgainBlock:^{
            [self.collectionView.mj_header beginRefreshing];
        }];
        return ;
    }
    [self.collectionView hideNoNetWork];
    [HFNetWork getWithURL:[NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_CATEGORY_GOODS] params:nil success:^(id response) {
        [MBProgressHUD hideHUD];
        [self.collectionView.mj_header endRefreshing];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        self.modelArray = [JJSortedCellModel mj_objectArrayWithKeyValuesArray:response[@"categorys"]];
        [self.collectionView reloadData];
        
    } fail:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelArray.count;
}

//创建collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JJSortedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sortCellIdentifier forIndexPath:indexPath];
    [cell createBordersWithColor:RGBA(249, 249, 249, 1) withCornerRadius:0 andWidth:1];
    cell.model = self.modelArray[indexPath.item];
    return cell;
    
}

//创建头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    JJSearchView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sortSearchHeader forIndexPath:indexPath];
    headerView.delegate =self;
    return headerView;
}

#pragma mark JJSearchViewDelegate 
- (void)searchWithString:(NSString *)string {
    //跳进分类列表
    JJSortedListViewController *sortedListViewController = [[JJSortedListViewController alloc]init];
    sortedListViewController.searchString = string;
    [self.navigationController pushViewController:sortedListViewController animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    //跳进分类列表
    JJSortedListViewController *sortedListViewController = [[JJSortedListViewController alloc]init];
    sortedListViewController.sortModel = self.modelArray[indexPath.row];
    [self.navigationController pushViewController:sortedListViewController animated:YES];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
//itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (SCREEN_WIDTH )/3;
    CGFloat height = width ;
    return CGSizeMake(width, height);
}

//头部size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 51 * KWIDTH_IPHONE6_SCALE);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


#pragma mark - lazyLoad
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layer = [[UICollectionViewFlowLayout alloc]init];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT_64, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT_64) collectionViewLayout:layer];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        
    }
    return _collectionView;
}

- (void)dealloc {
    [self clearNotificationAndGesture];
}
@end
