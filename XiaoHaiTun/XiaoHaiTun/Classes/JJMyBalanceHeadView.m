//
//  JJMyBalanceHeadView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMyBalanceHeadView.h"
#import "UILabel+LabelStyle.h"


@interface JJMyBalanceHeadView ()

//余额
@property (nonatomic, strong) UILabel *balanceLabel;

@end

@implementation JJMyBalanceHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self initBaseView];
    }
    return self;
}

- (void)initBaseView{
    self.balanceLabel = [[UILabel alloc]init];
    [self addSubview:_balanceLabel];
    [self.balanceLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:44] text:self.balance textColor:NORMAL_COLOR textAlignment:NSTextAlignmentCenter];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@62);
        make.top.equalTo(self).with.offset(26 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self);
    }];
    
    UILabel *messageLabel = [[UILabel alloc]init];
     [self addSubview:messageLabel];
    [messageLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"账户余额(元)" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.balanceLabel.mas_bottom).with.offset(2);
    }];
   
    UIView *spaceView = [[UIView alloc]init];
    spaceView.backgroundColor = RGBA(238, 238, 238, 1);
    [self addSubview:spaceView];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(10 * KWIDTH_IPHONE6_SCALE));
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)setBalance:(NSString *)balance {
    _balance = balance;
    self.balanceLabel.text = balance;
}
@end
