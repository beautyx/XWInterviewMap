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
* 起名时应遵从标准的 Objective-C命名规范，这样创建出来的接口更容易为开发者所理解
* 方法名要言简意赅，从左至右读起来要像个日常用语的句子才好
* 方法名里不要使用缩略后的类型名称
* 给方法起名时的第一要务就是确保其风格与你自己的代码或所要集成的框架相符

就是说在为自己创建的属性、成员变量、方法、协议等起名要见名知意。

#### 🇦🇹 第20条：为私有方法名加前缀
* 给私有方法的名称加上前缀，这样可以很容易地将其同公共方法区分开
* 不要单用一个下划线做私有方法的前缀，因为这种做法是预留给苹果公司用的

对于一个写好的类而言，若为公开方法更改名称，则需要在外部调用此类的方法的地方同样做修改，这样比较麻烦，在类内部实现的私有方法不会有这个问题，所以为私有方法加前缀可更好的区分两者。便于后期开发。用何种前缀取决于开发者的开发习惯，不建议使用下划线开头的前缀，因为这是Apple Dad 专属的方式。作者的习惯是私有方法的前缀是 `p_` ,例如：

```objective-c
/// 这是一个私有方法
- (id)p_playAirplaneMethod {
    id xx = @"**";
    return xx;
}
```

#### 🇦🇽 第21条：理解 Objective-C 错误类型
* 只有发生了可使整个应用程序崩溃的严重错误时，才应使用异常
* 在错误不那么严重的情况下，可以指派 “委托方法” 来处理错误，也可以把错误信息放在 `NSError`对象里，经由“输出参数”返回给调用者

在项目中可以自定义一个错误类型模型：

```objective-c
//  .h
//  自定义错误类型
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, XWErrorCode) {
    XWErrorCodeUnknow       = -1, //未知错误
    XWErrorCodeTypeError    = 100,//类型错误
    XWErrorCodeNullString   = 101,//空字符串
    XWErrorCodeBadInput     = 500,//错误的输入
};
extern NSString * const XWErrorDomain;
@interface XWError : NSError
+ (instancetype)errorCode:(XWErrorCode)errorCode userInfo:(NSDictionary *)userInfo;
@end

// .m
#import "XWError.h"
@implementation XWError
NSString * const XWErrorDomain = @"XWErrorDomain";
+ (instancetype)errorCode:(XWErrorCode)errorCode userInfo:(NSDictionary *)userInfo {
    XWError *error = [[XWError alloc] initWithDomain:XWErrorDomain code:errorCode userInfo:userInfo];
    return error;
}
@end
```
在调试程序合适的回调中可传入自定义错误信息。

#### 🇦🇺 第22条：理解 `NSCopying` 协议
* 若想令自己所写的对象具有拷贝功能，则需实现 `NSCopying` 协议
* 如果自定义的对象分为可变版本和不可变版本。那么就要同时实现 `NSCopying` 协议 与 `NSMutableCopying` 协议
* 赋值对象时需决定采用浅拷贝还是深拷贝，一般情况下应该尽量执行浅拷贝
* 如果你写的对象需要深拷贝，那么可考虑新增一个专门执行深拷贝的方法

我想让我创建的 `1Student` 类具备拷贝属性，那我需要实现 `NSCopying` 协议，实现它仅有的一个 `- (id)copyWithZone:(nullable NSZone *)zone` 方法。 如下:

```objective-c
@interface Student() <NSCopying>
@end
@implementation Student {
    NSMutableArray *p_homework;
}
#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone {
    Student *stuCopy = [[Student allocWithZone:zone] initWithFirstName:self.firstName lastName:self.lastName age:self.age homework:p_homework.copy];
    return stuCopy;
}
```
如此在调用 `Student` 的 `copy` 方法便会生成一个内容相同的不同 `Student` 对象

```objective-c
Student *stu = [Student studentWithFirstName:@"小极客" lastName:@"学伟" age:6 homework:@[@"小提琴",@"篮球"]];
Student *stu2 = [stu copy];
```

若希望自定义对象拥有 深拷贝 功能，那需要实现 `NSMutableCopying` 协议，并实现其唯一的方法 
`- (id)mutableCopyWithZone:(nullable NSZone *)zone` 具体实现如下：

```objective-c
#pragma mark - NSMutableCopying
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    Student *stuMtableCopy = [[Student allocWithZone:zone] initWithFirstName:self.firstName lastName:self.lastName.mutableCopy age:self.age homework:p_homework.copy];
    return stuMtableCopy;
}
```

补充一个 Array 和 Dictionary 分别指向浅复制和深复制之后的类型列表：
##### Array
首先声明两个数组：

```objective-c
NSArray *array = @[@1,@2];
NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
```
对其进行浅拷贝和深拷贝，打印结果如下：

```objective-c
2018-08-01 11:46:32.255187+0800 XWInterviewDemos[80249:5837261] [array copy]:__NSArrayI
2018-08-01 11:46:32.255337+0800 XWInterviewDemos[80249:5837261] [array mutableCopy]:__NSArrayM
2018-08-01 11:46:32.255431+0800 XWInterviewDemos[80249:5837261] [mutableArray copy]:__NSArrayI
2018-08-01 11:46:32.255516+0800 XWInterviewDemos[80249:5837261] [mutableArray mutableCopy]:__NSArrayM
```
其中 `__NSArrayI` 为不可变数组，`__NSArrayM` 为可变数组,结论：

| 原类 | 操作 | 拷贝结果|
|:---|:---|:---|
| NSArray |浅拷贝（copy） | 不可变（__NSArrayI）|
| NSArray | 深拷贝（mutableCopy）| 可变（__NSArrayM）|
| NSMutableArray | 浅拷贝（copy） | 不可变（__NSArrayI）|
| NSMutableArray | 深拷贝（mutableCopy） | 可变（__NSArrayM）|

##### Dictionary
首先声明两个字典：

```objective-c
NSDictionary *dictionary = @{@"key":@"value"};
NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
```
对其进行浅拷贝和深拷贝，打印结果如下：

```objective-c
2018-08-01 11:57:20.810019+0800 XWInterviewDemos[80385:5844478] [dictionary copy]:__NSSingleEntryDictionaryI
2018-08-01 11:57:20.810162+0800 XWInterviewDemos[80385:5844478] [dictionary mutableCopy]:__NSDictionaryM
2018-08-01 11:57:20.810277+0800 XWInterviewDemos[80385:5844478] [mutableDictionary copy]:__NSFrozenDictionaryM
2018-08-01 11:57:20.810374+0800 XWInterviewDemos[80385:5844478] [mutableDictionary mutableCopy]:__NSDictionaryM
```
其中 `__NSSingleEntryDictionaryI` 和 `__NSFrozenDictionaryM` 为不可变字典，`__NSDictionaryM` 为可变字典,结论：

| 原类 | 操作 | 拷贝结果|
|:---|:---|:---|
| NSDictionary |浅拷贝（copy） | 不可变（__NSSingleEntryDictionaryI）|
| NSDictionary | 深拷贝（mutableCopy）| 可变（__NSDictionaryM）|
| NSMutableDictionary | 浅拷贝（copy） | 不可变（__NSFrozenDictionaryM）|
| NSMutableDictionary | 深拷贝（mutableCopy） | 可变（__NSDictionaryM）|


### 第4章：协议与分类
#### 🇲🇴 第23条：通过委托与数据源协议进行对象间通信
* 委托模式为对象提供了一套接口，使其可由此将相关事件告知其他对象
* 将委托对象应该支持的接口定义成协议，在协议中把可能需要处理的事件定义成方法
* 当某对象需要从另一个对象获取数据时，可以使用委托模式。这种情景下，该模式亦称“数据源协议”
* 若有必要，可实现有位移段的结构体，将委托对象是否能响应协议方法这一信息缓存至其中

委托与数据源协议我们在使用 UITableView 时经常用到，我们在开发时可仿照其设计模式，将需要的数据通过数据源获取；将执行操作后的事件通过代理回调；并弱引用其代理对象。

```objective-c
@class Chinese;
@protocol ChineseDelegate <NSObject>
@optional
- (void)chinese:(Chinese *)chinese run:(double)kilometre;
- (void)chinese:(Chinese *)chinese didReceiveData:(NSData *)data;
- (void)chinese:(Chinese *)chinese didReceiveError:(NSError *)error;
@end

@interface Chinese : NSObject
// 委托对象-需弱引用
@property (nonatomic, weak) id<ChineseDelegate> delegate;
@end
```

在对象跑步时，通过代理方法回调给委托对象：

```objective-c
- (void)run {
    double runDistance = 0.0;
    if (self.delegate && [self respondsToSelector:@selector(chinese:run:)]) {
        [self.delegate chinese:self run:runDistance];
    }
}
```
倘若此方法每分钟都会调用 成百上千次，每次都执行 `respondsToSelector` 方法难免会对性能有一定影响,因为除第一次有效外其余都是重复判断，所以我们可以将是否能够响应此方法进行缓存！如例所示：

```objective-c
#import "Chinese.h"
@interface Chinese() {
    /// 定义一个结构体拥有三个位段，分别存储是否实现了三个对应的代理方法
    struct {
        unsigned int didReceiveData     : 1;    //是否实现 didReceiveData
        unsigned int didReceiveError    : 1;    //是否实现 didReceiveError
        unsigned int didRun             : 1;    //是否实现 run
    }_chineseDelegateFlags;
}
@end
@implementation Chinese
/// 重写 Delegate 方法，为 位段进行赋值
- (void)setDelegate:(id<ChineseDelegate>)delegate {
    _delegate = delegate;
    _chineseDelegateFlags.didRun = [delegate respondsToSelector:@selector(chinese:run:)];
    _chineseDelegateFlags.didReceiveData = [delegate respondsToSelector:@selector(chinese:didReceiveData:)];
    _chineseDelegateFlags.didReceiveError = [delegate respondsToSelector:@selector(chinese:didReceiveError:)];
}
/// 在调用delegate 的相关协议方法不再进行方法查询，直接取结构体位段存储的内容进行调用
- (void)run {
    double runDistance = 0.0;
    if (_chineseDelegateFlags.didRun) {
        [self.delegate chinese:self run:runDistance];
    }
    ///if (self.delegate && [self respondsToSelector:@selector(chinese:run:)]) {
    ///    [self.delegate chinese:self run:runDistance];
    ///}
}
```
若代理方法可能回调多次，那此项优化将大大提升程序运行效率！

#### 🇧🇧 第24条：将类的实现代码分散到便于管理的数个分类之中
* 使用分类机制把类的实现代码划分成易于管理的小块
* 将应该视为“私有”的方法归入名叫 `Private` 的分类，可隐藏实现细节

在开发一个类一般将所有的代码都放在一起，即便都是高聚合低耦合的代码，若程序越来越大，难免也会感觉不优雅，优雅的方式是按照功能将实现抽离到不同的分类中实现，在主类中引入其分类，直接调用分类中实现的方法。这样也便于管理。
根据分类的名称，可快速定位代码所属功能区，便于扩展维护。另外可创建一个所开发类名对应的 Private 分类，存放一些私有方法。这些方法无需暴露给外界，开发者自己维护。

#### 🇵🇬 第25条：总是为第三方类的分类名称加前缀
* 向第三方类中添加分类时，总应给其名称加上你专用的前缀
* 向第三方类中添加分类时，总应给其中的方法名加上你专用的前缀

分类中所实现的方法最终会在编译时加载到本类的方法列表中，若存在相同名称的方法，后编译的分类会覆盖前编译的，所以为分类中的方法加前缀是很有必要的。

#### 🇧🇸 第26条：勿在分类中声明属性
* 把封装数据所用的全部属性都定义在主接口里
* 在 “class-continuation 分类“ 中，可以定义存取方法，但尽量不要定义属性

原本分类中声明属性仅仅是自动生成该属性 `getter` 方法和 `setter` 方法的声明，不会生成成员变量和对应属性的`getter` 方法和 `setter` 方法
虽然 可以使用 `runtime` 的关联对象的方式为分类添加属性 `getter` 方法和 `setter` 方法的实现,使得分类能够定义属性。
但是分类的本质在于扩展类的功能，而非封装数据。使用上述方式需要写大量相似的代码，并且在内存管理上容易出错，改动属性的类型需要改变关联对象的相关类型，不利于维护，代码不优雅！

#### 🇵🇰 第27条：使用 “class-continuation 分类” 隐藏实现细节
* 使用 “class-continuation 分类” 向类中新增实例变量
* 如果某属性在主接口中声明为 “只读”，而类的内部又要用设置方法修改此属性，那么就在  “class-continuation 分类” 中将其扩展为 “可读写”
* 把私有方法的原型声明在 “class-continuation 分类” 里面
* 若想使类所遵循的协议不为人所知，则可于  “class-continuation 分类”  中声明

例如：

```objective-c
// .h  对外声明为只读，防止外界随意修改
@interface Chinese : NSObject
@property (nonatomic, weak) id<ChineseDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *firstName;
@property (nonatomic, copy, readonly) NSString *lastName;
@end

// .m 对内声明为可读写。使用扩展声明一些外界不得而知的私有成员变量
@interface Chinese() <NSCopying> {
    struct {
        unsigned int didReceiveData     : 1;    //是否实现 didReceiveData
        unsigned int didReceiveError    : 1;    //是否实现 didReceiveError
        unsigned int didRun             : 1;    //是否实现 run
    }_chineseDelegateFlags;
    
    NSString *p_girlFriend; 
}
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSUInteger age;
@end
```
或者在 “class-continuation 分类” 里面声明 C++ 对象，这样 .m 编译为 .mm 文件，对外界暴露依然是纯正的 OC 接口，在 Foundation 框架中,经常使用此策略。

#### 🇵🇾 第28条：通过协议提供匿名对象
* 协议可在某种程度上提供匿名类型。具体的对象类型可以淡化成遵从某协议的id类型，协议里规定了对象所应实现的方法
* 使用匿名对象来隐藏类型名称（或类名）
* 如果具体类型不重要，重要的是对象能够响应（定义在协议里的）方法，那么可使用匿名对象来表示



### 第5章：内存管理
#### 🇵🇸 第29条：理解引用计数
* 引用计数机制通过可以递增递减的计数器来管理内存。对象创建好之后，其保留技术至少为1。若保留计数为正，则对象继续存活。当保留计数降为0时，对象就被销魂了。
* 在对象生命期中，其余对象通过引用来保留或释放此对象。保留与释放操作分别会递增及递减保留计数

何为引用计数，用一张图表示便是：

![Snip20180801_8](http://p95ytk0ix.bkt.clouddn.com/2018-08-01-Snip20180801_8.png)
*图转自 《Objective-C高级编程+iOS与OS+X多线程和内存管理》图1.3*

看完此图差不多已经理解引用计数了，OK，本条完结。。。

另外，补充一个概念-**自动释放池** 
使用自动释放池可使对象的生命周期跨越 “方法调用边界”后存活到 runloop 的下一次事件循环。

#### 🇧🇭 第30条：以 ARC 简化引用计数
* 有ARC之后，程序员就无须担心内存管理问题了，使用ARC来编程，可省去类中的许多 “样板代码”
* ARC 管理对象生命周期的办法基本上就是：在合适的地方插入“保留”及“释放”操作。在ARC环境下，变量的内存管理语义可以通过修饰符指明，则原来则需要手工执行“保留”及“释放”操作
* 由方法返回的对象，其内存管理语义总是通过方法名来体现。ARC将此确定为开发者必须遵守的规则
* ARC只负责管理 Objective-C 对象的内存。尤其要注意：CoreFoundation 对象不归ARC 管理，开发者必须适时调用 CFRetain/CFRelease

ARC会以一种安全的方式设置：先保留新值，再释放旧值，最后设置实例变量，其中可以使用以下修饰符改变局部变量和实例变量的语义：

`__strong` 默认语义，保留此值
`__unsafe_unretained` 不保留此值，这么做可能不安全，因为等再次使用变量时，其对象可能已经回收了
`__weak` 不保留此值，但是变量可安全使用，因为如果系统把这个对象回收了，那么变量也会自动清空 - 可避免循环引用
`__autoreleasing` 把对象“按引用传递”给方法时，使用这个特殊的修饰符。此值在方法返回时自动释放

#### 🇵🇦 第31条：在 `dealloc` 方法中只释放引用并解除监听
* 在 `dealloc` 方法里，应该做的事情就是释放指向其他对象的引用，并取消原来订阅的“简直观测”（KVO）或 `NSNotificationCenter` 等通知，不要做其他事情
* 如果对象持有文件描述符等系统资源，那么应该专门编写一个方法来解释此种资源。这样的类要和其使用者约定：用完资源后必须调用 `close` 方法
* 执行异步任务的方法不应在 `dealloc` 里调用；只能在正常状态下执行的那些方法也不应在 `dealloc` 里调用，因为此时对象已处于正在回收的状态了

`dealloc` 方法是对象释放所调用的方法，此时若使用对象的成员变量可能已经被释放掉了，若使用异步回调时自身已经被释放，若回调中包含 `self` 会导致程序崩溃。

```objective-c
- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 释放需手动释放的资源
    //CFRelease(coreFoundationObject);
}
```

另外 即便对象释放，在极个别情况下并不会调用 `dealloc` 方法，程序终止时一定会调用的是在 application delegate 的 `- (void)applicationWillTerminate:(UIApplication *)application ` 方法, 若一定要清理某些对象，可在此方法中处理。

#### 🇧🇷 第32条：编写“异常安全代码”时留意内存管理问题
* 捕获异常时，一定要注意将 try 块内所创立的对象清理干净
* 在默认情况下，ARC不生成安全处理异常所需的清理代码，开启编译器标志后，可生产这种代码，不过会导致应用程序变大，而且会降低运行效率

#### 🇧🇾 第33条：以弱引用避免保留环
* 将某些引用设为 `weak`，可避免出现 “保留环”
* `weak` 引用可以自动清空，也可以不自动清空。自动清空是随着ARC而引入的新特性，由运行期系统来实现。在具备自动清空功能的弱引用上，可以随意读取其数据，因为这种引用不会指向已经回收过的对象

若两个对象互相引用，会形成保留环（循环引用），如图：
![Snip20180802_9](http://p95ytk0ix.bkt.clouddn.com/2018-08-02-Snip20180802_9.png)

保留环会引起内存泄露，对象间的互相持有导致保留环内的所有对象均无法正常释放。
避免保留环最佳方式是弱引用，通过“非拥有关系”的声明将环打破。这种关系可用 `weak` 和 `unsafe_unretained` 实现。两者的区别是 `weak` 修饰的对象在释放之后本身会置 nil， 而 `unsafe_unretained` 不会，在对象释放之后会依然指向被释放的那块内存。如图：
![Snip20180802_11](http://p95ytk0ix.bkt.clouddn.com/2018-08-02-Snip20180802_11.png)


```objective-c
@property (nonatomic, weak) id<ChineseDelegate> delegate;

 __weak typeof(self) weakSelf = self;
[NSTimer xw_timerTimeInterval:1.0 block:^{
    [weakSelf timerMethod];
} repeats:YES];
```

#### 🇧🇲 第34条：以“自动释放池块”降低内存峰值
* 自动释放池排布在栈中，对象收到 `autorelease`消息后，系统将其放入最顶端的池里。
* 合理利用自动池，可降低应用程序的内存峰值
* `@autoreleasepool` 这种新式写法能创建出更为轻便的自动释放池

主线程和GCD机制中的线程默认都会有自动释放池，无需程序员手动创建，并且系统会自动在 runloop 的执行下次时间循环时将池内对象清空。
如果在一个大的循环体中需要创建n多个对象时，使用 “自动释放池块” 可降低内存峰值，如例所示：

未做优化的方式：

```objective-c
- (void)testFor1 {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < 100000; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [arrayM addObject:str];
        NSLog(@"%@",str);
    }
}
```
此时内存使用情况：
![Snip20180802_13](http://p95ytk0ix.bkt.clouddn.com/2018-08-02-Snip20180802_13.png)
CPU使用情况：
![Snip20180802_14](http://p95ytk0ix.bkt.clouddn.com/2018-08-02-Snip20180802_14.png)

使用 “自动释放池块” 优化的方式：

```objective-c
- (void)testFor2 {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < 100000; i++) {
        @autoreleasepool {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [arrayM addObject:str];
            NSLog(@"%@",str);
        }
    }
}
```
优化后内存使用情况：
![Snip20180802_15](http://p95ytk0ix.bkt.clouddn.com/2018-08-02-Snip20180802_15.png)

优化后CPU使用情况：
![Snip20180802_16](http://p95ytk0ix.bkt.clouddn.com/2018-08-02-Snip20180802_16.png)

显而易见根据Xcode 显示**：并没有什么卵用**，此条原理上是可以降低内存占用峰值，但实际情况确实两者没有太大区别，能否起到优化的作用还需日后继续观察...

#### 🇧🇬 第35条：用“僵尸对象”调试内存管理问题
* 系统在回收对象时，可以不将其真的回收，而是把它转化为僵尸对象。通过环境变量 `NSZombieEnabled`可开启此功能
* 系统会修改对象的 `isa` 指针，令其指向特殊的僵尸类，从而使该对象变为僵尸对象。僵尸类能够响应所有的选择子，响应方式为：打印一条包含消息内容及其接受者的消息，然后终止应用程序

在Xcode 中勾选 Zombie Objects 可启用僵尸对象检测，此时给僵尸对象发送消息将会在控制台打印相关信息：
![Snip20180802_1](http://p95ytk0ix.bkt.clouddn.com/2018-08-02-Snip20180802_1.png)



#### 🇲🇵 第36条：不要使用 `retainCount`
* 对象的保留计数看似有用，实则不然，因为任何给定时间点上的“绝对保留计数”都无法反映对象生命期的全貌
* 引入 ARC 之后，`retainCount` 方法就正式废止了，在ARC下调用该方法会导致编译器报错。

在 ARC 时代下本身就不会使用 `retainCount`, 书中所讲述的几种情况仅出现在 MRC 编程环境下, 例如 `retainCount` 可能不为 0 的时候对象就会被系统释放，所以 `retainCount` 引用计数可能永远不为0，这是系统优化对象的释放行为导致的。



