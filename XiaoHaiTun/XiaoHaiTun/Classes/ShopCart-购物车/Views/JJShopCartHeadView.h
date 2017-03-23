//
//  JJShopCartHeadView.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HeadBtnClickBlock) (BOOL selected);

@interface JJShopCartHeadView : UIView
@property (weak, nonatomic) IBOutlet UIButton *allSelectedBtn;
@property (nonatomic, copy)HeadBtnClickBlock block;

+ (instancetype)shopCartHeadView;

@end
