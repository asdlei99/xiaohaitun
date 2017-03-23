//
//  JJActivityOrderPayMondyCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJActivityOrderPayMondyCell : UITableViewCell

//订单总额
@property (nonatomic, weak)UILabel* allOrderMoneyLabel;
//优惠金额
@property (nonatomic, weak)UILabel *favourableMoneyLabel;
//运费
@property (nonatomic, weak)UILabel *freightMoneyLabel;
//实际付款
@property (nonatomic, weak)UILabel *actualMoneyLabel;

@end
