//
//  JJTipTryOnceView.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/30.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJTipTryOnceView : UIView

@property (nonatomic, strong) UIImageView *noInternetImageView;
@property (nonatomic, strong) UILabel *tipLabel;

@property (strong, nonatomic) UIButton *tryLoadButton;



+ (instancetype)tipTryOnceView;
@end
