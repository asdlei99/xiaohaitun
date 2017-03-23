//
//  MBProgressHUD+gifHUD.m
//  HiFun
//
//  Created by hao on 16/8/8.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import "MBProgressHUD+gifHUD.h"
#import <SDWebImage/UIImage+GIF.h>
@implementation MBProgressHUD (gifHUD)
+ (void)showHUDWithGifName:(NSString *)gifName
               information:(NSString *)information {
    MBProgressHUD *hud = [self initHUDWithInformation:information mode:MBProgressHUDModeCustomView];
    UIImage *image = [UIImage sd_animatedGIFNamed:gifName];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imgView;
}

+ (void)showHUDWithPngName:(NSString *)pngName
               information:(NSString *)information {
    MBProgressHUD *hud = [self initHUDWithInformation:information mode:MBProgressHUDModeCustomView];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",pngName]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imgView;
}

+ (void)showHUDWithInformation:(NSString *)information
                       hudMode:(MBProgressHUDMode)mode {
    [self initHUDWithInformation:information mode:mode];
}

+ (void)showHUDWithDuration:(NSTimeInterval)duration
                    gifName:(NSString *)gifName
                information:(NSString *)information {
    MBProgressHUD *hud = [self initHUDWithInformation:information mode:MBProgressHUDModeCustomView];
    UIImage *image = [UIImage sd_animatedGIFNamed:gifName];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imgView;
    [hud hide:YES afterDelay:duration];
}

+ (void)showHUDWithDuration:(NSTimeInterval)duration
                    pngName:(NSString *)pngName
                information:(NSString *)information {
    MBProgressHUD *hud = [self initHUDWithInformation:information mode:MBProgressHUDModeCustomView];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",pngName]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imgView;
//    [hud hideAnimated:YES afterDelay:duration];
    [hud hide:YES afterDelay:duration];
}

+ (void)showHUDWithDuration:(NSTimeInterval)duration
                information:(NSString *)information
                    hudMode:(MBProgressHUDMode)mode {
    MBProgressHUD *hud = [self initHUDWithInformation:information mode:mode];
    [hud hide:YES afterDelay:duration];
}

+ (void)hideHUD {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
}

+ (MBProgressHUD *)initHUDWithInformation:(NSString *)information
                                     mode:(MBProgressHUDMode)mode {
    MBProgressHUD *presentHUD = [self HUDForView:[UIApplication sharedApplication].keyWindow];
    if (presentHUD != nil) {
        return nil;
    }
    
    MBProgressHUD *hud = [self showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    hud.backgroundColor = [UIColor colorWithRed:(0 / 255.0)  green:(0 / 255.0) blue:(0 / 255.0) alpha:(0.2)];
//    hud.backgroundView.alpha = 0.0;
    hud.mode = mode;
    hud.labelText = information;
    return hud;
}

+ (void)showHUD:(NSString *)title {
    MBProgressHUD *hud = [self initHUDWithInformation:title mode:MBProgressHUDModeIndeterminate];


//   MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//     hud.backgroundColor = [UIColor colorWithRed:(0 / 255.0)  green:(0 / 255.0) blue:(0 / 255.0) alpha:(0.2)];
//    
//   hud.labelText = title;

}
@end
