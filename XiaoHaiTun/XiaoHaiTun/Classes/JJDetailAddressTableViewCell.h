//
//  JJDetailAddressTableViewCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJDetailAddressTableViewCell : UITableViewCell

//图片
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
//详细地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//旅游名称
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@end
