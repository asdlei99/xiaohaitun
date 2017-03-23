//
//  JJReceiveAddressModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JJReceiveAddressModel : NSObject
//是否为默认
@property(nonatomic, copy)NSString *is_default;
//是否勾选
@property(nonatomic, assign)BOOL  isSelected;
//收货地址id(这个是id改的)
@property (nonatomic, copy)NSString* addressID;
//收货地址address_id(这个是原本的)这样写主要是后台两个人命名不统一
@property (nonatomic, copy)NSString *address_id;
//姓名
@property (nonatomic, copy)NSString* shipping_user;
//电话
@property (nonatomic, copy)NSString* mobile;
//地址
@property (nonatomic, copy)NSString* address;
//身份证
@property (nonatomic, copy) NSString *id_card;
//省
@property (nonatomic, copy) NSString *province;
//市
@property (nonatomic, copy) NSString *city;
//区
@property (nonatomic, copy) NSString *area;
//地址
@property (nonatomic, copy) NSString *detail;
@end

/*
 "id": 1,
 "shipping_user": "张三",
 "mobile": 123123123123,
 "province": "北京",
 "city": "北京",
 "area": "朝阳区",
 "id_card": "42011612234134",
 "address": "百子湾东里123号",
 "is_default": 1,
 */
