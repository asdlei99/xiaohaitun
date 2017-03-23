//
//  JJActivityRelateGoodsCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/24.
//  Copyright © 2016年 唐天成. All rights reserved.
//


#import "JJActivityRelateGoodsCell.h"
#import "JJHorizontalCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIView+XPKit.h"
#import "UIView+viewController.h"
#import "JJGoodsDetailViewController.h"
//#import "JJHorizontalCollectionViewCellModel.h"
#import "JJActivityRelateHorizonGoodsCell.h"

#define space 10



//注册JJHorizontalCollectionViewCell标示
static NSString * const horizontalCellIdentifier = @"horizontalCellIdentifier";


@interface JJActivityRelateGoodsCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//header头
@property (nonatomic, weak) UIView *headerViewView;

//CollectionView
@property (nonatomic, weak) UICollectionView *collectionView;

//pageController
@property (nonatomic, weak) UIPageControl *pageController;



@end


@implementation JJActivityRelateGoodsCell

- (void)setModelArray:(NSArray *)modelArray {
    _modelArray = modelArray;
    [self.collectionView reloadData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //创建视图控件
        [self createView];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    if(self = [super initWithFrame:frame]){
//        //创建视图控件
//        [self createView];
//    }
//    return self;
//}

//创建视图
- (void)createView {
    [self createHeader];
    [self createCollectonView];
    [self createPageControllerView];
}
//header头
- (void)createHeader {
    UIView *headerView = [[UIView alloc]init];
    self.headerViewView = headerView;
    [self.contentView addSubview:self.headerViewView];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"相关活动商品";
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.headerViewView);
    }];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGB(238, 238, 238);
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView);
        make.left.equalTo(headerView).with.offset(15);
        make.right.equalTo(headerView).with.offset(-15);
        make.height.equalTo(@1);
    }];
}
//collectionView
- (void)createCollectonView {
    //    self.contentView.backgroundColor = [UIColor yellowColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //    layout.itemSize = CGSizeMake(60, 60);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    
//    collectionView.backgroundColor = [UIColor greenColor];
    //设置数据源和代理
    collectionView.dataSource = self;
    collectionView.delegate = self;
    //注册
    [collectionView registerClass:[JJActivityRelateHorizonGoodsCell class] forCellWithReuseIdentifier:horizontalCellIdentifier];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
}
//创建pageController
- (void)createPageControllerView {
    UIPageControl *pageController = [[UIPageControl alloc]init];
    pageController.currentPageIndicatorTintColor = NORMAL_COLOR;
    pageController.pageIndicatorTintColor = [UIColor blackColor];
    
//    pageController.backgroundColor = [UIColor redColor];
    self.pageController = pageController;
    self.pageController.numberOfPages = 3;
    [self.contentView addSubview:self.pageController];
}

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger pagecount = self.modelArray.count / 3;
    if(self.modelArray.count % 3 > 0){
        pagecount++;
    }
    self.pageController.numberOfPages = pagecount;
    return self.modelArray.count;
    
    // return self.model.cellModels.count;
}

//创建collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JJActivityRelateHorizonGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:horizontalCellIdentifier forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JJGoodsDetailViewController *goodsDetailViewController = [[JJGoodsDetailViewController alloc]init];
    JJActivityDetailHorizontalGoodsModel *model = self.modelArray[indexPath.row];
//    goodsDetailViewController.model = model;
    goodsDetailViewController.goodsID = model.item_id;
    goodsDetailViewController.name = model.item_name;
    goodsDetailViewController.picture = model.item_pic;
//    goodsDetailViewController.is_collect = model.is_collect;
    [self.viewController.navigationController pushViewController:goodsDetailViewController animated:YES];
    
}

//itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.collectionView.width - 45) / 3, self.collectionView.height - 2 * 15);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    //    最小行间距

        return 15;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
        return 15;
    //    最小列间距
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 7.5, 15, 7.5);
}

#pragma mark - ScrollerVewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger number = scrollView.contentOffset.x / SCREEN_WIDTH;
    if((number * SCREEN_WIDTH) < scrollView.contentOffset.x){
        number++;
    }
    self.pageController.currentPage = number;
}


//布局
- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerViewView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44 * KWIDTH_IPHONE6_SCALE);
    self.collectionView.frame = CGRectMake(0, 44 * KWIDTH_IPHONE6_SCALE, self.width, 173 * KWIDTH_IPHONE6_SCALE );
    DebugLog(@"%@",NSStringFromCGRect(self.collectionView.frame));
    self.pageController.frame = CGRectMake(0, self.collectionView.bottom, SCREEN_WIDTH, self.height - self.collectionView.bottom);
}


@end
