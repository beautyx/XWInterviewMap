//
//  XWError.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/8/1.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "XWError.h"

@implementation XWError
NSString * const XWErrorDomain = @"XWErrorDomain";
+ (instancetype)errorCode:(XWErrorCode)errorCode userInfo:(NSDictionary *)userInfo {
    XWError *error = [[XWError alloc] initWithDomain:XWErrorDomain code:errorCode userInfo:userInfo];
    return error;
}
@end
