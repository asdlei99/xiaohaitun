//
//  JJNavigationController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJNavigationController.h"
#import "UIBarButtonItem+Fast.h"
#import "UIImage+XPKit.h"
//#import <JZNavigationExtension.h>
//#import "MXNavigationBarManager.h"

@interface JJNavigationController ()

@end

@implementation JJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *在类第一次被实例化的时候调用，此方法只会调用一次
 */
+(void)initialize{
    
    //设置背景颜色
    UINavigationBar* navBar=[UINavigationBar appearance];
    [navBar setBarTintColor:NORMAL_COLOR];
//    [self setShadowImage:[UIImage new]];
//    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    设置左右按钮上的文字颜色
    [navBar setTintColor:[UIColor whiteColor]];
    
    
//    修改中间题目的文字样式属性
    NSDictionary* attrDic=@{
                            NSForegroundColorAttributeName:[UIColor whiteColor]
                            };
    [navBar setTitleTextAttributes:attrDic];

}



/**
 *  重写push方法的目的 : 拦截所有push进来的子控制器
 *
 *  @param viewController 刚刚push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    DebugLog(@"%s     %ld",__func__,self.viewControllers.count);
    if (self.childViewControllers.count > 0) { // 如果viewController不是最早push进来的子控制器
        // 隐藏底部的工具条
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 2.覆盖返回按钮
        // 只要覆盖了返回按钮, 系统自带的拖拽返回上一级的功能就会失效
        viewController.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Nav_Back_White"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        
        //[UIBarButtonItem itemImage:@"navigationbar_back" highlightedImage:@"navigationbar_back_highlighted" target:self action:@selector(back)];
    }
    // 所有设置搞定后, 再push控制器
    [super pushViewController:viewController animated:animated];
}

-(void)back{
    [self popViewControllerAnimated:YES];
}

@end
