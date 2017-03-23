//
//  JJCashierHeaderView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJCashierHeaderView.h"

@implementation JJCashierHeaderView

+ (instancetype)cashierHeaderView{
    return [[NSBundle mainBundle]loadNibNamed:@"JJCashierHeaderView" owner:nil options:nil][0];
}

@end
