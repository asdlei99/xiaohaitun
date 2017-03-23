//
//  JJNoCollectTipView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJNoCollectTipView.h"

@implementation JJNoCollectTipView

+ (instancetype)tipNoCollectView {
    JJNoCollectTipView *tipTryOnceView = [[JJNoCollectTipView alloc]init];
    [tipTryOnceView setBaseView];
    return tipTryOnceView;
}

- (void)setBaseView {
    self.backgroundColor = RGBA(238, 238, 238, 1);
    self.noCollectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NO_Collect"]];
    [self addSubview:self.noCollectImageView];
    [self.noCollectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(160 * KWIDTH_IPHONE6_SCALE));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).with.offset(128 * KWIDTH_IPHONE6_SCALE);
    }];
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.font = [UIFont systemFontOfSize:14];
    self.tipLabel.textColor = RGBA(53, 53, 53, 1);
    self.tipLabel.text = @"您还没有收藏东东哦,快去逛逛吧";
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.noCollectImageView.mas_bottom).with.offset(26 *KWIDTH_IPHONE6_SCALE);
    }];
    
    self.goodButton = [[UIButton alloc]init];
    [self addSubview:self.goodButton];
    [self.goodButton setTitle:@"去逛逛" forState:UIControlStateNormal];
    [self.goodButton setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
    [self.goodButton setBackgroundColor:[UIColor whiteColor]];
    [self.goodButton createBordersWithColor:NORMAL_COLOR withCornerRadius:8 andWidth:1];
    self.goodButton.titleLabel.font = [UIFont systemFontOfSize:16] ;
    [self.goodButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).with.offset(50 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@36);
        make.width.equalTo(@96);
        make.centerX.equalTo(self);
    }];
}

@end
