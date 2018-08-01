//
//  Student.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/29.
//  Copyright © 2018 邱学伟. All rights reserved.
//  学生

#import "Student.h"
#import "Book.h"
#import <objc/runtime.h>
#import "Chinese.h"

@interface Student()
@property (nonatomic, copy) NSString *school;
@end
@implementation Student {
    NSMutableArray *p_homework;
}
- (void)addHomeworkMethod:(NSString *)homework {
    [p_homework addObject:homework];
}
- (void)removeHomeworkMethod:(NSString *)homework {
    [p_homework removeObject:homework];
}
- (instancetype)initWithSchool:(NSString *)school homework:(NSArray *)homework {
    if (self = [self init]) {
        self.school = school;
        p_homework = homework.mutableCopy;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %p, %@>",[self class],self,
            @{
              @"homework":p_homework
              }];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@ : %p, %@>",[self class],self,
            @{
              @"homework":p_homework
              }];
}

/// 子类重写父类全能初始化函数-更改默认值!
- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age {
    return [self initWithFirstName:firstName lastName:lastName age:age homework:@[]];
}
/// 指定初始化函数-需直接调用父类初始化函数
- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age homework:(NSArray *)homework {
    if (self = [super initWithFirstName:firstName lastName:lastName age:age]) {
        p_homework = homework.mutableCopy;
    }
    return self;
}
/// 指定初始化类方法
+ (instancetype)studentWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age homework:(NSArray *)homework {
    return [[self alloc] initWithFirstName:firstName lastName:lastName age:age homework:homework];
}
/// 重写系统初始化方法
- (instancetype)init {
    return [self initWithFirstName:@"祖国的" lastName:@"花朵" age:6 homework:@[]];
}
/// 其他初始化方法
+ (instancetype)studentWithHomework:(NSArray *)homework {
    return [self studentWithHomework:homework];
}

- (void)readBook {
    NSLog(@"read the book name is %@",self.book);
}

/// 调用了未实现的类方法
+ (BOOL)resolveClassMethod:(SEL)sel {
    return [super resolveClassMethod:sel];
}
/// 调用了未实现的实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(test)) {
        /// 调用了未实现的 test 方法,动态添加一个 trendsMethod 方法,使其转发给新加的方法 trendsMethod
        // 参数1:添加到的类, 参数2:添加新方法在类中的名称, 参数3:新方法的具体实现 , 参数3:新方法的参数返回值说明,如 v@: - 无参数无返回值  i@: - 无参数返回Int  i@:@ - 一个参数返回Int
        class_addMethod(self, sel, (IMP)class_getMethodImplementation([self class], @selector(trendsMethod)), "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
- (void)trendsMethod {
    NSLog(@"这是动态添加的方法");
}

/// 可将未实现的实例方法转发给其他类处理
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(testInstanceMethod)) {
        return [Chinese new];
    }
    return [super forwardingTargetForSelector:aSelector];
}
/// 可将未实现的类方法转发给其他类处理
+ (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(testClassMethod)) {
        return [Chinese class];
    }
    return [super forwardingTargetForSelector:aSelector];
}

/// 动态转发 实例 方法
/// 方法签名,定义 返回值,参数
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(testInstanceMethod:)) {
        /// "v@:@"
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return [super methodSignatureForSelector:aSelector];
}
// 转发方法最终实现
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (anInvocation.selector == @selector(testInstanceMethod:)) {
        /// 可以在此处理, 未实现的方法
        NSLog(@"这个方法 %s Student 没有实现!!!",sel_getName(anInvocation.selector));
        id param;
        [anInvocation getArgument:&param atIndex:2];
        NSLog(@"传进来的参数为: %@  - 可以使其搞事情",param);
        return;
    }
    return [super forwardInvocation:anInvocation];
}
/// 动态转发 类 方法
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(testClassMethod:)) {
        /// "v@:@"
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return [super methodSignatureForSelector:aSelector];
}
/// NSInvocation 封装了一个函数调用
//anInvocation.target  - 方法调用者
//anInvocation.selector - 方法名
//anInvocation getArgument:<#(nonnull void *)#> atIndex:<#(NSInteger)#>  - 获取第 index 个参数
+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (anInvocation.selector == @selector(testClassMethod:)) {
        return [anInvocation invokeWithTarget:[Chinese class]];
    }
    return [super forwardInvocation:anInvocation];
}
@end
