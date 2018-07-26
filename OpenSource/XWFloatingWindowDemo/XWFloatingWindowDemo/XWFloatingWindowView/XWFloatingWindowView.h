//
//  XWFloatingWindowView.h
//  XWFloatingWindowDemo
//
//  Created by 邱学伟 on 2018/7/22.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWFloatingWindowView : UIView

/**
 展示浮窗
 */
+ (void)showWithViewController:(UIViewController *)viewController;

/**
 是否正在展示浮窗

 @return 是/否 在展示浮窗
 */
+ (BOOL)isShowing;
@end
