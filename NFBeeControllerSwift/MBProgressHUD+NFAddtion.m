//
//  MBProgressHUD+NFAddtion.m
//  NFBeeControllerSwift
//
//  Created by jiangpengcheng on 16/8/16.
//  Copyright © 2016年 jiangpengcheng. All rights reserved.
//

#import "MBProgressHUD+NFAddtion.h"
#import <objc/runtime.h>

@implementation MBProgressHUD (NFAddtion)

+ (void)load{
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(showAnimated:)), class_getInstanceMethod(self, @selector(nf_showAnimated:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(hideAnimated:)), class_getInstanceMethod(self, @selector(nf_hideAnimated:)));
}

- (NSInteger)activityCount{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setActivityCount:(NSInteger)activityCount{
    objc_setAssociatedObject(self, @selector(activityCount), @(activityCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)nf_showAnimated:(BOOL)animated{
    NSAssert([NSThread isMainThread], @"NFProgressHUD needs to be accessed on the main thread.");
    self.activityCount++;
    if (self.activityCount == 1) {
        [self nf_showAnimated:animated];
    }
}

- (void)nf_hideAnimated:(BOOL)animated{
    NSAssert([NSThread isMainThread], @"NFProgressHUD needs to be accessed on the main thread.");
    self.activityCount--;
    if (self.activityCount <= 0) {
        [self nf_hideAnimated:animated];
        self.activityCount = 0;
    }
}

/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.labelText = text;
//    // 设置图片
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
//    // 再设置模式
//    hud.mode = MBProgressHUDModeCustomView;
//    
//    // 隐藏时候从父控件中移除
//    hud.removeFromSuperViewOnHide = YES;
//    
//    // 1秒之后再消失
//    [hud hide:YES afterDelay:0.7];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.font = [UIFont systemFontOfSize:16];
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.layer.cornerRadius =10;
    hud.contentColor = [UIColor whiteColor];
    [hud nf_showAnimated:true];
    [hud hideAnimated:// afterDelay:<#(NSTimeInterval)#>]
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *  @param view    显示信息的视图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

/**
 *  显示错误信息
 *
 */
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 *  @param view  需要显示信息的视图
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

/**
 *  显示错误信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

/**
 *  显示一些信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

/**
 *  手动关闭MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}


@end
