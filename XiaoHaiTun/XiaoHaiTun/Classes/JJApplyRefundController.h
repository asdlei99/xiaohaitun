//
//  JJApplyRefundController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
// 申请退款界面

#import "JJBaseViewController.h"
@class JJGoodsOrderModel;
@class JJGoodsWaitModel;

@protocol JJGoodsOrderRefundDelegate <NSObject>

- (void)goodsOrderRefundSuccess;

@end

@interface JJApplyRefundController : JJBaseViewController
//订单model
@property (nonatomic, strong) JJGoodsOrderModel *goodsOrderModel;
//订单中的商品数组
@property (nonatomic, strong) NSArray<JJGoodsWaitModel *> *goodsWaitModelArray;
@property (nonatomic, weak) id<JJGoodsOrderRefundDelegate > refundDelegate;
@end
