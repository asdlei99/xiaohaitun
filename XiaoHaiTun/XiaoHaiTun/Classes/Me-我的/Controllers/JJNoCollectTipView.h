//
//  JJNoCollectTipView.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJNoCollectTipView : UIView
@property (nonatomic, strong) UIImageView *noCollectImageView;
@property (nonatomic, strong) UILabel *tipLabel;

@property (strong, nonatomic) UIButton *goodButton;


+ (instancetype)tipNoCollectView;
@end
