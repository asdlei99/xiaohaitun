//
//  JJOrderNumberAndPayTypeView.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
// 订单详情页

#import <UIKit/UIKit.h>

@interface JJOrderNumberAndPayTypeView : UIView

//订单号
@property (nonatomic, weak) UILabel *ordersNumberLabel;
//等待付款/付款成功/已取消
@property (nonatomic, weak) UILabel *waitLabel;

@end
