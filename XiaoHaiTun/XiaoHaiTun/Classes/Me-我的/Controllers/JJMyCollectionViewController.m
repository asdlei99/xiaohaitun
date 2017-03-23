
#import "JJMyCollectionViewController.h"
#import "JJMyCollectionCell.h"
#import "JJMyCollectionModel.h"
#import "JJCollectionMenuView.h"
#import "USer.h"
#import <MJExtension.h>
#import "MBProgressHUD+gifHUD.h"
#import "HFNetWork.h"
#import "JJGoodsDetailViewController.h"
#import "MJRefresh.h"
#import "Util.h"
#import "JJMyCollectionGoodsViewController.h"
#import "JJMyCollectionActivityViewController.h"
#import "TCViewPager.h"

@interface JJMyCollectionViewController ()<UIGestureRecognizerDelegate>

//父子控制视图
@property (nonatomic, strong) TCViewPager *viewPager;

@property(nonatomic,assign)NSInteger currentVCIndex;

@property (nonatomic, strong)   JJMyCollectionGoodsViewController *myCollectionGoodsViewController ;
@property (nonatomic, strong)JJMyCollectionActivityViewController *myCollectionActivityViewController;


@end

@implementation JJMyCollectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentVCIndex = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.viewPager];
    self.navigationItem.title = @"我的收藏";
    //编辑按钮
    UIBarButtonItem *editButton= [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtn:)];
        self.navigationItem.rightBarButtonItem =editButton;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

//点击RightButtonItem
- (void)editBtn:(UIBarButtonItem *)button {

    //支持同时选中多行

    //    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    if(self.currentVCIndex == 0) {
        [self.myCollectionGoodsViewController editBtn:button];
    }else{
        [self.myCollectionActivityViewController editBtn:button];
    }
}

#pragma mark - 懒加载

- (TCViewPager *)viewPager
{
    if(_viewPager == nil) {
        //创建添加子视图控制器
        //我的收藏商品
        JJMyCollectionGoodsViewController *myCollectionGoodsViewController = [[JJMyCollectionGoodsViewController alloc]init];
        self.myCollectionGoodsViewController = myCollectionGoodsViewController;
        [self addChildViewController:myCollectionGoodsViewController];
        //我的收藏活动
        JJMyCollectionActivityViewController *myCollectionActivityViewController = [[JJMyCollectionActivityViewController alloc]init];
        self.myCollectionActivityViewController = myCollectionActivityViewController;
        [self addChildViewController:myCollectionActivityViewController];
        _viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT_64, self.view.width, SCREEN_HEIGHT - NAVIGATION_HEIGHT_64 ) titles:@[@"商品收藏", @"活动收藏"] icons:nil selectedIcons:nil views:@[myCollectionGoodsViewController,myCollectionActivityViewController] titlePageW: SCREEN_WIDTH / 2 selectedLabelScale:1.0];
        
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
        weakSelf(weakSelf);
        
        [_viewPager didSelectedBlock:^(id viewPager, NSInteger index) {
            DebugLog(@"%ld",index);
            weakSelf.currentVCIndex = index;
            if(weakSelf.currentVCIndex == 0) {
                [self.navigationItem.rightBarButtonItem setTitle:self.myCollectionGoodsViewController.tableView.editing ? @"完成" : @"编辑"];
            }else{
                [self.navigationItem.rightBarButtonItem setTitle:self.myCollectionActivityViewController.tableView.editing ? @"完成" : @"编辑"];
            }
        }];
    }
    return _viewPager;
}

@end






































////
////  JJMyCollectionViewViewController.m
////  XiaoHaiTun
////
////  Created by 唐天成 on 16/9/11.
////  Copyright © 2016年 唐天成. All rights reserved.
////
//
//#import "JJMyCollectionViewController.h"
//#import "JJMyCollectionCell.h"
//#import "JJMyCollectionModel.h"
//#import "JJCollectionMenuView.h"
//#import "USer.h"
//#import <MJExtension.h>
//#import "MBProgressHUD+gifHUD.h"
//#import "HFNetWork.h"
//#import "JJGoodsDetailViewController.h"
//#import <MJRefresh.h>
//#import "Util.h"
//
//
//static NSString * const MyCollectionCellIdentifier = @"JJMyCollectionCellIdentifier";
//
//
//@interface JJMyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
//@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic,strong) JJCollectionMenuView *collectionMenuView;
//
//
//@property (nonatomic, strong) NSMutableArray<JJMyCollectionModel *> *modelArray;
//
//@property (nonatomic, strong) NSMutableArray<JJMyCollectionModel *> *deleteArr;
//
//@end
//
//@implementation JJMyCollectionViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self initBaseView];
//    [self basicSet];
//    [self.tableView.mj_header beginRefreshing];
//    
//}
//-(void)dealloc{
//    
//}
////基本内容设置
//- (void)basicSet {
//    self.navigationItem.title = @"我的收藏";
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = RGBA(238, 238, 238, 1);
//    
//    [self.tableView registerClass:[JJMyCollectionCell class] forCellReuseIdentifier:MyCollectionCellIdentifier];
//    self.tableView.tableFooterView = [UIView new];
//    //下拉刷新
//    weakSelf(wealSelf)
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        if (![Util isNetWorkEnable]) {//先判断网络状态
//            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
//            [wealSelf.tableView.mj_header endRefreshing];
//            return ;
//        }
//            [wealSelf requestCollectionQuery];
//        
//    }];
//}
////
//////创建视图
//- (void)initBaseView {
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    [self.view addSubview:self.tableView];
//    
//    JJCollectionMenuView *collectionMenuView = [JJCollectionMenuView collectionMenuView];
//    self.collectionMenuView = collectionMenuView;
//    self.collectionMenuView.hidden = YES;
//    [self.view addSubview:collectionMenuView];
//    
//    weakSelf(weakself);
//    collectionMenuView.deleteBlock = ^{
//        if (weakself.tableView.editing) {
//            NSLog(@"%ld",weakself.deleteArr.count);
//            [weakself requestDeleteCollect];
//        }
//    };
//
//    collectionMenuView.allSelectBlock = ^(BOOL selected){
//        if (weakself.tableView.editing) {
//            if(selected){
//                for (int i = 0; i < weakself.modelArray.count; i ++) {
//                    
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//                    //选中所有的
//                    [weakself.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
////                    deleteArr等于所有
//                    [weakself.deleteArr removeAllObjects];
//                    [weakself.deleteArr addObjectsFromArray:weakself.modelArray];
//                }
//            }else{
//                for (int i = 0; i < weakself.modelArray.count; i ++) {
//                    
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//                    //不选中所有的
//                    [weakself.tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//                    [weakself.deleteArr removeAllObjects];
//                }
//            }
//        }
//    };
//    [collectionMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.height.equalTo(@49);
//    }];
//
//    //编辑按钮
//    UIBarButtonItem *editButton= [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtn:)];
//    self.navigationItem.rightBarButtonItem =editButton;
//}
//
////#pragma mark - 发出收藏网络请求
////
//////发出我的收藏列表请求
//- (void)requestCollectionQuery {
//    NSString * deleteCartRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_COLLECT_QUERY];
//    NSDictionary * params = @{@"user_id" : [User getUserInformation].userId};
//    [HFNetWork postWithURL:deleteCartRequesturl params:params success:^(id response) {
//        [MBProgressHUD hideHUD];
//        if (![response isKindOfClass:[NSDictionary class]]) {
//            return ;
//        }
//        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
//        if (codeValue) {
//            NSString *codeMessage = [response objectForKey:@"error_msg"];
//            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
//            return ;
//        }
//
//        self.modelArray = [JJMyCollectionModel mj_objectArrayWithKeyValuesArray:response[@"items"]];
//        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
//    } fail:^(NSError *error) {
//        [MBProgressHUD hideHUD];
//        NSInteger errCode = [error code];
//        DebugLog(@"errCode = %ld", errCode);
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
//        [self.tableView.mj_header endRefreshing];
//    }];
//}
////发出删除收藏请求
//- (void)requestDeleteCollect {
//    NSString * deleteCollectRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_COLLECT_DELETE];
//    NSMutableArray *deleteArray = [NSMutableArray array];
//    for(JJMyCollectionModel *model in self.deleteArr) {
//        [deleteArray addObject:model.goodsID];
//    }
//    
//    NSDictionary *params = @{@"user_id" : [User getUserInformation].userId, @"item_list" : deleteArray};
//    [HFNetWork postWithURL:deleteCollectRequesturl params:params success:^(id response) {
//        [MBProgressHUD hideHUD];
//        if (![response isKindOfClass:[NSDictionary class]]) {
//            return ;
//        }
//        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
//        if (codeValue) {
//            NSString *codeMessage = [response objectForKey:@"error_msg"];
//            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
//            return ;
//        }
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"删除成功" hudMode:MBProgressHUDModeText];
//        [self.modelArray removeObjectsInArray:self.deleteArr];
//        [self.deleteArr removeAllObjects];
//        [self.tableView reloadData];
//    } fail:^(NSError *error) {
//        [MBProgressHUD hideHUD];
//        NSInteger errCode = [error code];
//        DebugLog(@"errCode = %ld", errCode);
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
//    }];
//
//}
//
//
////点击RightButtonItem
//- (void)editBtn:(UIBarButtonItem *)button {
//    
//    //支持同时选中多行
//    
//    //    self.tableView.allowsMultipleSelectionDuringEditing = YES;
//    
//    [self.tableView setEditing:!self.tableView.editing animated:YES];
//    
//    if (self.tableView.editing) {
//        
//        self.collectionMenuView.hidden = NO;
//        [button setTitle:@"完成"];
//        //        [button setTitle:@"完成" forState:UIControlStateNormal];
//        
//    }else{
//        
//        self.collectionMenuView.hidden = YES;
//        [self.deleteArr removeAllObjects];
//        self.collectionMenuView.allSelectedBtn.selected = NO;
//        [button setTitle:@"编辑"];
//        
//    }
//    
//}
//
//
//
//#pragma mark - TableViewDataSource ||TableViewDelegate
//
////选择你要对表进行处理的方式  默认是删除方式
//
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//    
//}
//
////******//选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(tableView.editing){
//    [self.deleteArr addObject:[self.modelArray objectAtIndex:indexPath.row]];
//    }
//    else
//    {
//        JJGoodsDetailViewController *goodsDetailViewController = [[JJGoodsDetailViewController alloc]init];
//                JJMyCollectionModel *model = self.modelArray[indexPath.row];
//                goodsDetailViewController.goodsID = model.goodsID;
//                [self.navigationController pushViewController:goodsDetailViewController animated:YES];
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(tableView.editing){
//        self.collectionMenuView.allSelectedBtn.selected = NO;
//        [self.deleteArr removeObject:[self.modelArray objectAtIndex:indexPath.row]];
//    }
//    
//}
//
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return self.modelArray.count;
//}
//
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    JJMyCollectionCell *cel = [self.tableView dequeueReusableCellWithIdentifier:MyCollectionCellIdentifier forIndexPath:indexPath];
//    cel.model = self.modelArray[indexPath.row];
//    return cel;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 123 * KWIDTH_IPHONE6_SCALE;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 49;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}
//
//#pragma mark - 懒加载
//- (NSMutableArray *)modelArray {
//    if(!_modelArray) {
//        _modelArray = [NSMutableArray array];
//    }
//    return _modelArray;
//}
//
//- (NSMutableArray *)deleteArr {
//    if(!_deleteArr) {
//        _deleteArr = [NSMutableArray array];
//    }
//    return _deleteArr;
//}
//
//@end
