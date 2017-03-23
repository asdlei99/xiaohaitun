//
//  JJChooserViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJChooserViewController.h"
#import "TCADView.h"
#import "TCViewPager.h"
#import "JJChooseActivityViewController.h"
#import "JJNearActivityViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XMGTitleButton.h"
#import "JJActivityDetailViewController.h"
#import "HFNetWork.h"
#import "MBProgressHUD+gifHUD.h"
#import "JJRecommendADViewModel.h"
#import <MJExtension.h>
#import "JJActivityChooseADViewModel.h"
#import "MJRefresh.h"
#import "User.h"
#import "JJADDetailViewController.h"


//轮播图高度
#define ADVIEW_HEIGHT 180 * KWIDTH_IPHONE6_SCALE

//背景滑动scrollerView高度
#define SCROLL_HEIGHT (SCREEN_HEIGHT - PAGER_HEAD_HEIGHT - NAVIGATION_HEIGHT_64 - TABAR_HEIGHT_49)

#define headerViewHeight (180 * KWIDTH_IPHONE6_SCALE +  PAGER_HEAD_HEIGHT)

/*** 通知 ***/
/** TabBar按钮被重复点击的通知 */
NSString * const XMGTabBarButtonDidRepeatClickNotification = @"XMGTabBarButtonDidRepeatClickNotification";
/** 标题按钮被重复点击的通知 */
NSString * const XMGTitleButtonDidRepeatClickNotification = @"XMGTitleButtonDidRepeatClickNotification";


@interface JJChooserViewController ()<TCAdViewDelegate, UITableViewDelegate, JJChooseActivityDelegate, JJNearActivityDelegate>

/** UIScrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

/** 标题栏 */
@property (nonatomic, strong) UIView *titlesView;
//轮播图
@property (nonatomic, strong)TCADView *adView;
//用于存放标题栏和轮播图
@property (nonatomic, strong) UIView *topHeadView;

/** 当前选中的标题按钮 */
@property (nonatomic, weak) XMGTitleButton *selectedTitleButton;
/** 标题按钮底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;

//推荐活动控制器
@property (nonatomic, strong) JJChooseActivityViewController *chooseActivityViewController;
//附近活动控制器
@property (nonatomic, strong) JJNearActivityViewController *nearActivityViewController;

//最后tableView的滚动距离
@property(nonatomic,assign)CGFloat lastLeftY;
@property(nonatomic,assign)CGFloat lastRightY;

//最后headView的top(Y)
@property(nonatomic,assign)CGFloat lastHeadViewTop;
//左边滚动是否是手动拖动的
@property(nonatomic,assign)BOOL leftIsTcDrag;
//右边滚动是否是手动拖动的
@property(nonatomic,assign)BOOL rightIsTcDrag;

//轮播图模型数组
@property (nonatomic, strong)NSArray<JJActivityChooseADViewModel *> *activityADViewArray;


@end

@implementation JJChooserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScrollView];
    
    [self setupChildViewControllers];
    
    [self setupTitlesViewAndADView];
    
    self.lastLeftY = 0;
    self.lastRightY = 0;
    self.lastHeadViewTop = 0;
    self.leftIsTcDrag = NO;
    self.rightIsTcDrag = NO;
    

}

#pragma mark - 基本视图创建

- (void)setupChildViewControllers
{
    JJChooseActivityViewController *chooseViewController = [[JJChooseActivityViewController alloc] init];
    self.chooseActivityViewController = chooseViewController;
    chooseViewController.chooseDelegate = self;
    [self addChildViewController:chooseViewController];
    chooseViewController.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCROLL_HEIGHT) ;
    [self.scrollView addSubview:chooseViewController.tableView];
    
    
    JJNearActivityViewController *nearActivityViewController = [[JJNearActivityViewController alloc] init];
    self.nearActivityViewController = nearActivityViewController;
    nearActivityViewController.nearDelegate = self;
    [self addChildViewController:nearActivityViewController];
    nearActivityViewController.tableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCROLL_HEIGHT) ;
    [self.scrollView addSubview:nearActivityViewController.tableView];

}

- (void)setupScrollView
{
    // 不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.backgroundColor = XMGCommonBgColor;
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCROLL_HEIGHT);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(2 * SCREEN_WIDTH, 1);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setupTitlesViewAndADView
{
    self.topHeadView = [[UIView alloc]
                        initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerViewHeight)];
    self.topHeadView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topHeadView];
    [self.topHeadView addSubview:self.adView];
    [self.topHeadView addSubview:self.titlesView];
    
//    //发送轮播请求
//    NSString * ADViewRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_HOME_CAROUSEL];
//    NSDictionary *params = nil;
////    if([User getUserInformation]){
////        params = @{@"project_type" : @"2" , @"user_id" : [User getUserInformation].userId};
////    }else{
//        params = @{@"project_type" : @"2" };
////    }
//    
//    [HFNetWork postNoTipWithURL:ADViewRequesturl params:params success:^(id response) {
//        [MBProgressHUD hideHUD];
//        if (![response isKindOfClass:[NSDictionary class]]) {
//            return ;
//        }
//        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
//        if (codeValue) { //失败返回
//            NSString *codeMessage = [response objectForKey:@"error_msg"];
//            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
//            return ;
//        }
//        NSArray<JJActivityChooseADViewModel *> *modelArray = [JJActivityChooseADViewModel mj_objectArrayWithKeyValuesArray:response[@"carousel"]];
//        self.activityADViewArray = modelArray;
//        [self.adView setDataArray:modelArray];
//        if(modelArray.count <= 1) {
//            [self.adView.pageControl setHidden:YES];
//            return;
//        }
//        [self.adView setUserInteractionEnabled:YES];
//        [self.adView perform];
//        
//    } fail:^(NSError *error) {
//        NSInteger errCode = [error code];
//        DebugLog(@"errCode = %ld", errCode);
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
//    }];
}

#pragma mark - 监听点击
- (void)titleClick:(XMGTitleButton *)titleButton
{
    // 某个标题按钮被重复点击
    if (titleButton == self.selectedTitleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XMGTitleButtonDidRepeatClickNotification object:nil];
        return ;
    }
    
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    // 指示器
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = titleButton.width;
        self.indicatorView.centerX = titleButton.centerX;
        // 让UIScrollView滚动到对应位置
        CGPoint offset = self.scrollView.contentOffset;
        offset.x = titleButton.tag * self.scrollView.width;
        DebugLog(@"%@",NSStringFromCGPoint(offset));

        self.scrollView.contentOffset = offset;
    }];
    
   //    [self.scrollView setContentOffset:offset animated:YES];
    
}


//#pragma mark - 添加子控制器的view
//- (void)addChildVcView
//{
//    // 子控制器的索引
//    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
//    
//    // 取出子控制器
//    UIViewController *childVc = self.childViewControllers[index];
//    if ([childVc isViewLoaded]) return;
//    NSLog(@"%@",NSStringFromCGRect(self.scrollView.bounds));
//    childVc.view.frame = self.scrollView.bounds;
//    NSLog(@"%@",NSStringFromCGRect(self.scrollView.bounds));
//    [self.scrollView addSubview:childVc.view];
//}

#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    [self addChildVcView];
//}
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 选中\点击对应的按钮
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    XMGTitleButton *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
    
//    // 添加子控制器的view
//    [self addChildVcView];
    
    // 当index == 0时, viewWithTag:方法返回的就是self.titlesView
    //    XMGTitleButton *titleButton = (XMGTitleButton *)[self.titlesView viewWithTag:index];
}


#pragma mark - TCAdViewDelegate轮播代理
//轮播图代理
- (void)adView:(TCADView *)adView lazyLoadAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imageURL:(NSString *)imageURL
{
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    JJActivityChooseADViewModel * model = (JJActivityChooseADViewModel *)imageURL;
    DebugLog(@"%@",imageURL);
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

//选中图片
- (void)adView:(TCADView *)adView didSelectedAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imagePath:(NSString *)imagePath {
    NSInteger indexNow = index;
    if(indexNow == -1) {
        indexNow = 0;
    }
    JJActivityChooseADViewModel *model = self.activityADViewArray[indexNow];
    if(model) {
        if([model.url hasPrefix:@"http"]){
            JJADDetailViewController *adDetailVIewController = [[JJADDetailViewController alloc]init];
            adDetailVIewController.url = model.url;
            [self.navigationController pushViewController:adDetailVIewController animated:YES];
        }else if(model.associated_id.length !=0 && ![model.associated_id isEqualToString:@"0"]){
            JJActivityDetailViewController *activityDetailViewController = [[JJActivityDetailViewController alloc]init];
            
            activityDetailViewController.activityID = model.associated_id;
            [self.navigationController pushViewController:activityDetailViewController animated:YES];
        } 
    }
}

#pragma mark - 懒加载

- (TCADView *)adView {
    if(!_adView) {
        _adView = [[TCADView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADVIEW_HEIGHT)];
        _adView.displayTime = 3;
        _adView.delegate = self;
        _adView.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _adView.pageControl.pageIndicatorTintColor = NORMAL_COLOR;
        }
    return _adView;
}

- (UIView *)titlesView {
    if(!_titlesView){
        // 标题栏
        UIView *titlesView = [[UIView alloc] init];
        titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        titlesView.frame = CGRectMake(0, ADVIEW_HEIGHT, SCREEN_WIDTH, PAGER_HEAD_HEIGHT);
                _titlesView = titlesView;
        
        // 添加标题
        NSArray *titles = @[@"推荐活动", @"附近活动"];
        NSUInteger count = titles.count;
        CGFloat titleButtonW = titlesView.width / count;
        CGFloat titleButtonH = titlesView.height;
        for (NSUInteger i = 0; i < count; i++) {
            // 创建
            XMGTitleButton *titleButton = [XMGTitleButton buttonWithType:UIButtonTypeCustom];
            titleButton.tag = i;
            [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            [titlesView addSubview:titleButton];
            
            // 设置数据
            [titleButton setTitle:titles[i] forState:UIControlStateNormal];
            
            // 设置frame
            titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        }
        
        // 按钮的选中颜色
        XMGTitleButton *firstTitleButton = titlesView.subviews.firstObject;
        
        // 底部的指示器
        UIView *indicatorView = [[UIView alloc] init];
        indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
        indicatorView.height = 3;
        indicatorView.top = titlesView.height - indicatorView.height;
        [titlesView addSubview:indicatorView];
        self.indicatorView = indicatorView;
        
        // 立刻根据文字内容计算label的宽度
        [firstTitleButton.titleLabel sizeToFit];
        indicatorView.width = firstTitleButton.width;
        indicatorView.centerX = firstTitleButton.centerX;
        
        // 默认情况 : 选中最前面的标题按钮
        firstTitleButton.selected = YES;
        self.selectedTitleButton = firstTitleButton;

    }
    return _titlesView;
}

#pragma mark - Choose  And  Near   Delegate
- (void)chooseActivityViewControllerscrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.leftIsTcDrag = YES;
    self.rightIsTcDrag = NO;
}

- (void)chooseActivityViewControllerscrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
//    if(scrollView.dragging){
    if(self.leftIsTcDrag){
//        self.nearActivityViewController.tableView.scrollEnabled = NO;
//        if(scrollView.contentOffset.y <= headerViewHeight && scrollView.contentOffset.y >= 0) {
            CGPoint currentpoint= scrollView.contentOffset;
            CGFloat changeY = currentpoint.y - self.lastLeftY;
        DebugLog(@"choose  %@  self.lastLeftY %lf    changeY:  %lf   %ld",NSStringFromCGPoint(currentpoint),self.lastLeftY, changeY,scrollView.scrollEnabled);
            self.lastLeftY = currentpoint.y;
        if(changeY >= 0){//向上拖拽
            if((self.topHeadView.top - changeY) <= -headerViewHeight){
//                NSLog(@"1   %lf   %lf",self.topHeadView.top,changeY);
//                self.nearActivityViewController.tableView.contentOffset = CGPointMake(0, self.nearActivityViewController.tableView.contentOffset.y + (self.topHeadView.top + headerViewHeight));
//                [self.nearActivityViewController.tableView setContentOffset:CGPointMake(0, self.nearActivityViewController.tableView.contentOffset.y + (self.topHeadView.top + headerViewHeight))];
//                self.lastRightY = self.nearActivityViewController.tableView.contentOffset.y;
                
                self.topHeadView.transform = CGAffineTransformTranslate(self.topHeadView.transform, 0, -(self.topHeadView.top + headerViewHeight));
//                NSLog(@"%lf   ",self.nearActivityViewController.tableView.contentOffset.y);
                DebugLog(@"choose向上拖拽1   %lf    %ld",self.topHeadView.top,scrollView.scrollEnabled);
            }else{
//                self.nearActivityViewController.tableView.contentOffset = CGPointMake(0, self.nearActivityViewController.tableView.contentOffset.y + changeY);
//                [self.nearActivityViewController.tableView setContentOffset:CGPointMake(0, self.nearActivityViewController.tableView.contentOffset.y + changeY)];
//                 self.lastRightY = self.nearActivityViewController.tableView.contentOffset.y;
                self.topHeadView.transform = CGAffineTransformTranslate(self.topHeadView.transform, 0, -changeY);
                DebugLog(@"choose向上拖拽2  %lf  %ld",self.topHeadView.top,scrollView.scrollEnabled);
            }
            DebugLog(@"ee");
        }
        if(changeY < 0){//向下拖拽
            DebugLog(@"%lf   %lf    %lf",self.topHeadView.top,self.lastLeftY,changeY);
            if((-self.topHeadView.top) >= self.lastLeftY ){
//                if((self.topHeadView.top - changeY) >= 0 ){
//                    NSLog(@"1   %lf   %lf",self.topHeadView.top,changeY);
//                    self.nearActivityViewController.tableView.contentOffset = CGPointMake(0, self.nearActivityViewController.tableView.contentOffset.y + self.topHeadView.top);
//                     self.lastRightY = self.nearActivityViewController.tableView.contentOffset.y;
//                    [self.nearActivityViewController.tableView setContentOffset:CGPointMake(0, self.nearActivityViewController.tableView.contentOffset.y + self.topHeadView.top)];
//                    self.topHeadView.transform = CGAffineTransformTranslate(self.topHeadView.transform, 0, -self.topHeadView.top );
////                    NSLog(@"1   %lf",self.topHeadView.top);
//                    } else {
                DebugLog(@"ty%lf",self.topHeadView.transform.ty);
                //防止topHeadView向下移动后Y值超过0
//                if(self.topHeadView.transform.ty)
                self.topHeadView.top = -self.lastLeftY;
//                    self.topHeadView.transform = CGAffineTransformTranslate(self.topHeadView.transform, 0, -changeY);
//                    self.nearActivityViewController.tableView.contentOffset = CGPointMake(0, self.nearActivityViewController.tableView.contentOffset.y + changeY);
//                        [self.nearActivityViewController.tableView setContentOffset:CGPointMake(0, self.nearActivityViewController.tableView.contentOffset.y + changeY)];
//                    self.lastRightY = self.nearActivityViewController.tableView.contentOffset.y;
//                    NSLog(@"2");
//                }
            }
             DebugLog(@"choose向下拖拽1   %lf   %ld",self.topHeadView.top,scrollView.scrollEnabled);
        }
        DebugLog(@"%lf   %lf    %lf     %@",self.topHeadView.top,self.lastLeftY,changeY,NSStringFromCGPoint(self.nearActivityViewController.tableView.contentOffset));
        
        
        CGFloat currentHeadY = self.topHeadView.top;
        CGFloat headChangeY = currentHeadY - self.lastHeadViewTop;
        self.lastHeadViewTop = currentHeadY;
        self.nearActivityViewController.tableView.contentOffset = CGPointMake(0, self.nearActivityViewController.tableView.contentOffset.y - headChangeY);
        self.lastRightY = self.nearActivityViewController.tableView.contentOffset.y;
    }
}
//- (void)chooseActivityViewControllerscrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    
////    self.nearActivityViewController.tableView.scrollEnabled = YES;
////    DebugLog(@"%s",__func__);
//    NSLog(@"%s  lastHeadViewTop:%lf   currentHeadY:%lf    self.nearActivityViewController.tableView.contentOffset%@",__func__,self.lastHeadViewTop,self.topHeadView.top,NSStringFromCGPoint(self.nearActivityViewController.tableView.contentOffset));
//
//    CGFloat currentHeadY = self.topHeadView.top;
//    CGFloat changeY = currentHeadY - self.lastHeadViewTop;
//    self.lastHeadViewTop = currentHeadY;
//    self.nearActivityViewController.tableView.contentOffset = CGPointMake(0, self.nearActivityViewController.tableView.contentOffset.y - changeY);
//    self.lastRightY = self.nearActivityViewController.tableView.contentOffset.y;
//    NSLog(@"%s self.nearActivityViewController.tableView.contentOffset%@     changeY%lf",__func__,NSStringFromCGPoint(self.nearActivityViewController.tableView.contentOffset),changeY);
//}
//
//- (void)chooseActivityViewControllerscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
////    self.nearActivityViewController.tableView.scrollEnabled = YES;
////    DebugLog(@"%s",__func__);
//    NSLog(@"%s  lastHeadViewTop:%lf   currentHeadY:%lf    self.nearActivityViewController.tableView.contentOffset%@",__func__,self.lastHeadViewTop,self.topHeadView.top,NSStringFromCGPoint(self.nearActivityViewController.tableView.contentOffset));
//    CGFloat currentHeadY = self.topHeadView.top;
//    CGFloat changeY = currentHeadY - self.lastHeadViewTop;
//    self.lastHeadViewTop = currentHeadY;
//    self.nearActivityViewController.tableView.contentOffset = CGPointMake(0, self.nearActivityViewController.tableView.contentOffset.y - changeY);
//    self.lastRightY = self.nearActivityViewController.tableView.contentOffset.y;
// NSLog(@"%s self.nearActivityViewController.tableView.contentOffset%@     changeY%lf",__func__,NSStringFromCGPoint(self.nearActivityViewController.tableView.contentOffset),changeY);
//}

- (void)chooseActivityViewControllerSendRequestAndResultModelArray:(NSArray<JJActivityChooseADViewModel *> *)modelArray {
    self.activityADViewArray = modelArray;
    [self.adView setDataArray:modelArray];
    for (UIView *subView in self.adView.pageControl.subviews) {
        [subView createBordersWithColor:NORMAL_COLOR withCornerRadius:4 andWidth:1];
    }
    if(modelArray.count <= 1) {
        [self.adView.pageControl setHidden:YES];
        return;
    }
    [self.adView perform];
    [self.adView setUserInteractionEnabled:YES];
    

}



- (void)nearActivityViewControllerscrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.rightIsTcDrag = YES;
    self.leftIsTcDrag = NO;
}

- (void)nearActivityViewControllerscrollViewDidScroll:(UIScrollView *)scrollView
{
//    self.chooseActivityViewController.tableView.scrollEnabled = NO;
//    if(scrollView.dragging){
    if(self.rightIsTcDrag){
//      self.chooseActivityViewController.tableView.scrollEnabled = NO;
        
        CGPoint currentpoint= scrollView.contentOffset;
        CGFloat changeY = currentpoint.y - self.lastRightY;
        self.lastRightY = currentpoint.y;
        DebugLog(@"near  %@   changeY:  %lf      %ld",NSStringFromCGPoint(currentpoint),changeY,scrollView.scrollEnabled);
        if(changeY > 0){//向上拖拽
            if((self.topHeadView.top - changeY) <= -headerViewHeight){
//                NSLog(@"1   %lf   %lf",self.topHeadView.top,changeY);
                
//                self.chooseActivityViewController.tableView.contentOffset = CGPointMake(0, self.chooseActivityViewController.tableView.contentOffset.y + (self.topHeadView.top + headerViewHeight));
//                [self.chooseActivityViewController.tableView setContentOffset:CGPointMake(0, self.chooseActivityViewController.tableView.contentOffset.y + (self.topHeadView.top + headerViewHeight))];
//                self.lastLeftY = self.chooseActivityViewController.tableView.contentOffset.y;
                
                self.topHeadView.transform = CGAffineTransformTranslate(self.topHeadView.transform, 0, -(self.topHeadView.top + headerViewHeight));
                
                
//                NSLog(@"%lf   ",self.nearActivityViewController.tableView.contentOffset.y);
                
                //                NSLog(@"1   %lf",self.topHeadView.top);
                DebugLog(@"near向上拖拽1   %lf    %ld",self.topHeadView.top,scrollView.scrollEnabled);
            }else{
                
//                self.chooseActivityViewController.tableView.contentOffset = CGPointMake(0, self.chooseActivityViewController.tableView.contentOffset.y + changeY);
//                [self.chooseActivityViewController.tableView setContentOffset:CGPointMake(0, self.chooseActivityViewController.tableView.contentOffset.y + changeY)];
//                self.lastLeftY = self.chooseActivityViewController.tableView.contentOffset.y;
                
                self.topHeadView.transform = CGAffineTransformTranslate(self.topHeadView.transform, 0, -changeY);
                
                DebugLog(@"near向上拖拽2  %lf   %ld",self.topHeadView.top,scrollView.scrollEnabled);
                //                NSLog(@"2");
            }
            DebugLog(@"ee");
        }
        
        if(changeY < 0){//向下拖拽
//            NSLog(@"%lf   %lf    %lf",self.topHeadView.top,self.lastLeftY,changeY);
            if((-self.topHeadView.top) >= self.lastRightY ){
//                if((self.topHeadView.top - changeY) >= 0 ){
                    //                    NSLog(@"1   %lf   %lf",self.topHeadView.top,changeY);
                    
//                    self.chooseActivityViewController.tableView.contentOffset = CGPointMake(0, self.chooseActivityViewController.tableView.contentOffset.y + self.topHeadView.top);
//                    [self.chooseActivityViewController.tableView setContentOffset:CGPointMake(0, self.chooseActivityViewController.tableView.contentOffset.y + self.topHeadView.top)];
//                    self.lastLeftY = self.chooseActivityViewController.tableView.contentOffset.y;
                self.topHeadView.top = -self.lastRightY;
//                    self.topHeadView.transform = CGAffineTransformTranslate(self.topHeadView.transform, 0, -self.topHeadView.top );
                    //                    NSLog(@"1   %lf",self.topHeadView.top);
                    
//                }else{
//                    self.topHeadView.transform = CGAffineTransformTranslate(self.topHeadView.transform, 0, -changeY);
//                    self.chooseActivityViewController.tableView.contentOffset = CGPointMake(0, self.chooseActivityViewController.tableView.contentOffset.y + changeY);
//                    [self.chooseActivityViewController.tableView setContentOffset:CGPointMake(0, self.chooseActivityViewController.tableView.contentOffset.y + changeY)];
//                    self.lastLeftY = self.chooseActivityViewController.tableView.contentOffset.y;
                    //                    NSLog(@"2");
//                }
            }
            DebugLog(@"near向下拖拽1   %lf    %ld",self.topHeadView.top,scrollView.scrollEnabled);
        }
        CGFloat currentHeadY = self.topHeadView.top;
        CGFloat headChangeY = currentHeadY - self.lastHeadViewTop;
        self.lastHeadViewTop = currentHeadY;
        self.chooseActivityViewController.tableView.contentOffset = CGPointMake(0, self.chooseActivityViewController.tableView.contentOffset.y - headChangeY);
        self.lastLeftY = self.chooseActivityViewController.tableView.contentOffset.y;
    }
}
//- (void)nearActivityViewControllerscrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    //    self.chooseActivityViewController.tableView.scrollEnabled = YES;
//    //    DebugLog(@"%s",__func__);
//    NSLog(@"%s  lastHeadViewTop:%lf   currentHeadY:%lf    self.chooseActivityViewController.tableView.contentOffset%@",__func__,self.lastHeadViewTop,self.topHeadView.top,NSStringFromCGPoint(self.chooseActivityViewController.tableView.contentOffset));
//    CGFloat currentHeadY = self.topHeadView.top;
//    CGFloat changeY = currentHeadY - self.lastHeadViewTop;
//    self.lastHeadViewTop = currentHeadY;
//    self.chooseActivityViewController.tableView.contentOffset = CGPointMake(0, self.chooseActivityViewController.tableView.contentOffset.y - changeY);
//    self.lastLeftY = self.chooseActivityViewController.tableView.contentOffset.y;
//    NSLog(@"%s self.chooseActivityViewController.tableView.contentOffset%@     changeY%lf",__func__,NSStringFromCGPoint(self.chooseActivityViewController.tableView.contentOffset),changeY);
//}
//
//- (void)nearActivityViewControllerscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
////    self.chooseActivityViewController.tableView.scrollEnabled = YES;
////    DebugLog(@"%s",__func__);
//    NSLog(@"%s  lastHeadViewTop:%lf   currentHeadY:%lf    self.chooseActivityViewController.tableView.contentOffset%@",__func__,self.lastHeadViewTop,self.topHeadView.top,NSStringFromCGPoint(self.chooseActivityViewController.tableView.contentOffset));
//    CGFloat currentHeadY = self.topHeadView.top;
//    CGFloat changeY = currentHeadY - self.lastHeadViewTop;
//    self.lastHeadViewTop = currentHeadY;
//    self.chooseActivityViewController.tableView.contentOffset = CGPointMake(0, self.chooseActivityViewController.tableView.contentOffset.y - changeY);
//    self.lastLeftY = self.chooseActivityViewController.tableView.contentOffset.y;
//    NSLog(@"%s self.chooseActivityViewController.tableView.contentOffset%@     changeY%lf",__func__,NSStringFromCGPoint(self.chooseActivityViewController.tableView.contentOffset),changeY);
//}
@end
