//
//  JJMyBalanceCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMyBalanceCell.h"
#import "UILabel+LabelStyle.h"
#import "UIView+XPKit.h"
#import "JJMybalanceModel.h"

@interface JJMyBalanceCell ()

//充值类型
@property (nonatomic, weak) UILabel *rechargeableTypeLabel;
//充值说明
@property (nonatomic, weak) UILabel *rechargeableDescriptLabel;
//充值按钮
@property (nonatomic, weak) UIButton *rechargeableBtn;


@end

@implementation JJMyBalanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseView];
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    //充值类型
    UILabel *rechargeableTypeLabel = [[UILabel alloc]init];
    self.rechargeableTypeLabel = rechargeableTypeLabel;
    [self.contentView addSubview:self.rechargeableTypeLabel];
    [self.rechargeableTypeLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] text:@"充值500元" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
   //图文混排
    NSMutableAttributedString *attributLeft = [[NSMutableAttributedString alloc]initWithString:@"充值"];
    NSAttributedString *moneyAttributString = [[NSAttributedString alloc]initWithString:@"500" attributes:@{NSForegroundColorAttributeName:RGBA(234, 130, 44, 1)}];
    NSAttributedString *rightAttribute = [[NSAttributedString alloc]initWithString:@"元"];
    [attributLeft appendAttributedString:moneyAttributString];
    [attributLeft appendAttributedString:rightAttribute ];
    [self.rechargeableTypeLabel setAttributedText:attributLeft];
    
    [self.rechargeableTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
    }];
    
    
    //充值说明
    UILabel *reachargeableDescriptLabel = [[UILabel alloc]init];
    reachargeableDescriptLabel.numberOfLines = 1;
    self.rechargeableDescriptLabel = reachargeableDescriptLabel;
    [self.contentView addSubview:self.rechargeableDescriptLabel];
    
    [self.rechargeableDescriptLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"充值1000元送200,返回海豚比1000元" textColor:RGBA(153,153,153,1) textAlignment:NSTextAlignmentLeft];
    [self.rechargeableDescriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self.contentView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //充值按钮
    UIButton *reachargeableBtn = [[UIButton alloc]init];
    [reachargeableBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.rechargeableBtn = reachargeableBtn;
    [self.rechargeableBtn createBordersWithColor:RGBA(234, 130, 44, 1) withCornerRadius:2 andWidth:1];
    [self.rechargeableBtn setTitle:@"充值" forState:UIControlStateNormal];
    [self.rechargeableBtn setTitleColor:RGBA(234, 130, 44, 1) forState:UIControlStateNormal];
    [self.contentView addSubview:self.rechargeableBtn];
    [reachargeableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@(27 * KWIDTH_IPHONE6_SCALE));
        make.width.equalTo(@(72 * KWIDTH_IPHONE6_SCALE));
    }];
}

- (void)setModel:(JJMyBalanceModel *)model {
    _model = model;
    //图文混排
    NSMutableAttributedString *attributLeft = [[NSMutableAttributedString alloc]initWithString:@"充值"];
    NSAttributedString *moneyAttributString = [[NSAttributedString alloc]initWithString:model.rechargeMoney attributes:@{NSForegroundColorAttributeName:RGBA(234, 130, 44, 1)}];
    NSAttributedString *rightAttribute = [[NSAttributedString alloc]initWithString:@"元"];
    [attributLeft appendAttributedString:moneyAttributString];
    [attributLeft appendAttributedString:rightAttribute ];
    [self.rechargeableTypeLabel setAttributedText:attributLeft];
    
    self.rechargeableDescriptLabel.text = model.rechargeDetail;
    [self.rechargeableBtn addTarget:self action:@selector(btnclickToRecharge) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnclickToRecharge {
    if([self.delegate respondsToSelector:@selector(rechargeBtnClickWithMoney:)]) {
        [self.delegate rechargeBtnClickWithMoney:self.model.rechargeMoney];
    }
}

@end
