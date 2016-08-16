//
//  SVProgressHUD+NFAddtion.h
//  SVProgressHUD
//
//  Created by jiangpengcheng on 26/7/16.
//
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (NFAddtion)

/**
 *  默认NO，如果设置成YES，导航栏的用户交互不会被关闭
 *  注意：该方法是不安全的做法，请结合源码阅读
 */
+ (void)setEnableNavigationBarUserInteractions:(BOOL)enable;

@end
