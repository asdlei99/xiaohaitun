//
//  JJRecommendADViewModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/18.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJBaseGoodsModel.h"
/*
 {
 "carousel": [
 {
 "picture": "14740334841731.jpg",
 "order_no": 1,
 "title": "商品专题1",
 "url": "",
 "project_type": 1,
 "is_line": 1,
 "id": 1
 }
 ]
 }
 */


@interface JJRecommendADViewModel : JJBaseGoodsModel

@property (nonatomic, copy)NSString* picture;
@property (nonatomic, copy)NSString* order_no;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy)NSString* url;
@property (nonatomic, copy)NSString* project_type;
@property (nonatomic, copy)NSString* is_line;
@property (nonatomic, copy)NSString* GoodsID;
@property (nonatomic, copy)NSString* associated_id;//轮播图id
/*
 "picture": "http://....ac", # 轮播图片路径
 "name": "1号专题", # 名称
 "order_no": 1, # 排序号
 "url": "http://...vb", # 主题链接
 "project_type": 1, # 主题类型 1 商品，2 活动
 "is_line": 0, # 是否上线      1 yes，0 no
 "id": 1 # 主题id
 "related_goods_id": 3 # 关联商品id
 "related_activities_id"：null # 关联活动id
*/

@end
