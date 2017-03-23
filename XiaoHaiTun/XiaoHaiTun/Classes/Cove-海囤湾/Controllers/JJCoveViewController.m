//
//  JJCoveViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJCoveViewController.h"
#import "JJCoveViewController.h"
#import "JJCoverNotRecommendViewController.h"
#import "TCViewPager.h"
#import "JJRecommendViewController.h"
#import "JJCoveBaseViewController.h"
#import "UIBarButtonItem+Fast.h"
#import "JJCodeScanViewController.h"
#import "LBXScanView.h"
#import <objc/message.h>
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
//#import "MXNavigationBarManager.h"
#import "JJSortedViewController.h"
//#import "MXNavigationBarManager.h"
#import "HFNetWork.h"
#import "MBProgressHUD+gifHUD.h"
#import "JJSortedCellModel.h"
#import <MJExtension.h>
#import "UINavigationBar+Awesome.h"
#import "UIView+XPNotNetWork.h"
#import "User.h"

@interface JJCoveViewController ()

//父子控制视图
@property (nonatomic, strong) TCViewPager *viewPager;

@property (nonatomic, strong) NSArray<JJSortedCellModel *> *sortModelArray;



@end

@implementation JJCoveViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.tipTryOnceView];
    
     //去除scrollerView的自动压缩
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
//    [self.tipTryOnceView.tryLoadButton addTarget:self action:@selector(requestGoods) forControlEvents:UIControlEventTouchUpInside];
    [self requestGoods];
}

- (void)requestGoods{
    DebugLog(@"============================================");
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        weakSelf(weakSelf);
        [self.view showNoNetWorkWithTryAgainBlock:^{
            [weakSelf requestGoods];
        }];
        return ;
    }
    [self.view hideNoNetWork];
    User *user = [User getUserInformation];
    [HFNetWork getWithURL:[NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_CATEGORY_GOODS] params:nil success:^(id response) {
        
        DebugLog(@"+++++++++++++++++++++++++++++++++++++++");
        if (![response isKindOfClass:[NSDictionary class]]) {
            [MBProgressHUD hideHUD];
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD hideHUD];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        
        
        self.sortModelArray = [JJSortedCellModel mj_objectArrayWithKeyValuesArray:response[@"categorys"]];
        [self.view addSubview:self.viewPager];
    } fail:^(NSError *error) {
        
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        weakSelf(weakSelf);
        [self.view showNoNetWorkWithTryAgainBlock:^{
            [weakSelf requestGoods];
        }];
    }];
}

- (void)setupNavigationBar {
    [self.navigationController.navigationBar lt_setBackgroundColor:NORMAL_COLOR];
    //required
//    [MXNavigationBarManager managerWithController:self];
//    [MXNavigationBarManager setBarColor:NORMAL_COLOR];
//    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cover_TitleImage"]];
    self.navigationItem.title = @"小海囤";
    // 创建左边的按钮
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Nav_Search"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSort)];
    
    // 创建右边的按钮
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Nav_Scan"] style:UIBarButtonItemStylePlain target:self action:@selector(pushCodeScan)];
}


//跳转到分类
- (void)pushSort {

    //创建分类视图控制器
    JJSortedViewController *sortViewController = [[JJSortedViewController alloc]init];
    [self.navigationController pushViewController:sortViewController animated:YES];
}

//跳转到二维码扫描
- (void)pushCodeScan {
    
    if (![self cameraPemission])
    {
        [self showError:@"没有摄像机权限"];
        return;
    }
    //设置扫码区域参数设置
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
   //扫码框周围4个角的类型设置为在框的上面
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //码框周围4个角的颜色
    style.colorAngle = NORMAL_COLOR;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    JJCodeScanViewController *codeScanViewController = [[JJCodeScanViewController alloc]init];
    codeScanViewController.style = style;
    
//    codeScanViewController.isQQSimulator = YES;
//    codeScanViewController.isVideoZoom = YES;
    [self.navigationController pushViewController:codeScanViewController animated:YES];
}

//是否允许打开相机
- (BOOL)cameraPemission
{
    BOOL isHavePemission = NO;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    return isHavePemission;
}

- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了",nil];
}

#pragma mark - 懒加载

- (TCViewPager *)viewPager
{
    if(_viewPager == nil) {
        
        //创建添加子视图控制器
        //推荐
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        JJRecommendViewController *recommendViewController = [[JJRecommendViewController alloc]initWithCollectionViewLayout:layout];
        JJSortedCellModel *sortModel = [[JJSortedCellModel alloc]init];
        sortModel.categoryID = @"0";
        sortModel.name = @"推荐";
        recommendViewController.sortModel = sortModel;
        [self addChildViewController:recommendViewController];
        
//        //辅食
//         UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc]init];
//        UIViewController *goodsViewController =[[JJCoverNotRecommendViewController alloc]initWithCollectionViewLayout:layout1];
//        [self addChildViewController:goodsViewController];
        
        //标题数组
        NSMutableArray *titleArray = [NSMutableArray array];
        [titleArray addObject:sortModel.name];
        //控制器数组
        NSMutableArray *controllerArray = [NSMutableArray array];
        [controllerArray addObject:recommendViewController];
        
        
        for(JJSortedCellModel *model in self.sortModelArray) {
            [titleArray addObject:model.name];
            
            UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc]init];
            JJCoverNotRecommendViewController *goodsViewController =[[JJCoverNotRecommendViewController alloc]initWithCollectionViewLayout:layout1];
            [self addChildViewController:goodsViewController];
            goodsViewController.sortModel = model;
            [controllerArray addObject:goodsViewController];
        }
        CGFloat titlePageW = 0;
        if(titleArray.count <= 5 ){
            titlePageW = SCREEN_WIDTH / titleArray.count;
        }else{
            titlePageW = 80 * KWIDTH_IPHONE6_SCALE;
        }
        DebugLog(@"%lf",self.view.height);
        _viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT_64, self.view.width, self.view.height - NAVIGATION_HEIGHT_64 ) titles:titleArray icons:nil selectedIcons:nil views:controllerArray titlePageW: titlePageW selectedLabelScale:0.7];
        
        //不显示竖直分割
        _viewPager.showVLine = NO;
        
        //动画
        _viewPager.showAnimation = YES;
//        _viewPager.enabledScroll = NO;
        
        //title颜色
        _viewPager.tabTitleColor = [UIColor blackColor];
        
        //选中状态title颜色
        _viewPager.tabSelectedTitleColor = NORMAL_COLOR;//[UIColor colorWithRed:0.627 green:0.176 blue:0.169 alpha:1.000];
        
        //菜单按钮下方横线选中状态颜色
        _viewPager.tabSelectedArrowBgColor = NORMAL_COLOR;//[UIColor colorWithRed:0.784 green:0.259 blue:0.251 alpha:1.000];
        
        //菜单按钮下方横线颜色
        _viewPager.tabArrowBgColor = [UIColor colorWithWhite:0.929 alpha:1.000];
        
    }
    return _viewPager;
}


@end
