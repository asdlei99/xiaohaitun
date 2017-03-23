//
//  JJJJApplyRefundCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJGoodsOrderModel;
@interface JJApplyRefundCell : UITableViewCell

@property (nonatomic, strong)JJGoodsOrderModel *goodsOrderModel;
//提交申请按钮
@property (nonatomic, weak) UIButton *submitBtn;

@end
