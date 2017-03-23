//
//  JJMyCollectionModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJBaseGoodsModel.h"
@interface JJMyCollectionModel : JJBaseGoodsModel

//商品ID
@property (nonatomic, copy)NSString* goodsID;
//商品logo
@property (nonatomic, copy)NSString* cover;
//商品名称
@property (nonatomic, copy)NSString* name;
//商品价格
@property (nonatomic, copy)NSString* price;


@end
