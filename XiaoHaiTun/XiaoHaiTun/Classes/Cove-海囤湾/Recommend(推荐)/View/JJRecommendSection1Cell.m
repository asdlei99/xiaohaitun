//
//  JJRecommendSection1Cell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/29.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJRecommendSection1Cell.h"
#import "JJRecommendSection1Model.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface JJRecommendSection1Cell ()

//图片
@property (nonatomic, weak) UIImageView *imageView;

//介绍
@property (nonatomic, weak) UILabel *introduceLabel;

//价格
@property (nonatomic, weak) UILabel *priceLabel;

//横线
@property (nonatomic, weak) UIView *lineView;

@end

@implementation JJRecommendSection1Cell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        //创建视图控件
        [self createView];
    }
    return self;
}

//创建视图控件
- (void)createView{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageView];
    [imageView createBordersWithColor:[UIColor clearColor] withCornerRadius:3.0 andWidth:0];
    self.imageView = imageView;
    
    UILabel *introductionLabel = [[UILabel alloc]init];
    introductionLabel.text = @"美赞臣 安婴儿A+亲舒乳蛋白部分水解婴儿配方奶粉400g";
    introductionLabel.numberOfLines = 2;
    introductionLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:introductionLabel];
    self.introduceLabel = introductionLabel;
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.text = @"10yuan";
    priceLabel.font = [UIFont systemFontOfSize:12];
    priceLabel.textColor = NORMAL_COLOR;
    [self.contentView addSubview: priceLabel];
    self.priceLabel = priceLabel;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBA(236, 236, 236, 1);
    [self.contentView addSubview:lineView];
    self.lineView = lineView;

}


//布局
-(void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.equalTo(self.imageView.mas_width).multipliedBy(150.0/167);
    }];
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(8 * KWIDTH_IPHONE6_SCALE);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.lineView.mas_top).with.offset(-8);
    }];
    DebugLog(@"%@",NSStringFromCGRect(self.bounds));
}

//重写set方法给控件赋值
-(void)setModel:(JJRecommendSection1Model *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.introduceLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
}

@end
