//
//  JJPaySuccessViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJPaySuccessViewController.h"
#import "UIView+XPKit.h"
#import "JJTabBarController.h"
#import "JJMeViewController.h"
#import "JJMyActivityViewController.h"
#import "JJActivityOrderDeatilViewController.h"
#import "JJNavigationController.h"
#import "JJMyBalanceViewController.h"
//#import "JZNavigationExtension.h"
#import "JJWaitPayViewController.h"
#import "JJTabBarController.h"

@interface JJPaySuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *checkOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *continueShopBtn;

@end

@implementation JJPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseSet];
    [self.checkOrderBtn addTarget:self action:@selector(checkOrder) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.title = @"支付成功";
    [self.continueShopBtn addTarget:self action:@selector(continueShop) forControlEvents:UIControlEventTouchUpInside];
    if(self.type == 3) {
        self.successLabel.text = @"恭喜您!充值成功";
        self.navigationItem.title = @"充值成功";
        self.checkOrderBtn.hidden = YES;
        return;
    }
    if(self.model.total_fee == 0 && self.type == 2) {
        self.successLabel.text = @"恭喜您!报名成功";
        self.navigationItem.title = @"报名成功";
    }
    
   
}

- (void)back {
    if(self.type == 3) {//充值
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (void)baseSet {
    
    // 只要覆盖了返回按钮, 系统自带的拖拽返回上一级的功能就会失效
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Nav_Back_White"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
   
    [self.checkOrderBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:6 andWidth:0];
    [self.continueShopBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:6 andWidth:1];
}
//查看订单
- (void)checkOrder {
        [self.navigationController popToRootViewControllerAnimated:NO];
        JJTabBarController *tabbarController = (JJTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [tabbarController setSelectedIndex:3];
        JJNavigationController *meNavigationViewController = tabbarController.selectedViewController;
    if(self.type == 1 || self.type == 3) {//如果是商品或充值成功
        JJWaitPayViewController *goodsViewController = [[JJWaitPayViewController alloc]init];
        goodsViewController.goodsWaitType = 10;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [meNavigationViewController pushViewController:goodsViewController animated:NO];
        });
        
    } else {//如果是活动
        JJMyActivityViewController *activityViewController = [[JJMyActivityViewController alloc]init];
        //        JJMyBalanceViewController *a = [[JJMyBalanceViewController alloc]init];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [meNavigationViewController pushViewController:activityViewController animated:NO];
        });

    }
}
//继续购物
- (void)continueShop {
    [self.navigationController popToRootViewControllerAnimated:NO];
    JJTabBarController *tabbarController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (self.type == 1 || self.type == 3) {
        [tabbarController setSelectedIndex:0];
    } else {
        [tabbarController setSelectedIndex:1];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
