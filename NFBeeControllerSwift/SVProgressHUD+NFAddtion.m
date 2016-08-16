//
//  SVProgressHUD+NFAddtion.m
//  SVProgressHUD
//
//  Created by jiangpengcheng on 26/7/16.
//
//

#import "SVProgressHUD+NFAddtion.h"
#import <objc/runtime.h>

#define nf_msg_send(sender, return_type, selector)\
    ((return_type (*)(id, SEL))[sender methodForSelector:selector])(sender, selector)

#define nf_msg_send_with_obj(sender, return_type, selector, obj)\
    ((return_type (*)(id, SEL, id))[sender methodForSelector:selector])(sender, selector, obj)\

@implementation SVProgressHUD (NFAddtion)

+ (void)load{
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(overlayView)), class_getInstanceMethod(self, @selector(nf_overlayView)));
}

+ (void)setEnableNavigationBarUserInteractions:(BOOL)enable {
    SVProgressHUD* hud = nf_msg_send(self, SVProgressHUD*, @selector(sharedView));
    [hud setEnableNavigationBarUserInteractions:enable];
}

- (BOOL)enableNavigationBarUserInteractions {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEnableNavigationBarUserInteractions:(BOOL)enableNavigationBarUserInteractions{
    objc_setAssociatedObject(self, @selector(enableNavigationBarUserInteractions), @(enableNavigationBarUserInteractions), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (enableNavigationBarUserInteractions) {
        self.offsetFromCenter = UIOffsetMake(0, -32);
    }
}

- (UIControl *)nf_overlayView{
    UIControl* overlayView = nf_msg_send(self, UIControl*, @selector(nf_overlayView));
    if (self.enableNavigationBarUserInteractions && overlayView) {
        CGRect frame = overlayView.frame;
        frame.origin.y = 64;
        frame.size.height = [[[UIApplication sharedApplication] delegate] window].bounds.size.height - 64;
        overlayView.frame = frame;
    }
    
    return overlayView;
}

@end
