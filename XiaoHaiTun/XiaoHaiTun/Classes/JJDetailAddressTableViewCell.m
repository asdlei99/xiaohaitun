//
//  JJDetailAddressTableViewCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJDetailAddressTableViewCell.h"

@implementation JJDetailAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
