//
//  JJGoodsOrderModel.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJGoodsOrderModel.h"
#import <MJExtension.h>
@implementation JJGoodsOrderModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"goods_relateds" : [JJGoodsWaitModel class]};
}

@end
