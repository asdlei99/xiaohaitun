//
//  JJgoodsOrderLogistic.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJReceiveAddressModel.h"
//快递模型
@interface JJgoodsOrderLogisticModel : NSObject
//"logistics_id": 12 , # 快递id
//"logistics_no":  "1234123412341234", # 快递单号
//"logistics_company":  "sf", # 快递公司简称
//"logistics_company_name":  "顺丰", # 快递公司
//"logistics_zone":  "北京", # 地域
//"logistics_remark":  "已出发，下一站北京市", # 描述
//"logistics_time" : 01234132412341324 # 时间

//快递ID
@property (nonatomic, copy)NSString *logistics_id;
//快递单号
@property (nonatomic, copy)NSString *logistics_no;
//快递公司简称
@property (nonatomic, copy)NSString *logistics_company;
//快递公司
@property (nonatomic, copy)NSString *logistics_company_name;
//地域
@property (nonatomic, copy)NSString *logistics_zone;
//下一站描述
@property (nonatomic, copy)NSString *logistics_remark;
//时间
@property (nonatomic, copy)NSString *logistics_time;

@end

//订单+地址模型


