////
////  XZCustomViewController.m
////  DetailShow
////
////  Created by 微指 on 16/3/7.
////  Copyright © 2016年 CityNight. All rights reserved.
////待删除
//
//#import "JJCustomerViewController.h"
//
////轮播图高度
//#define adViewHeight (180 * KWIDTH_IPHONE6_SCALE)
//
////选择栏高度
//#define  titleBarHeight 37
//
////头部视图高度
//#define headViewHeight (adViewHeight + titleBarHeight)
//
//
//
//
//
//@interface JJCustomerViewController () <UITableViewDelegate>
//
//@property (nonatomic, assign) CGFloat lastOffsetY;
//@property (nonatomic, assign) CGFloat alpha;
//@end
//
//@implementation JJCustomerViewController
////-(void)viewWillAppear:(BOOL)animated {
////    [super viewWillAppear:animated];
////    self.view.hidden = NO;
////}
////-(void)viewWillDisappear:(BOOL)animated {
////    [super viewWillDisappear:animated];
////    self.view.hidden = YES;
////}
//-(void)viewDidLoad {
//    
//    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//    //    self.view.backgroundColor = [UIColor whiteColor];
//    
//    //    _lastOffsetY = -(kHeadViewH+ kTitleBarH);
//    
//    // 设置顶部额外滚动区域
//    self.tableView.contentInset = UIEdgeInsetsMake(headViewHeight, 0, 0, 0);
//    
//    //    XZTableView *tableView = (XZTableView *)self.tableView;
//    //    tableView.tabBar = _titleBar;
//    
//  
//}
//
//
//
////-(XZTableView *)tableView {
////    if (!_tableView) {
////        _tableView = [[XZTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
////        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
////        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
////        _tableView.delegate = self;
////        _tableView.tag = 1024;
////        [self.view addSubview:_tableView];
////    }
////    return _tableView;
////}
//CGFloat oldTop = 0;
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//       NSLog(@"%@ %@",self,NSStringFromCGPoint( scrollView.contentOffset));
//    
//    DebugLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
//    CGFloat insertSpace =-(scrollView.contentOffset.y + headViewHeight);
//    if (insertSpace < -headViewHeight){
//        insertSpace = -headViewHeight;
//    }
//    
//    //滚动距离
//    CGFloat contentOffsetY = scrollView.contentOffset.y;
//    if(contentOffsetY >= 0){
//        contentOffsetY = 0;
//    }
////    if( contentOffsetY <= 0 && contentOffsetY >= (-headViewHeight)){
//    
//    //发出通知
//    [[NSNotificationCenter defaultCenter]postNotificationName:JJNotificationScroll object:self userInfo:@{JJNotificationScrollContentofSize: @(contentOffsetY)}];
////    }
//    
//    self.headerView.top = insertSpace;
//    
//}
//
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}
//@end
