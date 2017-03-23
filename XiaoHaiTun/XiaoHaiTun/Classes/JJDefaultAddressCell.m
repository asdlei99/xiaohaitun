//
//  JJDefaultAddressCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJDefaultAddressCell.h"
#import "UILabel+LabelStyle.h"
#import "JJReceiveAddressModel.h"

@interface JJDefaultAddressCell ()
//定位图标
@property (nonatomic, weak) UIImageView *addressIcon;
//姓名
@property (nonatomic, weak) UILabel *nameLabel;
//手机
@property (nonatomic, weak) UILabel *phoneLabel;
//收货地址
@property (nonatomic, weak) UILabel *addressLabel;
//红色默认文字
@property (nonatomic, weak) UILabel *defaultLabel;
@end


@implementation JJDefaultAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseView];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    self.contentView.backgroundColor = [UIColor whiteColor];

    UIImageView *colorLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"colorLine"]];
    colorLine.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:colorLine];
    [colorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(40);
        make.height.equalTo(@4);
    }];
    
    
    //定位图标
    UIImageView *addressIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address"]];
    addressIcon.hidden = YES;
    self.addressIcon = addressIcon;
    [self.contentView addSubview:addressIcon];
    [addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(colorLine.mas_top).with.offset(-20 * KWIDTH_IPHONE6_SCALE);
        make.width.height.equalTo(@16);
    }];
    addressIcon.contentMode = UIViewContentModeScaleAspectFill;
    
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.hidden = YES;
    self.nameLabel = nameLabel;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(28 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(addressIcon.mas_right).with.offset(3 * KWIDTH_IPHONE6_SCALE);
    }];
    
//    //手机
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.hidden = YES;
    self.phoneLabel = phoneLabel;
    [self.contentView addSubview:phoneLabel];
    [self.phoneLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(22 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(self.nameLabel);
    }];
    //红色默认文字
    UILabel *defaultLabel = [[UILabel alloc]init];
    defaultLabel.hidden = YES;
    self.defaultLabel = defaultLabel;
    defaultLabel.backgroundColor = NORMAL_COLOR;
    [self.contentView addSubview:defaultLabel];
    defaultLabel.font = [UIFont systemFontOfSize:10];
    defaultLabel.textAlignment = NSTextAlignmentCenter;
    defaultLabel.text = @"默认";
    [defaultLabel setTextColor:[UIColor whiteColor]];
    [defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@15);
        make.left.equalTo(self.phoneLabel.mas_right).with.offset(13 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(self.phoneLabel);
    }];
    
    //地址
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.hidden = YES;
    addressLabel.numberOfLines = 1;
    self.addressLabel = addressLabel;
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] text:@"" textColor:RGBA(153,153,153,1) textAlignment:NSTextAlignmentLeft];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressIcon.mas_right).with.offset(3 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(addressIcon);
    }];
}

- (void)setReceiveAddressModel:(JJReceiveAddressModel *)receiveAddressModel {
    _receiveAddressModel = receiveAddressModel;
    if(receiveAddressModel == nil){
        
    }else{
        self.nameLabel.hidden = NO;
        self.nameLabel.text = receiveAddressModel.shipping_user;
        self.addressLabel.hidden = NO;
        self.addressLabel.text = [ NSString stringWithFormat:@"%@ %@ %@ %@",receiveAddressModel.province,receiveAddressModel.city,receiveAddressModel.area, receiveAddressModel.address];
        self.addressIcon.hidden = NO;
        self.phoneLabel.hidden = NO;
        self.phoneLabel.text = receiveAddressModel.mobile;
        if(receiveAddressModel.is_default.boolValue == YES) {
            self.defaultLabel.hidden = NO;
        }else{
            self.defaultLabel.hidden = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
