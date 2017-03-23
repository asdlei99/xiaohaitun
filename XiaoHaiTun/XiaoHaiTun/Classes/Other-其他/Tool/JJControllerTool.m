//
//  IWControllerTool.m
//  传智WB
//
//  Created by 唐天成 on 15-10-26.
//  Copyright (c) 2015年 唐天成. All rights reserved.
//

#import "JJControllerTool.h"
#import "JJNewfeatureViewController.h"
#import "JJTabBarController.h"
@implementation JJControllerTool
+ (void)chooseController{
    // 1.获取沙盒中的版本号
    NSUserDefaults* defaults= [NSUserDefaults standardUserDefaults];
    NSString *key = @"CFBundleShortVersionString";
    NSString* sandBoxVersion=[defaults valueForKey:key];
    // 2.获取当前软件的版本号
    NSDictionary *md =[NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = md[key];
    UIApplication* application=[UIApplication sharedApplication];
    UIWindow* window=[application keyWindow];

    DebugLog(@"%@  %@",currentVersion,sandBoxVersion);
    if([currentVersion compare:sandBoxVersion] == NSOrderedDescending){
        // 存储当前版本号
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
        
        // 第一次使用当前版本  --> 显示新特性界面
        //        NSLog(@"显示新特性界面");
        JJNewfeatureViewController *newfeature = [[JJNewfeatureViewController alloc] init];
                window.rootViewController = newfeature;
    }else{
        JJTabBarController *tabBarController=[[JJTabBarController alloc]init];
        window.rootViewController=tabBarController;
    }

}
@end
