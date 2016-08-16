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


@end
