//
//  JJCity.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJCity : NSObject

@property (nonatomic, copy)NSString* cityID;

@property (nonatomic, copy)NSString* cityName;

+(NSDictionary*)mj_replacedKeyFromPropertyName;

+ (void)saveCityArrayInformation:(NSArray *)cityArray;
+ (void)removeCityArrayInformation;
+ (NSArray *)getcityArrayInformation;
@end
