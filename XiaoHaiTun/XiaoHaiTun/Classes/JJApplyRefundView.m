//
//  JJApplyRefundView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJApplyRefundView.h"

@implementation JJApplyRefundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)applyRefundView {
    return  [[NSBundle mainBundle]loadNibNamed:@"JJApplyRefundView" owner:nil options:nil][0];
}

@end
