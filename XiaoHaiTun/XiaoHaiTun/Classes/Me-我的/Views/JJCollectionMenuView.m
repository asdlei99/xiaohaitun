//
//  JJCollectionMenuView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJCollectionMenuView.h"

@interface JJCollectionMenuView ()



@end

@implementation JJCollectionMenuView

-(void)awakeFromNib{
    [self.allSelectedBtn addTarget:self action:@selector(allSelectedBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

+ (instancetype)collectionMenuView {
    return [[NSBundle mainBundle]loadNibNamed:@"JJCollectionMenuView" owner:nil options:nil][0];
}

//全选按钮点击
- (void)allSelectedBtnClcik:(UIButton *)btn{
     btn.selected = !btn.selected;
    if(self.allSelectBlock){
        self.allSelectBlock(btn.selected);
    }
}
//删除按钮点击
-(void)deleteBtnClick:(UIButton *)btn{
    if(self.deleteBlock){
        self.deleteBlock();
    }
}


@end
