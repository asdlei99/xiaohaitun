//
//  JJCashierCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJCashierCell.h"
#import <ReactiveCocoa.h>

@interface JJCashierCell ()

//支付图标
@property (nonatomic, weak) UIImageView *iconImageView;
//支付名称
@property (nonatomic, weak) UILabel *payTypeLabel;
//支付消息
@property (nonatomic, weak) UILabel *payMessageLabel;
//勾选按钮
@property (nonatomic, weak) UIImageView *chooseImage;


@end

@implementation JJCashierCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addObserve];
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    //勾选按钮
    UIImageView *chooseImage = [[UIImageView alloc]init];
    chooseImage.contentMode = UIViewContentModeCenter;
    self.chooseImage = chooseImage;
    [chooseImage setImage:[UIImage imageNamed:@"shopCar_Normal"]];
    [chooseImage setHighlightedImage:[UIImage imageNamed:@"shopCar_Select"]];
    [self.contentView addSubview:self.chooseImage];
    [self.chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    
    //支付图标
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WX_Icon"]];
    self.iconImageView = iconImageView;
    [self.contentView addSubview:iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.width.height.equalTo(@25);
        make.centerY.equalTo(self.contentView);
    }];
    
    //支付名称
    UILabel *payTypeLabel = [[UILabel alloc]init];
    payTypeLabel.text = @"余额宝";
    self.payTypeLabel = payTypeLabel;
    [self.contentView addSubview:self.payTypeLabel];
    [payTypeLabel setFont:[UIFont systemFontOfSize:14]];
    [payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(8 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //支付消息
    UILabel *payMessageLabel = [[UILabel alloc]init];
    self.payMessageLabel = payMessageLabel;
    [self.contentView addSubview:self.payMessageLabel];
    payMessageLabel.font = [UIFont systemFontOfSize:12];
    payMessageLabel.text = @"微信安全支付";
    payMessageLabel.textColor = RGBA(153, 153, 153, 1);
    [payMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(8 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self.contentView).with.offset(- 10 * KWIDTH_IPHONE6_SCALE);
    }];
    
}

//RACObserve
- (void)addObserve {
    [RACObserve(self, model.isChoose)subscribeNext:^(NSNumber *x) {
        self.chooseImage.highlighted = x.boolValue;
    }];
}

- (void)setModel:(JJCashierModel *)model{
    _model = model;
    self.iconImageView.image = [UIImage imageNamed:model.iconName];
    self.payTypeLabel.text  =model.payTypeString;
    self.payMessageLabel.text = model.payMessageString;
    self.chooseImage.highlighted = model.isChoose;
}

@end
