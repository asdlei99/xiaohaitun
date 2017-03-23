//
//  JJActivityOrderPayMondyCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityOrderPayMondyCell.h"
#import "UILabel+LabelStyle.h"

@interface JJActivityOrderPayMondyCell ()

@end

@implementation JJActivityOrderPayMondyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initBaseView];
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *bottomView = [[UIView alloc]init];
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.contentView);
    }];
    
    //订单总额
    UILabel* allOrderMoneyMessageLabel = [[UILabel alloc]init];
    [bottomView addSubview:allOrderMoneyMessageLabel];
    [allOrderMoneyMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"订单总额:" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [allOrderMoneyMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(bottomView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
    UILabel *allOrderMoneyLabel = [[UILabel alloc]init];
    [bottomView addSubview:allOrderMoneyLabel];
    self.allOrderMoneyLabel =allOrderMoneyLabel;
    [allOrderMoneyLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    [allOrderMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(bottomView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
        
    }];
    
    
    
    //优惠金额
    UILabel *favourableMoneyMessageLabel = [[UILabel alloc]init];
    [bottomView addSubview:favourableMoneyMessageLabel];
    [favourableMoneyMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"优惠金额:" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [favourableMoneyMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allOrderMoneyMessageLabel.mas_bottom).with.offset(6 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(bottomView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
    UILabel *favourableMoneyLabel = [[UILabel alloc]init];
    [bottomView addSubview:favourableMoneyLabel];
    self.favourableMoneyLabel = favourableMoneyLabel;
    [favourableMoneyLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    [favourableMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allOrderMoneyMessageLabel.mas_bottom).with.offset(6 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(bottomView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
    
    
    //运费
    UILabel *freightMoneyMessageLabel = [[UILabel alloc]init];
    [bottomView addSubview:freightMoneyMessageLabel];
    [freightMoneyMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"运费:" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [freightMoneyMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(favourableMoneyMessageLabel.mas_bottom).with.offset(6 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(bottomView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
    UILabel *freightMoneyLabel = [[UILabel alloc]init];
    [bottomView addSubview:freightMoneyLabel];
    self.freightMoneyLabel = freightMoneyLabel;
    [freightMoneyLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    [freightMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(favourableMoneyMessageLabel.mas_bottom).with.offset(6 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(bottomView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
    
    
    
    //实际付款
    UILabel *actualMoneyMessageLabel = [[UILabel alloc]init];
    [bottomView addSubview:actualMoneyMessageLabel];
    [actualMoneyMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"实际付款:" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [actualMoneyMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(freightMoneyMessageLabel.mas_bottom).with.offset(6 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(bottomView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
    UILabel *actualMoneyLabel = [[UILabel alloc]init];
    [bottomView addSubview:actualMoneyLabel];
    self.actualMoneyLabel = actualMoneyLabel;
    [actualMoneyLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    [actualMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(freightMoneyMessageLabel.mas_bottom).with.offset(6 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(bottomView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
    
}


@end
