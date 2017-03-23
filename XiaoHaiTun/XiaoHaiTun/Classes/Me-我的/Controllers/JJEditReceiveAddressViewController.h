//
//  JJEditReceiveAddressViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJReceiveAddressModel.h"'
@class JJEditReceiveAddressViewController;

typedef void(^EditSuccessBlock)(void);

@interface JJEditReceiveAddressViewController : JJBaseViewController


@property (nonatomic, strong) JJReceiveAddressModel *model;

@property (nonatomic, copy)EditSuccessBlock editBlock;

@end
