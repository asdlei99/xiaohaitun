//
//  JJSortedListViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/5.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJSortedCellModel.h"
@interface JJSortedListViewController : JJBaseViewController

@property (nonatomic, strong) JJSortedCellModel *sortModel;

@property (nonatomic, copy) NSString *searchString;

@end
