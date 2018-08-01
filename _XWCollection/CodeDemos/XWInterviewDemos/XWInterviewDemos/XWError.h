//
//  XWError.h
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/8/1.
//  Copyright © 2018 邱学伟. All rights reserved.
//  自定义错误类型
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, XWErrorCode) {
    XWErrorCodeUnknow       = -1, //未知错误
    XWErrorCodeTypeError    = 100,//类型错误
    XWErrorCodeNullString   = 101,//空字符串
    XWErrorCodeBadInput     = 500,//错误的输入
};
extern NSString * const XWErrorDomain;
@interface XWError : NSError
+ (instancetype)errorCode:(XWErrorCode)errorCode userInfo:(NSDictionary *)userInfo;
@end
