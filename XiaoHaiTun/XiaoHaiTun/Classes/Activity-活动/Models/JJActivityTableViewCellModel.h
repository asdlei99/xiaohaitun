//
//  JJActivityTableViewCellModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJActivityDetailHorizontalGoodsModel.h"
#import "JJBaseGoodsModel.h"
@interface JJActivityTableViewCellModel : JJBaseGoodsModel
//活动ID
@property (nonatomic, copy)NSString* activityID;
//活动名称
@property (nonatomic, copy)NSString* name;

//图片地址,仅仅只有活动详情用
@property (nonatomic, copy)NSString* cover;
@property (nonatomic, copy)NSString* picture;

//图片地址
@property (nonatomic, strong)NSArray* pictures;

//年龄段
@property (nonatomic, copy)NSString* age;
//商家名称
@property (nonatomic, copy)NSString* merchant;
//城市
@property (nonatomic, copy)NSString* city;
//经纬度
@property (nonatomic, copy)NSString* lng;
@property (nonatomic, copy)NSString* lat;
//商家电话
@property (nonatomic, copy)NSString* phone;
//开始时间
@property (nonatomic, copy)NSString* start_time;
//结束时间
@property (nonatomic, copy)NSString* end_time;
//限制
@property (nonatomic, copy)NSString* limit;
//价格
@property (nonatomic, copy)NSString* price;
//地址
@property (nonatomic, copy)NSString* address;
//内容
@property (nonatomic, copy)NSString* content;
//类别名
@property (nonatomic, copy)NSString* category;
//距离
@property (nonatomic, copy)NSString* distance;

//推荐商品
@property (nonatomic, strong) NSArray<JJActivityDetailHorizontalGoodsModel *> *items;


@end

/*
 "id": 12,
 "name": "推荐活动", # 名称
 "picture": "http://...vb", # 图片地址
 "age":  "0~3岁", #
 "merchant":  "商家名称",
 "city":  "城市",
 "lng":  1212121212,
 "lat":  1212121212,
 "start_time":  1212121212,
 "end_time":  1212121212,
 "limit": 2,
 "price":  12.3,
 "address":  "地址名称",
 "content":  "内容",
 
 */
