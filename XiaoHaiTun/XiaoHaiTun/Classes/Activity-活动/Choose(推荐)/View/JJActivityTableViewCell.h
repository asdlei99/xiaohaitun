//
//  JJActivityTableViewCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/6.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJActivityTableViewCellModel;
@interface JJActivityTableViewCell : UITableViewCell

@property (nonatomic, strong) JJActivityTableViewCellModel *model;

//图片
@property (nonatomic, weak) UIImageView *iconImageView;

//价格label
@property (nonatomic, weak) UILabel *priceLabel;

//描述Lable
@property (nonatomic, weak) UILabel *descriptLabel;
//距离
@property (nonatomic, weak) UILabel *distanceLabel;
//距离图
@property (nonatomic, weak) UIImageView *distanceImageView;
@end
