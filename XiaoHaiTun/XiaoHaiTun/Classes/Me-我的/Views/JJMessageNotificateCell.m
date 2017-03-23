//
//  JJMessageNotificateCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMessageNotificateCell.h"
#import <Masonry.h>
#import "UILabel+LabelStyle.h"
@implementation JJMessageNotificateCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initBaseViews];
    }
    return self;
}

- (void)initBaseViews {
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 20, 300, 22)];
    self.nameLabel = nameLabel;
    [nameLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] text:@"接收新消息通知" textColor:[UIColor blackColor] textAlignment:nil];
    [self.contentView addSubview:nameLabel];
    
    UILabel * detailLabel = [[UILabel alloc]init];
    self.detailLabel = detailLabel;
    [detailLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] text:@"要开启或停用,您可以在设置>小海囤>通知中心手动设置" textColor:RGBA(153,153,153,1) textAlignment:nil];
    [self.contentView addSubview:detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(16);
        make.bottom.equalTo(self.contentView).with.offset(-17);
    }];
    
    
    
    
    UILabel * stopLabel = [[UILabel alloc]init];
    [self.contentView addSubview:stopLabel];
    [stopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-30);
    }];
    self.stopLabel = stopLabel;
    [stopLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] text:@"已停用" textColor:RGBA(153,153,153,1) textAlignment:nil];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
