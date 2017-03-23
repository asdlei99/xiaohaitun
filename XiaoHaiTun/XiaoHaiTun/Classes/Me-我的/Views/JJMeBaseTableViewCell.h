//
//  JJMeBaseTableViewCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/6.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJMeBaseTableViewCell : UITableViewCell

//图片
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
//名称
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
//多少钱
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
