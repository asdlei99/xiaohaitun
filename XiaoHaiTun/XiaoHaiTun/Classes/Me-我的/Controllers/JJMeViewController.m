//
//  JJMeViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//
#import "JJMeViewController.h"
#import "JJLoginViewController.h"
#import "MBProgressHUD+gifHUD.h"
#import "JJAddInformationViewController.h"
//#import "MXNavigationBarManager.h"
#import "JJHobbyModel.h"
#import <ReactiveCocoa.h>
#import "JJMeBaseTableViewCell.h"
#import "JJMeBaseTableViewCell.h"
#import "JJWaitGoodsTableViewCell.h"
#import "JJMeHeadView.h"
#import "UIView+XPKit.h"
#import "User.h"
#import "HFNetWork.h"
#import "MBProgressHUD+gifHUD.h"
#import "JJLoginViewController.h"
#import <UIImageView+WebCache.h>
#import "UIStoryboard+JJEasyCreate.h"
#import "JJSettingViewController.h"
#import "JJWaitPayViewController.h"
#import "JJWaitPayViewController.h"
#import "JJMyActivityViewController.h"
#import "JJMyCollectionViewController.h"
#import "JJMyCollectionGoodsViewController.h"
#import "JJReceiveAddressViewController.h"
#import "JJMyBalanceViewController.h"
#import "NSDate+Age.h"
#import "JJNavigationController.h"
#import "UIViewController+ModelLogin.h"
#import "UINavigationBar+Awesome.h"
#import "UIImage+XPKit.h"
#import "JJChangeInformationViewController.h"
#import <MJExtension.h>


static NSString * const meBaseTableViewCellIdentifier = @"meBaseTableViewCellIdentifier";
static NSString * const waitGoodsTableViewCellIdentifier = @"waitGoodsTableViewCellIdentifier";

@interface JJMeViewController ()

//@property (nonatomic, strong) JJHobbyModel *hobbyModel;

@property (nonatomic, strong) User *user;


@end

@implementation JJMeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置导航条内容
//    [self setupNavigationBar];
    [self.navigationController.navigationBar lt_setBackgroundColor:NORMAL_COLOR];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [MXNavigationBarManager reStore];
//    [self.navigationController.navigationBar lt_reset];
}





////设置导航条内容
//- (void)setupNavigationBar {
//    //required
////    [MXNavigationBarManager saveWithController:self];
////    [MXNavigationBarManager managerWithController:self];
////    [MXNavigationBarManager setBarColor:NORMAL_COLOR];
////    [MXNavigationBarManager setTintColor:[UIColor whiteColor]];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.backgroundColor = RGBA(229, 229, 229, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.bounces = NO;
    self.user = [User getUserInformation];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signInTypeChange) name:SignInTypeChangeNotification object:nil];
//    //设置导航条内容
    [self setnavigationBar];
    //注册Cell
    [self registCell];
    
}



- (void)usernameDidChange:(UITextField *)username
{
    DebugLog(@"%@", username.text);
}
- (void)signInTypeChange {
    self.user = [User getUserInformation];
    [self.tableView reloadData];
}

#pragma mark - setupView

- (void)setnavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingProfile)];
}

//点击右端设置按钮
- (void)settingProfile{
    JJSettingViewController *settingViewController = [UIStoryboard instantiateInitialViewControllerWithStoryboardName:@"Setting"];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

//注册Cell
- (void)registCell{
    [self.tableView registerClass:[JJWaitGoodsTableViewCell class] forCellReuseIdentifier:waitGoodsTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"JJMeBaseTableViewCell" bundle:nil]  forCellReuseIdentifier:meBaseTableViewCellIdentifier];
}

#pragma mark - request请求
////发出请求个人信息
//- (void)requesrWithUserMessage {
//    
//    User *user = [User getUserInformation];
//    NSString *url = [NSString stringWithFormat:@"%@%@%@",DEVELOP_BASE_URL,API_USER,user.userId];
//    NSLog(@"%@",url);
//    
//    [HFNetWork getWithURL:url params:nil success:^(id response) {
//        [MBProgressHUD hideHUD];
//        if (![response isKindOfClass:[NSDictionary class]]) {
//            return ;
//        }
//        if ([response isKindOfClass:[NSData class]]) {
//            NSString *result = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
//            DebugLog(@"result:%@", result);
//        }
//        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
//        NSInteger userStatus = [[response objectForKey:@"user_status"]integerValue];
//        if (codeValue) { //失败返回
//            NSString *codeMessage = [response objectForKey:@"error_msg"];
//            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
//            return ;
//        }
//    } fail:^(NSError *error) {
//        [MBProgressHUD hideHUD];
//        NSLog(@"%@",error);
//        NSInteger errorCode = [error code];
//        DebugLog(@"errorCode == %ld", (long)errorCode);
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
//    }];
//    
//}

#pragma mark - UITableViewDataSource||UITbaleViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
            {
                JJMeBaseTableViewCell * cel = [tableView dequeueReusableCellWithIdentifier:meBaseTableViewCellIdentifier];
                cel.imageIcon.image = [UIImage imageNamed:@"me_Order"];
                cel.titleNameLabel.text = @"我的订单";
                cel.moneyLabel.hidden = YES;
                return cel;
                break;
            }
            case 1:
            {
                JJWaitGoodsTableViewCell * cel = [tableView dequeueReusableCellWithIdentifier:waitGoodsTableViewCellIdentifier];
                
                return cel;
                break;
            }
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                JJMeBaseTableViewCell * cel = [tableView dequeueReusableCellWithIdentifier:meBaseTableViewCellIdentifier];
                cel.imageIcon.image = [UIImage imageNamed:@"me_Money"];
                cel.titleNameLabel.text = @"我的余额";
                if(self.user) {
                    cel.moneyLabel.text =[NSString stringWithFormat:@"¥%@",self.user.balance];
                    cel.moneyLabel.hidden = NO;
                }else{
                    cel.moneyLabel.hidden = YES;
                }
                
                return cel;
                break;
            }
            case 1:
            {
                JJMeBaseTableViewCell * cel = [tableView dequeueReusableCellWithIdentifier:meBaseTableViewCellIdentifier];
                cel.imageIcon.image = [UIImage imageNamed:@"me_Activity"];
                cel.titleNameLabel.text = @"我的活动";
                cel.moneyLabel.hidden = YES;
                return cel;
                break;
            }
            case 2:
            {
                JJMeBaseTableViewCell * cel = [tableView dequeueReusableCellWithIdentifier:meBaseTableViewCellIdentifier];
                cel.imageIcon.image = [UIImage imageNamed:@"me_Collect"];
                cel.titleNameLabel.text = @"我的收藏";
                cel.moneyLabel.hidden = YES;

                return cel;
                break;
            }
            case 3:
            {
                JJMeBaseTableViewCell * cel = [tableView dequeueReusableCellWithIdentifier:meBaseTableViewCellIdentifier];
                cel.imageIcon.image = [UIImage imageNamed:@"me_Address"];
                cel.titleNameLabel.text = @"收货地址";
                cel.moneyLabel.hidden = YES;
                return cel;
                break;
            }
            default:
                break;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 1) {
        return 81;
    }
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
    return 210;
    }else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 210)];
        v.backgroundColor = [UIColor blackColor];
        JJMeHeadView *meHeadView =[[JJMeHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
        
        [v addSubview:meHeadView];
        [meHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(v);
        }];
        
        //如果是登陆状态
        if(self.user) {
            meHeadView.nameLabel.hidden = NO;
            meHeadView.nameLabel.text = self.user.nickname;
            [meHeadView.pictureImageView sd_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:[UIImage imageNamed:@"me_icon"]];
            
            //将时间戳转为日期
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.user.baby_birthday];
            meHeadView.descriptLabel.text = [NSString stringWithFormat:@"宝宝%@了",date.currentAge];
            [meHeadView whenTouchedUp:^{
                JJChangeInformationViewController *changeInformationViewController = [UIStoryboard instantiateInitialViewControllerWithStoryboardName:@"ChangeInformation"];
                [self.navigationController pushViewController:changeInformationViewController animated:YES];
            }];
            //如果是未登陆状态
        } else {
            meHeadView.nameLabel.hidden = YES;
            [meHeadView.pictureImageView sd_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:[UIImage imageNamed:@"me_icon"]];
            meHeadView.descriptLabel.text = @"登录/注册";
            weakSelf(weakSelf);
            [meHeadView whenTouchedUp:^{
                [weakSelf modelToLoginVC];
//                [self.navigationController pushViewController:loginViewController animated:YES];
            }];
        }
        return v;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if(self.user != nil){
        //我的订单
        if(indexPath.section == 0 && indexPath.row == 0){
            JJWaitPayViewController *orderViewController = [[JJWaitPayViewController alloc]init];
            orderViewController.goodsWaitType = 10;
            [self.navigationController pushViewController:orderViewController animated:YES];
            return;
        }
        //我的余额
        if(indexPath.section == 1 && indexPath.row == 0) {
            JJMyBalanceViewController *balanceViewController = [[JJMyBalanceViewController alloc]init];
            balanceViewController.balance = self.user.balance;
            [self.navigationController pushViewController:balanceViewController animated:YES];
            return;
        }
        //我的活动
        if(indexPath.section == 1 && indexPath.row == 1){
            JJMyActivityViewController *activityViewController = [[JJMyActivityViewController alloc]init];
            [self.navigationController pushViewController:activityViewController animated:YES];
            return;
        }
        //我的收藏
        if(indexPath.section == 1 && indexPath.row == 2){
            JJMyCollectionViewController *myCollectionViewController = [[JJMyCollectionViewController alloc]init];
            [self.navigationController pushViewController:myCollectionViewController animated:YES];
            return;
        }
        //选择收货地址
        if(indexPath.section == 1 && indexPath.row == 3) {
            JJReceiveAddressViewController *reveiveAddressViewController = [[JJReceiveAddressViewController alloc]init];
            reveiveAddressViewController.isHideChooseImage = YES;
            [self.navigationController pushViewController:reveiveAddressViewController animated:YES];
            return;
        }
    }else{
        [self modelToLoginVC];
    }
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
