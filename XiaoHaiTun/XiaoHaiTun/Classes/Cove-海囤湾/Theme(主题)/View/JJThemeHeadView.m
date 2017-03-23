//
//  JJThemeHeadView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/18.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJThemeHeadView.h"

@interface JJThemeHeadView()

@end

@implementation JJThemeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
        self.iconView.clipsToBounds = YES;
        self.iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.iconView];
//        self.backgroundColor = [UIColor purpleColor];
//        self.iconView.backgroundColor = [UIColor greenColor];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).with.offset(15 * KWIDTH_IPHONE6_SCALE);
            make.bottom.right.equalTo(self).with.offset(- 15 * KWIDTH_IPHONE6_SCALE);
        }];
        
    }
    return self;
}

@end
