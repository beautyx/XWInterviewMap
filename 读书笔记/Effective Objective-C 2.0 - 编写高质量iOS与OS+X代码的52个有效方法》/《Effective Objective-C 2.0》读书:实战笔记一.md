##《Effective Objective-C 2.0》读书/实战笔记一

### 第一章：熟悉Objective-C
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

