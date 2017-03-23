//
//  JJActivityOrderMessageTableViewCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJActivityOrderMessageTableViewCell : UITableViewCell

//出发日期
@property (nonatomic, weak)UILabel* goDateLabel;
//类型
@property (nonatomic, weak)UILabel *typeLabel;
//费用
@property (nonatomic, weak)UILabel *payMoneyLabel;
//订单备注
@property (nonatomic, weak)UILabel *remarkStringLabel ;
@end
