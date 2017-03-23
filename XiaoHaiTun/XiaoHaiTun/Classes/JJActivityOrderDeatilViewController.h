//
//  JJActivityOrderDeatilViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJMyActivityModel.h"

@protocol JJActivityOrderDeatilDelegate <NSObject>

- (void)refundSuccess ;

@end

@interface JJActivityOrderDeatilViewController : JJBaseViewController

@property (nonatomic, strong) JJMyActivityModel *model;

@property (nonatomic, weak) id<JJActivityOrderDeatilDelegate> refundDelegate;

@end
