//
//  JJEditOrNewAddressBaseView.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJEditOrNewAddressBaseView : UIView
@property (weak, nonatomic) IBOutlet UILabel *baseLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

+ (instancetype)editOrNewAddressBaseView ;
@end
