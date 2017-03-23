//
//  JJAddNewReceiveAddressViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"

typedef void(^AddSuccessBlock)(void);

@interface JJAddNewReceiveAddressViewController : JJBaseViewController

@property (nonatomic, copy)AddSuccessBlock addBlock;

@end
