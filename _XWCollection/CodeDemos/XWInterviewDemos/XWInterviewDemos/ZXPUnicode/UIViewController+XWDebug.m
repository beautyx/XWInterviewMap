//
//  UIViewController+XWDebug.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/31.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation UIViewController (XWDebug)
#ifdef DEBUG
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /// 交换 class 的 viewDidLoad 方法
        Method originViewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method xwViewDidLoad = class_getInstanceMethod(self, @selector(xw_viewDidLoad));
        method_exchangeImplementations(originViewDidLoad, xwViewDidLoad);
        
        /// 交换 class 的 viewDidAppear方法
        Method originViewDidAppear = class_getInstanceMethod(self, @selector(viewDidAppear:));
        Method xwViewDidAppear = class_getInstanceMethod(self, @selector(xw_viewDidAppear:));
        method_exchangeImplementations(originViewDidAppear, xwViewDidAppear);
    });
}
- (void)xw_viewDidLoad {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"*********  %@  **** viewDidload ****",self);
    });
    [self xw_viewDidLoad];
}
- (void)xw_viewDidAppear:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"*********  %@  **** viewDidAppear ****",self);
    });
    [self xw_viewDidAppear:animated];
}
#else
#endif
@end

/// 动态交换 m1 和 m2 两个方法的实现
//    method_exchangeImplementations(Method  _Nonnull m1, Method  _Nonnull m2);
/// 获取方法的实现 cls: 方法所在的对象, name: 方法名
//    Method class_getInstanceMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name)

