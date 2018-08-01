//
//  Chinese.h
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/29.
//  Copyright © 2018 邱学伟. All rights reserved.
//  中国人
#import <Foundation/Foundation.h>

@class Chinese;
@protocol ChineseDelegate <NSObject>
@optional
- (void)chinese:(Chinese *)chinese run:(double)kilometre;
- (void)chinese:(Chinese *)chinese didReceiveData:(NSData *)data;
- (void)chinese:(Chinese *)chinese didReceiveError:(NSError *)error;
@end

@interface Chinese : NSObject
@property (nonatomic, weak) id<ChineseDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *firstName;
@property (nonatomic, copy, readonly) NSString *lastName;
@property (nonatomic, assign, readonly) NSUInteger age;
/// 全能初始化对象方法
- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age;
/// 全能初始化类方法
+ (instancetype)chineseWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age;
/// 其他初始化对象方法
+ (instancetype)chineseWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
@end
