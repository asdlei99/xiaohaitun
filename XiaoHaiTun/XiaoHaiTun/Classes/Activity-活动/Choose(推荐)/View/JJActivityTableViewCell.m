//
//  JJActivityTableViewCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/6.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityTableViewCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "JJActivityTableViewCellModel.h"
#import "UIView+XPKit.h"

@interface JJActivityTableViewCell()




@end

@implementation JJActivityTableViewCell

- (void)setModel:(JJActivityTableViewCellModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.iconImageView.backgroundColor = RGBA(238, 238, 238, 1);
//    NSMutableAttributedString *attributeStringM = [NSMutableAttributedString ]

    self.descriptLabel.text = model.name;
    self.distanceLabel.text = model.distance;
    //图文混排
    
    NSMutableAttributedString *attributLeft = [[NSMutableAttributedString alloc]init];
    
    NSAttributedString *moneyAttributString = [[NSAttributedString alloc]initWithString:@"¥" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} ];
    
    NSAttributedString *rightAttribute = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",model.price] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]}] ;
    [attributLeft appendAttributedString:moneyAttributString];
    [attributLeft appendAttributedString:rightAttribute];
    self.priceLabel.attributedText = attributLeft;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建基本视图
        [self createBaseView];
    }
    return self;
}

- (void)createBaseView {
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"1"];
    self.iconImageView = imageView;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:imageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.top.equalTo(self.contentView).with.offset(10);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(37.0 / 71);
    }];
    
    
    //距离
    UILabel *distanceLabel = [[UILabel alloc]init];
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabel.font = [UIFont systemFontOfSize:12];
    self.distanceLabel = distanceLabel;
    [self.iconImageView addSubview:distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImageView).with.offset(-10);
        make.bottom.equalTo(self.iconImageView).with.offset(-14);
        make.height.equalTo(@17);
    }];
    UIImageView *distanceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Shape"]];
    self.distanceImageView = distanceImageView;
    [self.iconImageView addSubview:distanceImageView];
    [distanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.distanceLabel);
        make.right.equalTo(self.distanceLabel.mas_left).with.offset(-6);
    }];
    distanceLabel.hidden = YES;
    distanceImageView.hidden = YES;

    //价格
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.text = @"¥158.00";
    //    priceLabel.backgroundColor = [UIColor blueColor];
//    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = NORMAL_COLOR;
    priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
//    self.priceLabel.backgroundColor = [UIColor blueColor];
    
    UILabel *descriptLabel = [[UILabel alloc]init];
    descriptLabel.text = @"中国的小马尔代夫 荷兰风情月坨岛";
    descriptLabel.font = [UIFont systemFontOfSize:14];
    descriptLabel.textColor = [UIColor blackColor];
    descriptLabel.numberOfLines = 1;
    self.descriptLabel = descriptLabel;
    [self.contentView addSubview:descriptLabel];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10);
        make.top.equalTo(self.iconImageView.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.descriptLabel.mas_right).with.offset(5);
    }];
    [self.descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(self.iconImageView.mas_bottom);
        make.bottom.equalTo(self.contentView);
//        make.right.equalTo(self.priceLabel.mas_left).with.offset(-5);
    }];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
