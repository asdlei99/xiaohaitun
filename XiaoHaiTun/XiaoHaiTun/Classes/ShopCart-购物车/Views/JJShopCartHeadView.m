//
//  JJShopCartHeadView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJShopCartHeadView.h"

@implementation JJShopCartHeadView

+ (instancetype)shopCartHeadView{
    JJShopCartHeadView *headView = [[NSBundle mainBundle]loadNibNamed:@"JJShopCartHeadView" owner:nil options:nil][0];
    
    return headView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.allSelectedBtn addTarget:self action:@selector(allSelectedbtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)allSelectedbtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if(self.block){
        self.block(btn.selected);
    }
}

@end
