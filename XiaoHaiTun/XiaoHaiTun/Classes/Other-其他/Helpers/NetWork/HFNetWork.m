//
//  HFNetWork.m
//  HiFun
//
//  Created by attackt on 16/7/29.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import "HFNetWork.h"
#import <AFNetworking.h>
//#import "YYCache.h"
#import "NetWorkChecker.h"
#import "Util.h"
#import "MBProgressHUD+gifHUD.h"
#import "User.h"
#import "UIView+viewController.h"
#import "MJRefresh.h"
#import "NSObject+ViewController.h"
#import "UIViewController+Alert.h"
#import "JJTabBarController.h"
#import <ShareSDK/ShareSDK.h>
#import "UIViewController+ModelLogin.h"

@interface HFNetWork ()

@end

@implementation HFNetWork
//NSString *const hf_httpRequestKey = @"hf_httpRequestKey";
static NSMutableArray *hf_requestTasks;
static NSTimeInterval hf_timeout = 30.f;


#pragma mark Priviate -- Methods
+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hf_requestTasks = [[NSMutableArray alloc] init];
    });
    
    return hf_requestTasks;
    
}

// 字符串中含有中文字符的判断
+ (BOOL)isContainChineseStr:(NSString *)string {
    for(int i = 0;i < [string length];i++) {
        int a =[string characterAtIndex:i];
        if( a >0x4e00 && a <0x9fff) {
            return YES;
        }
    }
    return NO;
}

//网络实时状态的判断
+ (BOOL)isNetWorkEnable {
    BOOL isNetWorkEnable = [[NetWorkChecker shareInstance] networkStatus];
    return isNetWorkEnable;
}

//对URL含有中文的进行中文编码
+ (NSString *)hf_URLEncoding:(NSString *)url {
    if ([self isContainChineseStr:url]) {
        return [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    return url;
}


+ (AFHTTPSessionManager *)AFHTTPSessionManager {

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    User *user = [User getUserInformation];
    if(!(user.token == nil || [user.token isEqualToString:@""])){
        NSString *token = [NSString stringWithFormat:@"JWT %@",user.token];
//        NSString *token = [NSString stringWithFormat:@"%@",user.token];
    [sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    sessionManager.requestSerializer.timeoutInterval = hf_timeout; //请求超时设定
    sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    sessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    // /先导入证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"dopstore" ofType:@"cer"];//证书的路径
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//    DebugLog(@"%@  %@",cerPath,certData);
    
    sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    sessionManager.securityPolicy.allowInvalidCertificates = YES;
    sessionManager.securityPolicy.validatesDomainName = NO;
//    sessionManager.securityPolicy.pinnedCertificates =[NSSet setWithObject:certData];
    
//    // AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    
//    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    // 如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//    
//    //validatesDomainName 是否需要验证域名，默认为YES；
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = NO;
    sessionManager.operationQueue.maxConcurrentOperationCount = 3;

      //    });
    DebugLog(@"%p",sessionManager);
    return sessionManager;
}


+ (HFURLSessionTask *)requestWithHttpMethod:(HTTPMethod)httpMethod
                                  URLString:(NSString *)url
                                     params:(NSDictionary *)params
                               successBlock:(HFResponseSuccessBlock)success
                               failureBlock:(HFResponseFailureBlock)failure {
//    //先处理缓存问题
//    YYCache *cache = [[YYCache alloc] initWithName:hf_httpRequestKey];
//    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
//    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
//    id cacheData;
//    if (isCache) {
//        cacheData = [cache objectForKey:cacheKey];
//        if (cacheData) {
//            success(cacheData);
//            return nil;
//        }
//    }
    
    //如果没有缓存，则走正常的网络请求步骤
    if (![self isNetWorkEnable]) {
        DebugLog(@"网络连接不可用");
    }
    if (url) {
        url = [self hf_URLEncoding:url];
    }
    DebugLog(@"请求的URL:%@",url);
    
    AFHTTPSessionManager *sessionManager = [self AFHTTPSessionManager];
    HFURLSessionTask *sessionTask = nil;
    if (httpMethod == HFRequestGET) {
        sessionTask = [sessionManager GET:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            
            [[self allTasks] removeObject:task];
            if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                [self objectWithJSONData:responseObject];
            }
            
            //如果token登陆过期
            NSString *tokExpiredString = responseObject[@"detail"];
            if(tokExpiredString.length != 0) {
                [MBProgressHUD hideHUD];
                //先退出登陆
                [User removeUserInformation];
                //在推出账号的位置添加取消授权,防止下次自动登录
                [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
                [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
                [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                JJTabBarController *tabbarC = [UIApplication sharedApplication].keyWindow.rootViewController;
                typeof(tabbarC)weakTabbarC = tabbarC;
                [tabbarC showAlertWithTitle:@"提示" message:@"登录过期,重新登录" cancelTitle:@"确定" cancelBlock:^{
                    [weakTabbarC modelToLoginVC];
                }];
                return;
            }
            DebugLog(@"responseObject : %@",responseObject);
            success(responseObject);
//            [cache setObject:responseObject forKey:cacheKey];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self allTasks] removeObject:task];
            failure(error);
        }];
    } else if (httpMethod == HFRequestPOST) {
        sessionTask = [sessionManager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [[self allTasks] removeObject:task];
            if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                [self objectWithJSONData:responseObject];
            }
            
            //如果token登陆过期
            NSString *tokExpiredString = responseObject[@"detail"];
            if(tokExpiredString.length != 0) {
                [MBProgressHUD hideHUD];
                //先退出登陆
                [User removeUserInformation];
                //在推出账号的位置添加取消授权,防止下次自动登录
                [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
                [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
                [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                JJTabBarController *tabbarC = [UIApplication sharedApplication].keyWindow.rootViewController;
                typeof(tabbarC)weakTabbarC = tabbarC;
                [tabbarC showAlertWithTitle:@"提示" message:@"登录过期,重新登录" cancelTitle:@"确定" cancelBlock:^{
                    [weakTabbarC modelToLoginVC];
                }];
                return;
            }
            DebugLog(@"responseObject : %@",responseObject);
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self allTasks] removeObject:task];
            failure(error);
        }];
    }
    if (sessionTask) {
        [[self allTasks] addObject:sessionTask];
    }
    return sessionTask;
}

/**
 *  NSData转为json数据
 */
+ (nullable id)objectWithJSONData:(nonnull NSData *)JSONData {
    NSError *error;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:&error];
    return JSONObject;
}



#pragma mark Public -- Methods

//无提示
+ (HFURLSessionTask *)getNoTipWithURL:(NSString *)url
                          params:(NSDictionary *)params
                         success:(HFResponseSuccessBlock)success
                            fail:(HFResponseFailureBlock)fail {
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        return nil;
    }
    NSString *cacheKey = url;
    return [self requestWithHttpMethod:HFRequestGET
                             URLString:url
                                params:params
                          successBlock:success
                          failureBlock:fail];
    
}


+ (HFURLSessionTask *)postNoTipWithURL:(NSString *)url
                           params:(NSDictionary *)params
                          success:(HFResponseSuccessBlock)success
                             fail:(HFResponseFailureBlock)fail {
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        return nil;
    }
    NSString *cacheKey = url;
    return [self requestWithHttpMethod:HFRequestPOST
                             URLString:url
                                params:params
                          successBlock:success
                          failureBlock:fail];
}

//有提示
+ (HFURLSessionTask *)getWithURL:(NSString *)url
                          params:(NSDictionary *)params
                         success:(HFResponseSuccessBlock)success
                            fail:(HFResponseFailureBlock)fail {
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        return nil;
    }
    [MBProgressHUD showHUD:nil];
    NSString *cacheKey = url;
    return [self requestWithHttpMethod:HFRequestGET
                             URLString:url
                                params:params
                          successBlock:success
                          failureBlock:fail];
    
}


+ (HFURLSessionTask *)postWithURL:(NSString *)url
                           params:(NSDictionary *)params
                          success:(HFResponseSuccessBlock)success
                             fail:(HFResponseFailureBlock)fail {
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        return nil;
    }
    [MBProgressHUD showHUD:nil];
    NSString *cacheKey = url;
    return [self requestWithHttpMethod:HFRequestPOST
                             URLString:url
                                params:params
                          successBlock:success
                          failureBlock:fail];
}


+ (void)cancelAllRequest {
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(HFURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[HFURLSessionTask class]]) {
                [task cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (!url) {
        return;
    }
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(HFURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[HFURLSessionTask class]] && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return ;
            }
        }];
    }
}

+ (void)setTimeOut:(NSTimeInterval)timeInterval {
    hf_timeout = timeInterval;
}
@end
