//
//  JJActivityOrderGoodsCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityOrderGoodsCell.h"
#import "UILabel+LabelStyle.h"

@interface JJActivityOrderGoodsCell ()

@end

@implementation JJActivityOrderGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initBaseView];
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
//    self.backgroundColor = RGBA(247, 247, 247, 1);
    //衣服logo
    UIImageView *activityIcon = [[UIImageView alloc]init];
    [activityIcon createBordersWithColor:RGBA(153, 153, 153, 1) withCornerRadius:0 andWidth:1];
    activityIcon.image = [UIImage imageNamed:@"defaultUserIcon"];
    self.activityIcon = activityIcon;
    [self.contentView addSubview:activityIcon];
    [_activityIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self.contentView).with.offset(-24 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.contentView).with.offset(15 * KWIDTH_IPHONE6_SCALE);
        make.width.equalTo(_activityIcon.mas_height);
    }];
    //衣服描述
    UILabel *descriptLabel = [[UILabel alloc]init];
    [descriptLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:RGBA(51,51,51,1) textAlignment:NSTextAlignmentLeft];
    descriptLabel.numberOfLines = 2;
    self.descriptLabel = descriptLabel;
    [self.contentView addSubview:self.descriptLabel];
    [_descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityIcon.mas_right).with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(self.contentView).with.offset(-17 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(self.contentView).with.offset(23 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //地址
    UILabel *addressLabel = [[UILabel alloc]init];
    self.addressLabel = addressLabel;
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] text:@"" textColor:RGBA(153,153,153,1) textAlignment:NSTextAlignmentLeft];
    self.addressLabel.numberOfLines = 2;
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityIcon.mas_right).with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-35 * KWIDTH_IPHONE6_SCALE);
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



@end
