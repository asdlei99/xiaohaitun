//
//  JJReceiveAddressCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJReceiveAddressModel.h"

typedef void(^DeleteAddresCellBlock)(void);

@interface JJReceiveAddressCell : UITableViewCell

@property (nonatomic, strong) JJReceiveAddressModel *model;

@property (nonatomic, copy)DeleteAddresCellBlock deleteCellBlock;

//勾选按钮
@property (nonatomic, weak) UIImageView *chooseImage;

@end
