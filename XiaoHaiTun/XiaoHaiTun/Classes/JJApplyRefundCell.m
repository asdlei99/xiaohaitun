//
//  JJJJApplyRefundCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJApplyRefundCell.h"
#import "UILabel+LabelStyle.h"
#import "JJGoodsOrderModel.h"
#import "JJReceiveAddressModel.h"

@interface JJApplyRefundCell()

//姓名
@property (nonatomic, weak) UILabel *nameLabel;
//手机
@property (nonatomic, weak) UILabel *phoneLabel;
//收货地址
@property (nonatomic, weak) UILabel *addressLabel;

@end

@implementation JJApplyRefundCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initBaseView];
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
    [toplabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"退换邮件地址" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentLeft];
    [toplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
    }];
    //姓名
    UILabel *nameLabel = [[UILabel alloc]init];
    self.nameLabel = nameLabel;
    [topView addSubview:self.nameLabel];
    [self.nameLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toplabel.mas_bottom).with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //手机
    UILabel *phoneLabel = [[UILabel alloc]init];
    self.phoneLabel = phoneLabel;
    [self.phoneLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
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
    [self.addressLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(self.phoneLabel.mas_bottom).with.offset(6 * KWIDTH_IPHONE6_SCALE);
        //        make.right.equalTo(self.editButton.mas_left).with.offset(-13 * KWIDTH_IPHONE6_SCALE);
    }];
    //横线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBA(229, 229, 229, 1);
    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(topView).with.offset(13);
        make.right.equalTo(topView);
        make.bottom.equalTo(topView);
    }];
    
    //center
    UIView *centerView = [[UIView alloc]init];
    [self.contentView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.bottom.equalTo(self.contentView);
    }];
    //提交申请按钮
    UIButton *submitBtn = [[UIButton alloc]init];
    self.submitBtn = submitBtn;
    [centerView addSubview:submitBtn];
    [submitBtn setBackgroundColor:NORMAL_COLOR];
    [submitBtn setTintColor:[UIColor whiteColor]];
    [submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [submitBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [submitBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:6 andWidth:0];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(centerView).with.offset(-20 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(centerView).with.offset(25 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@(42 * KWIDTH_IPHONE6_SCALE));
    }];
    
    //换货说明
    UILabel * instructLabel = [[UILabel alloc]init];
    instructLabel.numberOfLines = 0;
    [centerView addSubview:instructLabel];
    [instructLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] text:@"退款换货说明\n\n1.请务必将所有邮寄来物品快递到到退还地址.\n2.请确保所有物品无任何损坏,如有损坏请提前致电客服.\n3.请准确填写邮寄快递公司,运单号及详细地址联系方式." textColor:RGBA(153,153,153,1) textAlignment:NSTextAlignmentLeft];
    [instructLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitBtn.mas_bottom).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(centerView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(centerView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(centerView).with.offset(- 20 * KWIDTH_IPHONE6_SCALE);
    }];
}

- (void)setGoodsOrderModel:(JJGoodsOrderModel *)goodsOrderModel {
    _goodsOrderModel = goodsOrderModel;
    JJReceiveAddressModel *rceiveOrderModel = goodsOrderModel.address;
    JJReceiveAddressModel *receiveAddressModel = goodsOrderModel.address;
    self.nameLabel.text = receiveAddressModel.shipping_user;
    self.phoneLabel.text = receiveAddressModel.mobile;
    self.addressLabel.text = receiveAddressModel.detail;
}
@end
