//
//  NSTimer+XW.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/17.
//  Copyright © 2018年 邱学伟. All rights reserved.
//

#import "NSTimer+XW.h"
#import <objc/runtime.h>
@implementation NSTimer (XW)
static void *kXW_NSTimerTagKey = "kXW_NSTimerTagKey";
#pragma mark - tag / getter setter
/// setter
- (void)setTag:(NSUInteger)tag {
    NSNumber *tagValue = [NSNumber numberWithUnsignedInteger:tag];
    objc_setAssociatedObject(self, kXW_NSTimerTagKey, tagValue, OBJC_ASSOCIATION_ASSIGN);
}
/// getter
- (NSUInteger)tag {
    NSNumber *tagValue = objc_getAssociatedObject(self, kXW_NSTimerTagKey);
    return tagValue.unsignedIntegerValue;
}

+ (NSTimer *)xw_timerTimeInterval:(NSTimeInterval)timeInterval block:(void(^)(void))block repeats:(BOOL)repeats {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerMethod:) userInfo:block repeats:repeats];
    return timer;
}

+ (void)timerMethod:(NSTimer *)timer {
    void(^inBlock)(void) = [timer userInfo];
    if (inBlock) {
        inBlock();
    }
}
@end
