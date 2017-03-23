//
//  XMGTitleButton.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/16.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGTitleButton.h"

@implementation XMGTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置按钮颜色
        // self.selected = NO;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // self.selected = YES;
        [self setTitleColor:NORMAL_COLOR forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {}

@end
