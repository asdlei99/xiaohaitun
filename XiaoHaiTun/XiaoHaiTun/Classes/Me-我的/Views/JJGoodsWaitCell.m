//
//  JJGoodsWaitCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJGoodsWaitCell.h"
#import <Masonry.h>
#import "UILabel+LabelStyle.h"
#import "JJGoodsWaitModel.h"
#import <UIImageView+WebCache.h>
#import "JJGoodsOrderModel.h"
#import "JJCashierViewController.h"
#import "UIView+viewController.h"

@interface JJGoodsWaitCell()

//订单号
@property (nonatomic, weak) UILabel *ordersNumberLabel;


//等待付款/付款成功/已取消
@property (nonatomic, weak) UILabel *waitLabel;

//衣服logo
@property (nonatomic, weak) UIImageView *goodsIcon;

//衣服描述
@property (nonatomic, weak) UILabel *descriptLabel;

//衣服颜色型号
@property (nonatomic, weak) UILabel *sizeColorLabel;

//衣服数量
@property (nonatomic, weak) UILabel *countLabel;

//衣服价格
@property (nonatomic, weak) UILabel *priceLabel;



@end

@implementation JJGoodsWaitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    //top
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 57 * KWIDTH_IPHONE6_SCALE)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];
    //订单号
    UILabel *ordersNumberLabel = [[UILabel alloc]init];
    [ordersNumberLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"订单号:17267174431" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentLeft];
    self.ordersNumberLabel = ordersNumberLabel;
    [topView addSubview:self.ordersNumberLabel];
    [_ordersNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).with.offset(13 * KWIDTH_IPHONE6_SCALE);
        make.top.bottom.equalTo(topView);
    }];
    //代付款
    UILabel *waitLabel = [[UILabel alloc]init];
    [waitLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"等待付款" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentRight];
    self.waitLabel = waitLabel;
    [topView addSubview:_waitLabel];
    [_waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(topView);
        make.right.equalTo(topView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
    }];
    
    
    //center
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 57 * KWIDTH_IPHONE6_SCALE, SCREEN_WIDTH, 120 * KWIDTH_IPHONE6_SCALE)];
    centerView.backgroundColor = RGBA(247, 247, 247, 1);
    [self.contentView addSubview:centerView];
    //衣服logo
    UIImageView *goodsIcon = [[UIImageView alloc]init];
    goodsIcon.contentMode = UIViewContentModeScaleAspectFill;
    [goodsIcon createBordersWithColor:RGBA(153, 153, 153, 1) withCornerRadius:0 andWidth:1];
    goodsIcon.image = [UIImage imageNamed:@"defaultUserIcon"];
    self.goodsIcon = goodsIcon;
    [centerView addSubview:goodsIcon];
    [_goodsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(centerView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(centerView).with.offset(15 * KWIDTH_IPHONE6_SCALE);
        make.width.equalTo(_goodsIcon.mas_height);
    }];
    //衣服描述
    UILabel *descriptLabel = [[UILabel alloc]init];
    [descriptLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14] text:@"衣服就是好啊hi阿好啊hi阿红我还为阿海hi爱" textColor:RGBA(51,51,51,1) textAlignment:NSTextAlignmentLeft];
    descriptLabel.numberOfLines = 2;
    self.descriptLabel = descriptLabel;
    [centerView addSubview:self.descriptLabel];
    [_descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsIcon.mas_right).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(centerView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(centerView).with.offset(18 * KWIDTH_IPHONE6_SCALE);
    }];
    //衣服颜色数量
    UILabel *sizeColorLabel = [[UILabel alloc]init];
    [sizeColorLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:12] text:@"黑色、34" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentLeft];
    self.sizeColorLabel = sizeColorLabel;
    [centerView addSubview:self.sizeColorLabel];
    [_sizeColorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsIcon.mas_right).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(centerView).with.offset(-23 * KWIDTH_IPHONE6_SCALE);
    }];
    //数量
    UILabel *countLabel = [[UILabel alloc]init];
    [countLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:12] text:@"X1" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentLeft];
    self.countLabel = countLabel;
    [centerView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerView).with.offset(-15 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(centerView).with.offset(-23 * KWIDTH_IPHONE6_SCALE);
    }];

    
    //bottom
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, centerView.bottom, SCREEN_WIDTH, 63 * KWIDTH_IPHONE6_SCALE)];
    bottom.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottom];
    UILabel * textlabel = [[UILabel alloc]init];
    [textlabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14] text:@"实付款:" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentLeft];
    [bottom addSubview:textlabel];
    [textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(bottom);
        make.left.equalTo(bottom).with.offset(14 * KWIDTH_IPHONE6_SCALE);
    }];
//    //衣服价格
    UILabel *priceLabel = [[UILabel alloc]init];
    [priceLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    priceLabel.text = @"¥345";
    self.priceLabel = priceLabel;
    [bottom addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textlabel.mas_right).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.top.bottom.equalTo(bottom);
    }];
    //支付按钮
    UIButton *payButton = [[UIButton alloc]init];
    [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    payButton.backgroundColor = NORMAL_COLOR;
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.payButton = payButton;
    [bottom addSubview:payButton];
    [self.payButton addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottom.mas_right).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(bottom);
        make.width.equalTo(@76);
        make.height.equalTo(@29);
    }];
    
    
    UIView *spaceView = [[UIView alloc]init];
    spaceView.backgroundColor = RGBA(238, 238, 238, 1);
    [self.contentView addSubview:spaceView];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(bottom.mas_bottom);
        make.height.equalTo(@(10 * KWIDTH_IPHONE6_SCALE));
    }];
}

- (void)setModel:(JJGoodsOrderModel *)model {
    _model = model;
    self.ordersNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",model.order_num];
    self.priceLabel.text =[NSString stringWithFormat:@"¥%@", model.real_fee];
    
    switch (model.status) {
        case 0:
        self.waitLabel.text = @"待下单";
        self.payButton.hidden = YES;
        break;
        case 1:
        self.waitLabel.text = @"付款成功";
        self.payButton.hidden = YES;
        break;
        case 2:
        self.waitLabel.text = @"订单取消";
        self.payButton.hidden = YES;
        break;
        case 3:
        self.waitLabel.text = @"待发货";
        self.payButton.hidden = YES;
        break;
        case 4:
        self.waitLabel.text = @"配送中";
        self.payButton.hidden = YES;
        break;
        case 5:
        self.waitLabel.text = @"已完成";
        self.payButton.hidden = YES;
        break;
        case 6:
        self.waitLabel.text = @"退款申请中";
        self.payButton.hidden = YES;
        break;
        case 7:
        self.waitLabel.text = @"退款中";
        self.payButton.hidden = YES;
        break;
        case 8:
        self.waitLabel.text = @"退款成功";
        self.payButton.hidden = YES;
        break;
        case 9:
        self.waitLabel.text = @"等待付款";
        self.payButton.hidden = NO;
        break;
        case 10:
        self.waitLabel.text = @"收货成功";
        self.payButton.hidden = YES;
        break;
        case 11:
        self.waitLabel.text = @"退款失败";
        self.payButton.hidden = YES;
        break;
    
        default:
        break;
    }
    if(self.model.goods_relateds.count!=0) {
        JJGoodsWaitModel *goodsWaitModel = self.model.goods_relateds[0];
        
        
        [self.goodsIcon sd_setImageWithURL:[NSURL URLWithString:goodsWaitModel.goods_cover] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        self.descriptLabel.text = goodsWaitModel.goods_name;
        self.sizeColorLabel.text = goodsWaitModel.goods_sku_str;
        self.countLabel.text = [NSString stringWithFormat:@"X%ld",goodsWaitModel.goods_num];

    }else {
        NSLog(@"kong");
    }
}

//点击立即支付
- (void)payBtnClick:(UIButton *)btn {
    JJCashierViewController *cashierViewController = [[JJCashierViewController alloc]init];
    cashierViewController.type = 1;
    JJOrderModel *model = [[JJOrderModel alloc]init];
    model.order_num = self.model.order_num;
    model.total_fee = self.model.real_fee.floatValue;
    cashierViewController.model = model;
    [self.viewController.navigationController pushViewController:cashierViewController animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
