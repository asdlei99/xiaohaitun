//
//  JJRecommendSection1Model.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/29.
//  Copyright © 2016年 唐天成. All rights reserved.
//  section1 的Cell的模型

#import <Foundation/Foundation.h>
#import "JJBaseGoodsModel.h"

@interface JJRecommendSection1Model : JJBaseGoodsModel
//商品ID
@property (nonatomic, copy)NSString* GoodsID;
//封面图片路径
@property (nonatomic, copy)NSString* cover;
////封面缩略图
//@property (nonatomic, copy)NSString *cover1;
//名称
@property (nonatomic, copy)NSString* name;
//编号
@property (nonatomic, copy)NSString* number;
//库存数量
@property (nonatomic, copy)NSString* stock_number;
//price
@property (nonatomic, copy)NSString* price;


//是否上架 ，0下 1上
@property (nonatomic, copy)NSString* status;
//# 是否删除，0 F 1 T
@property (nonatomic, copy)NSString* is_del;
//# 所属保税区id
@property (nonatomic, copy)NSString* free_zone_id;
//# 详情
@property (nonatomic, copy)NSString* detail;
//# 剩余库存
@property (nonatomic, copy)NSString* stock_surplus;
//# 所属商家id
@property (nonatomic, copy)NSString* merchant_id;
//# 参数
@property (nonatomic, copy)NSString* parameter;

@end
/*
 "id": 1,
 "cover": "http://....ac",  #封面图片路径
 "name": "child", # 名称
 "number": "orange11231", # 编号
 "stock_number": 1, # 库存数量
 "price": 1.2

*/
