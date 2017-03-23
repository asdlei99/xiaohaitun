//
//  JJActivityCodeCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJActivityOrderCodeCell : UITableViewCell
//二维码图片
@property (nonatomic, weak) UIImageView *codeIcon;

//验证码
@property (nonatomic, weak) UILabel *codeLabel;

@end
