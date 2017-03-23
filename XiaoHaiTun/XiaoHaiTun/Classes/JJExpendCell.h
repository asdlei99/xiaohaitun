//
//  JJExpendCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJExpendCell : UITableViewCell

//商品总额
@property (nonatomic, weak)UILabel* allOrderMoneyLabel;
//运费
@property (nonatomic, weak)UILabel *freightMoneyLabel;

@end
