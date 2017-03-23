//
//  JJShopCarCellModel.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJShopCarCellModel.h"
#import <MJExtension.h>

@implementation JJShopCarCellModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"goodsID" : @"id"};
}

@end
