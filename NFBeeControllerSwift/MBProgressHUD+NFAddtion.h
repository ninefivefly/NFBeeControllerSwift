//
//  MBProgressHUD+NFAddtion.h
//  NFBeeControllerSwift
//
//  Created by jiangpengcheng on 16/8/16.
//  Copyright © 2016年 jiangpengcheng. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (NFAddtion)

@property(nonatomic)NSInteger activityCount;

+ (instancetype)appearance;
+ (instancetype)loadingHud:(NSString *)text view:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;

+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
