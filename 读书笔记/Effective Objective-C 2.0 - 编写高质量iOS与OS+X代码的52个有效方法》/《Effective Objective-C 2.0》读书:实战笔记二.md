<p align='center'>
<img src='http://p95ytk0ix.bkt.clouddn.com/2018-07-31-8726ab1532ca52746711381b07cc9971.jpg'>
</p>


##《Effective Objective-C 2.0》读书/实战笔记 二

### 第3章：接口与API设计
#### 🇪🇪 第15条：用前缀避免命名空间冲突
* 选择与你的公司，应用程序或两者皆有关联之名称作为类名的前缀，并在所有代码中均使用这一前缀
* 若自己所开发的程序库中用到了第三方库，则应为其中的名称加上前缀

顾名思义就是说在自己开发的类需要加前缀，iOS~~程序员~~开发工程师普遍使用双字母的前缀，就像我在开发时习惯加前缀 `XW`,其实，这是不科学的，因为苹果爸爸公司保留使用所有“两字母前缀”的权利，所以自己的前缀应该是三个字母的，不仅仅是类名，还有分类、全局变量...


#### 🇦🇩 第16条：提供“全能初始化方法”
* 在类中提供一个全能初始化方法，并于文档里指明。其他初始化方法均应调用此方法。
* 若全能初始化方法与超类不同，则需覆写超类中对应的方法
* 如果超类的初始化方法不适应于子类，那么应该覆写这个超类方法，并在其中抛出异常

举一个生动形象的例子：
Chinese 类

```objective-c
//.h
//  中国人
#import <Foundation/Foundation.h>
@interface Chinese : NSObject
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

//.m
#import "Chinese.h"
@interface Chinese()
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSUInteger age;
@end
@implementation Chinese
/// 全能初始化函数-只有全能初始化函数才能进行赋值操作
- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age {
    if (self = [super init]) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.age = age;
    }
    return self;
}
+ (instancetype)chineseWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age {
    Chinese *people = [[self alloc] initWithFirstName:firstName lastName:lastName age:age];
    return people;
}
- (instancetype)init {
    return [self initWithFirstName:@"龙的" lastName:@"传人" age:1]; // 调用指定初始化函数赋予其默认值
}
+ (instancetype)chineseWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    return [self chineseWithFirstName:firstName lastName:lastName age:1];
}
@end
```

Student 类继承自 Chinese

```objective-c
//.h
//  中国学生
#import "Chinese.h"
@interface Student : Chinese
@property (nonatomic, strong, readonly) NSArray *homework;
/// 指定初始化函数-需直接调用父类初始化函数
- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age homework:(NSArray *)homework;
/// 指定初始化类方法
+ (instancetype)studentWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age homework:(NSArray *)homework;
/// 其他初始化方法
+ (instancetype)studentWithHomework:(NSArray *)homework;
@end

//.m
#import "Chinese.h"
@implementation Student {
    NSMutableArray *p_homework;
}
/// 子类重写父类全能初始化函数-更改默认值!
- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age {
    return [self initWithFirstName:firstName lastName:lastName age:age homework:@[]];
}
/// 指定初始化函数-需直接调用父类初始化函数
- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age homework:(NSArray *)homework {
    if (self = [super initWithFirstName:firstName lastName:lastName age:age]) {
        p_homework = homework.copy;
    }
    return self;
}
/// 指定初始化类方法
+ (instancetype)studentWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age homework:(NSArray *)homework {
    return [[self alloc] initWithFirstName:firstName lastName:lastName age:age homework:homework];
}
/// 重写系统初始化方法
- (instancetype)init {
    return [self initWithFirstName:@"祖国的" lastName:@"花朵" age:6 homework:@[]];
}
/// 其他初始化方法
+ (instancetype)studentWithHomework:(NSArray *)homework {
    return [self studentWithHomework:homework];
}
@end
```

#### 🇦🇴 第17条：实现 `description` 方法

