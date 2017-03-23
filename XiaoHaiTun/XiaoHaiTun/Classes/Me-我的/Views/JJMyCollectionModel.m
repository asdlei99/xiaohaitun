//
//  JJMyCollectionModel.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMyCollectionModel.h"
#import "JJMyCollectionCell.h"
#import <MJExtension.h>


@interface JJMyCollectionModel ()

@end

@implementation JJMyCollectionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"goodsID" : @"id"};
}

@end
