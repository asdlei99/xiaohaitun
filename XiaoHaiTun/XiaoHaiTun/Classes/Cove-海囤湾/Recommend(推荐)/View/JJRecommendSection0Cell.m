//
//  JJRecommendSection0Cell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/29.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJRecommendSection0Cell.h"
#import "JJHorizontalCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIView+XPKit.h"
#import "UIView+viewController.h"
#import "JJGoodsDetailViewController.h"
#import "JJRecommendSection1Model.h"
#import "JJThemeViewController.h"

#define space 10



//注册JJHorizontalCollectionViewCell标示
static NSString * const horizontalCellIdentifier = @"horizontalCellIdentifier";


@interface JJRecommendSection0Cell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//大图
@property (nonatomic, weak) UIImageView *imageView;

//CollectionView
@property (nonatomic, weak) UICollectionView *collectionView;

//灰色横线
@property (nonatomic, weak) UIView *lineView;

//模型数组
@property (nonatomic, strong) NSArray<JJRecommendSection1Model *> *HorizontalCollectionViewCellModelArray;


@end


@implementation JJRecommendSection0Cell

- (void)setModel:(JJRecommendSection0CellModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.HorizontalCollectionViewCellModelArray = model.related_goods;
    [self.collectionView reloadData];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        //创建视图控件
        [self createView];
    }
    return self;
}

//创建视图
- (void)createView {
//    self.contentView.backgroundColor = [UIColor yellowColor];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"WeChat_1469763071"];
    self.imageView = imageView;
    [self.contentView addSubview:imageView];
    weakSelf(weakSelf)
    [self.imageView whenTouchedUp:^{
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        JJThemeViewController *themeViewController = [[JJThemeViewController alloc]initWithCollectionViewLayout:layout];
        themeViewController.themeModel = self.model;
        
        [weakSelf.viewController.navigationController pushViewController:themeViewController animated:YES];
    }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.itemSize = CGSizeMake(60, 60);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    CGRectMake(0, self.imageView.bottom, self.width, self.height - self.imageView.bottom - 10);

    collectionView.backgroundColor = [UIColor whiteColor];

    //设置数据源和代理
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    //注册
    [collectionView registerClass:[JJHorizontalCollectionViewCell class] forCellWithReuseIdentifier:horizontalCellIdentifier];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    
    UIView *lineView = [[UIView alloc]init];
    self.lineView = lineView;
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = RGBA(239, 239, 239, 1);

}


#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.HorizontalCollectionViewCellModelArray.count;

}

//创建collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JJHorizontalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:horizontalCellIdentifier forIndexPath:indexPath];
    cell.model = self.HorizontalCollectionViewCellModelArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JJGoodsDetailViewController *goodsDetailViewController = [[JJGoodsDetailViewController alloc]init];
    JJRecommendSection1Model *model = self.HorizontalCollectionViewCellModelArray[indexPath.row];
//    goodsDetailViewController.model = model;
    goodsDetailViewController.goodsID = model.GoodsID;
    goodsDetailViewController.name = model.name;
    goodsDetailViewController.picture = model.cover;
//    goodsDetailViewController.is_collect = model.is_collect;
    [self.viewController.navigationController pushViewController:goodsDetailViewController animated:YES];

}

//itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.collectionView.height - 2 * 10) * (125.0 / 182), self.collectionView.height - 2 * 10);
}

//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    //    最小行间距
//
//        return 10;
//}

//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//        return 10;
//    //    最小列间距
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
        return UIEdgeInsetsMake(10, 10, 10, 10);
}


//布局
- (void)layoutSubviews {
    [super layoutSubviews];
//    NSLog(@"%@",NSStringFromCGRect(self.bounds));
    self.imageView.frame = CGRectMake(10 , 10, self.width - 10 * 2 , (self.width - 10 * 2) * (176.0 /375));
    self.collectionView.frame = CGRectMake(0, self.imageView.bottom, SCREEN_WIDTH, self.height - self.imageView.bottom - 10);
    DebugLog(@"%@",NSStringFromCGRect(self.collectionView.frame));
    self.lineView.frame = CGRectMake(0, self.collectionView.bottom, self.width, 10);
    
    
}
@end
