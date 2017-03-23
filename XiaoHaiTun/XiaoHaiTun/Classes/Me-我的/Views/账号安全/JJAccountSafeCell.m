//
//  JJAccountSafeCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJAccountSafeCell.h"
#import "UILabel+LabelStyle.h"
#import <Masonry.h>

@interface JJAccountSafeCell ()

@end

@implementation JJAccountSafeCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self initBaseViews];
    }
    return self;
}

- (void)initBaseViews {
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 20, 100, 22)];
    self.nameLabel = nameLabel;
    [nameLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] text:@"登录密码" textColor:[UIColor blackColor] textAlignment:nil];
    [self.contentView addSubview:nameLabel];
    
     UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 50, 300 ,17)];
    self.detailLabel = detailLabel;
    [detailLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] text:@"建议定期更改密码以保护账号安全" textColor:RGBA(153,153,153,1) textAlignment:nil];
    [self.contentView addSubview:detailLabel];
    
    UILabel * phoneLabel = [[UILabel alloc]init];
    [self.contentView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-1);
    }];
    self.phoneLabel = phoneLabel;
    [phoneLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] text:@"" textColor:RGBA(153,153,153,1) textAlignment:nil];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
