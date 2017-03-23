//
//  UIButton+Custom.h
//  HiFun
//
//  Created by hao on 16/8/18.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Custom)
/**
 *  按钮内的文字和图片垂直居中
 *
 *  @param space 文字和图片间距
 */
- (void)verticalCenterImageAndTitle:(float)space;

/**
 *  按钮内的文字和图片垂直居中
 */
- (void)verticalCenterImageAndTitle;

/**
 *  按钮内的文字和图片水平居中
 *
 *  @param space 文字和图片间距
 */
- (void)horizontalCenterImageAndTitle:(float)space;




@end
