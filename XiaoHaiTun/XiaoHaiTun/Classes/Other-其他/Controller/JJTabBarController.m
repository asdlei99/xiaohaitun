//
//  JJTabBarController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTabBarController.h"
#import "JJNavigationController.h"
#import "JJTabBar.h"
#import "JJCoveViewController.h"
#import "JJActivityViewController.h"
#import "JJShopCartViewController.h"
#import "JJMeViewController.h"
#import "JJActivityDetailViewController.h"
#import "UIImage+XPKit.h"

@interface JJTabBarController ()

@end

@implementation JJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**** 设置所有UITabBarItem的文字属性 ****/
    [self setupItemTitleTextAttributes];
    
    /**** 添加子控制器 ****/
    [self setupChildViewControllers];
    
    /**** 更换TabBar ****/
    [self setupTabBar];

}

/**
 *  设置所有UITabBarItem的文字属性
 */
- (void)setupItemTitleTextAttributes
{
    UITabBarItem *item = [UITabBarItem appearance];
   
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
   
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

/**
 *  添加子控制器
 */
- (void)setupChildViewControllers
{
    [self setupOneChildViewController:[[JJNavigationController alloc] initWithRootViewController:[[JJCoveViewController alloc] init]] title:@"商城" image:@"Tab_Cove_Normal" selectedImage:@"Tab_Cove_Select"];
    
    [self setupOneChildViewController:[[JJNavigationController alloc] initWithRootViewController:[[JJActivityViewController alloc] init]] title:@"活动" image:@"Tab_Activity_Normal" selectedImage:@"Tab_Activity_Select"];
    
    [self setupOneChildViewController:[[JJNavigationController alloc] initWithRootViewController:[[JJShopCartViewController alloc] init]] title:@"购物车" image:@"Tab_ShopCart_Normal" selectedImage:@"Tab_ShopCart_Select"];
    
    [self setupOneChildViewController:[[JJNavigationController alloc] initWithRootViewController:[[JJMeViewController alloc] init]] title:@"我的" image:@"Tab_Me_Normal" selectedImage:@"Tab_Me_Select"];

}

/**
 *  初始化一个子控制器
 *
 *  @param vc            子控制器
 *  @param title         标题
 *  @param image         图标
 *  @param selectedImage 选中的图标
 */
- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    if (image.length) { // 图片名有具体值
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [self addChildViewController:vc];

}

/**
 *  更换TabBar
 */
- (void)setupTabBar
{
    self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
//    [self setValue:[[JJTabBar alloc] init] forKeyPath:@"tabBar"];
}
@end
