//
//  UIButton+Enlarge.h
//  HiFun
//
//  Created by attackt on 16/8/17.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Enlarge)

/**
 *  增加button的可点击范围
 */
- (void) setEnlargeEdgeWithTop:(CGFloat) top
                         right:(CGFloat) right
                        bottom:(CGFloat) bottom
                          left:(CGFloat) left;

@end
