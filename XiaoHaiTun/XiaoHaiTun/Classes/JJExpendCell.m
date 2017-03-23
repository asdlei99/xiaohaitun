//
//  JJExpendCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJExpendCell.h"
#import "UILabel+LabelStyle.h"

@interface JJExpendCell ()


@end

@implementation JJExpendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseView];
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    self.selectionStyle = NO;
    self.contentView.backgroundColor = [UIColor whiteColor];
    //订单总额
    UILabel* allOrderMoneyMessageLabel = [[UILabel alloc]init];
    [self.contentView addSubview:allOrderMoneyMessageLabel];
    [allOrderMoneyMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13] text:@"商品总额:" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [allOrderMoneyMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.contentView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@18);
    }];
    UILabel *allOrderMoneyLabel = [[UILabel alloc]init];
    [self.contentView addSubview:allOrderMoneyLabel];
    self.allOrderMoneyLabel =allOrderMoneyLabel;
    [allOrderMoneyLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    [allOrderMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(self.contentView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@18);
        
    }];
    
    //运费
    UILabel *freightMoneyMessageLabel = [[UILabel alloc]init];
    [self.contentView addSubview:freightMoneyMessageLabel];
    [freightMoneyMessageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"运费:" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [freightMoneyMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allOrderMoneyLabel.mas_bottom).with.offset(8 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.contentView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@18);
    }];
    UILabel *freightMoneyLabel = [[UILabel alloc]init];
    [self.contentView addSubview:freightMoneyLabel];
    self.freightMoneyLabel = freightMoneyLabel;
    [freightMoneyLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentLeft];
    [freightMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allOrderMoneyLabel.mas_bottom).with.offset(8 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(self.contentView).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@18);
    }];
}


@end
