//
//  JJShopCarCellModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJShopCarCellModel : NSObject
//商品ID
@property (nonatomic, copy)NSString* goodsID;
//是否选中
@property (nonatomic, assign)BOOL selected;
//图片地址
@property (nonatomic, copy)NSString *cover;
//描述
@property (nonatomic, copy)NSString *name;
//价格
@property (nonatomic, assign)CGFloat price;
//数量
@property (nonatomic, assign)NSInteger number;
//规格id
@property (nonatomic, copy) NSString *goods_sku_id;
//规格字符串
@property (nonatomic, copy) NSString *goods_sku_str;


@end
