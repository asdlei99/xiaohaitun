//
//  JJImmediratePayView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJImmediratePayView.h"

@implementation JJImmediratePayView

+ (instancetype)immediratePayView {
   return  [[NSBundle mainBundle]loadNibNamed:@"JJImmediratePay" owner:nil options:nil][0];
}

@end
