//
//  JJGoodsOrderConfirmViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
@class JJShopCarCellModel;

@interface JJGoodsOrderConfirmViewController : JJBaseViewController

//选中的model数组
@property (nonatomic, strong) NSMutableArray<JJShopCarCellModel *> *selectedModelArray;
@property (nonatomic, assign) CGFloat allPayMoney;


@end
