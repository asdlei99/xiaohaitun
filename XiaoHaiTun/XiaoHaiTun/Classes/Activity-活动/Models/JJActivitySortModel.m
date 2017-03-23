//
//  JJActivitySortModel.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/19.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivitySortModel.h"
#import <MJExtension.h>

@implementation JJActivitySortModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"categoryID" : @"id"};
}

@end
