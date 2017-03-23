//
//  JJMeHeadView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/7.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMeHeadView.h"
#import "UIView+FrameExpand.h"

@implementation JJMeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = NORMAL_COLOR;
        self.descriptLabel = [[UILabel alloc]init];
        [self addSubview:self.descriptLabel];
        self.descriptLabel.text = @"登录 / 注册";
        self.descriptLabel.textColor = [UIColor whiteColor];
               
        self.pictureImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_icon"]];
        self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.pictureImageView];
       
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.text = @"王杰";
        self.nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
       
        
        //[[NSBundle mainBundle]loadNibNamed:@"JJMeHeadVieww" owner:nil options:nil][0];
        [self.pictureImageView createBordersWithColor:RGBA(242, 145, 155, 1) withCornerRadius:39 andWidth:2];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-5);
    }];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@78);
        make.bottom.equalTo(self.descriptLabel.mas_top).with.offset(-10);
        make.centerX.equalTo(self);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.pictureImageView.mas_top).with.offset(-5);
    }];
}
//+ (instancetype)meHeadView {
//    JJMeHeadView * headView = [[JJMeHeadView alloc]init];
//    headView.backgroundColor = NORMAL_COLOR;
//    headView.descriptLabel = [[UILabel alloc]init];
//    [headView addSubview:headView.descriptLabel];
//    headView.descriptLabel.text = @"登录 / 注册";
//    headView.descriptLabel.textColor = [UIColor whiteColor];
//    [headView.descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(headView);
//        make.bottom.equalTo(headView).with.offset(15);
//    }];
//    
//    headView.pictureImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_icon"]];
//    [headView addSubview:headView.pictureImageView];
//    [headView.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@78);
//        make.bottom.equalTo(headView.descriptLabel.mas_top).with.offset(-23);
//        make.centerX.equalTo(headView);
//    }];
//    
//    headView.nameLabel = [[UILabel alloc]init];
//    headView.nameLabel.text = @"王杰";
//    headView.nameLabel.textColor = [UIColor whiteColor];
//    [headView addSubview:headView.nameLabel];
//    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(headView);
//        make.bottom.equalTo(headView.pictureImageView.mas_top).with.offset(-10);
//    }];
//    
//    //[[NSBundle mainBundle]loadNibNamed:@"JJMeHeadVieww" owner:nil options:nil][0];
//    [headView.pictureImageView createBordersWithColor:RGBA(242, 145, 155, 1) withCornerRadius:headView.pictureImageView.width/2 andWidth:2];
//    return headView;
//    
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
