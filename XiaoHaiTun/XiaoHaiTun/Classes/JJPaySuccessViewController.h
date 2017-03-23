//
//  JJPaySuccessViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJBaseViewController.h"
#import "JJOrderModel.h"

@interface JJPaySuccessViewController : JJBaseViewController
@property (nonatomic, strong) JJOrderModel *model;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

//商品:1    活动:2   充值:3
@property(nonatomic,assign)NSInteger type;
@end
