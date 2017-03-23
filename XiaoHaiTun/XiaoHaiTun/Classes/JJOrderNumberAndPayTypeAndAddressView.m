//
//  JJOrderNumberAndPayTypeAndAddressView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJOrderNumberAndPayTypeAndAddressView.h"
#import "UILabel+LabelStyle.h"
#import "JJGoodsOrderModel.h"
#import "JJgoodsOrderLogisticModel.h"
#import "NSString+XPKit.h"

@interface JJOrderNumberAndPayTypeAndAddressView()

//订单号
@property (nonatomic, weak) UILabel *ordersNumberLabel;
//等待付款/付款成功/已取消
@property (nonatomic, weak) UILabel *waitLabel;

//快递信息
@property (nonatomic, weak) UILabel *expressMessageLabel;
//时间
@property (nonatomic, weak) UILabel *dateLabel;


@end


@implementation JJOrderNumberAndPayTypeAndAddressView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 59 * KWIDTH_IPHONE6_SCALE)];
        [self addSubview:topView];
        
        //订单号
        UILabel *ordersNumberLabel = [[UILabel alloc]init];
        [ordersNumberLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"订单号:00000" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentLeft];
        self.ordersNumberLabel = ordersNumberLabel;
        [topView addSubview:self.ordersNumberLabel];
        [_ordersNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView).with.offset(13 * KWIDTH_IPHONE6_SCALE);
            make.top.bottom.equalTo(topView);
        }];
        //代付款
        UILabel *waitLabel = [[UILabel alloc]init];
        [waitLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentRight];
        self.waitLabel = waitLabel;
        [topView addSubview:_waitLabel];
        [_waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(topView);
            make.right.equalTo(topView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        }];
        UIView * lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBA(238, 238, 238, 1);
        [topView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(topView);
            make.height.equalTo(@1);
        }];
        //底部
        UIView *bottomView = [[UIView alloc]init];
        bottomView.clipsToBounds = YES;
        self.bottomView = bottomView;
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(topView.mas_bottom);
        }];
        //快递信息
        UILabel *expressMessageLabel = [[UILabel alloc]init];
        expressMessageLabel.numberOfLines = 2;
        self.expressMessageLabel = expressMessageLabel;
        [bottomView addSubview:self.expressMessageLabel];
        [self.expressMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [self.expressMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
            make.top.equalTo(bottomView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
            make.right.equalTo(bottomView).with.offset(-39 * KWIDTH_IPHONE6_SCALE);
        }];
        //时间
        UILabel *dateLabel = [[UILabel alloc]init];
        self.dateLabel = dateLabel;
        [bottomView addSubview:self.dateLabel];
        [self.dateLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:10] text:@"" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentLeft];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
            make.bottom.equalTo(bottomView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        }];
        //箭头
        UIImageView *arrowPicyureView = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"me_Arrow"]];
        [bottomView addSubview:arrowPicyureView];
        [arrowPicyureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView);
            make.right.equalTo(bottomView).with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        }];
    }return self;
    
}

- (void)setGoodsOrderLogisticModel:(JJgoodsOrderLogisticModel *)goodsOrderLogisticModel {
    _goodsOrderLogisticModel = goodsOrderLogisticModel;
    self.expressMessageLabel.text = [NSString stringWithFormat:@"[%@转运中心]%@  %@",goodsOrderLogisticModel.logistics_zone,goodsOrderLogisticModel.logistics_remark,goodsOrderLogisticModel.logistics_company_name];
    self.dateLabel.text = [goodsOrderLogisticModel.logistics_time stringChangeToDate:@"yyyy-MM-dd HH:mm:ss"];
}
- (void)setGoodsOrderModel:(JJGoodsOrderModel *)goodsOrderModel {
    _goodsOrderModel = goodsOrderModel;
    self.ordersNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",goodsOrderModel.order_num];
    switch (goodsOrderModel.status) {
        case 0:
        self.waitLabel.text = @"待下单";
//        self.bottomView.hidden = YES;
        break;
        case 1:
        self.waitLabel.text = @"付款成功";
//        self.bottomView.hidden = YES;
        break;
        case 2:
        self.waitLabel.text = @"订单取消";
//        self.bottomView.hidden = YES;
        break;
        case 3:
        self.waitLabel.text = @"待发货";
//        self.bottomView.hidden = YES;
        break;
        case 4:
        self.waitLabel.text = @"配送中";
        break;
        case 5:
        self.waitLabel.text = @"已完成";
//        self.bottomView.hidden = YES;
        break;
        case 6:
        self.waitLabel.text = @"退款申请中";
//        self.bottomView.hidden = YES;
        break;
        case 7:
        self.waitLabel.text = @"退款中";
//        self.bottomView.hidden = YES;
        break;
        case 8:
        self.waitLabel.text = @"退款成功";
//        self.bottomView.hidden = YES;
        break;
        case 9:
        self.waitLabel.text = @"等待付款";
        self.bottomView.hidden = YES;
        break;
        case 10:
            self.waitLabel.text = @"收货成功";
//            self.bottomView.hidden = NO;
            break;
        case 11:
            self.waitLabel.text = @"退款失败";
//            self.bottomView.hidden = YES;
            break;
        default:
        break;
    }
}

@end
