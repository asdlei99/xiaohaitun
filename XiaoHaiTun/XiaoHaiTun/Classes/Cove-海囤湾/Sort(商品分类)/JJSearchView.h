//
//  JJSearchView.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JJSearchViewDelegate <NSObject>

- (void)searchWithString:(NSString *)string;

@end

@interface JJSearchView : UICollectionReusableView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, weak) id<JJSearchViewDelegate> delegate;
@end
