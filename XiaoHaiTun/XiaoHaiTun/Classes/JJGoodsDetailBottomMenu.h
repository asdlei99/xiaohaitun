//
//  JJGoodsDetailBottomMenu.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJGoodsDetailBottomMenu : UIView
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *shopCartButton;
@property (weak, nonatomic) IBOutlet UIButton *joinShopCart;
@property (weak, nonatomic) IBOutlet UIButton *bookNowButton;

+ (instancetype)goodsDetailBottomMenu;

@end
