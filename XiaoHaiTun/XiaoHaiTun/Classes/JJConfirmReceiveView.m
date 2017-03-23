//
//  JJConfirmReceiveView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJConfirmReceiveView.h"

@implementation JJConfirmReceiveView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)confirmReceiveView {
    return  [[NSBundle mainBundle]loadNibNamed:@"JJConfirmReceiveView" owner:nil options:nil][0];
}
@end
