//
//  Student.h
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/29.
//  Copyright © 2018 邱学伟. All rights reserved.
//  中国学生

#import "Chinese.h"
#import <UIKit/UIKit.h>

@class Book;
@interface Student : Chinese
@property (nonatomic, strong, readonly) NSArray *homework;
/// 指定初始化函数-需直接调用父类初始化函数
- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age homework:(NSArray *)homework;
/// 指定初始化类方法
+ (instancetype)studentWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age homework:(NSArray *)homework;
/// 其他初始化方法
+ (instancetype)studentWithHomework:(NSArray *)homework;


@property (nonatomic, strong) Book *book;
- (void)test;
+ (void)testClassMethod;
- (void)testInstanceMethod;

+ (void)testClassMethod:(NSString *)param;
- (void)testInstanceMethod:(NSString *)param;

+ (void)testClassMethod:(NSString *)param other:(CGFloat)other;
- (void)testInstanceMethod:(NSString *)param other:(CGFloat)other;
@end
