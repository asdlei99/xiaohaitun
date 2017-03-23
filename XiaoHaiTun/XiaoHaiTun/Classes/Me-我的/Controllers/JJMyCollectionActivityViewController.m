//
//  JJMyCollectionViewViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMyCollectionActivityViewController.h"
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
#import "JJActivityDetailViewController.h"
//#import "JJNoCollectTipView.h"
#import "JJTabBarController.h"
#import "UIView+XPNotNetWork.h"

static NSString * const MyCollectionCellIdentifier = @"JJMyCollectionCellIdentifier";


@interface JJMyCollectionActivityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) JJCollectionMenuView *collectionMenuView;
@property (nonatomic, strong) NSMutableArray<JJMyCollectionModel *> *modelArray;
@property (nonatomic, strong) NSMutableArray<JJMyCollectionModel *> *deleteArr;

@end

@implementation JJMyCollectionActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    [self basicSet];
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)dealloc{
    
}

//基本内容设置
- (void)basicSet {
    //    self.navigationItem.title = @"我的收藏";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBA(238, 238, 238, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[JJMyCollectionCell class] forCellReuseIdentifier:MyCollectionCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    //下拉刷新
    weakSelf(wealSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![Util isNetWorkEnable]) {//先判断网络状态
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            [wealSelf.tableView.mj_header endRefreshing];
            [wealSelf.tableView showNoNetWorkWithTryAgainBlock:^{
                [wealSelf.tableView.mj_header beginRefreshing];
            }];
            return ;
        }
        [wealSelf.tableView hideNoNetWork];
        [wealSelf requestCollectionQuery];
        
    }];
}
//
////创建视图
- (void)initBaseView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT_64 - PAGER_HEAD_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    JJCollectionMenuView *collectionMenuView = [JJCollectionMenuView collectionMenuView];
    self.collectionMenuView = collectionMenuView;
    self.collectionMenuView.hidden = YES;
    [self.view addSubview:collectionMenuView];
    weakSelf(weakself);
    collectionMenuView.deleteBlock = ^{
        if (weakself.tableView.editing) {
            DebugLog(@"%ld",weakself.deleteArr.count);
            [weakself requestDeleteCollect];
        }
    };
    
    collectionMenuView.allSelectBlock = ^(BOOL selected){
        if (weakself.tableView.editing) {
            if(selected){
                for (int i = 0; i < weakself.modelArray.count; i ++) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    //选中所有的
                    [weakself.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                    //                    deleteArr等于所有
                    [weakself.deleteArr removeAllObjects];
                    [weakself.deleteArr addObjectsFromArray:weakself.modelArray];
                }
            }else{
                for (int i = 0; i < weakself.modelArray.count; i ++) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    //不选中所有的
                    [weakself.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                    [weakself.deleteArr removeAllObjects];
                }
            }
        }
    };
    [collectionMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@49);
    }];
}

#pragma mark - 编辑按钮点击
- (void)editBtn:(UIBarButtonItem *)button {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.editing) {
        
        self.collectionMenuView.hidden = NO;
        [button setTitle:@"完成"];
        //        [button setTitle:@"完成" forState:UIControlStateNormal];
        
    }else{
        
        self.collectionMenuView.hidden = YES;
        [self.deleteArr removeAllObjects];
        self.collectionMenuView.allSelectedBtn.selected = NO;
        [button setTitle:@"编辑"];
        
    }
    
}

#pragma mark - 发出收藏网络请求
//
////发出我的收藏列表请求
- (void)requestCollectionQuery {
    NSString * deleteCartRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_COLLECT_QUERY];
    NSDictionary * params = @{@"user_id" : [User getUserInformation].userId , @"is_activity" : @1};
    [HFNetWork postWithURL:deleteCartRequesturl params:params success:^(id response) {
         [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) {
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        
        self.modelArray = [JJMyCollectionModel mj_objectArrayWithKeyValuesArray:response[@"items"]];
        if(self.modelArray.count == 0){
            weakSelf(weakSelf);
            [self.tableView showNoDateWithImageName:@"NO_Collect" title:@"你还没有收藏东东哦,快去逛逛吧" btnName:@"去逛逛" TryAgainBlock:^{
                [weakSelf gotoGoods];
            }];
            
        }else{
            [self.tableView hideNoDate];
            [self.tableView reloadData];
        }

       
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        [self.tableView.mj_header endRefreshing];
    }];
}
////发出删除收藏请求
//- (void)deleteRequestWithIndexPath:(NSIndexPath *)indexPath {
//    NSString * deleteCollectRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_COLLECT_EDIT];
//    JJMyCollectionModel *model = self.modelArray[indexPath.row];
//    NSDictionary *params = @{@"user_id" : [User getUserInformation].userId, @"item_id" : model.goodsID , @"action_id" : @2 , @"is_activity" : @1};
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
//        [self.modelArray removeObject:model];
//        
//        if(self.modelArray.count == 0){
//            weakSelf(weakSelf);
//            [self.tableView showNoDateWithImageName:@"NO_Collect" title:@"你还没有收藏东东哦,快去逛逛吧" btnName:@"去逛逛" TryAgainBlock:^{
//                [weakSelf gotoGoods];
//            }];
//            
//        }else{
//            [self.tableView hideNoDate];
//            [self.tableView reloadData];
//        }
//        
//    } fail:^(NSError *error) {
//        [MBProgressHUD hideHUD];
//        NSInteger errCode = [error code];
//        DebugLog(@"errCode = %ld", errCode);
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
//    }];
//    
//}

#pragma mark - 发出批量删除收藏请求
- (void)requestDeleteCollect {
    NSString * deleteCollectRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_COLLECT_DELETE];
    NSMutableArray *deleteArray = [NSMutableArray array];
    for(JJMyCollectionModel *model in self.deleteArr) {
        [deleteArray addObject:model.goodsID];
    }
    
    NSDictionary *params = @{@"user_id" : [User getUserInformation].userId, @"item_list" : [Util arrayToJson:deleteArray]  , @"is_activity" : @"1"};
    [HFNetWork postWithURL:deleteCollectRequesturl params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) {
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        [MBProgressHUD showHUDWithDuration:1.0 information:@"删除成功" hudMode:MBProgressHUDModeText];
        [self.modelArray removeObjectsInArray:self.deleteArr];
        [self.deleteArr removeAllObjects];
        [self.tableView reloadData];
        
        if(self.modelArray.count == 0){
            weakSelf(weakSelf);
            self.collectionMenuView.hidden = YES;
            [self.tableView showNoDateWithImageName:@"NO_Collect" title:@"你还没有收藏东东哦,快去逛逛吧" btnName:@"去逛逛" TryAgainBlock:^{
                [weakSelf gotoGoods];
            }];
            
        }else{
            [self.tableView hideNoDate];
            
        }

    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
    
}

//前往活动首页
- (void)gotoGoods {
    JJTabBarController *tabbarController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarController setSelectedIndex:1];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - TableViewDataSource ||TableViewDelegate

////加上以下代码支持删除
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self deleteRequestWithIndexPath:indexPath];
//    }
//}

//选择你要对表进行处理的方式  默认是删除方式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}

//******//选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.editing){
        [self.deleteArr addObject:[self.modelArray objectAtIndex:indexPath.row]];
    }
    else
    {
        JJActivityDetailViewController *activityDetailViewController = [[JJActivityDetailViewController alloc]init];
        JJMyCollectionModel *model = self.modelArray[indexPath.row];
        activityDetailViewController.activityID = model.goodsID;
        [self.navigationController pushViewController:activityDetailViewController animated:YES];
    }
}

//取消这一行的删除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.editing){
        self.collectionMenuView.allSelectedBtn.selected = NO;
        [self.deleteArr removeObject:[self.modelArray objectAtIndex:indexPath.row]];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.modelArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJMyCollectionCell *cel = [self.tableView dequeueReusableCellWithIdentifier:MyCollectionCellIdentifier forIndexPath:indexPath];
    cel.model = self.modelArray[indexPath.row];
    return cel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 123 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 49;
}

#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
- (NSMutableArray *)deleteArr {
    if(!_deleteArr) {
        _deleteArr = [NSMutableArray array];
    }
    return _deleteArr;
}

//- (JJNoCollectTipView *)noCollectTipView {
//    if(!_noCollectTipView) {
//        _noCollectTipView = [JJNoCollectTipView tipNoCollectView];
//         _noCollectTipView.frame = CGRectMake(0 , 0 , SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT_64 - PAGER_HEAD_HEIGHT);
//        _noCollectTipView.hidden = YES;
//        [self.tableView addSubview:_noCollectTipView];
//        [_noCollectTipView.goodButton addTarget: self action:@selector(gotoGoods) forControlEvents:UIControlEventTouchUpInside];
////        [_noCollectTipView mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.left.right.top.bottom.equalTo(self.tableView);
////        }];
//    }
//    return _noCollectTipView;
//}

@end
