//
//  JJCityPickerView.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJCity;
@interface JJCityPickerView : UIView

@property (nonatomic,copy) void (^completion)(JJCity *city);

- (void)showPickerWithCityName:(NSString *)cityName;//市 名


@end
