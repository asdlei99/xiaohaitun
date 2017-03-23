//
//  JJAddressAndOrderRemarkCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJAddressAndOrderRemarkCell.h"
#import "UILabel+LabelStyle.h"
#import "JJGoodsOrderModel.h"

@interface JJAddressAndOrderRemarkCell ()

//姓名
@property (nonatomic, weak) UILabel *nameLabel;
//手机
@property (nonatomic, weak) UILabel *phoneLabel;
//收货地址
@property (nonatomic, weak) UILabel *addressLabel;
//订单备注
@property (nonatomic, weak) UILabel *remarkStringLabel;


@end


@implementation JJAddressAndOrderRemarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    //top
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 95 * KWIDTH_IPHONE6_SCALE)];
    [self.contentView addSubview:topView];
    //配送地址Label
    UILabel *toplabel = [[UILabel alloc]init];
    [topView addSubview:toplabel];
    [toplabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"配送地址" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentLeft];
    [toplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
    }];
    //姓名
    UILabel *nameLabel = [[UILabel alloc]init];
    self.nameLabel = nameLabel;
    [topView addSubview:self.nameLabel];
    [self.nameLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"王杰" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toplabel.mas_bottom).with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //手机
    UILabel *phoneLabel = [[UILabel alloc]init];
    self.phoneLabel = phoneLabel;
    [self.phoneLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"18394154100" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [topView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toplabel.mas_bottom).with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.nameLabel.mas_right).with.offset(22 * KWIDTH_IPHONE6_SCALE);
    }];
    //地址
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.numberOfLines = 1;
    self.addressLabel = addressLabel;
    [topView addSubview:self.addressLabel];
    [self.addressLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] text:@"河北省北京市朝阳区疆外soho十号楼2303" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(self.phoneLabel.mas_bottom).with.offset(6 * KWIDTH_IPHONE6_SCALE);
//        make.right.equalTo(self.editButton.mas_left).with.offset(-13 * KWIDTH_IPHONE6_SCALE);
        
    }];
    //横线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBA(238, 238, 238, 1);
    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(topView).with.offset(13);
        make.right.equalTo(topView);
        make.bottom.equalTo(topView);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
    //订单备注
    UILabel *remarkLabel = [[UILabel alloc]init];
    [bottomView addSubview: remarkLabel];
    [remarkLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"订单备注" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentLeft];
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(topView.mas_bottom).with.offset(14 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UILabel *remarkStringLabel = [[UILabel alloc]init];
    self.remarkStringLabel = remarkStringLabel;
    [bottomView addSubview:remarkStringLabel];
    [remarkStringLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [remarkStringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(remarkLabel.mas_bottom).with.offset(6);
    }];
}

- (void)setGoodsOrderModel:(JJGoodsOrderModel *)goodsOrderModel {
    _goodsOrderModel = goodsOrderModel;
    self.remarkStringLabel.text = goodsOrderModel.note;
    JJReceiveAddressModel *receiveAddressModel = goodsOrderModel.address;
    self.nameLabel.text = receiveAddressModel.shipping_user;
    self.phoneLabel.text = receiveAddressModel.mobile;
    self.addressLabel.text = receiveAddressModel.detail;
}
@end
