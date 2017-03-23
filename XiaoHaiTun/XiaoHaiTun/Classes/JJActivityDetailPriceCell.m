//
//  JJActivityDetailPriceCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityDetailPriceCell.h"
#import "UILabel+LabelStyle.h"
#import <Masonry.h>
#import "UIView+XPKit.h"

@interface JJActivityDetailPriceCell ()

//活动名称
@property (nonatomic, weak) UILabel *nameLabel;
////活动往返地址时间
//@property (nonatomic, weak) UILabel *placeAndTimeLabel;
//价格
@property (nonatomic, weak) UILabel *priceLabel;
//限制人数
@property (nonatomic, weak) UILabel *limitCountLabel;

@end

@implementation JJActivityDetailPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initBaseView];
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    //活动名称
    UILabel *nameLabel = [[UILabel alloc]init];
    self.nameLabel = nameLabel;
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(16 * KWIDTH_IPHONE6_SCALE);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@44);
    }];
    
//    //往返地址时间Label
//    UILabel *placeAndTimeLabel = [[UILabel alloc]init];
//    self.placeAndTimeLabel = placeAndTimeLabel;
//    [self.contentView addSubview:self.placeAndTimeLabel];
//    [self.placeAndTimeLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] text:@"上海-仁川=上海5天4晚" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
//    [self.placeAndTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.contentView);
//        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8 * KWIDTH_IPHONE6_SCALE);
//        make.height.equalTo(@18);
//    }];
    
    //价格Label
    UILabel *priceLabel = [[UILabel alloc]init];
    self.priceLabel = priceLabel;
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:24] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentCenter];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(37 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(self.contentView).with.offset(-37 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@24);
    }];
    
    //限制人数Label
    UILabel *limitCountLabel = [[UILabel alloc]init];
    self.limitCountLabel = limitCountLabel;
    [self.contentView addSubview:self.limitCountLabel];
    [self.limitCountLabel jj_setLableStyleWithBackgroundColor:RGBA(221, 221, 221, 1) font:[UIFont systemFontOfSize:10] text:@"" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [self.limitCountLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:3 andWidth:0];
    [self.limitCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.equalTo(@20);
        make.width.equalTo(@62);
    }];
    
}

- (void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name;
}
- (void)setPrice:(NSString *)price{
    _price = price;
    if(price.floatValue == 0){
        self.priceLabel.text = @"免费";
        return ;
    }
    self.priceLabel.text =[NSString stringWithFormat:@"¥%@", price];
//    self.limitCountLabel.hidden = YES;
}
//- (void)setAddress:(NSString *)address{
//    _address = address;
//    self.placeAndTimeLabel.text = address;
//}
- (void)setLimit:(NSString *)limit {
    _limit = limit;
    self.limitCountLabel.text =[NSString stringWithFormat:@"限制%@人",limit];
    if (limit.floatValue == 0) {
        self.limitCountLabel.hidden = YES;
    }
}

@end
