//
//  JJLogisticHeaderCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJLogisticHeaderCell.h"

@interface JJLogisticHeaderCell()

@end

@implementation JJLogisticHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //订单编号名字Label
        UILabel *orderNameLabel = [[UILabel alloc]init];
        orderNameLabel.textColor = RGBA(153, 153, 153, 1);
        orderNameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:orderNameLabel];
        orderNameLabel.text = @"订单编号: ";
        [orderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        }];
        //订单编号字符串Label
        UILabel *orderNumLabel = [[UILabel alloc]init];
        orderNumLabel.textColor = [UIColor blackColor];
        orderNumLabel.font = [UIFont systemFontOfSize:14];
        self.orderNumLabel = orderNumLabel;
        [self.contentView addSubview:orderNumLabel];
        [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(orderNameLabel.mas_right);
            make.top.equalTo(self.contentView).with.offset(15 * KWIDTH_IPHONE6_SCALE);
        }];
        
        //配送方式名字Label
        UILabel *logisticNameLabel = [[UILabel alloc]init];
        logisticNameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:logisticNameLabel];
        logisticNameLabel.text = @"配送方式: ";
        logisticNameLabel.textColor = RGBA(153, 153, 153, 1);
        [logisticNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.bottom.equalTo(self.contentView).with.offset(-15 * KWIDTH_IPHONE6_SCALE);
        }];
        //配送方式字符串Label
        UILabel *logisticLabel = [[UILabel alloc]init];
        logisticLabel.font = [UIFont systemFontOfSize:14];
        logisticLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:logisticLabel];
        self.logisticLabel = logisticLabel;
        [self.logisticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(logisticNameLabel.mas_right);
            make.bottom.equalTo(self.contentView).with.offset(-15 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    return self;
}

@end
