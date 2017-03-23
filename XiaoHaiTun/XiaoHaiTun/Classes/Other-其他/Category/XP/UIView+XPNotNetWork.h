//
//  UIView+EmptyData.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/14.
//  Copyright © 2016年 唐天成. All rights reserved.
// 当数量为0

#import <UIKit/UIKit.h>

typedef void(^TryOnceAgainBlock)(void);

@interface UIView (XPNotNetWork)
//没有网络时
- (void)showNoNetWorkWithTryAgainBlock:(TryOnceAgainBlock)block;
- (void)hideNoNetWork;
//@property (nonatomic, strong) JJTipTryOnceView *ttipTryOnceView;

/**
 返回无数据时

 @param imageName 图片名   传nil会有一个默认图
 @param title     描述
 @param btnName   按钮名    若传nil则把按钮隐藏
 @param block     点下按钮要做的事
 */
- (void)showNoDateWithImageName:(NSString *)imageName title:(NSString *)title btnName:(NSString *)btnName TryAgainBlock:(TryOnceAgainBlock)block;
- (void)hideNoDate;


@end
