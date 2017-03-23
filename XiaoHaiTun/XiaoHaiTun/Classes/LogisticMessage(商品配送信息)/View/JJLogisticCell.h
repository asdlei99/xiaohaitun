//
//  JJLogisticCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JJgoodsOrderLogisticModel;

@interface JJLogisticCell : UITableViewCell

@property (nonatomic, strong) JJgoodsOrderLogisticModel *orderLogisticModel;

//上竖线
@property (nonatomic, strong) UIView *topVerticalView;
//中圆圈
@property (nonatomic, strong) UIImageView *centerCircleView;
//下竖线
@property (nonatomic, strong) UIView *bottomVerticalView;
//物流信息
@property (nonatomic, strong) UILabel *logisticMessageLabel;
//日期
@property (nonatomic, strong) UILabel *dateMessageLabel;

@end
