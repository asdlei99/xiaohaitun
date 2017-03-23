//
//  JJShopCartPayView.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJShopCartPayView : UIView

+ (JJShopCartPayView *)shopCartView;

@property(nonatomic,assign)CGFloat totalPrice;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *gotoPayBtn;
@end
