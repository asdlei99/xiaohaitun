//
//  AppDelegate.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "AppDelegate.h"
#import "JJTabBarController.h"
#import "JJControllerTool.h"
#import "UIImageView+WebCache.h"
#import "NetWorkChecker.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//#import <UserNotifications/UserNotifications.h>
#import "Pingpp.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import "User.h"
#import "JJActivityOrderDeatilViewController.h"
#import "JJOrderDetailViewController.h"
#import "UIViewController+Alert.h"
#import "JJGoodsOrderModel.h"
#import "JJNavigationController.h"
#import "JJMyBalanceViewController.h"
#import "UIView+viewController.h"
#import <MeiQiaSDK/MQManager.h>
#import "MQServiceToViewInterface.h"
#import "JJActivityOrderDeatilViewController.h"
#import "JJMyActivityModel.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, assign) NSInteger badgeNumber; // 远程通知消息数量

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    // 显示窗口
    [self.window makeKeyAndVisible];
    //选择进入新特性还是APP首页
    [JJControllerTool chooseController];
   
    [self setupShareSDK];
    [self setupJPUSHWithLaunchOptions:launchOptions];//关于推送暂时下面的说法都是经过实践正确的
    //显示ping++ 的log信息
    [Pingpp setDebugMode:YES];
//    [Pingpp setAppId:PingPlusAppkey];
    //请填写您的美洽 AppKey
    [MQManager initWithAppkey:@"c614316d10c490745a53e25e7480b078" completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            DebugLog(@"美洽 SDK：初始化成功");
        } else {
            DebugLog(@"error:%@",error);
        }
        [MQServiceToViewInterface getUnreadMessagesWithCompletion:^(NSArray *messages, NSError *error) {
            DebugLog(@">> unread message count: %d", (int)messages.count);
        }];
    }];
    
    return YES;

}


#pragma mark -shareSDK
- (void)setupShareSDK {
    [ShareSDK registerApp:ShareSDKAppKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:WeiboAppKey
                                           appSecret:WeiboAppSecret
                                         redirectUri:@"http://www.attackt.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WeiChatAppId
                                       appSecret:WeiChatAppSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQAppId
                                      appKey:QQAppSecret
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

//
//#pragma mark - JPUSH极光推送
- (void)setupJPUSHWithLaunchOptions:(NSDictionary *)launchOptions {
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
   // 注册远程通知
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAppKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            DebugLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            DebugLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    
//    // 判断是否是通过点击通知打开了应用程序
//    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {

    
}
#pragma mark -- 极光推送回调方法
- (void)networkDidSetup:(NSNotification *)notification
{
    // 获取当前用户id，上报给极光，用作别名
    User *user = [User getUserInformation];
    //针对设备给极光服务器反馈了别名，app服务端可以用别名来针对性推送消息
    [JPUSHService setTags:nil alias:[NSString stringWithFormat:@"%@", user.userId] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        DebugLog(@"极光推送错误码+++++++：%d", iResCode);
        
        if (iResCode == 0) {
            DebugLog(@"极光推送：设置别名成功, 别名：%@", user.userId);
        }
    }];
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    //上传设备deviceToken，以便美洽自建推送后，迁移推送
    [MQManager registerDeviceToken:deviceToken];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //    [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFY_AVPLAYER_STOP_PLAY object:nil];
    
    // -- 极光推送
    // 将小红点清除
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeNumber;
    [JPUSHService setBadge:self.badgeNumber];
    //App 进入后台时，关闭美洽服务
    [MQManager closeMeiqiaService];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // -- 极光推送
    // 将小红点清除
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeNumber;
    [JPUSHService setBadge:self.badgeNumber];
    //App 进入前台时，开启美洽服务
    [MQManager openMeiqiaService];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // -- 极光推送
    // 将小红点清除
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeNumber;
    [JPUSHService setBadge:self.badgeNumber];
}

// 当应用程序接收到内存警告的时候就会调用
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 应该在该方法中释放掉不需要的内存
    // 1.停止所有的子线程下载
    [[SDWebImageManager sharedManager] cancelAll];
    // 2.清空SDWebImage保存的所有内存缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    DebugLog(@"%@",userInfo);
//    application.applicationState =
//    UIApplicationStateActive,      这个是处于前台时
//    UIApplicationStateInactive,    这个是后台和杀死时
//    UIApplicationStateBackground   这个啥时候都不调用(不懂)
//    这个是当应用处于后台时,点击发送过来的通知后会调用的
//    这个是当应用处于前台时,也会收到通知
//    当应用程序被杀死时,点击发送过来的通知后也会调用
//    总而言之只要是点击推送的消息进入应用程序的都会调用次方法
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    DebugLog(@"+++90%@", userInfo);
    // 获取服务器端推送过来的消息数量
    self.badgeNumber = [[[userInfo objectForKey:@"aps"] valueForKey:@"badge"] integerValue];
    
    if (application.applicationState == UIApplicationStateActive) {
        weakSelf(weakSelf);
        [application.keyWindow.rootViewController showAlertWithTitle:@"推送消息" message:alert cancelBlock:^{
            // 通知消息角标
            weakSelf.badgeNumber = 0;
        } certainBlock:^{
            [weakSelf handleRemoteNotificaionWithUserInfo:userInfo];
        }];
    }
    
    // 如果程序在后台和运行状态下
    if (application.applicationState != UIApplicationStateBackground && application.applicationState != UIApplicationStateActive) {
        
        [self handleRemoteNotificaionWithUserInfo:userInfo];
        
    }
    /*!
     * @abstract 处理收到的 APNs 消息
     */
    
    // Required, iOS 7及之后才能用 Support
    // 处理接收到的消息
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark -- 自定义方法
- (void)handleRemoteNotificaionWithUserInfo:(NSDictionary *)userInfo {
    if (userInfo) {
        // 通知消息角标
        self.badgeNumber = 0;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.badgeNumber];
        [JPUSHService setBadge:self.badgeNumber];
        NSString *orderID = [userInfo valueForKey:@"order_num"]; //服务端传递的Extras附加字段，key是自己定义的,这里是服务器返回订单号
        //商品 1   活动  2
        NSInteger order_type = [(NSNumber *)[userInfo valueForKey:@"order_type"] integerValue];
        NSInteger notice_type = [(NSNumber *)[userInfo valueForKey:@"notice_type"] integerValue];
        if (notice_type == 1) {
            //跳到我的余额
            JJMyBalanceViewController *balanceVC = [[JJMyBalanceViewController alloc]init];
//            JJNavigationController *navigationVIewController = [[JJNavigationController alloc]initWithRootViewController:balanceVC];
//            [self.window.rootViewController presentViewController:navigationVIewController animated:YES completion:nil];
            [[UIView currentViewController].navigationController pushViewController:balanceVC animated:YES];
            
        } else {
            if(order_type == 1) {//跳到商品订单
                if (orderID) {
                    JJOrderDetailViewController *orderDetailViewController = [[JJOrderDetailViewController alloc] init];
                    JJGoodsOrderModel *goodsOrderModel = [[JJGoodsOrderModel alloc]init];
                    goodsOrderModel.order_num = orderID;
                    orderDetailViewController.orderModel = goodsOrderModel;
                    //                JJNavigationController *navigationVIewController = [[JJNavigationController alloc]initWithRootViewController:orderDetailViewController];
                    //                [self.window.rootViewController presentViewController:navigationVIewController animated:YES completion:nil];
                    [[UIView currentViewController].navigationController pushViewController:orderDetailViewController animated:YES];
                }

            } else {//跳到活动订单
                JJActivityOrderDeatilViewController * activityOrderDeatilViewController = [[JJActivityOrderDeatilViewController alloc]init];
//                activityOrderDeatilViewController.refundDelegate = self;
                JJMyActivityModel *model = [[JJMyActivityModel alloc]init];
                model.order_num = orderID;
                activityOrderDeatilViewController.model = model;
                 [[UIView currentViewController].navigationController pushViewController:activityOrderDeatilViewController animated:YES];
            }
        }
    }
}

#pragma mark - Ping++
/**
 *  有关Ping++的方法配置
 */
//iOS8及以下
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
    return canHandleURL;
}

//iOS9及以上
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
    return canHandleURL;
}

@end
