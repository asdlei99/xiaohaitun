//
//  JJOrderGoodsCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJOrderGoodsCell.h"
#import "UILabel+LabelStyle.h"
#import "JJGoodsWaitModel.h"
#import <UIImageView+WebCache.h>

@interface JJOrderGoodsCell ()

//衣服logo
@property (nonatomic, weak) UIImageView *goodsIcon;

//衣服描述
@property (nonatomic, weak) UILabel *descriptLabel;

//商品规格串
@property (nonatomic, weak) UILabel *goodsSkuLabel;

//衣服数量
@property (nonatomic, weak) UILabel *countLabel;

//衣服价格
@property (nonatomic, weak) UILabel *priceLabel;

@end

@implementation JJOrderGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseView];
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = RGBA(247, 247, 247, 1);
    //衣服logo
    UIImageView *goodsIcon = [[UIImageView alloc]init];
    [goodsIcon createBordersWithColor:RGBA(222, 222, 222, 1) withCornerRadius:0 andWidth:1];
    goodsIcon.image = [UIImage imageNamed:@"defaultUserIcon"];
    self.goodsIcon = goodsIcon;
    [self.contentView addSubview:goodsIcon];
    [_goodsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self.contentView).with.offset(-24 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.contentView).with.offset(15 * KWIDTH_IPHONE6_SCALE);
        make.width.equalTo(_goodsIcon.mas_height);
    }];
    //衣服描述
    UILabel *descriptLabel = [[UILabel alloc]init];
    [descriptLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:RGBA(51,51,51,1) textAlignment:NSTextAlignmentLeft];
    descriptLabel.numberOfLines = 2;
    self.descriptLabel = descriptLabel;
    [self.contentView addSubview:self.descriptLabel];
    [_descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsIcon.mas_right).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(self.contentView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(self.contentView).with.offset(18 * KWIDTH_IPHONE6_SCALE);
    }];
    //商品规格串Label
    UILabel *goodsSkuLabel = [[UILabel alloc]init];
    [goodsSkuLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:12] text:@"" textColor:RGBA(153,153,153,1) textAlignment:NSTextAlignmentLeft];
    self.goodsSkuLabel = goodsSkuLabel;
    [self.contentView addSubview:self.goodsSkuLabel];
    [self.goodsSkuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsIcon.mas_right).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(self.descriptLabel.mas_bottom).with.offset(3 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //衣服价格
    UILabel *priceLabel = [[UILabel alloc]init];
    [priceLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:12] text:@"¥89.00" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    self.priceLabel = priceLabel;
    [self.contentView addSubview:self.priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsIcon.mas_right).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self.contentView).with.offset(-30 * KWIDTH_IPHONE6_SCALE);
    }];
    //数量
    UILabel *countLabel = [[UILabel alloc]init];
    [countLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:12] text:@"X1" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    self.countLabel = countLabel;
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-15 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self.contentView).with.offset(-30 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UIView *spaceView = [[UIView alloc]init];
    spaceView.backgroundColor = RGBA(238, 238, 238, 1);
    [self.contentView addSubview:spaceView];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@(10 * KWIDTH_IPHONE6_SCALE));
    }];
}

- (void)setModel:(JJGoodsWaitModel *)model {
    _model = model;
    [self.goodsIcon sd_setImageWithURL:[NSURL URLWithString:model.goods_cover] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.descriptLabel.text = model.goods_name;
    self.countLabel.text =[NSString stringWithFormat:@"X%ld", model.goods_num];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    self.goodsSkuLabel.text = model.goods_sku_str;
}


@end
