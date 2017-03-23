//
//  UILabel+labelStyle.m
//  HiFun
//
//  Created by attackt on 16/7/28.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import "UILabel+LabelStyle.h"

@implementation UILabel (LabelStyle)

- (void)jj_setLableStyleWithBackgroundColor:(UIColor *)backgroungColor
                                       font:(UIFont *)font
                                       text:(NSString *)text
                                  textColor:(UIColor *)textColor
                              textAlignment:(NSTextAlignment)textAlignment {
    self.backgroundColor = backgroungColor;
    self.font = font;
    self.text = text;
    self.textColor = textColor;
    self.textAlignment = textAlignment;
}

- (CGSize)jj_sizeToFitWithText:(NSString *)text Font:(UIFont *)font {
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize textSize = [text boundingRectWithSize:size
                                         options:NSStringDrawingTruncatesLastVisibleLine|
                       NSStringDrawingUsesLineFragmentOrigin|
                       NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil].size;
    
    return textSize;
}
@end
