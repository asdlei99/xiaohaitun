//
//  JJReceiveAddressViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
@class JJReceiveAddressModel;

@protocol JJChooseAddressModelDelegate <NSObject>

- (void)chooseAddressModel:(JJReceiveAddressModel *)addressModel;

@end

@interface JJReceiveAddressViewController : JJBaseViewController

@property (nonatomic, weak) id<JJChooseAddressModelDelegate> selecteDelegate;
//是否隐藏勾选按钮
@property(nonatomic,assign)BOOL isHideChooseImage;

//该id的地址是被选中的
@property (nonatomic, strong) NSString *selectedModelId;


@end
