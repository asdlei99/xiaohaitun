//
//  JJReceiveAddressModel.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReceiveAddressModel.h"
#import <MJExtension.h>

@implementation JJReceiveAddressModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"addressID" : @"id"};
}

- (void)setAddress_id:(NSString *)address_id {
    self.addressID = address_id;
}
@end
