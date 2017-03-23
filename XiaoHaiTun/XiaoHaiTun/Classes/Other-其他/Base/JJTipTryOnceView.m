//
//  JJTipTryOnceView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/30.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTipTryOnceView.h"

@interface JJTipTryOnceView ()


@end

@implementation JJTipTryOnceView

+ (instancetype)tipTryOnceView {
    JJTipTryOnceView *tipTryOnceView = [[JJTipTryOnceView alloc]init];
    
    return tipTryOnceView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setBaseView];
    }
    return self;
}

- (void)setBaseView {
    self.backgroundColor = RGBA(238, 238, 238, 1);
    self.noInternetImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NO_WIFI"]];
    [self addSubview:self.noInternetImageView];
    [self.noInternetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(160 * KWIDTH_IPHONE6_SCALE));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).with.offset(128 * KWIDTH_IPHONE6_SCALE);
    }];
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.font = [UIFont systemFontOfSize:14];
    self.tipLabel.textColor = RGBA(53, 53, 53, 1);
    self.tipLabel.text = @"当前网络不可用,请检查网络设置";
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.noInternetImageView.mas_bottom).with.offset(26 *KWIDTH_IPHONE6_SCALE);
    }];
    
    self.tryLoadButton = [[UIButton alloc]init];
    [self addSubview:self.tryLoadButton];
    [self.tryLoadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.tryLoadButton setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
    [self.tryLoadButton setBackgroundColor:[UIColor whiteColor]];
    [self.tryLoadButton createBordersWithColor:NORMAL_COLOR withCornerRadius:8 andWidth:1];
    self.tryLoadButton.titleLabel.font = [UIFont systemFontOfSize:16] ;
    [self.tryLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).with.offset(50 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@36);
        make.width.equalTo(@105);
        make.centerX.equalTo(self);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
