//
//  JJSortedListViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/5.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSortedListViewController.h"
#import "TCViewPager.h"
#import "JJCoveBaseViewController.h"
#import "JJSearchView.h"
#import "UIViewController+KeyboardCorver.h"

@interface JJSortedListViewController ()<JJSearchViewDelegate>

//父子控制视图
@property (nonatomic, strong) TCViewPager *viewPager;
//搜索图
@property (nonatomic, strong) JJSearchView *searchView;

@property (nonatomic, strong) NSMutableArray<JJCoveBaseViewController *> *viewPageViewControllerArray;

//@property (nonatomic, strong)JJCoveBaseViewController *defaultGoodsViewController;//默认
//@property (nonatomic, strong)JJCoveBaseViewController *salesGoodsViewController;//按销量
//@property (nonatomic, strong)JJCoveBaseViewController *priceGoodsViewController;//按价格
//@property (nonatomic, strong)JJCoveBaseViewController *ageGoodsViewController;//按年龄段


@end

@implementation JJSortedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"商品列表";
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.viewPager];
    [self addNotification];
}

#pragma mark - JJSearchViewDelegate 
- (void)searchWithString:(NSString *)string {
    for(JJCoveBaseViewController *coverBaseViewController in self.viewPageViewControllerArray) {
        coverBaseViewController.searchString = string;
    }
    JJCoveBaseViewController *currentVC = self.viewPageViewControllerArray[self.viewPager.selectIndex];
    [currentVC.collectionView.mj_header beginRefreshing];
//    self.defaultGoodsViewController.searchString = string;
//    self.salesGoodsViewController.searchString = string;
//    self.priceGoodsViewController.searchString = string;
//    self.ageGoodsViewController.searchString = string;
//    self.viewPager.selectIndex
}

#pragma mark - 懒加载
- (JJSearchView *)searchView {
    if(!_searchView) {
        _searchView = [[JJSearchView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 51 * KWIDTH_IPHONE6_SCALE)];
        _searchView.delegate = self;
    }
    return _searchView;
}

- (TCViewPager *)viewPager
{
    if(_viewPager == nil) {
        //创建添加子视图控制器
        //默认排序
        UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc]init];
        JJCoveBaseViewController *defaultGoodsViewController =[[JJCoveBaseViewController alloc]initWithCollectionViewLayout:layout1];
//        self.defaultGoodsViewController = defaultGoodsViewController;
        [self.viewPageViewControllerArray addObject:defaultGoodsViewController];
        defaultGoodsViewController.searchString = self.searchString;
        defaultGoodsViewController.sortModel = self.sortModel;
        [self addChildViewController:defaultGoodsViewController];
        
        //按销量
        UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc]init];
        JJCoveBaseViewController *salesGoodsViewController =[[JJCoveBaseViewController alloc]initWithCollectionViewLayout:layout2];
//        self.salesGoodsViewController = salesGoodsViewController;
        [self.viewPageViewControllerArray addObject:salesGoodsViewController];
        salesGoodsViewController.searchString = self.searchString;
        salesGoodsViewController.sortModel = self.sortModel;
        [self addChildViewController:salesGoodsViewController];
        
        //按价格
        UICollectionViewFlowLayout *layout3 = [[UICollectionViewFlowLayout alloc]init];
        JJCoveBaseViewController *priceGoodsViewController =[[JJCoveBaseViewController alloc]initWithCollectionViewLayout:layout3];
//        self.priceGoodsViewController = priceGoodsViewController;
        [self.viewPageViewControllerArray addObject:priceGoodsViewController];
        priceGoodsViewController.searchString = self.searchString;
        priceGoodsViewController.sortModel = self.sortModel;
        [self addChildViewController:priceGoodsViewController];
        
        //按年龄段
        UICollectionViewFlowLayout *layout4 = [[UICollectionViewFlowLayout alloc]init];
        JJCoveBaseViewController *ageGoodsViewController =[[JJCoveBaseViewController alloc]initWithCollectionViewLayout:layout4];
//        self.ageGoodsViewController = ageGoodsViewController;
        [self.viewPageViewControllerArray addObject:ageGoodsViewController];
        ageGoodsViewController.searchString = self.searchString;
        ageGoodsViewController.sortModel = self.sortModel;
        [self addChildViewController:ageGoodsViewController];
        
        _viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT_64 + (51 * KWIDTH_IPHONE6_SCALE) , self.view.width, self.view.height - NAVIGATION_HEIGHT_64 - 51 * KWIDTH_IPHONE6_SCALE) titles:@[@"默认排序", @"按销量", @"按价格",@"按年龄段"] icons:nil selectedIcons:nil views:@[defaultGoodsViewController,salesGoodsViewController,priceGoodsViewController,ageGoodsViewController] titlePageW: SCREEN_WIDTH / 4 selectedLabelScale:0.7];
        
        //不显示竖直分割
        _viewPager.showVLine = NO;
        
        //动画
        _viewPager.showAnimation = YES;
        //        _viewPager.enabledScroll = NO;
        
        //title颜色
        _viewPager.tabTitleColor = [UIColor blackColor];
        
        //选中状态title颜色
        _viewPager.tabSelectedTitleColor = NORMAL_COLOR;
        
        //菜单按钮下方横线选中状态颜色
        _viewPager.tabSelectedArrowBgColor = NORMAL_COLOR;
        
        //菜单按钮下方横线颜色
        _viewPager.tabArrowBgColor = [UIColor colorWithWhite:0.929 alpha:1.000];
        
    }
    return _viewPager;
}

- (NSMutableArray *)viewPageViewControllerArray {
    if(!_viewPageViewControllerArray) {
        _viewPageViewControllerArray = [NSMutableArray array];
    }
    return _viewPageViewControllerArray;
}
@end
