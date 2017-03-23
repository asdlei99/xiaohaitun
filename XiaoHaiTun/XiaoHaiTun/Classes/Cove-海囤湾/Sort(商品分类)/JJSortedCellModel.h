//
//  JJSortedCellModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/5.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJBaseGoodsModel.h"

@interface JJSortedCellModel : JJBaseGoodsModel

@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *name;
//分类ID
@property (nonatomic, copy)NSString* categoryID;

@end
