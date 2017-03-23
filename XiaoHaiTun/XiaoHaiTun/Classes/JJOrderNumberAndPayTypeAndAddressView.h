//
//  JJOrderNumberAndPayTypeAndAddressView.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
// 订单详情页

#import <UIKit/UIKit.h>

@class JJgoodsOrderLogisticModel;
@class JJGoodsOrderModel;

@interface JJOrderNumberAndPayTypeAndAddressView : UIView

@property (nonatomic, strong) JJgoodsOrderLogisticModel *goodsOrderLogisticModel;
@property (nonatomic, strong) JJGoodsOrderModel *goodsOrderModel;

//底部View
@property (nonatomic, strong) UIView *bottomView;

@end
