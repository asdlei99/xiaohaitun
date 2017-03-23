//
//  JJSubmitMenuView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSubmitMenuView.h"

@implementation JJSubmitMenuView

+ (instancetype)submitMenuView {
    return [[NSBundle mainBundle]loadNibNamed:@"JJSubmitMenuView" owner:nil options:nil][0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
