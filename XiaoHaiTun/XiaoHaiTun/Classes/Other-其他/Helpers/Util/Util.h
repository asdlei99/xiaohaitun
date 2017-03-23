//
//  Util.h
//  HiFun
//
//  Created by attackt on 16/8/4.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

/**
 * 获取当前系统的语言
 * iOS9.0之前          zh-Hans:简体中文    en:英文
 * iOS9.0和iOS9.0之后  zh-Hans-CN:简体中文 en-CN:英文
 * 建议的判断方式是 if ([[Util getPreferredLanguage] hasPrefix:@"zh-Hans"])
 */
+ (NSString *)getPreferredLanguage;

/**
 *  是否纯数字
 */
+ (BOOL)isPureInt:(NSString*)string;

/**
 *  是否为合法的手机号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  是否为数字和字母
 */
+ (BOOL)isNumberAndChar:(NSString *)string;

/**
 * 将 image 进行 base64 转码
 */
+ (NSString *)base64WithImage:(UIImage *)image;

/**
 *  将 base64字符串转为 image
 */
+ (UIImage *)imageWithBase64String:(NSString *)string;

/**
 *  JSON字符串转NSDictionary
 */
+ (NSDictionary *)JsonStringToDictionary:(NSString *)jsonString;

/**
 *  NSDictionary转 JSON
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/**
 *  NSArray转 JSON
 */
+ (NSString*)arrayToJson:(NSArray *)arr;
/**
 *  网络实时状态的判断
 */
+ (BOOL)isNetWorkEnable;

/**
 获取客户端ip
 */
+ (NSString *)getClientIP;

/**
 * 只含有汉语、英文字符、数字、下划线
 */
+ (BOOL)isValiteNum_Char_CNStr:(NSString *)string;

/**
 * //判断一个字符串是否是纯数字
 */
+ (BOOL)ismathNumberWithString:(NSString *)string;
@end
