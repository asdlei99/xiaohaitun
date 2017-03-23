//
//  JJGoodsDetailBottomMenu.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJGoodsDetailBottomMenu.h"

@implementation JJGoodsDetailBottomMenu

+ (instancetype)goodsDetailBottomMenu {
    return [[NSBundle mainBundle]loadNibNamed:@"JJGoodsDetailBottomMenu" owner:nil options:nil][0];

}

@end
