//
//  XWPerson.h
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/17.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWPerson : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign, readonly) double height;

@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

+ (void)log;

- (void)log;
@end
