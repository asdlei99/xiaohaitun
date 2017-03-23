////
////  JJActivitySortViewController.m
////  XiaoHaiTun
////
////  Created by 唐天成 on 16/9/7.
////  Copyright © 2016年 唐天成. All rights reserved.
////
//
//#import "JJActivitySortViewController.h"
//#import "JJActivityBaseViewController.h"
//#import "TCViewPager.h"
//#import "JJActivityBaseViewController.h"
//
//@interface JJActivitySortViewController ()
//
//@property (nonatomic, strong) TCViewPager *viewPager;
//
//
//@end
//
//@implementation JJActivitySortViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.view addSubview:self.viewPager];
//    
//    self.navigationItem.title = @"列表";
//    // Do any additional setup after loading the view.
//}
//
//
//
//#pragma mark - 懒加载
////
////- (TCViewPager *)viewPager
////{
////    if(_viewPager == nil) {
////        //默认排序
////        JJActivityBaseViewController *chooseViewController = [[JJActivityBaseViewController alloc]init];
////        JJActivitySortModel *activitySortModelChoose = [[JJActivitySortModel alloc]init];
////        activitySortModelChoose.order_id = @"1";
////        activitySortModelChoose.keyWord = self.keyWord;
////        chooseViewController.sortModel = activitySortModelChoose;
////        [self addChildViewController:chooseViewController];
////        
////        //按销量
////        JJActivityBaseViewController *earlyEducationViewController =[[JJActivityBaseViewController alloc]init];
////        JJActivitySortModel *activitySortModelEarly = [[JJActivitySortModel alloc]init];
////        activitySortModelEarly.order_id = @"2";
////        activitySortModelEarly.keyWord = self.keyWord;
////        earlyEducationViewController.sortModel = activitySortModelEarly;
////        [self addChildViewController:earlyEducationViewController];
////        
////        //按价格
////        JJActivityBaseViewController *amusementParkViewController = [[JJActivityBaseViewController alloc]init];
////        JJActivitySortModel *activitySortModelAmusement = [[JJActivitySortModel alloc]init];
////        amusementParkViewController.sortModel = activitySortModelAmusement;
////        activitySortModelAmusement.order_id = @"3";
////        activitySortModelAmusement.keyWord = self.keyWord;
////        [self addChildViewController:amusementParkViewController];
////        
////        //按年龄段
////        JJActivityBaseViewController *familyTripViewController = [[JJActivityBaseViewController alloc]init];
////        JJActivitySortModel *activitySortModelFamily = [[JJActivitySortModel alloc]init];
////        activitySortModelFamily.order_id = @"4";
////        activitySortModelFamily.keyWord = self.keyWord;
////        familyTripViewController.sortModel = activitySortModelFamily;
////        [self addChildViewController:familyTripViewController];
////        
////        _viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT_64, self.view.width, self.view.height - TABAR_HEIGHT_49) titles:@[@"默认排序", @"按销量", @"按价格",@"按年龄段"] icons:nil selectedIcons:nil views:@[chooseViewController, earlyEducationViewController, amusementParkViewController,familyTripViewController] titlePageW: SCREEN_WIDTH / 4 selectedLabelScale:0.7];
////        _viewPager.showVLine = NO;
////        _viewPager.showAnimation = YES;
////        //        _viewPager.enabledScroll = NO;
////        _viewPager.tabTitleColor = [UIColor blackColor];
////        _viewPager.tabSelectedTitleColor = NORMAL_COLOR;
////        
////        
////        _viewPager.tabSelectedArrowBgColor = NORMAL_COLOR;
////        _viewPager.tabArrowBgColor = [UIColor colorWithWhite:0.929 alpha:1.000];
////        
////    }
////    return _viewPager;
////}
//
//@end
