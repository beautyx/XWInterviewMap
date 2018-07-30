//
//  Book.h
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/29.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BookType) {
    BookTypeMath,
    BookTypeChinese,
    BookTypeEnglish,
};
@interface Book : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *author;
+ (instancetype)bookWithType:(BookType)type;
- (void)read;
@end
