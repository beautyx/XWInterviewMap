//
//  Chinese.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/29.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "Chinese.h"

@implementation Chinese
+ (void)testClassMethod {
    NSLog(@"Chinese 的 类方法 testClassMethod");
}

- (void)testInstanceMethod {
    NSLog(@"Chinese 的 实例方法 testClassMethod");
}

+ (void)testClassMethod:(NSString *)param {
    NSLog(@"Chinese 的 类方法 testClassMethod: 参数: %@",param);
}

- (void)testInstanceMethod:(NSString *)param {
    NSLog(@"Chinese 的 实例方法 testClassMethod: 参数: %@",param);
}
@end
