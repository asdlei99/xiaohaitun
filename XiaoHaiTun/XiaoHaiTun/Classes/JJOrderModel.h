//
//  JJOrderModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJOrderModel : NSObject
//订单号
@property (nonatomic, copy)NSString *order_num;
//实付款
@property (nonatomic, assign)CGFloat total_fee;
@end
