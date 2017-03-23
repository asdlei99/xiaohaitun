//
//  JJActivityOrderConfirmMessageView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/16.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityOrderConfirmMessageView.h"
#import "UILabel+LabelStyle.h"

@interface JJActivityOrderConfirmMessageView ()


//数量
//@property (nonatomic, weak)UILabel *countLabel;

@end

@implementation JJActivityOrderConfirmMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        //top
        UIView *topView = [[UIView alloc]init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        //出发日期
        UILabel* goDateMessageLabel = [[UILabel alloc]init];
        [topView addSubview:goDateMessageLabel];
        [goDateMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"出发日期" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [goDateMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).with.offset(12 * KWIDTH_IPHONE6_SCALE);
            make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
            make.height.equalTo(@20);
        }];
        UILabel *goDateLabel = [[UILabel alloc]init];
        [topView addSubview:goDateLabel];
        self.goDateLabel =goDateLabel;
        [goDateLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"¥ 2016-8-8" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
        [goDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
            make.right.equalTo(topView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
            make.height.equalTo(@20);
            
        }];
        
        //类型
        UILabel *typeMessageLabel = [[UILabel alloc]init];
        [topView addSubview:typeMessageLabel];
        [typeMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"类型" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [typeMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(goDateLabel.mas_bottom).with.offset(12 * KWIDTH_IPHONE6_SCALE);
            make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
            make.height.equalTo(@20);
        }];
        UILabel *typeLabel = [[UILabel alloc]init];
        [topView addSubview:typeLabel];
        self.typeLabel = typeLabel;
        [typeLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"893" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(goDateLabel.mas_bottom).with.offset(12 * KWIDTH_IPHONE6_SCALE);
            make.right.equalTo(topView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
            make.height.equalTo(@20);
        }];
        
        
        //费用
        UILabel *payMoneyMessageLabel = [[UILabel alloc]init];
        [topView addSubview:payMoneyMessageLabel];
        [payMoneyMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"费用" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [payMoneyMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(typeLabel.mas_bottom).with.offset(12 * KWIDTH_IPHONE6_SCALE);
            make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
            make.height.equalTo(@20);
        }];
        UILabel *payMoneyLabel = [[UILabel alloc]init];
        [topView addSubview:payMoneyLabel];
        self.payMoneyLabel = payMoneyLabel;
        [payMoneyLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"8934元" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
        [payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(typeLabel.mas_bottom).with.offset(12 * KWIDTH_IPHONE6_SCALE);
            make.right.equalTo(topView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
            make.height.equalTo(@20);
        }];
        
        //横线
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBA(238, 238, 238, 1);
        [topView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
            make.left.equalTo(topView);
            make.right.equalTo(topView);
            make.bottom.equalTo(topView);
        }];
        

    }
    return self;
}

@end
