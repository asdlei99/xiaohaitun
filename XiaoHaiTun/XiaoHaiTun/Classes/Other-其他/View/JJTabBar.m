//
//  JJTabBar.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTabBar.h"
#import "UIImage+XPKit.h"

@implementation JJTabBar

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    }
    return self;
}

@end
