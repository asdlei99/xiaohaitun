//
//  MBProgressHUD+gifHUD.h
//  HiFun
//
//  Created by hao on 16/8/8.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (gifHUD)
/**
 *  显示带gif图片的进度条(hud)
 *
 *  @param gifName     图片名称
 *  @param information 显示的文字
 */
+ (void)showHUDWithGifName:(NSString *)gifName
               information:(NSString *)information;

/**
 *  显示带png图片的进度条（hud)
 *
 *  @param pngName     图片名称
 *  @param information 显示的文字
 */
+ (void)showHUDWithPngName:(NSString *)pngName
               information:(NSString *)information;

/**
 *  显示MBProgress原生进度条（hud)
 *
 *  @param information 显示的文字
 *  @param mode        进度条样式：MBProgressHUDModeIndeterminate(转圈）、MBProgressHUDModeText（纯文字）
 */
+ (void)showHUDWithInformation:(NSString *)information
                       hudMode:(MBProgressHUDMode)mode;

/**
 *  显示带gif图片，并且出现duration时长后消失的进度条(hud)
 *
 *  @param duration    显示时长
 *  @param gifName     图片名称
 *  @param information 显示的文字
 */
+ (void)showHUDWithDuration:(NSTimeInterval)duration
                    gifName:(NSString *)gifName
                information:(NSString *)information;

/**
 *  显示带png图片，并且出现duration时长后消失的进度条(hud)
 *
 *  @param duration    显示时长
 *  @param pngName     图片名称
 *  @param information 显示的文字
 */
+ (void)showHUDWithDuration:(NSTimeInterval)duration
                    pngName:(NSString *)pngName
                information:(NSString *)information;

/**
 *  显示MBProgress原生进度条(hud),并且出现duration时长后自动消失。
 *
 *  @param duration    显示时长
 *  @param information 显示的文字
 *  @param mode        进度条样式：MBProgressHUDModeIndeterminate(转圈）、MBProgressHUDModeText（纯文字）
 */
+ (void)showHUDWithDuration:(NSTimeInterval)duration
                information:(NSString *)information
                    hudMode:(MBProgressHUDMode)mode;

/**
 *  隐藏进度条（hud)
 */
+ (void)hideHUD;

/**
 *  显示MBProgress原生进度条(hud),并且出现duration时长后自动消失。
 *
 *  @param duration    显示时长
 *  @param information 显示的文字
 *  @param mode        进度条样式：MBProgressHUDModeIndeterminate(转圈）、MBProgressHUDModeText（纯文字）
 */
+ (void)showHUDWithDuration:(NSTimeInterval)duration
                information:(NSString *)information
                    hudMode:(MBProgressHUDMode)mode;



/**
 *  hud 显示
 *
 *  @param title hud下方的文字 传 nil 的话只显示 hud
 */
+ (void)showHUD:(NSString *)title;
@end
