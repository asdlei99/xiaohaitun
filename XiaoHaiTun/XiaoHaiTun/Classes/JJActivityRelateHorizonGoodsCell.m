//
//  JJActivityRelateHorizonGoodsCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/25.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityRelateHorizonGoodsCell.h"
#import "UIView+FrameExpand.h"
#import <UIImageView+WebCache.h>

@interface JJActivityRelateHorizonGoodsCell ()

//图片
@property (nonatomic, weak) UIImageView *imageView;

//描述
@property (nonatomic, weak) UILabel *descriptionLabel;

//价格
@property (nonatomic, weak) UILabel *priceLabel;

@end

@implementation JJActivityRelateHorizonGoodsCell

- (void)setModel:(JJActivityDetailHorizontalGoodsModel *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.item_pic] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.descriptionLabel.text = model.item_name;
    self.priceLabel.text = model.item_price;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

//创建视图
- (void)createView {
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"图层 3"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView = imageView;
    [self.contentView addSubview:self.imageView];
    //创建边框圆角
    [self.imageView createBordersWithColor:RGBA(239, 239, 239, 1) withCornerRadius:5 andWidth:1];
    
    UILabel *descriptionLabel = [[UILabel alloc]init];
    descriptionLabel.numberOfLines = 1;
    self.descriptionLabel = descriptionLabel;
    self.descriptionLabel.font = [UIFont systemFontOfSize:12];
    self.descriptionLabel.text = @"好爱好会或多或少会发的是否会受到副教授积分";
    [self.contentView addSubview:self.descriptionLabel];
    
    UILabel *priceLabel = [[UILabel alloc]init];
    self.priceLabel = priceLabel;
    self.priceLabel.font = [UIFont systemFontOfSize:12];
    self.priceLabel.textColor = NORMAL_COLOR;
    priceLabel.text = @"123元";
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.priceLabel];
}


//布局
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(self.imageView.mas_width);
    }];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView.mas_width);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(4);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(3);
        make.left.right.equalTo(self.contentView);
    }];
}
@end
