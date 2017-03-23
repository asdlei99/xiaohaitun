//
//  JJCollectionMenuView.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DeleteBlock)(void);
typedef void (^AllSelectBlock)(BOOL);

@interface JJCollectionMenuView : UIView
//全选
@property (weak, nonatomic) IBOutlet UIButton *allSelectedBtn;

//删除
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@property (nonatomic, copy)DeleteBlock deleteBlock;
@property (nonatomic, copy)AllSelectBlock allSelectBlock;

+ (instancetype)collectionMenuView;

@end
