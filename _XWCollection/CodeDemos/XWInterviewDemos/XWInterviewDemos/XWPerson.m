//
//  XWPerson.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/17.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "XWPerson.h"

@interface XWPerson()
@property (nonatomic, copy) NSString *age;

@property (nonatomic, assign, readwrite) double height;
@end

@implementation XWPerson

//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//    if ([key isEqualToString:@"name"]) {
//        return NO;
//    }
//    return [super automaticallyNotifiesObserversForKey:key];
//}

//- (void)setName:(NSString *)name {
//    [self willChangeValueForKey:@"name"];
//    _name = name;
//    [self didChangeValueForKey:@"name"];
//}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@",_firstName,_lastName];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    
    if ([key isEqualToString:@"fullName"]) {
        NSArray *affectingKeys = @[@"lastName", @"firstName"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}

+ (NSSet *)keyPathsForValuesAffectingFullName {
    return [NSSet setWithObjects:@"lastName", @"firstName", nil];
}

+ (void)initialize {
    NSLog(@"%@ %s",self,__func__);
}

//+(void)load {
//    NSLog(@"%s",__func__);
//}



+ (void)log {
    NSLog(@"类方法 log");
}

- (void)log {
    NSLog(@"象方法 log");
}
@end
