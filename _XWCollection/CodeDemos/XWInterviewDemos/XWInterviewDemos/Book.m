//
//  Book.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/29.
//  Copyright © 2018 邱学伟. All rights reserved.
//  书籍

#import "Book.h"

@implementation Book
- (BOOL)isEqualToBook:(Book *)object {
    if (self == object) return YES;
    if (![_name isEqualToString:object.name]) return NO;
    if (![_author isEqualToString:object.author]) return NO;
    return YES;
}
- (NSUInteger)hash {
    NSUInteger nameHash = [_name hash];
    NSUInteger authorHash = [_author hash];
    return nameHash ^ authorHash;
}
@end
