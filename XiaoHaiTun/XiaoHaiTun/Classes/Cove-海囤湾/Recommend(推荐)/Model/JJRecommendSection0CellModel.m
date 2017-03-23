//
//  JJRecommendSection0CellModel.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJRecommendSection0CellModel.h"
#import <MJExtension.h>


@implementation JJRecommendSection0CellModel

+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"GoodsID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"related_goods" : [JJRecommendSection1Model class]};
}

@end
