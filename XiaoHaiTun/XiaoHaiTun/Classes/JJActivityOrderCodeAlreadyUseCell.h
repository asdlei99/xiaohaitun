//
//  JJActivityOrderCodeAlreadyUseCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJActivityOrderCodeAlreadyUseCell : UITableViewCell
//二维码图片
@property (nonatomic, weak) UIImageView *codeIcon;

//验证码
@property (nonatomic, weak) UILabel *codeLabel;

//使用时间Label
@property (nonatomic, weak) UILabel *useTimeLabel;
@end
