//
//  Student.h
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/29.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Book;
@interface Student : NSObject
@property (nonatomic, strong) Book *book;
- (void)test;
+ (void)testClassMethod;
- (void)testInstanceMethod;

+ (void)testClassMethod:(NSString *)param;
- (void)testInstanceMethod:(NSString *)param;

+ (void)testClassMethod:(NSString *)param other:(CGFloat)other;
- (void)testInstanceMethod:(NSString *)param other:(CGFloat)other;
@end
