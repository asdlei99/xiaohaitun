//
//  JJInformationPictureCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJInformationPictureCell.h"
#import "UIView+FrameExpand.h"

@implementation JJInformationPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pictureView.backgroundColor = [UIColor purpleColor];
    [self.pictureView createBordersWithColor:[UIColor clearColor] withCornerRadius:self.pictureView.width/2 andWidth:1];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
