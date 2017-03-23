//
//  JJMyBalanceCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJMyBalanceModel;

@protocol JJMyBalanceModelDelegate <NSObject>

- (void)rechargeBtnClickWithMoney:(NSString *)money;

@end

@interface JJMyBalanceCell : UITableViewCell
@property (nonatomic, strong) JJMyBalanceModel *model;

@property (nonatomic, weak) id<JJMyBalanceModelDelegate> delegate;

@end
