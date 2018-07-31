<p align='center'>
<img src='http://p95ytk0ix.bkt.clouddn.com/2018-07-31-8726ab1532ca52746711381b07cc9971.jpg'>
</p>


##《Effective Objective-C 2.0》读书/实战笔记 一

### 第1章：熟悉Objective-C
#### 🇨🇳 第1条：了解 Objective-C 语言的起源
* Objective-C 为C语言添加了面向对象的特性，是其超级。Objective-C 说那个动态绑定的消息结构，也就是说，在运行时才检查对象类型。接收一条消息之后，究竟应执行何种代码，由运行期环境而非编译器来决定。
* 理解C语言的核心概念有助于写好Objective-C程序。尤其要掌握内存模型和指针。


``` objective-c
NSString *theString = @"Hello World";
NSString *theString2 = @"Hello World";
NSLog(@"theString:%p --- theString:2%p",theString,theString2);
    
```
打印结果：

```
theString:0x11bb0d158 --- theString:20x11bb0d158
```
两个变量为指向同一块内存的相同指针。此时将 `theString2` 赋值为 “Hello World !!!!”

```objective-c
theString2 = @"Hello World !!!!";
NSLog(@"theString:%p --- theString:2%p",theString,theString2);
```
打印结果：

```
theString:0x12002e158 --- theString:20x12002e198
```
此时，两者变为不同的内存地址。所以，对象的本质是指向某一块内存区域的指针，指针的存储位置取决于对象声明的区域和有无成员变量指向。若在方法内部声明的对象，内存会分配到栈中，随着栈帧弹出而被自动清理；若对象为成员变量，内存则分配在堆区，声明周期需要程序员管理。
另外在探寻对象本质的过程中发现对象的本质为声明为isa的指针，一枚指针在32位计算机占4字节，64位计算机占8字节，真正在iOS系统中，isa指针实际占用了**16字节**的内存区域，在此文中通过 `clang` 将OC代码转化为 `C++`代码探究了一个对象所占的实际内存大小，详细可参阅 [iOS底层原理探究- NSObject 内存大小](https://blog.csdn.net/qxuewei/article/details/80547278) 

#### 🇦🇫 第2条：在类的头文件中尽量少引入其他头文件
* 除非确有必要，否则不要引入头文件，一般来说，应该在某个类的头文件中使用向前声明来提及别的类，并在实现文件中引入那些类的头文件。这样做可以尽量降低类之间的耦合。
* 有时无法使用向前声明，比如要声明某个类遵循一项协议，尽量把“该类遵循某协议” 的这条声明移至“class-continuation 分类中”。如果不行的话，就把协议单独放在某一个头文件中，然后将其引入。


```objective-c
//Student.h
@class Book; //向前引用，避免在 .h 里导入其他文件
@interface Student : NSObject
@property (nonatomic, strong) BOOK *book;
@end

//student.m
#import "Book.h"
@implementation Student
- (void)readBook {
    NSLog(@"read the book name is %@",self.book);
}
@end

```

#### 🇦🇬 第3条：多用字面量语法，少用与之等价的方法
* 应该使用字面量语法来创建字符串、数值、数组、字典。与创建此类对象的常规方法相比，这么做更加简明扼要。
* 应该通过取下标操作来访问数组下标或字典中的键所对应的元素。
* 用字面量语法创建数组或字典，若值中有 nil ，则会抛出异常。因此，务必确保值里不含 nil。

##### 0️⃣ 字面数值
```objective-c
NSNumber *number = [NSNumber numberWithInteger:10086];
```
改为

```objective-c
NSNumber *number = @10086;
```

##### 1️⃣ 字面量数组
```objective-c
 NSArray *books = [NSArray arrayWithObjects:@"算法图解",@"高性能iOS应用开发",@"Effective Objective-C 2.0", nil];
 
 NSString *firstBook = [books objectAtIndex:0];
```
改为

```objective-c
NSArray *books = @[@"算法图解",@"高性能iOS应用开发",@"Effective Objective-C 2.0"];

NSString *firstBook = books[0];
```

##### 2️⃣ 字面量字典

```objective-c
NSDictionary *info1 = [NSDictionary dictionaryWithObjectsAndKeys:@"极客学伟",@"name",[NSNumber numberWithInteger:18],@"age", nil];
NSString *name1 = [info1 objectForKey:@"name"];
```
改为

```objective-c
NSDictionary *info2 = @{
                        @"name":@"极客学伟",
                        @"age":@18,
                        };
NSString *name2 = info2[@"name"];
```

##### 3️⃣ 可变数组与字典

```objective-c
[arrayM replaceObjectAtIndex:0 withObject:@"new Object"];
[dictM setObject:@19 forKey:@"age"];
```
改为

```objective-c
arrayM[0] = @"new Object";
dictM[@"age"] = @19;
```

##### 4️⃣ 局限性
###### 1、字面量语法所创建的对象必须属于 Foundation 框架，自定义类无法使用字面量语法创建。

###### 2、使用字面量语法创建的对象只能是不可变的。若希望其变为可变类型，可将其深复制一份

```objective-c
NSMutableArray *arrayM = @[@1,@"123",@"567"].mutableCopy;
```
#### 🏳️‍🌈 第4条：多用类型常量，少用 `#define` 预处理指令
* 不要用预处理指令定义常量。这样定义的常量不含类型信息，编译器只是会在编译前据此执行查找与替换操作。即使有人重新定义了常量值，编译器也不会产生警告信息⚠️，这将导致应用程序中的常量值不一致。
* 在实现文件中使用 `static const` 来定义“只在编译单元内可见的常量”。由于此类常量不在全局符号表中，所以无需为其名称加前缀。
* 在头文件中使用 `extern` 来声明全局常量，并在相关实现文件中定义其值。这种常量要出现在全局符号表中，所以名称应该加以区隔，通常用与之相关的类名做前缀。

预处理指令是代码拷贝，在编译时会将代码中所有预处理指令展开填充到代码中，减少预处理指令也会加快编译速度。

##### 私有常量

```objective-c
.m
static const NSTimeInterval kAnimationDuration = 0.3;
```

##### 全局常量

```objective-c
.h
extern NSString * const XWTestViewNoticationName;

.m
NSString * const XWTestViewNoticationName = @"XWTestViewNoticationName";
```

#### 🇩🇿 第5条：用枚举表示状态、选项、状态码
* 应该用枚举来表示状态机的状态、传递给方法的选项以及状态码等值，给这些值起个易懂的名字。
* 如果把传递给某个方法的选项表示为枚举类型，而多个选项又可以同时使用，那么就将各选项定义为2的幂，以便通过按位或操作将其组合起来。
* 用 `NS_ENUUM` 与 `NS_OPTIONS` 宏来定义枚举类型，并指明其底层数据类型。这样做可以确保枚举是用开发者所选的底层数据类型实现出来的，而不会采用编译器所选类型。
* 在处理枚举类型的`switch`语句中不要实现 `default `分支。这样的话，加入新枚举之后，编译器就会提示开发者：`switch` 语句并未处理所以枚举。


```objective-c
/// 位移枚举
typedef NS_OPTIONS(NSUInteger, XWDirection) {
    XWDirectionTop          = 0,
    XWDirectionBottom       = 1 << 0,
    XWDirectionLeft         = 1 << 1,
    XWDirectionRight        = 1 << 2,
};

/// 常量枚举
typedef NS_ENUM(NSUInteger, SexType) {
    SexTypeMale,
    SexTypeFemale,
    SexTypeUnknow,
};
```

### 第2章：对象、消息、运行时
#### 🇦🇫 第6条：理解“属性”这一概念
* 可以用 `@property` 语法来定义对象中所封装的数据。
* 通过“特质”来指定存储数据所需的正确语义。
* 在设置属性所对应的实例变量时，一定要遵从该属性所声明的语义。

使用属性编译器会自动生成实例变量和改变量的get方法和set方法。
同时可以使用 `@synthesize` 指定实例变量的名称，使用 `@dynamic` 使编译器不自动生成get方法和set方法。
属性可分为四类，分别：

##### 1.原子性
* `atomic` 原子性，系统默认。并不是线程安全，`release` 方法不受原子性约束.
* `nonatomic` 非原子性

##### 2.读写权限
* `readwrite` 可读可写，同时拥有get方法和set方法。
* `readonly` 只读，仅有 get 方法。

##### 3.内存管理语义
* `assign` 简单赋值，用于基本成员类型
* `strong` 表示“拥有关系”，设置新值时会保留新值，释放旧值，再把新值设置给当前属性。
* `weak` 表示“非拥有关系”，设置新值时既不保留新值，也不释放旧值。同 `assign` 类似，所指对象销毁时会置nil
* `unsafe_unretained` 表示一种非拥有关系，语义同 `assign`,仅适用于对象类型。当目标对象被销魂时不会自动清空。
* `copy` 表达的关系和 `strong` 类似。区别在于设置新值时不会保留新值，而是将其 拷贝 后赋值给当前属性。

##### 4.方法名
* `getter=<name>` 指定获取方法（getter）的方法名， 
如: `@property (nonatomic, getter=isOn) BOOL on;`
* `setter=<name>` 指定设置方法（setter）的方法名。

#### 🇦🇷 第7条：在对象内部尽量直接访问实例变量
* 在对象内部读取数据时，应该直接通过实例变量来读，而写入数据时，则应通过属性来写。
* 在初始化方法及 `dealloc`方法中，应该直接通过实例变量来读写数据。
* 有时会使用懒加载配置某数据，这种情况需要通过属性来读取数据。

在对象内部直接使用成员变量比使用点语法的优势在于，前者不需要经过 Objective-C 的方法派发过程，执行速度会更快，这时编译器会直接访问保存对象实例变量的那块内存。不过直接访问成员变量不会触发 `KVO`,所以使用点语法访问属性还是直接使用成员变量取决于具体行为。

#### 🇦🇪 第8条：理解“对象等同性”这一概念
* 若想监测对象的等同性，请提供 `isEqual:` 与 `hash` 方法。
* 相同对象必须具有相同的哈希码，但是两个哈希码相同的对象未必相同。
* 不要盲目地逐个监测每条属性，而是应该依照具体需求来制定检测方案。
* 编写 `hash` 方法时，应该使用计算速度快而且哈希码碰撞几率低的算法。

常规比较相等的方式 `==` 比较的是两个对象指针是否相同。
在自定义对象重写 `isEqual` 方法可使用此方式：

```objective-c
- (BOOL)isEqualToBook:(Book *)object {
    if (self == object) return YES;
    if (![_name isEqualToString:object.name]) return NO;
    if (![_author isEqualToString:object.author]) return NO;
    return YES;
}
```
在自定义对象重写 `hash` 方法可使用此方式：

```objective-c
@implementation Book
- (NSUInteger)hash {
    NSUInteger nameHash = [_name hash];
    NSUInteger authorHash = [_author hash];
    return nameHash ^ authorHash;
}
@end
```

#### 🇦🇼 第9条：以“类族模式”隐藏实现细节
* 类族模式可以把实现细节隐藏在一套简单的公共接口后面
* 系统框架中经常使用类族
* 从类族的公共抽象基类中继承子类时要当心，若有开发文档，则应先阅读

例如声明一本书作为基类，通过“类族模式“创建相关的类，对应类型的在子类中实现相关方法。如下：

```objective-c
.h
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
```

```objective-c
.m
@interface BookMath : Book
- (void)read;
@end
@implementation BookMath
- (void)read {
    NSLog(@"read The Math");
}
@end

@interface BookChinese : Book
- (void)read;
@end
@implementation BookChinese
- (void)read {
    NSLog(@"read The Chinese");
}
@end

@interface BookEnglish : Book
- (void)read;
@end
@implementation BookEnglish
- (void)read {
    NSLog(@"read The English");
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
@end
```

#### 🇴🇲 第10条：在既有类中使用关联对象存放自定义数据
* 可以通过“关联对象”机制把两个对象连起来
* 定义关联对象时可指定内存管理语义，用以模仿定义属性时所采用的“拥有关系” 与 “非拥有关系”
* 只有在其他做法不可行时才应选用关联对象，因为这种做法通常会引入难于查找的 bug

关联对象的语法：

```objective-c
#import <objc/runtime.h>

// Setter 方法
void objc_setAssociatedObject(id  _Nonnull object, const void * _Nonnull key, id  _Nullable value, objc_AssociationPolicy policy)
    
// Getter 方法
id objc_getAssociatedObject(id  _Nonnull object, const void * _Nonnull key)
    
// 移除指定对象的所有关联对象值
void objc_removeAssociatedObjects(id  _Nonnull object)
```

实例一：使用关联对象将声明和执行进行 聚合
原写法

```objective-c
- (void)testAlertAssociate {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"要培养哪种生活习惯?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"早起",@"早睡", nil];
    [alertView show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"你要早起");
    }else if (buttonIndex == 2) {
        NSLog(@"你要晚睡");
    }else{
        NSLog(@"取消");
    }
}
```
使用 “关联对象改写” 改写为：

```objective-c
static void *kAlertViewKey = "kAlertViewKey";
- (void)testAlertAssociate {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"要培养哪种生活习惯?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"早起",@"早睡", nil];
    [alertView show];
    void(^AlertBlock)(NSUInteger) = ^(NSUInteger buttonIndex){
        if (buttonIndex == 1) {
            NSLog(@"你要早起");
        }else if (buttonIndex == 2) {
            NSLog(@"你要早睡");
        }else{
            NSLog(@"取消");
        }
    };
    objc_setAssociatedObject(alertView, kAlertViewKey, AlertBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void(^AlertBlock)(NSUInteger) = objc_getAssociatedObject(alertView, kAlertViewKey);
    AlertBlock(buttonIndex);
}
```
如此可将实现和声明在一起处理，在回调处取出所关联的代码块执行。可使得代码更易读。

实例二：为分类添加属性
众所周知，在 Objective-C 的分类中声明属性只能自动生成该属性的 getter 方法和 setter 方法 的声明，没有具体实现。所以真正给分类添加属性，使用关联对象是比较好的一种方式。


```objective-c
//NSTimer+XW.h
@interface NSTimer (XW)
@property (nonatomic, assign) NSUInteger tag;
@end

//NSTimer+XW.m
#import "NSTimer+XW.h"
#import <objc/runtime.h>
@implementation NSTimer (XW)
static void *kXW_NSTimerTagKey = "kXW_NSTimerTagKey";
#pragma mark - tag / getter setter
/// setter
- (void)setTag:(NSUInteger)tag {
    NSNumber *tagValue = [NSNumber numberWithUnsignedInteger:tag];
    objc_setAssociatedObject(self, kXW_NSTimerTagKey, tagValue, OBJC_ASSOCIATION_ASSIGN);
}
/// getter
- (NSUInteger)tag {
    NSNumber *tagValue = objc_getAssociatedObject(self, kXW_NSTimerTagKey);
    return tagValue.unsignedIntegerValue;
}
@end
```

#### 🇦🇿 第11条：理解 `objc_msgSend` 的作用
* 消息由接受者、选择子及参数构成。给某对象“发送消息”也就是相当于在该对象上“调用方法”
* 发给某对象的全部消息都要有“动态消息派发系统”来处理，该系统会查出对应的方法，并执行其代码。

`objc_msgSend` 执行流程
![Snip20180731_5](http://p95ytk0ix.bkt.clouddn.com/2018-07-31-Snip20180731_5.png)
*注：上图出自 SEEMYGO MJ老师*

众所周知, OC 中方法调用的本质是发送消息 `objc_msgSend` ，其原型为：

```objective-c
/// self:消息接受者，cmd:选择子即执行方法，...:其他参数
void objc_msgSend(id self, SEL cmd, ...);
```
举个例子🌰：


```objective-c
// xx类
id returnValue = [self doSomething:@"param"];

实质为：
id returnValue = objc_msgSend(xx类, @selector(doSomething:),@"param");
```
其中OC在实现此机制的同时设计了缓存机制，每次调用一个方法会将此方法进行缓存，再次执行相同方法会提高执行效率，使其和静态绑定调用方法的速度相差不会那么悬殊。

#### 🇪🇬 第12条：理解消息转发机制
* 若对象无法响应某个选择子（seletor），则进入消息转发流程
* 通过运行期的动态方法解析功能，我们可以在需要用到某个方法时再将其加入类中
* 对象可以把其无法解读的某些选择子转交给其他对象来处理
* 经过上述两步之后，如果还是没办法处理选择子，那就启动完整的消息转发机制

消息转发的全流程：
![Snip20180731_4](http://p95ytk0ix.bkt.clouddn.com/2018-07-31-Snip20180731_4.png)

倘若调用一个没有实现的方法，控制台会抛出如下经典错误信息：
`unrecognized selector sent to instance 0xxx`

在方法调用和抛出异常中间还经历了一段鲜为人知的历程，名曰：消息转发机制。上述错误提示便是调用没实现的方法之后底层转发给 `NSObject` 的 `doedNotRecognizeSelector:`方法所抛出的。
消息转发的具体过程，首先：

##### 动态方法解析

```objective-c
/// 调用了未实现的类方法
+ (BOOL)resolveClassMethod:(SEL)sel {
    return [super resolveClassMethod:sel];
}
/// 调用了未实现的实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return [super resolveInstanceMethod:sel];
}
```
表示是否可以新增一个实例方法用以处理此方法，前提此类需要在程序中提前写好，可用Runtime 的 class_addMethod动态添加。


```objective-c
/// 调用了未实现的实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(test)) {
        /// 调用了未实现的 test 方法,动态添加一个 trendsMethod 方法,使其转发给新加的方法 trendsMethod
        
        // 参数1:添加到的类, 参数2:添加新方法在类中的名称, 参数3:新方法的具体实现 
        // 参数4:新方法的参数返回值说明,如 v@: - 无参数无返回值  i@: - 无参数返回Int  i@:@ - 一个参数返回Int
        class_addMethod(self, sel, (IMP)class_getMethodImplementation([self class], @selector(trendsMethod)), "v@:");
       
        return YES; //此处返回 YES or NO 都可以
    }
    return [super resolveInstanceMethod:sel];
}
- (void)trendsMethod {
    NSLog(@"这是动态添加的方法");
}
```

##### 备援接收者

```objective-c
/// 可将未实现的实例方法转发给其他类处理
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(testInstanceMethod)) {
        return [Chinese new]; // 消息转发给能够处理该实例方法的类的对象
    }
    return [super forwardingTargetForSelector:aSelector];
}
/// 可将未实现的类方法转发给其他类处理
+ (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(testClassMethod)) {
        return [Chinese class]; // 消息转发给能够处理该类方法的类
    }
    return [super forwardingTargetForSelector:aSelector];
}
```

##### 完整的消息转发
若上述过程都没有处理，程序会有最后一次处理机会，便是：
###### 动态转发 实例 方法

```objective-c
/// 方法签名,定义 返回值,参数
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(testInstanceMethod:)) {
        /// "v@:@"
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return [super methodSignatureForSelector:aSelector];
}
/// NSInvocation 封装了一个函数调用
//anInvocation.target  - 方法调用者
//anInvocation.selector - 方法名
//anInvocation getArgument:<#(nonnull void *)#> atIndex:<#(NSInteger)#>  - 获取第 index 个参数
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (anInvocation.selector == @selector(testInstanceMethod:)) {
        return [anInvocation invokeWithTarget:[Chinese new]];//将实现转给另外一个实现了此方法的对象进行处理
    }
    return [super forwardInvocation:anInvocation];
}
```

###### 动态转发 类 方法

```objective-c
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(testClassMethod:)) {
        /// "v@:@"
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return [super methodSignatureForSelector:aSelector];
}
+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (anInvocation.selector == @selector(testClassMethod:)) {
        return [anInvocation invokeWithTarget:[Chinese class]];//将实现转给另外一个实现了此方法的对象进行处理
    }
    return [super forwardInvocation:anInvocation];
}
```
如上方法其实在实现 `forwardingTargetForSelector` 方法进行转发就可以实现相同的功能，何必到最后这步处理呢。所以，他的功能不止于此。实际可以函数中直接对未处理方法进行实现，如下：

```objective-c
/// 方法签名,定义 返回值,参数
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(testInstanceMethod:)) {
        /// "v@:@"
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return [super methodSignatureForSelector:aSelector];
}
// 转发方法最终实现
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (anInvocation.selector == @selector(testInstanceMethod:)) {
        /// 可以在此处理, 未实现的方法
        NSLog(@"这个方法 %s Student 没有实现!!!",sel_getName(anInvocation.selector));
        id param;
        [anInvocation getArgument:&param atIndex:2];
        NSLog(@"传进来的参数为: %@  - 可以使其搞事情",param);
        return;
    }
    return [super forwardInvocation:anInvocation];
}
```

##### 消息转发的实际应用
我们可以使用消息转发的机制，使程序永远不会出现 
`unrecognized selector sent to instance 0xxx` 
这种崩溃。并在控制台输出具体信息，我们可以实现一个 `NSObject`的分类 如下：

```objective-c
#import "NSObject+XWTool.h"
@implementation NSObject (XWTool)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) {/// 已实现不做处理
        return [self methodSignatureForSelector:aSelector];
    }
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"在 %@ 类中, 调用了没有实现的实例方法: %@ ",NSStringFromClass([self class]),NSStringFromSelector(anInvocation.selector));
}
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) {/// 已实现不做处理
        return [self methodSignatureForSelector:aSelector];
    }
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}
+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"在 %@ 类中, 调用了没有实现的类方法: %@ ",NSStringFromClass([self class]),NSStringFromSelector(anInvocation.selector));
}
```

#### 🇪🇹 第13条：用“方法调配技术“调试“黑盒方法“
* 在运行期，可以向类中新增或替换选择子所对应的方法实现
* 使用另一份实现来替换原有的方法实现，这道工序叫做“方法调配”，开发者常用此技术向原有类中增加新功能
* 一般来说，只有调试程序的时候才需要在运行时修改方法实现，这种做法不宜滥用

 本质是使用 `runtime` 在运行时实现方法的替换:
 
```objective-c
/// 动态交换 m1 和 m2 两个方法的实现
method_exchangeImplementations(Method  _Nonnull m1, Method  _Nonnull m2);
```
方法的实现可通过如下方法获取：

```objective-c
/// 获取方法的实现 cls: 方法所在的对象, name: 方法名
Method class_getInstanceMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name)
```

##### 实际应用，在程序运行过程中控制台打印当前所展示的控制器信息，这在代码熟悉过程中十分有用：

```objective-c
//UIViewController+XWDebug.m
#import "UIViewController+XWDebug.h"
#import <objc/runtime.h>
@implementation UIViewController (XWDebug)
#ifdef DEBUG
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /// 交换 class 的 viewDidLoad 方法
        Method originViewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method xwViewDidLoad = class_getInstanceMethod(self, @selector(xw_viewDidLoad));
        method_exchangeImplementations(originViewDidLoad, xwViewDidLoad);
        
        /// 交换 class 的 viewDidAppear方法
        Method originViewDidAppear = class_getInstanceMethod(self, @selector(viewDidAppear:));
        Method xwViewDidAppear = class_getInstanceMethod(self, @selector(xw_viewDidAppear:));
        method_exchangeImplementations(originViewDidAppear, xwViewDidAppear);
    });
}
- (void)xw_viewDidLoad {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"*********  %@  **** viewDidload ****",self);
    });
    [self xw_viewDidLoad];
}
- (void)xw_viewDidAppear:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"*********  %@  **** viewDidAppear ****",self);
    });
    [self xw_viewDidAppear:animated];
}
#else
#endif
@end
```

#### 🇮🇪 第14条：理解“类对象”的用意
* 每个实例都有一个指向Class对象的指针，用以表名其类型，而这些 Class 对象则构成类的继承体系
* 如果对象类型无法在编译期确定，那么就应该使用类型信息查询方法来探知
* 尽量使用类型信息查询方式来确定对象类型，而不要直接比较类对象，因为某些对象可能实现了消息转发功能

判断对象是否为某个类实例：

```objective-c
- (BOOL)isMemberOfClass:(Class)aClass;
```

判断对象是否为某类或其派生类的实例：

```objective-c
- (BOOL)isKindOfClass:(Class)aClass;
```

例如判断 一个 `NSDictionary` 的实例：

```objective-c
NSMutableDictionary  *dict = @{@"key":@"value"}.mutableCopy;
BOOL example1 = [dict isMemberOfClass:[NSDictionary class]];            // NO
BOOL example2 = [dict isMemberOfClass:[NSMutableDictionary class]];     // NO
BOOL example3 = [dict isKindOfClass:[NSDictionary class]];              // YES
BOOL example4 = [dict isKindOfClass:[NSMutableDictionary class]];       // YES
BOOL example5 = [dict isKindOfClass:[NSArray class]];                   // NO
//    BOOL example6 = [dict isKindOfClass:[__NSDictionaryM class]];     // YES
```
注意，在 `[dict isMemberOfClass:[NSMutableDictionary class]]` 的判断中，实际上返回的 NO，虽然我们声明 `dict` 为 `NSMutableDictionary` 的实例，但实际上 `dict` 为 `__NSDictionaryM` 类的一个实例，在控制台可验证：

```
(lldb) po [dict isMemberOfClass:[__NSDictionaryM class]]
YES
```
 《Effective Objective-C 2.0》书中所写的实例是错误的！！
 
![Snip20180731_7](http://p95ytk0ix.bkt.clouddn.com/2018-07-31-Snip20180731_7.png)

故 尽信书不如无书，相信实际所验证的，这也启发读者在读书过程中需要尽量将实例验证一下，说不定作者在写书时也是想当然的落笔。

前两章完结，后续几天会陆续发表其余篇章的读书/实战笔记，笔者期待和众大神一起学习，共同进步。

*未完待续..*.


