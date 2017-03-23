//
//  JJSortedCellModel.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/5.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSortedCellModel.h"
#import <MJExtension.h>

@implementation JJSortedCellModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"categoryID" : @"id"};
}

@end
