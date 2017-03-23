//
//  JJThemeViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/18.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJThemeViewController.h"
//#import "JJHorizontalCollectionViewCell.h"
#import "JJRecommendSection1Cell.h"
#import "JJThemeHeadView.h"
#import "JJRecommendSection1Model.h"
#import <UIImageView+WebCache.h>
#import "JJGoodsDetailViewController.h"

#define collectionViewSpace (15 * KWIDTH_IPHONE6_SCALE)

static NSString * const headIdentifier = @"JJHeadIdentifier";
static NSString * const cellIdentifier = @"JJCellIdentifier";

@interface JJThemeViewController ()

@end


@implementation JJThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.themeModel.title;;
    self.collectionView.backgroundColor = [UIColor whiteColor];//= RGBA(238, 238, 238, 1);
    [self regiset];
}

//注册
- (void)regiset {
    [self.collectionView registerClass:[JJRecommendSection1Cell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass: [JJThemeHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier];
}
#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.themeModel.related_goods.count;
    
}

//创建collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        JJRecommendSection1Cell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.model = self.themeModel.related_goods[indexPath.row];
//    cell.backgroundColor = [UIColor yellowColor];
        return cell;
}

//创建头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
        if (kind == UICollectionElementKindSectionHeader){
            JJThemeHeadView *themeHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier forIndexPath:indexPath];
            themeHeadView.clipsToBounds = YES;
            [themeHeadView.iconView sd_setImageWithURL:[NSURL URLWithString:self.themeModel.picture] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] options:SDWebImageRetryFailed];
            
            return themeHeadView;
        }
        return [UICollectionReusableView new];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        JJGoodsDetailViewController *goodsDetailViewController = [[JJGoodsDetailViewController alloc]init];
        JJRecommendSection1Model *model = self.themeModel.related_goods[indexPath.row];
        goodsDetailViewController.goodsID = model.GoodsID;
        goodsDetailViewController.name = model.name;
        goodsDetailViewController.picture = model.cover;
        //        goodsDetailViewController.is_collect = model.is_collect;
        [self.navigationController pushViewController:goodsDetailViewController animated:YES];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
//itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (SCREEN_WIDTH - 3 * collectionViewSpace)/2-1;
    CGFloat height = width * (215.0 / 167);
    return CGSizeMake(width, height);

}

//头部size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH , 196 * KWIDTH_IPHONE6_SCALE);
    
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//最小行间距
        return collectionViewSpace;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return collectionViewSpace;
    //    最小列间距
}

////section间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
        return UIEdgeInsetsMake(0, collectionViewSpace, 0, collectionViewSpace);
}

@end
