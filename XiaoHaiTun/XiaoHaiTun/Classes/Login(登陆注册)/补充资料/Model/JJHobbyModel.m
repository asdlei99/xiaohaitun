//
//  JJHobbyModel.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/5.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJHobbyModel.h"
#import <MJExtension.h>
@interface JJHobbyModel()


@end

@implementation JJHobbyModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
//重新判断equal
- (BOOL)isEqual:(JJHobbyModel *)other
{
    if (self.ID == other.ID) {
        return YES;
    }
    return [super isEqual:other];
}


@end
