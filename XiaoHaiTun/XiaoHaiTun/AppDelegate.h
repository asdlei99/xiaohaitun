//
//  AppDelegate.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *channel = @"AppStore";
static BOOL isProduction = YES;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//方便登陆的时候极光注册userName关键字
- (void)networkDidSetup:(NSNotification *)notification;
@end

