//
//  JJOrderPayMondyCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJOrderPayMondyCell.h"
#import "UILabel+LabelStyle.h"
#import "JJGoodsOrderModel.h"

@interface JJOrderPayMondyCell ()

//订单总额
@property (nonatomic, weak)UILabel *allOrderMoneyLabel;
//优惠金额
@property (nonatomic, weak)UILabel *favourableMoneyLabel;
//运费
@property (nonatomic, weak)UILabel *freightMoneyLabel;
//实际付款
@property (nonatomic, weak)UILabel *actualMoneyLabel;

@end

@implementation JJOrderPayMondyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    //top
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52 * KWIDTH_IPHONE6_SCALE)];
    [self.contentView addSubview:topView];
    topView.backgroundColor = RGBA(238, 238, 238, 1);
    //支付信息Label
    UILabel *payMessagelabel = [[UILabel alloc]init];
    [topView addSubview:payMessagelabel];
    [payMessagelabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14] text:@"支付信息" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentLeft];
    [payMessagelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(topView).with.offset(24 * KWIDTH_IPHONE6_SCALE);
    }];
    
    
    UIView *bottomView = [[UIView alloc]init];
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.bottom.equalTo(self.contentView);
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
    [allOrderMoneyLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"¥0" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
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
    [favourableMoneyLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"¥0" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
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
    [freightMoneyLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"¥0" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
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
    self.actualMoneyLabel = actualMoneyLabel;
    [bottomView addSubview:actualMoneyLabel];
    [actualMoneyLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"¥0" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    [actualMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(freightMoneyMessageLabel.mas_bottom).with.offset(6 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(bottomView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
}

- (void)setGoodsOrderModel:(JJGoodsOrderModel *)goodsOrderModel {
    _goodsOrderModel = goodsOrderModel;
    self.allOrderMoneyLabel.text = [NSString stringWithFormat:@"¥%@",goodsOrderModel.total_fee];
    self.actualMoneyLabel.text = [NSString stringWithFormat:@"¥%@",goodsOrderModel.real_fee];
    
    
}

@end
