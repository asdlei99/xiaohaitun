//
//  JJCashierViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJOrderModel.h"

@interface JJCashierViewController : JJBaseViewController
@property (nonatomic, strong) JJOrderModel *model;

//商品:1    活动:2
@property(nonatomic,assign)NSInteger type;
@end
