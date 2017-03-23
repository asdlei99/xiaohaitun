//
//  JJActivityViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityViewController.h"
#import "TCViewPager.h"
#import "JJChooserViewController.h"
#import "JJActivityBaseViewController.h"
#import "JJActivitySortViewController.h"
//#import "MXNavigationBarManager.h"
#import "HFNetWork.h"
#import "MBProgressHUD+gifHUD.h"
#import "JJActivitySortModel.h"
#import <MJExtension.h>
#import <CoreLocation/CoreLocation.h>
#import "UINavigationBar+Awesome.h"
#import "UIView+XPKit.h"
#import "UIImage+XPKit.h"
#import "UIViewController+KeyboardCorver.h"
#import <ReactiveCocoa.h>
#import "UIView+XPNotNetWork.h"

@interface JJActivityViewController ()<CLLocationManagerDelegate , UISearchBarDelegate>

//父子控制视图
@property (nonatomic, strong) TCViewPager *viewPager;

@property (nonatomic, strong) NSArray<JJActivitySortModel *> *sortModelArray;

//管理者
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UILabel *leftBarLabel;


//搜索BackView
@property (nonatomic, strong) UIView *searchBackView;
//搜索View
@property (nonatomic, strong) UIView *searchView;
//搜索条
@property (nonatomic, strong) UISearchBar *searchBar;
//搜索按钮
@property (nonatomic, strong) UIButton *searchBtn;

@end


@implementation JJActivityViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:NORMAL_COLOR];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //基本设置
    [self setupNavigationBar];
    //发起网络请求
    [self activityCategoryRequest];
//    [self.tipTryOnceView.tryLoadButton addTarget:self action:@selector(activityCategoryRequest) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - 发起网络请求
- (void)activityCategoryRequest {
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        weakSelf(weakSelf)
        [self.view showNoNetWorkWithTryAgainBlock:^{
            [weakSelf activityCategoryRequest];
        }];
        return ;
    }
    [self.view hideNoNetWork];
    
    [HFNetWork getWithURL:[NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_CATEGORY_ACTIVITY] params:nil success:^(id response) {
        
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        
        self.sortModelArray = [JJActivitySortModel mj_objectArrayWithKeyValuesArray:response[@"categories"]];
        [self.view addSubview:self.viewPager];
    } fail:^(NSError *error) {
        
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        weakSelf(weakSelf);
        [self.view showNoNetWorkWithTryAgainBlock:^{
            [weakSelf activityCategoryRequest];
        }];
    }];

}

//定位
- (void)location {
    //iOS8+询问用户是否允许定位 (前台和后台; 只运行前台)
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        //使用期间定位(前台定位)
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        //小于8.0
        [self.locationManager startUpdatingLocation];
    }
}


//设置导航条内容
- (void)setupNavigationBar {
    //去除scrollerView的自动压缩
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"亲子活动";
//    [MXNavigationBarManager managerWithController:self];
//    [MXNavigationBarManager setBarColor:NORMAL_COLOR];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Nav_Search"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoSortActivity)];
    UILabel *label = [[UILabel alloc]init];
    self.leftBarLabel = label;
    label.textColor = [UIColor whiteColor];
    label.text = @"北京";
    label.frame = CGRectMake(0, 0, 100, 50);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:label];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark --- CLLocationManagerDelegate
//明确用户是否允许定位
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            DebugLog(@"用户允许定位啦");
            //设定一下定位的准确性
            self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
            [self.locationManager startUpdatingLocation];
            //开始定位
            break;
        case kCLAuthorizationStatusDenied:
        {
            DebugLog(@"用户不允许定位");
            //发出通知
            [[NSNotificationCenter defaultCenter]postNotificationName:LocationNotificatiion object:nil userInfo:nil];
            break;
        }
        default:
            break;
    }
}


//通知用户的位置 (调用多次)
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //locations数组: 按照一定的先后顺序添加，数组中的最后一项是最新的位置
    CLLocation *location = [locations lastObject];
    DebugLog(@"latitude:%f, longtitude:%f", location.coordinate.latitude, location.coordinate.longitude);
    //发出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:LocationNotificatiion object:nil userInfo:@{@"location" : location}];
    [self clickGeodecoder:location];
    //手动停止定位的功能
    [self.locationManager stopUpdatingLocation];
}

- (void)clickGeodecoder:(CLLocation *)location{
    //反地理编码(给定经纬度 --> 详细信息)
    //1.创建地理编码对象
    CLGeocoder* geocoder=[CLGeocoder new];
    //根据经纬度反向地理编译出地址信息
    //2.发送请求
    if(location != nil) {
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
         {
             if (array.count > 0)
             {
                 CLPlacemark *placemark = [array objectAtIndex:0];
                 DebugLog(@"%@",placemark.addressDictionary);
                 //NSLog(@%@,placemark.name);//具体位置
                 //获取城市
                 NSString *city = placemark.locality;
                 if (!city) {
                     //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                     city = placemark.administrativeArea;
                 }
                 //             cityName = city;
                 DebugLog(@"定位完成:%@",city);
                 self.leftBarLabel.text = city;
                 
                 //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
                 //             [self.locationManager stopUpdatingLocation];
             }else if (error == nil && [array count] == 0)
             {
                 DebugLog(@"No results were returned.");
             }else if (error != nil)
             {
                 DebugLog(@"An error occurred = %@, error");
             }
         }];
    }
}


//前往活动排序页
- (void)gotoSortActivity {
    self.searchBackView.hidden = NO;
    [self.searchBar becomeFirstResponder];
//    [self.navigationController pushViewController:[[JJActivitySortViewController alloc]init] animated:YES];
}

#pragma mark - UISearchBarDelegate

//开始编辑文字,即键盘弹出来那下
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchBtn.enabled = searchBar.text.length > 0 ? YES : NO;
}
//键盘收回,结束编辑
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}
//搜索框里的文字发生变化,正在编辑
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.searchBtn.enabled = searchText.length > 0 ? YES : NO;
    DebugLog(@"%ld",self.searchBtn.hidden);
}
//点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    self.searchBackView.hidden = YES;
//    JJActivitySortViewController *activitySortViewController = [[JJActivitySortViewController alloc]init];
//    activitySortViewController.keyWord = self.searchBar.text;
//    [self.navigationController pushViewController:activitySortViewController animated:YES];
    JJActivityBaseViewController *searchViewController = [[JJActivityBaseViewController alloc]init];
    JJActivitySortModel *sortModel = [[JJActivitySortModel alloc]init];
    sortModel.keyWord = self.searchBar.text;
    DebugLog(@"%@",sortModel.keyWord);
    searchViewController.sortModel = sortModel;
    
    [self.navigationController pushViewController:searchViewController animated:YES];
    self.searchBar.text = nil;
}

#pragma mark - 懒加载

- (TCViewPager *)viewPager
{
    if(_viewPager == nil) {
        //推荐
        JJChooserViewController *chooseViewController = [[JJChooserViewController alloc]init];
        JJActivitySortModel *sortModel = [[JJActivitySortModel alloc]init];
        sortModel.categoryID = @"0";
        sortModel.name = @"推荐";
        chooseViewController.sortModel = sortModel;
        [self addChildViewController:chooseViewController];
       
//        //早教
//        JJActivityBaseViewController *earlyEducationViewController =[[JJActivityBaseViewController alloc]init];
//        [self addChildViewController:earlyEducationViewController];
       
        //标题数组
        NSMutableArray *titleArray = [NSMutableArray array];
        [titleArray addObject:sortModel.name];
        //控制器数组
        NSMutableArray *controllerArray = [NSMutableArray array];
        [controllerArray addObject:chooseViewController];
        for(JJActivitySortModel *model in self.sortModelArray) {
            [titleArray addObject:model.name];
            UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc]init];
            JJActivityBaseViewController *goodsViewController =[[JJActivityBaseViewController alloc]init];
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
        _viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT_64, self.view.width, self.view.height - NAVIGATION_HEIGHT_64 ) titles:titleArray icons:nil selectedIcons:nil views:controllerArray titlePageW: titlePageW selectedLabelScale:0.7];
        _viewPager.showVLine = NO;
        _viewPager.showAnimation = YES;
        //        _viewPager.enabledScroll = NO;
        _viewPager.tabTitleColor = [UIColor blackColor];
        _viewPager.tabSelectedTitleColor = NORMAL_COLOR;
        _viewPager.tabSelectedArrowBgColor = NORMAL_COLOR;
        _viewPager.tabArrowBgColor = [UIColor colorWithWhite:0.929 alpha:1.000];
        //定位
        [self location];
    }
    return _viewPager;
}

- (CLLocationManager *)locationManager {
    if(!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        //精准度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    }
    return _locationManager;
}

//- (UISearchBar *)searchBar {
//    if(_searchBar == nil) {
//        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        _searchBar.backgroundColor = [UIColor greenColor];
//        _searchBar.placeholder = @"请输入搜索关键字";
//        [self.navigationController.navigationBar addSubview:_searchBar];
////        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.left.top.right.bottom.equalTo(self.navigationController.navigationBar);
////        }];
//    }
//    return _searchBar;
//}
- (UIView *)searchBackView {
    if(!_searchBackView) {
        _searchBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _searchBackView.backgroundColor = RGBA(214, 214, 214, 0.5);
        __weak typeof(_searchBackView)searchV = _searchBackView;
        weakSelf(weakself);
        [_searchBackView whenTapped:^{
            [weakself.searchBar resignFirstResponder];
            searchV.hidden = YES;
            weakself.searchBar.text = nil;
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:_searchBackView];
        
        self.searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_HEIGHT_64)];
        self.searchView.backgroundColor = NORMAL_COLOR;
        [self.searchBackView addSubview:self.searchView];
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(40, 20, SCREEN_WIDTH - 100, NAVIGATION_HEIGHT_44)];
        self.searchBar.delegate = self;
//        self.searchBar.searchBarStyle = UISearchBarStyleProminent;
        //修改背景颜色但是不会修改搜索textField颜色
        self.searchBar.barTintColor = NORMAL_COLOR;
        //设置这个颜色值会影响搜索框中的光标的颜色
        self.searchBar.tintColor = NORMAL_COLOR;
        self.searchBar.placeholder = @"请输入搜索关键字";
        [self.searchView addSubview:self.searchBar];
        //上下两条线把上下黑边挡住
        UIView *topLineView = [[UIView alloc]init];
        topLineView.backgroundColor = NORMAL_COLOR;
        [self.searchBar addSubview:topLineView];
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.searchBar);
            make.height.equalTo(@1);
        }];
        UIView *bottomLineView = [[UIView alloc]init];
        bottomLineView.backgroundColor = NORMAL_COLOR;
        [self.searchBar addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.searchBar);
            make.height.equalTo(@1);
        }];
        self.searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.searchBar.right, 20, 60, 44)];
        [self.searchBtn addTarget:self action:@selector(searchBarSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [self.searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.searchBtn setTitleColor:RGB(238, 238, 238) forState:UIControlStateDisabled];
        [self.searchView addSubview:self.searchBtn];
    }
    return _searchBackView;
}


@end
