//
//  JJStoreType.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJStoreTypeView.h"

@implementation JJStoreTypeView

+(instancetype)storeTypeView {
    return [[NSBundle mainBundle]loadNibNamed:@"JJStoreTypeView" owner:nil options:nil][0];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
