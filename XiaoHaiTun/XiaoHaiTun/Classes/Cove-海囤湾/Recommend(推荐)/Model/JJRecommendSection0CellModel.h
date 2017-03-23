//
//  JJRecommendSection0CellModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJRecommendSection1Model.h"
#import "JJBaseGoodsModel.h"

@interface JJRecommendSection0CellModel : JJBaseGoodsModel
//"http://....ac", #图片路径
@property (nonatomic, copy)NSString* picture;
//"title": "child", # 名称
@property (nonatomic, copy)NSString* title;
//"url": "http://...vb", #
@property (nonatomic, copy)NSString* url;
////"theme_type": 1, # 1 商品
//@property (nonatomic, copy)NSString* theme_type;
//"id": 1, #
@property (nonatomic, copy)NSString* GoodsID;

////大图Url
//@property (nonatomic, copy)NSString* bigImageUrl;

@property (nonatomic, strong) NSArray<JJRecommendSection1Model *> *related_goods;


@end
