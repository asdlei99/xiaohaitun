//
//  JJActivityChooseADViewModel.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/19.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityChooseADViewModel.h"
#import <MJExtension.h>

@implementation JJActivityChooseADViewModel
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"activityID":@"id"};
}
@end
