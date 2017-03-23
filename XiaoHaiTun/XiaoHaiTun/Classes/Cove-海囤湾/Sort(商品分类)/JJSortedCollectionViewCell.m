//
//  JJSortedCollectionViewCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/5.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSortedCollectionViewCell.h"
#import "JJSortedCellModel.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface JJSortedCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *name;

@end

@implementation JJSortedCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] init];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        self.imageV.clipsToBounds = YES;
        [self.contentView addSubview:self.imageV];
        self.imageV.image = [UIImage imageNamed:@"Group 4"];
        
        self.name = [[UILabel alloc] init];
        self.name.text = @"母婴";
        self.name.font = [UIFont systemFontOfSize:12];
        self.name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.name];
        
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@(61 * KWIDTH_IPHONE6_SCALE));
            make.height.equalTo(@(61 * KWIDTH_IPHONE6_SCALE));
            make.top.equalTo(@(21 * KWIDTH_IPHONE6_SCALE));
        }];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView.mas_width);
            make.height.equalTo(@17);
            make.top.equalTo(self.imageV.mas_bottom).with.offset(5);
            make.centerX.equalTo(self.contentView);
        }];

        
    }
    return self;
}

- (void)setModel:(JJSortedCellModel *)model
{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.name.text = model.name;
    
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//   }
@end
