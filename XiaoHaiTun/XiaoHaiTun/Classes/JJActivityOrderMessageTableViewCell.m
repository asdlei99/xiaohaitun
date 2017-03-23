//
//  JJActivityOrderMessageTableViewCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityOrderMessageTableViewCell.h"
#import "UILabel+LabelStyle.h"

@interface JJActivityOrderMessageTableViewCell()

////数量
//@property (nonatomic, weak)UILabel *countLabel;


@end


@implementation JJActivityOrderMessageTableViewCell

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
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 107 * KWIDTH_IPHONE6_SCALE)];
    [self.contentView addSubview:topView];
    
    //出发日期
    UILabel* goDateMessageLabel = [[UILabel alloc]init];
    [topView addSubview:goDateMessageLabel];
    [goDateMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"出发日期" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [goDateMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
    UILabel *goDateLabel = [[UILabel alloc]init];
    [topView addSubview:goDateLabel];
    self.goDateLabel =goDateLabel;
    [goDateLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    [goDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(topView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
        
    }];
    
    
    
    //类型
    UILabel *typeMessageLabel = [[UILabel alloc]init];
    [topView addSubview:typeMessageLabel];
    [typeMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"类型" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [typeMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goDateLabel.mas_bottom).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
    UILabel *typeLabel = [[UILabel alloc]init];
    [topView addSubview:typeLabel];
    self.typeLabel = typeLabel;
    [typeLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"893" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goDateLabel.mas_bottom).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(topView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
    
    //费用
    UILabel *payMoneyMessageLabel = [[UILabel alloc]init];
    [topView addSubview:payMoneyMessageLabel];
    [payMoneyMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"费用" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [payMoneyMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeLabel.mas_bottom).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
    UILabel *payMoneyLabel = [[UILabel alloc]init];
    [topView addSubview:payMoneyLabel];
    self.payMoneyLabel = payMoneyLabel;
    [payMoneyLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    [payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeLabel.mas_bottom).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(topView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@20);
    }];
    
//    //数量
//    UILabel *countMessageLabel = [[UILabel alloc]init];
//    [topView addSubview:countMessageLabel];
//    [countMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"数量" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//    [countMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(payMoneyMessageLabel.mas_bottom).with.offset(12 * KWIDTH_IPHONE6_SCALE);
//        make.left.equalTo(topView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
//        make.height.equalTo(@20);
//    }];
//    UILabel *countLabel = [[UILabel alloc]init];
//    [topView addSubview:countLabel];
//    [countLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"00" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
//    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(payMoneyMessageLabel.mas_bottom).with.offset(12 * KWIDTH_IPHONE6_SCALE);
//        make.right.equalTo(topView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
//        make.height.equalTo(@20);
//    }];
    
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

    
    
    //底部
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
    
    UIView *spaceView = [[UIView alloc]init];
    spaceView.backgroundColor = RGBA(238, 238, 238, 1);
    [bottomView addSubview:spaceView];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.height.equalTo(@(10 * KWIDTH_IPHONE6_SCALE));
    }];

    
}


@end
