//
//  JJShopCartPayView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJShopCartPayView.h"

@interface JJShopCartPayView ()




@end

@implementation JJShopCartPayView

+ (JJShopCartPayView *)shopCartView {
    JJShopCartPayView *shopCartPayView = [[NSBundle mainBundle]loadNibNamed:@"JJShopCartPayView" owner:nil options:nil][0];
    return shopCartPayView;
}

- (void)setTotalPrice:(CGFloat)totalPrice{
    _totalPrice = totalPrice;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2lf",totalPrice] ;
    
}

- (IBAction)gotPay:(id)sender {
    
}
@end
