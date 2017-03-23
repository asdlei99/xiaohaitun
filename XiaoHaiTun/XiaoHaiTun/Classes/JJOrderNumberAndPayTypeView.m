//
//  JJOrderNumberAndPayTypeView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJOrderNumberAndPayTypeView.h"
#import "UILabel+LabelStyle.h"

@interface JJOrderNumberAndPayTypeView()

@end


@implementation JJOrderNumberAndPayTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //订单号
        UILabel *ordersNumberLabel = [[UILabel alloc]init];
        [ordersNumberLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentLeft];
        self.ordersNumberLabel = ordersNumberLabel;
        [self addSubview:self.ordersNumberLabel];
        [_ordersNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(13 * KWIDTH_IPHONE6_SCALE);
            make.top.bottom.equalTo(self);
        }];
        //代付款
        UILabel *waitLabel = [[UILabel alloc]init];
        [waitLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentRight];
        self.waitLabel = waitLabel;
        [self addSubview:_waitLabel];
        [_waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(self).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBA(238, 238, 238, 1);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.bottom.equalTo(self);
            make.height.equalTo(@1);
            make.right.equalTo(self);
        }];
    }return self;

}

@end
