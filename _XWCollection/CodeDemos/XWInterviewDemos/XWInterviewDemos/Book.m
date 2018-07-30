//
//  Book.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/29.
//  Copyright © 2018 邱学伟. All rights reserved.
//  书籍

#import "Book.h"

@interface BookMath : Book
- (void)read;
@end
@implementation BookMath
- (void)read {
    NSLog(@"read Math");
}
@end

@interface BookChinese : Book
- (void)read;
@end
@implementation BookChinese
- (void)read {
    NSLog(@"read Chines");
}
@end

@interface BookEnglish : Book
- (void)read;
@end
@implementation BookEnglish
- (void)read {
    NSLog(@"read English");
}
@end

@implementation Book

+ (instancetype)bookWithType:(BookType)type {
    switch (type) {
        case BookTypeMath:
            return [BookMath new];
            break;
        case BookTypeChinese:
            return [BookChinese new];
            break;
        case BookTypeEnglish:
            return [BookEnglish new];
            break;
    }
}

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
