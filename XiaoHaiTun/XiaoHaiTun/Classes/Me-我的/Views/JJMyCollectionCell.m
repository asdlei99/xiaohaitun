//
//  JJMyCollectionViewCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMyCollectionCell.h"
#import "UILabel+LabelStyle.h"
#import "JJMyCollectionModel.h"
#import <UIImageView+WebCache.h>

@interface JJMyCollectionCell ()

//收藏logo
@property (nonatomic, weak) UIImageView *goodsIcon;

//收藏描述
@property (nonatomic, weak) UILabel *descriptLabel;

//收藏价格
@property (nonatomic, weak) UILabel *priceLabel;

@end


@implementation JJMyCollectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseView];
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    
    //top
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 118 * KWIDTH_IPHONE6_SCALE)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];

    //衣服logo
    UIImageView *goodsIcon = [[UIImageView alloc]init];
    goodsIcon.contentMode = UIViewContentModeScaleAspectFill;
    goodsIcon.image = [UIImage imageNamed:@"defaultUserIcon"];
    [goodsIcon createBordersWithColor:RGBA(221, 221, 221, 1) withCornerRadius:0 andWidth:1];
    self.goodsIcon = goodsIcon;
    [topView addSubview:goodsIcon];
    [_goodsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).with.offset(18 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(topView).with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.width.equalTo(_goodsIcon.mas_height);
    }];
    //衣服描述
    UILabel *descriptLabel = [[UILabel alloc]init];
    descriptLabel.numberOfLines = 3;
    [descriptLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14] text:@"衣服就是好啊hi阿好啊hi阿红我还为阿海hi爱" textColor:RGBA(51,51,51,1) textAlignment:NSTextAlignmentLeft];
    self.descriptLabel = descriptLabel;
    [topView addSubview:self.descriptLabel];
    [_descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsIcon.mas_right).with.offset(22 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(topView).with.offset(-19 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(topView).with.offset(24 * KWIDTH_IPHONE6_SCALE);
    }];
    //衣服价格
    UILabel *priceLabel = [[UILabel alloc]init];
    [priceLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:12] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    priceLabel.text = @"¥345";
    self.priceLabel = priceLabel;
    [topView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsIcon.mas_right).with.offset(22 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(topView).with.offset(-11 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UIView *spaceView = [[UIView alloc]init];
    spaceView.backgroundColor = RGBA(238, 238, 238, 1);
    [self.contentView addSubview:spaceView];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(-100);
        make.top.equalTo(topView.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
}

- (void)setModel:(JJMyCollectionModel *)model {
    _model = model;
    
    [self.goodsIcon sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.descriptLabel.text = model.name;
    self.priceLabel.text =[NSString stringWithFormat:@"¥%@", model.price];

}




-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"shopCar_Select"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"shopCar_Normal"];
                    }
                }
            }
        }
    }
}
@end
