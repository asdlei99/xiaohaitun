//
//  JJUpdateNameController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"

typedef void(^UpdateBlock)(NSString *);

@interface JJUpdateNameController : JJBaseViewController

@property (nonatomic, copy)UpdateBlock updateBlock;

@property (nonatomic, copy) NSString *name;
@end
