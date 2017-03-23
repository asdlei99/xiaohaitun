//
//  UIButton+Custom.m
//  HiFun
//
//  Created by hao on 16/8/18.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)
- (void)verticalCenterImageAndTitle:(float)space {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGFloat totalHeight = (imageSize.height + titleSize.height + space);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
}

- (void)verticalCenterImageAndTitle {
    const int DEFAULT_SPACING = 6.0f;
    [self verticalCenterImageAndTitle:DEFAULT_SPACING];
}

- (void)horizontalCenterImageAndTitle:(float)space {
//    CGSize imageSize = self.imageView.frame.size;
//    CGSize titleSize = self.titleLabel.frame.size;
//    CGFloat totalWidth = (imageSize.width + titleSize.width + space);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, space / 2.0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, space / 2.0, 0, 0);
    
}
@end
