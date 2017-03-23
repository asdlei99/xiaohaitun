//
//  JJGoodsWaitCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJGoodsWaitModel;
@class JJGoodsOrderModel;
@interface JJGoodsWaitCell : UITableViewCell

@property(nonatomic, strong)JJGoodsOrderModel *model;

//立即支付
@property (nonatomic, weak) UIButton *payButton;

@end
