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
        p_homework = homework.mutableCopy;
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
* 实现 `description` 方法返回一个有意义的字符串，用以描述该实例
* 若想在调试时打印出更详尽的对象描述信息。则应实现 `debugDescription` 方法

若直接打印自定义对象，控制台仅仅是显示该对象的地址，不会显示对象的具体细节，在程序开发中对象指针的地址或许有用，但大多数情况下，我们需要得知对象内部的具体细节，所以OC提供了 `description` 方法可以实现。

```objective-c
@interface Chinese()
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSUInteger age;
@end
@implementation Chinese
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %p, %@>",[self class],self,
            @{
              @"firstName":_firstName,
              @"lastName" :_lastName,
              @"age": @(_age)
              }];
}
@end
```
这种使用字典输出各属性或成员变量内存的方式比较好，若之后需要增删属性直接修改字典的键值对就可以了。
另外 `debugDescription` 方法是在控制台使用 `po` 命令打印对象信息所调用的方式，若已经实现 `description` 方法, 可不覆写 `debugDescription` 方法,因为系统会默认调用 `description` 方法。

#### 🇦🇮 第18条：尽量使用不可变对象
* 尽量创建不可变对象
* 若某属性尽可用于对象内部修改，则在 “class-continuation分类” 中将其由readonly属性扩展为readwrite属性
* 不要把可变对象的collection作为属性公开，而应提供相关方法，以此修改对象中的可变 collection

 在开发自定义类时，在 .h 里声明的属性尽量设置为不可变，只读的属性，外界只能通过特定的方法更改其内容，这对于一个功能的封装性是至关重要的。例如我们之前所声明的 `Student` 类:
 
```objective-c
// .h
@interface Student : Chinese
@property (nonatomic, copy, readonly) NSString *school;
@property (nonatomic, strong, readonly) NSArray *homework;

- (void)addHomeworkMethod:(NSString *)homework;
- (void)removeHomeworkMethod:(NSString *)homework;
@end

// .m
@interface Student()
@property (nonatomic, copy) NSString *school;
@end
@implementation Student {
    NSMutableArray *p_homework;
}
- (void)addHomeworkMethod:(NSString *)homework {
    [p_homework addObject:homework];
}
- (void)removeHomeworkMethod:(NSString *)homework {
    [p_homework removeObject:homework];
}
- (instancetype)initWithSchool:(NSString *)school homework:(NSArray *)homework {
    if (self = [self init]) {
        self.school = school;
        p_homework = homework.mutableCopy;
    }
    return self;
}
@end
```
如此定义外界只能通过固定的方法对对象内的属性进行更新，便于功能的封装，减少 bug 出现的概率。
另外使用不可变对象也增强程序的执行效率。


#### 🇦🇬 第19条：使用清晰而协调的命名方式



