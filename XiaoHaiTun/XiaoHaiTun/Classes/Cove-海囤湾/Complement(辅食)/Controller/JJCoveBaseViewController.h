//
//  JJComplementViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//  辅食页面

#import "JJBaseCollectionViewController.h"
#import "JJSortedCellModel.h"

@interface JJCoveBaseViewController : JJBaseCollectionViewController

@property (nonatomic, strong) JJSortedCellModel *sortModel;
@property (nonatomic, copy) NSString *searchString;

@end
