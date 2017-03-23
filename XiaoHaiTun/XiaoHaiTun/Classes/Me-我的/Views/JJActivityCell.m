//
//  JJActivityCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityCell.h"
#import <Masonry.h>
#import "UILabel+LabelStyle.h"
#import <UIImageView+WebCache.h>
#import "JJMyActivityModel.h"
@interface JJActivityCell ()

//订单号
@property (nonatomic, weak) UILabel *ordersNumberLabel;


//付款成功/报名成功
@property (nonatomic, weak) UILabel *waitLabel;

//活动logo
@property (nonatomic, weak) UIImageView *goodsIcon;

//活动描述
@property (nonatomic, weak) UILabel *descriptLabel;

//地点
@property (nonatomic, weak) UILabel *placeLabel;


@end

@implementation JJActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseView];
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
    //付款成功/报名成功
    UILabel *waitLabel = [[UILabel alloc]init];
    [waitLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"等待付款" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentRight];
    self.waitLabel = waitLabel;
    [topView addSubview:_waitLabel];
    [_waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(topView);
        make.right.equalTo(topView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
    }];
    //横线
    UIView *grayLineView = [[UIView alloc]init];
    grayLineView.backgroundColor = RGBA(238, 238, 238, 1);
    [topView addSubview:grayLineView];
    [grayLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.bottom.equalTo(topView);
        make.left.equalTo(topView).with.offset(15 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(topView);
    }];
    
    
    
    //center
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 57 * KWIDTH_IPHONE6_SCALE, SCREEN_WIDTH, 120 * KWIDTH_IPHONE6_SCALE)];
    centerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:centerView];
    //衣服logo
    UIImageView *goodsIcon = [[UIImageView alloc]init];
    goodsIcon.backgroundColor = RGBA(239, 239, 239, 1);
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
    //往返地点
    UILabel *placeLabel = [[UILabel alloc]init];
    [centerView addSubview:placeLabel];
    self.placeLabel = placeLabel;
    [self.placeLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14] text:@"上海-仁川-上海" textColor:RGBA(51,51,51,1) textAlignment:NSTextAlignmentLeft];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerView).with.offset(-36 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.goodsIcon.mas_right).with.offset(12 * KWIDTH_IPHONE6_SCALE);
    }];

    UIView *spaceView = [[UIView alloc]init];
    spaceView.backgroundColor = RGBA(238, 238, 238, 1);
    [self.contentView addSubview:spaceView];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(centerView.mas_bottom);
        make.height.equalTo(@(10 * KWIDTH_IPHONE6_SCALE));
    }];
}

- (void)setModel:(JJMyActivityModel *)model{
    _model = model;
    self.ordersNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",model.order_num];
    [self.goodsIcon sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.descriptLabel.text = model.name;
    self.placeLabel.text = model.address;
    
    //等待付款
    if(model.status == JJMyActivityWaitPay) {
        self.waitLabel.text = @"等待付款";
    }
    //付款成功
    if(model.status == JJMyActivitySuccessPay) {
         self.waitLabel.text = @"付款成功";
    }
    //订单取消
    if(model.status == JJMyActivityCancleOrder) {
        self.waitLabel.text = @"订单取消";
    }
    //报名成功
    if(model.status == JJMyActivityApplySuccess) {
        self.waitLabel.text = @"报名成功";
    }
    //退款申请中
    if(model.status == JJMyActivityOrderRefoundApplying) {
        self.waitLabel.text = @"退款申请中";
    }
    //退款中
    if(model.status == JJMyActivityOrderRefounding) {
        self.waitLabel.text = @"退款中";
    }
    //退款成功
    if(model.status == JJMyActivityOrderRefoundSuccess) {
        self.waitLabel.text = @"退款成功";
    }
    //已结束
    if(model.status == JJMyActivityOrderComplete) {
        self.waitLabel.text = @"已参加";
    }
    //退款失败
    if(model.status == JJMyActivityOrderRefoundFail) {
        self.waitLabel.text = @"退款失败";
    }
    //支付成功
    if(model.status == JJMyActivityPayMent) {
        self.waitLabel.text = @"支付中";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
