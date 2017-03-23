//
//  JJGoodsWaitModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

//"goods_id": 1, # 商品id
//"goods_name": 1, # 商品名称
//"goods_cover": "http://asdfaf.jpg", # 商品图片
//"goods_price": 1.0,  # 商品价格
//"goods_num": 1,  # 商品数量
//"goods_sku_str":   "蓝色，24",  # 商品规格串

@interface JJGoodsWaitModel : NSObject
//商品Id
@property (nonatomic, copy)NSString *goods_id;

//商品图片
@property (nonatomic, copy)NSString* goods_cover;

//商品名称
@property (nonatomic, copy)NSString* goods_name;

//商品价格
@property (nonatomic, copy)NSString* goods_price;
//商品数量
@property(nonatomic,assign)NSInteger goods_num;
//商品规格串"蓝色，24",
@property (nonatomic, copy)NSString* goods_sku_str;


@end
