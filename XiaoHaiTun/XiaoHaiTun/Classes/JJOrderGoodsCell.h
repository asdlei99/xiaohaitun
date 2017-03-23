//
//  JJOrderGoodsCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//  订单详情页

#import <UIKit/UIKit.h>
@class JJGoodsWaitModel;
//@class JJShopCarCellModel;
@interface JJOrderGoodsCell : UITableViewCell

//为什么有两个模型?因为他妈的后台命名不统一
@property (nonatomic, strong) JJGoodsWaitModel *model;


@end
