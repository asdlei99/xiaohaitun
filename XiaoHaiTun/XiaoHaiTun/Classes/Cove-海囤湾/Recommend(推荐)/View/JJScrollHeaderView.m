//
//  JJScrollHeaderView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJScrollHeaderView.h"
#import "TCADView.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "JJGoodsDetailViewController.h"
#import "UIView+viewController.h"
#import "JJRecommendADViewModel.h"
#import "JJADDetailViewController.h"
#import "JJGoodsDetailViewController.h"

@interface JJScrollHeaderView ()<TCAdViewDelegate>

//轮播View
@property (nonatomic, strong) TCADView *adView;
@property (nonatomic, strong) NSArray<JJRecommendADViewModel *> *modelArray;

@end

@implementation JJScrollHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.adView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.adView];
        //        self.adView.backgroundColor = [UIColor redColor];
        [self.adView mas_remakeConstraints:^(MASConstraintMaker *make){
            make.leading.top.trailing.bottom.equalTo(self);
        }];
    }
    return self;
}


#pragma mark - Delegate
- (void)adView:(TCADView *)adView lazyLoadAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imageURL:(NSString *)imageURL
{
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    JJRecommendADViewModel * model = (JJRecommendADViewModel *)imageURL;
    DebugLog(@"%@",imageURL);
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    //    imageView.image = [UIImage imageNamed:imageURL];
}

- (void)adView:(TCADView *)adView didSelectedAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imagePath:(NSString *)imagePath {
    DebugLog(@"%ld",index);
    NSInteger indexNow = index;
    if(indexNow == -1) {
        indexNow = 0;
    }
    JJRecommendADViewModel *model = self.modelArray[indexNow];
    if(model){
//    JJGoodsDetailViewController *goodsDetailViewController = [[JJGoodsDetailViewController alloc]init];
////    goodsDetailViewController.model = model;
//    goodsDetailViewController.goodsID = model.GoodsID;
//    goodsDetailViewController.name = model.title;
//    goodsDetailViewController.picture = model.picture;
//    goodsDetailViewController.is_collect = model.is_collect;
        
        if(model.url.length != 0 ) {
            JJADDetailViewController *adDetailViewController = [[JJADDetailViewController alloc]init];
            adDetailViewController.url = model.url;
            DebugLog(@"%@",model.url);
            [self.viewController.navigationController pushViewController:adDetailViewController animated:YES];
        }else if(model.associated_id.length != 0 && ![model.associated_id isEqualToString:@"0"]){
            JJGoodsDetailViewController *goodsDetailVC = [[JJGoodsDetailViewController alloc]init];
            goodsDetailVC.goodsID = model.associated_id;
            goodsDetailVC.name = model.title;
            goodsDetailVC.picture = model.picture;
            [self.viewController.navigationController pushViewController:goodsDetailVC animated:YES];
    
        }
    }
}

#pragma mark - Public Interface
- (void)configWithBanners:(NSArray<JJRecommendADViewModel *> *)banners
{
    if(!banners) {
        return;
    }
    self.modelArray = banners;
    [self.adView setDataArray:banners];
    if(banners.count <= 1) {
        [self.adView.pageControl setHidden:YES];
        return;
    }
    [self.adView setUserInteractionEnabled:YES];
    
    DebugLog(@"%ld",_adView.pageControl.subviews.count);
    for (UIView *subView in _adView.pageControl.subviews) {
        [subView createBordersWithColor:NORMAL_COLOR withCornerRadius:4 andWidth:1];
    }
    [self.adView perform];
}

#pragma mark - 懒加载

- (TCADView *)adView
{
    if(!_adView) {
        _adView = [[TCADView alloc] initWithFrame:self.bounds];
        _adView.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _adView.pageControl.pageIndicatorTintColor = NORMAL_COLOR;
        _adView.displayTime = 3;
        _adView.delegate = self;
    }
    
    return _adView;
}


@end
