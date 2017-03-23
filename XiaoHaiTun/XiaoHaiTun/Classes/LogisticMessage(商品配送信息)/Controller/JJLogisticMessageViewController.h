//
//  JJLogisticMessageViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseTableViewController.h"
@class JJGoodsOrderModel;
@class JJgoodsOrderLogisticModel;

@interface JJLogisticMessageViewController : JJBaseTableViewController
//订单model
@property (nonatomic, strong) JJGoodsOrderModel *goodsOrderModel;
//快递model
@property (nonatomic, strong) JJgoodsOrderLogisticModel *goodsOrderLogisticModel;


@end
