//
//  JJLogisticCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJLogisticCell.h"
#import "NSString+XPKit.h"
#import "JJgoodsOrderLogisticModel.h"

@interface JJLogisticCell ()

@end

@implementation JJLogisticCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //上竖线
        self.topVerticalView = [[UIView alloc]init];
        self.topVerticalView.backgroundColor = RGBA(238, 238, 238, 1);
        [self.contentView addSubview:self.topVerticalView];
        [self.topVerticalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(25 * KWIDTH_IPHONE6_SCALE);
            make.top.equalTo(self.contentView);
            make.width.equalTo(@2);
            make.height.equalTo(@14);
        }];
        //中圆圈
        self.centerCircleView = [[UIImageView alloc]init];
        self.centerCircleView.backgroundColor = RGBA(238, 238, 238, 1);
        [self.contentView addSubview:self.centerCircleView];
        [self.centerCircleView createBordersWithColor:[UIColor clearColor] withCornerRadius:6.5 andWidth:0];
        [self.centerCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topVerticalView.mas_bottom);
            make.width.height.equalTo(@13);
            make.centerX.equalTo(self.topVerticalView);
        }];
        
        //下竖线
        self.bottomVerticalView = [[UIView alloc]init];
        self.bottomVerticalView.backgroundColor = RGBA(238, 238, 238, 1);
        [self.contentView addSubview:self.bottomVerticalView];
        [self.bottomVerticalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(25 * KWIDTH_IPHONE6_SCALE);
            make.top.equalTo(self.centerCircleView.mas_bottom);
            make.bottom.equalTo(self.contentView);
            make.width.equalTo(@2);
            
        }];

        //物流信息
        self.logisticMessageLabel = [[UILabel alloc]init];
        self.logisticMessageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.logisticMessageLabel.text = @"";
        self.logisticMessageLabel.numberOfLines = 0;
        self.logisticMessageLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.logisticMessageLabel];
        self.logisticMessageLabel.textColor = RGBA(153, 153, 153, 1);
        [self.logisticMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(14);
            make.left.equalTo(self.centerCircleView.mas_right).with.offset(17);
            make.right.equalTo(self.contentView).with.offset(-17);
        }];
        
        //日期
        self.dateMessageLabel = [[UILabel alloc]init];
        self.dateMessageLabel.text = @"";
        [self.contentView addSubview:self.dateMessageLabel];
        self.dateMessageLabel.textColor = RGBA(153, 153, 153, 1);
        self.dateMessageLabel.font = [UIFont systemFontOfSize:12];
        [self.dateMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.centerCircleView.mas_right).with.offset(17);
            make.top.equalTo(self.logisticMessageLabel.mas_bottom).with.offset(4);
            make.bottom.equalTo(self.contentView).with.offset(-11);
            make.height.equalTo(@17);
        }];
        
        //底部线条
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBA(238, 238, 238, 1);
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.centerCircleView.mas_right).with.offset(17);
        }];
    }
    return self;
}

- (void)setOrderLogisticModel:(JJgoodsOrderLogisticModel *)orderLogisticModel {
    _orderLogisticModel = orderLogisticModel;
    self.dateMessageLabel.text = [orderLogisticModel.logistics_time stringChangeToDate:@"yyyy-MM-dd HH-mm-ss"];
    self.logisticMessageLabel.text = [NSString stringWithFormat:@"[%@] %@",orderLogisticModel.logistics_zone,orderLogisticModel.logistics_remark];
}

@end
