//
//  JJAddInformationViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/5.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
@class JJHobbyModel;
@interface JJAddInformationViewController : JJBaseViewController
/**
 /*    传入的参数
 **/
//电话号码
@property (nonatomic, copy )NSString* mobile;

//验证码
@property (nonatomic, copy)NSString* v_code;

//密码
@property (nonatomic, copy)NSString* password;

//宝宝爱好模型数组
@property (nonatomic, strong) NSArray<JJHobbyModel *> *hobbyModelsArray;

//宝宝性别模型数组
@property (nonatomic, strong) NSArray<JJHobbyModel *> *sexModelArray;


@end
