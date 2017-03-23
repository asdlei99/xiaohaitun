//
//  HFNetWork.h
//  HiFun
//
//  Created by attackt on 16/7/29.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 请求方法的枚举值
 */
typedef NS_ENUM(NSInteger, HTTPMethod) {
    HFRequestGET,
    HFRequestPOST
};
@class NSURLSessionTask;
typedef NSURLSessionTask HFURLSessionTask;

typedef void (^HFResponseSuccessBlock)(id response);
typedef void (^HFResponseFailureBlock)(NSError *error);

@interface HFNetWork : NSObject

//无提示
/**
 *  GET 请求
 *
 *  @param url     URL
 *  @param params  请求参数
 *  @param isCache 是否使用缓存
 *  @param success 请求成功的回调
 *  @param fail    请求失败的回调
 *
 *  @return 有可能取消的API
 */
+ (HFURLSessionTask *)getNoTipWithURL:(NSString *)url
                               params:(NSDictionary *)params
                              success:(HFResponseSuccessBlock)success
                                 fail:(HFResponseFailureBlock)fail;
/**
 *  POST请求
 *
 *  @param url     URL
 *  @param params  请求参数
 *  @param isCache 是否使用缓存数据
 *  @param success 请求成功的回调
 *  @param fail    请求失败的回调
 *
 *  @return 有可能取消的API
 */
+ (HFURLSessionTask *)postNoTipWithURL:(NSString *)url
                                params:(NSDictionary *)params
                               success:(HFResponseSuccessBlock)success
                                  fail:(HFResponseFailureBlock)fail;


/**
 *  GET 请求
 *
 *  @param url     URL
 *  @param params  请求参数
 *  @param isCache 是否使用缓存
 *  @param success 请求成功的回调
 *  @param fail    请求失败的回调
 *
 *  @return 有可能取消的API
 */
+ (HFURLSessionTask *)getWithURL:(NSString *)url
                          params:(NSDictionary *)params
                         success:(HFResponseSuccessBlock)success
                            fail:(HFResponseFailureBlock)fail;

/**
 *  POST请求
 *
 *  @param url     URL
 *  @param params  请求参数
 *  @param isCache 是否使用缓存数据
 *  @param success 请求成功的回调
 *  @param fail    请求失败的回调
 *
 *  @return 有可能取消的API
 */
+ (HFURLSessionTask *)postWithURL:(NSString *)url
                           params:(NSDictionary *)params
                          success:(HFResponseSuccessBlock)success
                             fail:(HFResponseFailureBlock)fail;
/**
 *  取消特定URL的请求
 *
 *  @param url URL字符串
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/**
 *  取消所有请求
 */
+ (void)cancelAllRequest;

/**
 *  请求超时设定
 *
 *  @param timeInterval 超时时间
 */
+ (void)setTimeOut:(NSTimeInterval)timeInterval;

/**
 *  所有的task请求
 *
 *  @return 返回所有的task请求数组
 */
+ (NSMutableArray *)allTasks ;
@end
