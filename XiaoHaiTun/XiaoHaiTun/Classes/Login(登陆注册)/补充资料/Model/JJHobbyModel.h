//
//  JJHobbyModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/5.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJHobbyModel : NSObject

//图片地址
@property (nonatomic, copy)NSString *picture;

//名称
@property (nonatomic, copy)NSString *name;

//爱好的ID
@property (nonatomic, assign)NSInteger ID;

//判断是否被点击
@property (nonatomic,assign)BOOL isSelected;

@end
