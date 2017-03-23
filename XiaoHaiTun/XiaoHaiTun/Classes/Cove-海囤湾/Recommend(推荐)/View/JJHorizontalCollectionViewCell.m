//
//  JJHorizontalCollectionViewCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/29.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJHorizontalCollectionViewCell.h"
#import "UIView+FrameExpand.h"
#import <UIImageView+WebCache.h>

@interface JJHorizontalCollectionViewCell ()

//图片
@property (nonatomic, weak) UIImageView *imageView;

//描述
@property (nonatomic, weak) UILabel *descriptionLabel;

//价格
@property (nonatomic, weak) UILabel *priceLabel;

@end

@implementation JJHorizontalCollectionViewCell
- (void)setModel:(JJRecommendSection1Model *)model{
//    model.cover = [NSString stringWithFormat:@"%@?imageView2/1/w/250/h/240",model.cover];
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.descriptionLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
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
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView = imageView;
    [self.contentView addSubview:self.imageView];
    //创建边框圆角
    [self.imageView createBordersWithColor:RGBA(245, 245, 245, 1) withCornerRadius:5 andWidth:1];
    
    UILabel *descriptionLabel = [[UILabel alloc]init];
    descriptionLabel.numberOfLines = 2;
    self.descriptionLabel = descriptionLabel;
    self.descriptionLabel.font = [UIFont systemFontOfSize:12];
    self.descriptionLabel.text = @"好爱好会或多或少会发的是否会受到副教授积分";
    [self.contentView addSubview:self.descriptionLabel];
    
    UILabel *priceLabel = [[UILabel alloc]init];
    self.priceLabel = priceLabel;
    self.priceLabel.font = [UIFont systemFontOfSize:12];
    self.priceLabel.textColor = NORMAL_COLOR;
    priceLabel.text = @"123元";
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
        make.width.equalTo(self.contentView.mas_width).multipliedBy(101.0/125);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-4);
        make.left.equalTo(self.descriptionLabel);
    }];
}
@end
