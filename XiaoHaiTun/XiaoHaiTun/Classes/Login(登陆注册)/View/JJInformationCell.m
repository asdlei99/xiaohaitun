//
//  JJInformationCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/5.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJInformationCell.h"
#import <ReactiveCocoa.h>
#import <UIImageView+WebCache.h>

@interface JJInformationCell()

@end

@implementation JJInformationCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
      
        self.imageV = [[UIImageView alloc] init];
//        self.imageV.backgroundColor = [UIColor greenColor];
        self.imageV.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.imageV];
        self.imageV.image = [UIImage imageNamed:@"Welcome_3.0_3"];
        
        self.chooseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choose_add_Information"]];
        self.chooseImageView.contentMode = UIViewContentModeCenter;
        self.chooseImageView.hidden = YES;
        self.chooseImageView.backgroundColor = RGBA(240, 5, 70, 0.7);
        [self.imageV addSubview:self.chooseImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.text = @"rew";
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        [RACObserve(self, hobbyModel.isSelected)subscribeNext:^(NSNumber *isSelected) {
            if(isSelected.boolValue == YES) {
                self.chooseImageView.hidden = NO;
            }else{
                self.chooseImageView.hidden = YES;
            }
        }];
    }
    return self;
}

- (void)setHobbyModel:(JJHobbyModel *)hobbyModel
{
    DebugLog(@"%@   %@   %ld",hobbyModel.picture,hobbyModel.name,hobbyModel.ID);
    _hobbyModel = hobbyModel;
    if([hobbyModel.picture hasPrefix:@"http"]){
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:hobbyModel.picture] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    }else{
        NSURL *url = [NSURL fileURLWithPath:hobbyModel.picture];
        [self.imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    }
    
    self.nameLabel.text = hobbyModel.name;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerX.equalTo(self.contentView.mas_centerX);
        //            make.width.equalTo(@(61 * KWIDTH_IPHONE6_SCALE));
        //            make.height.equalTo(@(61 * KWIDTH_IPHONE6_SCALE));
        //            make.top.equalTo(@(21 * KWIDTH_IPHONE6_SCALE));
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(self.imageV.mas_width);
    }];
    //变圆
    [self.imageV createBordersWithColor:[UIColor whiteColor] withCornerRadius:(self.width / 2) andWidth:0];
    
    [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.right.equalTo(self.imageV);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView.mas_width);
        make.height.equalTo(@20);
        //            make.top.equalTo(self.imageV.mas_bottom).with.offset(5);
        //            make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    

}

@end
