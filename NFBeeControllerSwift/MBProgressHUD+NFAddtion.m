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

+ (instancetype)appearance{
    static dispatch_once_t onceToken;
    static MBProgressHUD* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[MBProgressHUD alloc]init];
        instance.contentColor = [UIColor whiteColor];
        instance.label.font = [UIFont systemFontOfSize:16];
        instance.removeFromSuperViewOnHide = YES;
        instance.bezelView.color = [UIColor blackColor];
        instance.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        instance.bezelView.layer.cornerRadius = 10;
    });
    return instance;
}

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
 *  创建一个定制的hud
 *
 *  @param text
 *  @param view
 *
 *  @return
 */
+ (instancetype)loadingHud:(NSString *)text view:(UIView *)view {
    if (view == nil) {
        return nil;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    hud.label.text = text;
    hud.label.font = [MBProgressHUD appearance].label.font;
    hud.bezelView.color = [MBProgressHUD appearance].bezelView.color;
    hud.bezelView.style = [MBProgressHUD appearance].bezelView.style;
    hud.bezelView.layer.cornerRadius = [MBProgressHUD appearance].bezelView.layer.cornerRadius;
    hud.removeFromSuperViewOnHide = [MBProgressHUD appearance].removeFromSuperViewOnHide;
    hud.contentColor = [MBProgressHUD appearance].contentColor;
    [view addSubview:hud];
    
    return hud;
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
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.font = [MBProgressHUD appearance].label.font;
    hud.bezelView.color = [MBProgressHUD appearance].bezelView.color;
    hud.bezelView.style = [MBProgressHUD appearance].bezelView.style;
    hud.bezelView.layer.cornerRadius = [MBProgressHUD appearance].bezelView.layer.cornerRadius;
    hud.removeFromSuperViewOnHide = [MBProgressHUD appearance].removeFromSuperViewOnHide;
    hud.contentColor = [MBProgressHUD appearance].contentColor;
    hud.userInteractionEnabled = NO;
    
    if (icon.length) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:icon]];
    }
    
    [hud hideAnimated:true afterDelay:3.0];
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
    [self show:success icon:@"success" view:view];
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
    [self show:error icon:@"error" view:view];
}

/**
 *  显示错误信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (void)showMessage:(NSString *)message
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
+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"Message here!", @"HUD message title");
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [hud hideAnimated:YES afterDelay:3.f];
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
