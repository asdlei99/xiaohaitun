//
//  JJRemarkInputView.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJRemarkInputView : UIView
@property (nonatomic, copy)NSString* title;
@property (weak, nonatomic) IBOutlet UITextField *inputRemarkTextField;

+ (instancetype)remarkInputView;

@end
