//
//  UIViewController+Alert.m
//  HiFun
//
//  Created by attackt on 16/7/28.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import "UIViewController+Alert.h"

@interface UIViewController ()

//确定
@property (nonatomic, copy)AlertViewBlock centerBlock;
//取消
@property (nonatomic, copy)AlertViewBlock cancleBlock;

@end


@implementation UIViewController (Alert)

static char cancleKey;
-(void)setCancleBlock:(AlertViewBlock)cancleBlock{
    objc_setAssociatedObject(self, &cancleKey, cancleBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString*)cancleBlock{
    return objc_getAssociatedObject(self, &cancleKey);
}

static char centerKey;
-(void)setCenterBlock:(AlertViewBlock)centerBlock{
    objc_setAssociatedObject(self, &centerKey, centerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString*)centerBlock{
    return objc_getAssociatedObject(self, &centerKey);
}


- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle {
    if (IOS_VERSION >= 9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancleAction];
    } else {//版本向下兼容
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}



- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelBlock:(AlertViewBlock)cancleBlock
              certainBlock:(AlertViewBlock)certainBloack{
    if (IOS_VERSION >= 9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cancleBlock();
        }];
        [alert addAction:cancleAction];
        UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            certainBloack();
        }];
        [alert addAction:certainAction];

    } else {//版本向下兼容
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title  message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    if(cancleBlock){
        self.cancleBlock = cancleBlock;
    }
    if(certainBloack){
        self.centerBlock = certainBloack;
    }
    
        [alert show];
        
    }
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle
               cancelBlock:(AlertViewBlock)cancelBloack {
    if (IOS_VERSION >= 9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(cancelBloack) {
                cancelBloack();
            }
        }];
        [alert addAction:cancleAction];
    } else {//版本向下兼容
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
    if(cancelBloack){
        self.cancleBlock = cancelBloack;
    }
        [alert show];
}

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if(self.cancleBlock){
            self.cancleBlock();
        }
    }
    if(buttonIndex == 1){
        if(self.centerBlock){
            self.centerBlock();
        }
    }
    DebugLog(@"%ld",buttonIndex);
}


@end
