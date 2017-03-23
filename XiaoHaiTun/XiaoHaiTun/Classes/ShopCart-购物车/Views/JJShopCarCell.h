//
//  JJShopCarCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJShopCarCellModel;

typedef void (^AddMoneyBlock)(CGFloat addMoney);
typedef void (^ReduceMoneyBlock)(CGFloat reduceMoney);
typedef void (^ChooseBtnClickBlock)(BOOL selected);


@interface JJShopCarCell : UITableViewCell

@property (nonatomic, strong) JJShopCarCellModel *model;

@property (nonatomic, copy)AddMoneyBlock addMoneyBlock;
@property (nonatomic, copy)ReduceMoneyBlock reduceMoneyBlock;
@property (nonatomic, copy)ChooseBtnClickBlock chooseBtnBlock;

@property (weak, nonatomic) IBOutlet UIView *whiteLineView;
@end
