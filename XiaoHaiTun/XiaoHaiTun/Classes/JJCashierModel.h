//
//  JJCashierModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PaymentType) {
    PaymentTypeCard = 0,//银联
    PaymentTypeAlipay,//支付宝
    PaymentTypeWechat//微信
    
};

@interface JJCashierModel : NSObject
@property(nonatomic,assign)PaymentType type;

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *payTypeString;
@property (nonatomic, copy) NSString *payMessageString;
@property(nonatomic,assign) BOOL isChoose;
@end
