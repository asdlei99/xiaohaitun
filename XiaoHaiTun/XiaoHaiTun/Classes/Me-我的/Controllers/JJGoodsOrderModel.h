//
//  JJGoodsOrderModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJGoodsWaitModel.h"
#import "JJReceiveAddressModel.h"
@interface JJGoodsOrderModel : NSObject
//代付款||待收货||待发货(订单状态)
@property(nonatomic,assign)NSInteger status;
//订单号
@property (nonatomic, copy)NSString* order_num;
//订单实际付款
@property (nonatomic, copy)NSString* real_fee;
//订单总额
@property (nonatomic, copy)NSString *total_fee;
//备注
@property (nonatomic, copy)NSString *note;
@property (nonatomic, strong) NSArray<JJGoodsWaitModel *> *goods_relateds;

//收货地址
@property (nonatomic, strong) JJReceiveAddressModel *address;

@end
