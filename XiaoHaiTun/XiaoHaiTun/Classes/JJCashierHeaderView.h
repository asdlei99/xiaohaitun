//
//  JJCashierHeaderView.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJCashierHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
+ (instancetype)cashierHeaderView;
@end
