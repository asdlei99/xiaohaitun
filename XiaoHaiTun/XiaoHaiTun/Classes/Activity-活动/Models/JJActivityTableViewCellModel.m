//
//  JJActivityTableViewCellModel.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityTableViewCellModel.h"
#import <MJExtension.h>

@implementation JJActivityTableViewCellModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"activityID" : @"id" , @"pictures" : @"picture" };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"items" : [JJActivityDetailHorizontalGoodsModel class]};
}

@end
