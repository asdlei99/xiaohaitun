//
//  JJWaitPayViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"

@interface JJWaitPayViewController : JJBaseViewController


//(0, '待下单'),
//(1, '付款成功'),
//(2, '订单取消'),
//(3, '待发货'),
//(4, '配送中'),
//(5, '已完成'),
//(6, '退款申请中'),
//(7, '退款中'),
//(8, '退款成功'),
//(9, '等待付款'),
//10   我的所有订单
@property(nonatomic,assign)NSInteger goodsWaitType;

@end
