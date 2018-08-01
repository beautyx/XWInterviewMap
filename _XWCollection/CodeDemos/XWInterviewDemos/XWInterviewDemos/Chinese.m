//
//  Chinese.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/29.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "Chinese.h"
@interface Chinese() <NSCopying> {
    struct {
        unsigned int didReceiveData     : 1;    //是否实现 didReceiveData
        unsigned int didReceiveError    : 1;    //是否实现 didReceiveError
        unsigned int didRun             : 1;    //是否实现 run
    }_chineseDelegateFlags;
    
    NSString *p_girlFriend;
}
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSUInteger age;
@end
@implementation Chinese
- (void)setDelegate:(id<ChineseDelegate>)delegate {
    _delegate = delegate;
    _chineseDelegateFlags.didRun = [delegate respondsToSelector:@selector(chinese:run:)];
    _chineseDelegateFlags.didReceiveData = [delegate respondsToSelector:@selector(chinese:didReceiveData:)];
    _chineseDelegateFlags.didReceiveError = [delegate respondsToSelector:@selector(chinese:didReceiveError:)];
}

- (void)run {
    double runDistance = 0.0;
    if (_chineseDelegateFlags.didRun) {
        [self.delegate chinese:self run:runDistance];
    }
    if (self.delegate && [self respondsToSelector:@selector(chinese:run:)]) {
        [self.delegate chinese:self run:runDistance];
    }
}
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %p, %@>",[self class],self,
            @{@"firstName":_firstName,
              @"lastName" :_lastName,
              @"age": @(_age)
              }];
}

/// 全能初始化函数-只有全能初始化函数才能进行赋值操作
- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age {
    if (self = [super init]) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.age = age;
    }
    return self;
}
+ (instancetype)chineseWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age {
    Chinese *people = [[self alloc] initWithFirstName:firstName lastName:lastName age:age];
    return people;
}
- (instancetype)init {
    return [self initWithFirstName:@"龙的" lastName:@"传人" age:1]; // 调用指定初始化函数赋予其默认值
}
+ (instancetype)chineseWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    return [self chineseWithFirstName:firstName lastName:lastName age:1];
}



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
