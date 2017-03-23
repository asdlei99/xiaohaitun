//
//  JJSettingViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/7.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSettingViewController.h"
#import "UIStoryboard+JJEasyCreate.h"
#import "JJChangeInformationViewController.h"
#import "User.h"
#import "JJLoginViewController.h"
#import "MBProgressHUD+gifHUD.h"
#import "UIViewController+Alert.h"
#import "JJAccountSafeViewController.h"
#import "JJMessageNotificateViewController.h"
#import "JJHelpCenterViewController.h"
#import "JJSuggessionViewController.h"
#import "JJReceiveAddressViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "UIViewController+ModelLogin.h"
#import <StoreKit/StoreKit.h>
#import "JJAboutAppViewController.h"

@interface JJSettingViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *loginLogoutBtn;

@end

@implementation JJSettingViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [MXNavigationBarManager reStoreWithFullStatus];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loginLogoutBtn createBordersWithColor:normal withCornerRadius:6 andWidth:0];
    self.navigationItem.title = @"设置";
    self.tableView.backgroundColor = RGBA(238, 238, 238, 1);
    self.tableView.tableFooterView = [UIView new];
    NSLog(@"%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    [self.loginLogoutBtn addTarget:self action:@selector(loginOrLogoutClick:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(btnTitleChange) name:SignInTypeChangeNotification object:nil];
    [self btnTitleChange];
    // Do any additional setup after loading the view.
}

- (void)btnTitleChange {
    if([User getUserInformation]) {
        //已登陆
        [self.loginLogoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    }else{
        //未登陆
        [self.loginLogoutBtn setTitle:@"登录" forState:UIControlStateNormal];
    }

}

//退出或登陆
- (void)loginOrLogoutClick:(UIButton *)btn {
    if([btn.titleLabel.text isEqualToString:@"退出"]){
        weakSelf(weakself);
        [self showAlertWithTitle:nil message:@"确定退出登录?" cancelBlock:^{
            
        } certainBlock:^{
            [User removeUserInformation];
            [[NSNotificationCenter defaultCenter]postNotificationName:ShopCartNotification object:nil];
            //在推出账号的位置添加取消授权,防止下次自动登录
            [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
            [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
            [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
            
        }];

    } else {
        [self modelToLoginVC];
    }
    
}

#pragma mark - UITableViewDataSource || UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 4;
    }
    if (section == 1) {
        return 4;
    }
    if (section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell_%ld_%ld", (long)indexPath.section, (long)indexPath.row] forIndexPath:indexPath];
    if(indexPath.section == 2 && indexPath.row == 1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = RGBA(238, 238, 23, 1);
        [cell.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(cell);
            make.bottom.equalTo(cell).with.offset(1);
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;

    switch (indexPath.section) {
        case 0://Section 0
        {
            switch (indexPath.row) {
                case 0:
                {
                    //我的资料
                    if ([User getUserInformation]) {
                    JJChangeInformationViewController * changeVC = [UIStoryboard instantiateInitialViewControllerWithStoryboardName:@"ChangeInformation"];
                    [self.navigationController pushViewController:changeVC  animated:YES];
                    }else{
                        [self modelToLoginVC];
                    }
                    break;
                }
                case 1:
                {
                    //账号安全
                    if ([User getUserInformation]) {
                    JJAccountSafeViewController *accountSafeViewController = [[JJAccountSafeViewController alloc]init];
                    [self.navigationController pushViewController:accountSafeViewController animated:YES];
                    }else{
                        [self modelToLoginVC];
                    }
                    
                    break;
                }
                case 2:
                {
                    //收货地址
                    if(![User getUserInformation]) {
                        [self modelToLoginVC];
                    }else{
                    JJReceiveAddressViewController *receiveAddressViewCotroller = [[JJReceiveAddressViewController alloc]init];
                        receiveAddressViewCotroller.isHideChooseImage = YES;
                    [self.navigationController pushViewController:receiveAddressViewCotroller animated:YES];
                    }
                    break;
                }
                case 3:
                {
                    //消息通知
                    if(![User getUserInformation]) {
                        [self modelToLoginVC];
                    }else{
                        JJMessageNotificateViewController *messageNotiVC = [[JJMessageNotificateViewController alloc]init];
                        [self.navigationController pushViewController:messageNotiVC animated:YES];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
            
        case 1://Section 1
        {
            switch (indexPath.row) {
                case 0:
                {
                    if(![User getUserInformation]) {
                        [self modelToLoginVC];
                    }else{
                    JJSuggessionViewController *suggesVC = [[JJSuggessionViewController alloc]init];
                    [self.navigationController pushViewController:suggesVC animated:YES];
                    }
                  
                    break;
                }
                case 1:
                {
                    if(![User getUserInformation]) {
                        [self modelToLoginVC];
                    }else{
                    JJHelpCenterViewController *helpVC = [[JJHelpCenterViewController alloc]init];
                    [self.navigationController pushViewController:helpVC animated:YES];
                    }
                    break;
                }
                case 2:
                {
                    
                    break;
                }
                case 3:
                {
                    //跳出appstore
                    [self evaluate];
                    break;
                }
                    
                default:
                    break;
            }

            break;
        }
            
        case 2://Section 1
        {
            switch (indexPath.row) {
                case 0:
                {
                    JJAboutAppViewController *aboutAppVC = [[JJAboutAppViewController alloc]init];
                    [self.navigationController pushViewController:aboutAppVC animated:YES];
                    break;
                }
//                case 1:
//                {
//                    weakSelf(weakself);
////                    if(IOS_VERSION >= 9.0){
//                    [self showAlertWithTitle:nil message:@"确定退出登录?" cancelBlock:^{
//                        
//                    } certainBlock:^{
//                        [User removeUserInformation];
//                        //在推出账号的位置添加取消授权,防止下次自动登录
//                        [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
//                        [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
//                        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
//                        [weakself.navigationController popToRootViewControllerAnimated:YES];
//
//                    }];
//                    }else{
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//                        [alert show];
//                    }
                    
//                    break;
//                }
                default:
                    break;
            }

            break;
        }
        default:
            break;
    }
}


- (void)evaluate{
    
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId
     @{SKStoreProductParameterITunesItemIdentifier : XiaoHaiTunAPPID} completionBlock:^(BOOL result, NSError *error) {
         NSLog(@"qq");
         //block回调
         if(error){
             DebugLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出AppStore应用界面
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }
              ];
         }
     }];
}

//取消按钮监听方法
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//#pragma mark UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if(buttonIndex == 1){
//        [User removeUserInformation];
//        //在推出账号的位置添加取消授权,防止下次自动登录
//        [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
//        [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
//        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
