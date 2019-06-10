---
title: 《Effective Objective-C 2.0》读书/实战笔记 三  
date: 2018-08-10 
categories: [读书笔记]
tags: [读书笔记,iOS,Objective-C]
---

<!-- more -->

##《Effective Objective-C 2.0》读书/实战笔记 三


##### [《Effective Objective-C 2.0》读书/实战笔记 一](https://juejin.im/post/5b60709fe51d45179b0ad208)
##### [《Effective Objective-C 2.0》读书/实战笔记 二](https://juejin.im/post/5b6629c5f265da0f7f44c38b)

### 第6章：块与大中枢派发
#### 🇧🇯 第37条：理解“块”这一概念
* 块 是C、C++、Objective-C 中的语法闭包
* 块 可接受参数，也可返回值
* 块 可以分配在栈或堆上，也可以是全局的。分配在栈上的块可拷贝到堆里，这样的话，就和标准 Objective-C 对象一样，具备引用计数了。

声明一个返回值为 Int 的block

```objective-c
int(^BlockIntType)(void) = ^ {
    NSLog(@"返回 10010");
    return 10010;
};
```
block 声明的语法为
`return_type (^block_name)(parameters)`

Block 内部引用外部变量涉及到一个变量捕获的概念，若捕获基本数据类型在Block 内部会进行值拷贝，若捕获对象类型 内部会进行指针拷贝,不会拷贝其内存地址, 无法对外部变量进行修改，若希望修改外部变量，则需声明为 `block` 类型，在Block 内部会创建 `__Block_byref_obj_0` 和 `__main_block_impl_0` 两个结构体，会将外部变量copy到堆区并指向外部变量内存地址，可直接对外部变量进行修改。详细关于 Block 的解析可参见：[iOS底层原理 - Block本质探究](https://blog.csdn.net/qxuewei/article/details/80854273)

block 内存布局：
![Snip20180808_1](http://p95ytk0ix.bkt.clouddn.com/2018-08-08-Snip20180808_1.png)

Block 的分类：

|Block 类型|条件|存储域|执行Copy后效果|
|:----|:----|:----|:----|
|NSGlobalBlock （全局Block）|Block 内部没有引用其他外部变量|数据区|无任何变化|
|NSStackBlock（栈Block）|Block 内部访问了 auto变量|栈区|从栈复制到堆|
|NSMallocBlock （堆Block）|NSStackBlock 调用了copy|堆区|其引用计数加1|

#### 🇧🇪 第38条：为常用的块类型创建typedef
* 以 typedef 重新定义块类型，可令块类型变量用起来更加简单
* 定义新类型时应遵从现有的命名习惯，勿使其名称与别的类型相冲突
* 不妨为同一个块签名定义多个类型别名。如果要重构的代码使用了块类型的某个别名，那么只需修改相应typedef中的块签名即可，无须改动其他 typedef


```objective-c
int (^XWTestBlock)(int first,int second) = ^ (int first,int second) {
    return first + second;
};
```
使用 `typedef` 创建Block , 可将Block作为类型声明，使代码可读性更强，形如：

```objective-c
typedef int(^XWTestBlock2)(int,int);
XWTestBlock2 block = ^(int first,int second) {
    return first + second;
};
```

#### 🇵🇪 第39条：用 handler 块降低代码分散程度
* 在创建对象时，可以使用内联的 handler 块将相关业务逻辑一并声明
* 在有多个实例需要监控时，如果使用委托模式，那么经常需要根据传入的对象来切换，而若改用 handler 块，那么可以增加一个参数，使调用者可通过此参数决定应该把块安排在哪个队列上执行

很多情况下，在一个功能类的回调使用 block 比使用 delegate 会让代码看起来更简洁，API更友好。如：

```objective-c
/**
 Empties the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)removeAllObjectsWithBlock:(void(^)(void))block;

/**
 Empties the cache with block.
 This method returns immediately and executes the clear operation with block in background.
 
 @warning You should not send message to this instance in these blocks.
 @param progress This block will be invoked during removing, pass nil to ignore.
 @param end      This block will be invoked at the end, pass nil to ignore.
 */
- (void)removeAllObjectsWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                                 endBlock:(nullable void(^)(BOOL error))end
```

#### 🇮🇸 第40条：用块引用其所属对象时不要出现保留环
* 如果块所捕获的对象直接或间接保留了块本身，那么就得当心保留环问题。
* 一定要找个适当的时机解除保留环，而不能把责任推给API的调用者

保留环即我们常说的循环引用，在Block内部若需要捕获自己的持有者，如果不对其弱引用将会造成循环引用，使对象无法释放。
例如弱引用当前控制器的方式：

`__weak __typeof(&*self) weakSelf = self;`

推荐一个笔者常用的一个宏定义：

```objective-c
/// 弱引用当前控制器
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
```

还有一种情况是在Block内部引用了当前持有者所强引用的对象也会造成循环引用，这时在使用完毕之后手动将其置 nil 。也可以避免循环引用。

#### 🇵🇷 第41条：多用派发队列，少用同步锁
* 派发队列可用来表述同步语义，这种做法要比使用 `@synchronized ()` 块或 `NSLock` 对象更简单
* 将同步与异步派发结合起来，可以实现与普通加锁机制一样的同步行为，而这么做却不会阻塞执行异步派发的线程
* 使用同步队列及栅栏块，可以令同步行为更加高效

若两个线程同时执行同一份代码可能会出现问题，这时使用同步锁可以避免，如：

```objective-c
@synchronized (self) {
    NSLog(@"极客学伟");
}
```

再如：

```objective-c
NSLock *lock = [[NSLock alloc] init];
[lock lock];
NSLog(@"极客学伟");
[lock unlock];
```
 也可以使用栅栏函数，将属性的 `getter` 可同步获取，  对 `setter` 方法进行加锁操作，如：
 
```objective-c
NSUInteger _age;
dispatch_queue_t _queue;

- (void)setAge:(NSUInteger)age {
    dispatch_barrier_async(_queue, ^{
        self->_age = age;
    });
}

- (NSUInteger)age {
    __block NSUInteger outPutAge;
    dispatch_sync(_queue, ^{
        outPutAge = self->_age;
    });
    return outPutAge;
}
```
此时程序的执行顺序是：
![Snip20180810_1](http://p95ytk0ix.bkt.clouddn.com/2018-08-10-Snip20180810_1.png)

使用何种方案也要取决于当前的业务场景

#### 🇵🇱 第42条：多用 `GCD`，少用 `performSelector` 系列方法
* `performSelector` 系列方法在内存管理方面容易有疏失。它无法确定将要执行的选择子具体是什么，因而 ARC 编译器也就无法插入适当的内存管理方法
* `performSelector` 系列方法所能吃力的选择子太过局限，选择子的返回值类型及发送给方法的参数个数都受到限制。
* 如果想把任务放在另一个线程上执行，那么最好不要用 `performSelector`  系列方法，而是应该把任务封装到块里，然后调用 `GCD` 派发机制的相关方法来实现

#### 🇧🇦 第43条：掌握 `GCD` 及操作队列的使用时机
* 在解决多线程与任务管理问题时，派发队列并非唯一方案
* 操作队列提供了一套高层的 Objective-C API , 能实现纯 GCD 所具备的绝大部分功能，而且还能完成一些更为复杂的操作，那些操作若改用 GCD 来实现，则需另外编写代码

实现多线程编程除 GCD 以外还有一个很方便的技术便是 `NSOperationQueue` , GCD 是底层C语言的API, `NSOperationQueue` 是 Objective-C 的对象，是对于 GCD 的封装，在很多场景使用 `NSOperationQueue` 会使代码易读性更高。使用`NSOperationQueue`的一些优势：
1. 轻易取消某个操作，不过已经启动的操作无法取消。将操作添加到 GCD 是无法取消的。
2. 指定操作间的依赖关系。

```objective-c
NSOperationQueue *quque = [[NSOperationQueue alloc] init];
    NSBlockOperation *downloadOperation = [NSBlockOperation blockOperationWithBlock:^{
        sleep(3);
        NSLog(@"下载某资源文件 %@",[NSThread currentThread]);
    }];
    NSBlockOperation *showInUIOperation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"在 UI 进行展示 %@",[NSThread currentThread]);
        }];
    }];
    
    [showInUIOperation addDependency:downloadOperation];
    
    [quque addOperation:downloadOperation];
    [quque addOperation:showInUIOperation];
```
3. 通过 KVO 监听 NSOperation 对象的属性。例如：`isCancelled`,`isFinished`
4. 指定操作的优先级，`queuePriority`
5. 重用 `NSOperation` 对象。系统为我们提供了两种 `NSOperation` 对象的子类，`NSBlockOperation` 和 `NSInvocationOperation`, 针对不同业务也可以自己进行重用。
 
#### 🇧🇴 第44条：通过 `Dispatch Group` 机制，根据系统资源状况来执行任务
* 一系列任务可归入一个 `dispatch group` 之中，开发者可以在这组任务执行完毕时获得通知
* 通过 `dispatch group` ， 可以在并发式派发队列里同时执行多项任务，此时 GCD 会根据系统资源状况来调度这些并发执行的任务。开发者开发者若自己来实现此功能，则需要编写大量代码。

```objective-c
- (void)testGCDGroup {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.qiuxuewei.q", DISPATCH_QUEUE_CONCURRENT);//并行
    dispatch_group_async(group, queue, ^{
        for (NSUInteger i = 0; i < 10; i++) {
            sleep(0.5);
            NSLog(@"线程: %@ +++  i:%zd",[NSThread currentThread], i);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (NSUInteger j = 0; j < 15; j++) {
            sleep(0.5);
            NSLog(@"线程: %@ +++  j:%zd",[NSThread currentThread], j);
        }
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"线程: %@ +++  dispatch_group_notify",[NSThread currentThread]);
    });
}
```
补充：使用 `dispatch_apply` 实现快速遍历

```objective-c
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_apply(10000, queue, ^(size_t index) {
    NSLog(@"Thread : %@   ----  %zu",[NSThread currentThread],index);
});
```

#### 🇧🇿 第45条：使用 `dispatch_once` 来执行只需运行一次的线程安全代码
* 经常需要编写 “只需执行一次的线程安全代码”。通过 GCD 所提供的 `dispatch_once` 函数，很容易就能实现此功能。
* 标记应该声明在 static 或 global 作用域中，这样的话，在把只需执行一次的块传给 dispatch_once 函数时，传进去的标记也是相同的。

```objective-c
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"once");
    });
```
扩展：若希望实现一个可销魂的单例，可把 `static dispatch_once_t onceToken;` 作为一个静态变量，在需要销魂单例的地方将 `onceToken` 置 0，再手动将单例 置nil。此时再使用单例时便会再次创建。

#### 🇧🇼 第46条：不要使用 `dispatch_get_current_queue`
* `dispatch_get_current_queue` 函数的行为常常与开发者所预期的不同。此函数已经废弃，只应做调试之用。
* 由于派发队列是按层级来组织的，所以无法单用某个队列对象来描述 “当前队列” 这一概念
* `dispatch_get_current_queue` 函数用于解决由不可重入的代码所引发的死锁，然而能用此函数解决的问题，通常也能改用“队列特定数据来解决”

记住不要使用 `dispatch_get_current_queue` 这个函数打印当前队列就可以了，因为不准！原因有可能当前队列也同时处在另外一个队列的并非中。

### 第7章：系统框架
#### 🇧🇹 第47条：熟悉系统框架
* 许多系统框架都可以直接使用，其中最重要的是 `Foundation` 与 `CoreFoundation` , 这两个框架提供了构建应用程序所需的许多核心功能
* 很多常见任务都能用框架来做，例如音频与视频处理，网络通信、数据管理等
* 请记住：用纯 C 写成的框架与用 Objective-C 写成的一样重要，若想成为优秀的 Objective-C 开发者，应该掌握 C 语言的核心概念

列举常用的几种系统库：

* CFNetwork : 提供 C 语言级别的网络通信能力
* CoreAudo : 提供 C 语言级别的API来操作设备上的音频硬件
* CoreData : 操作 SQLite 数据库
* CoreText : 高效执行文字排版和渲染

直接使用上述框架无法使用 ARC 自动管理内存。

* CoreAnimation : Objective-C 开发的动画库
* CoreGraphics : C 语言开发的2D渲染所必备的数据结构和函数。其中定义了我们耳熟能详的 CGPoint 、CGSize 、 CGRect 等数据结构


#### 🇧🇫 第48条：多用块枚举，少用 for 循环
* 遍历 collection 有四种方法。最基本的方式是 `for 循环`，其次是 `NSEnumerator` 遍历法及快速遍历法，最新、最先进的方式是 “块枚举法”
* “块枚举法” 本身就能通过 GCD 来并发执行遍历操作，无须另行编写代码。而采用其他遍历方式则无法轻易实现这一点。
* 若提前知道待遍历的 collection 含有何种对象，则应修改块签名，指出对象的具体类型

若使用老式 For 循环遍历字典和Set, 需要创建额外数组，必然会产生额外开销

![Snip20180912_1](http://p95ytk0ix.bkt.clouddn.com/2018-09-12-Snip20180912_1.png)

OC 提供了如下几种遍历方式用以提高效率和增强易读性

##### `NSEnumerator`
其优势是可遍历 OC 中所有的集合类型，可读性更强

```objective-c
- (void)testEnumerator {
    NSArray *array = @[@1,@2,@3];
    NSDictionary *dictionary = @{
                                 @"key1":@"value1",
                                 @"key2":@"value2",
                                 @"key3":@"value3"
                                 };
    NSSet *set = [NSSet setWithObjects:@4,@5,@6, nil];
    /// array
    NSEnumerator *arrayEnumerator = [array objectEnumerator];
    id object;
    while ((object = arrayEnumerator.nextObject) != nil) {
        NSLog(@"array-%@",object);
    }
    
    /// dictionary
    NSEnumerator *dictionaryEnumerator = [dictionary keyEnumerator];
    id value,key;
    while ((key = dictionaryEnumerator.nextObject) != nil) {
        value = dictionary[key];
        NSLog(@"dictionary - key:%@  value:%@",key,value);
    }
    
    /// set
    NSEnumerator *setEnumerator = [set objectEnumerator];
    id setObject;
    while ((setObject = setEnumerator.nextObject) != nil) {
        NSLog(@"set - %@",setObject);
    }
}
```

#### 快速遍历
快速遍历代码更简洁，而且更高效，缺点是遍历数组时无法获取当前对象所对应的下标

```objective-c
- (void)testForIn {
    NSArray *array = @[@1,@2,@3];
    NSDictionary *dictionary = @{
                                 @"key1":@"value1",
                                 @"key2":@"value2",
                                 @"key3":@"value3"
                                 };
    NSSet *set = [NSSet setWithObjects:@4,@5,@6, nil];
    /// array
    for (NSNumber *obj in array) {
        NSLog(@"array - %@",obj);
    }
    
    /// dictionary
    for (NSString *key in dictionary) {
        NSLog(@"dictionary - key:%@  value:%@",key,dictionary[key]);
    }
    
    /// set
    for (NSNumber *setObject in set) {
        NSLog(@"set - %@",setObject);
    }
}
```

#### 基于块的遍历方式
其优势是代码简洁， 可获取集合中的更多信息，包括数组的下标、字典的key和value，并且能够修改块的方法签名，以免进行类型转换，其中 stop 参数可手动终止遍历- `*stop = YES`

```
- (void)testBlockEnum {
    NSArray *array = @[@1,@2,@3];
    NSDictionary *dictionary = @{
                                 @"key1":@"value1",
                                 @"key2":@"value2",
                                 @"key3":@"value3"
                                 };
    NSSet *set = [NSSet setWithObjects:@4,@5,@6, nil];
    /// array
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"array - idx:%zd - obj:%@",idx,obj);
    }];
    
    /// dictionary
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"dictionary - key:%@  value:%@",key,obj);
    }];
    
    /// set
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"set - %@",obj);
    }];
}

```

#### 🇧🇮 第49条：对自定义其内存管理语义的 `collection` 使用无缝桥接
* 通过无缝桥接技术，可以在 `Foundation` 框架中的 `Objective-C` 对象与 `CoreFoundation` 框架中的 C 语言数据结构之间来回转换
* 在 `CoreFoundation` 层面创建 `collection` 时，可以指定许多回调函数，这些函数表示此 `collection` 应如何处理其元素。然后，可运用无缝桥接技术，将其转换成具备特殊内存管理语义的 `Objective-C` `collection`

何为无缝桥接， 形如：

```objective-c
    NSArray *array = @[@1,@2,@3];
    NSLog(@"array.count: %zd",array.count);
    CFArrayRef arrayRef = (__bridge CFArrayRef)array;
    NSLog(@"arrayRef: %zd",CFArrayGetCount(arrayRef));
```

#### 🇰🇵 第50条：构建缓存时选用 `NSCache` 而非 `NSDictionary`
* 实现缓存时应选用 `NSCache` 而非 `NSDictionary`对象，因为 `NSCache` 可以提供优雅的自动删减功能，而且是“线程安全的”，此外，它与字典不同，并不会拷贝键。
* 可以给 `NSCache` 对象设置上限，用以限制缓存中对象的总个数及 “总成本”，而这些尺度则定义了缓存删减其中对象的时机。但是绝对不要把这些尺度当成可靠的 “硬限制”， 它们仅对 `NSCache` 起指导作用
* 将 `NSPurgeableData` 与 `NSCache` 搭配使用, 可实现自动清除数据的功能，也就是说，当 `NSPurgeableData` 对象所占内存为系统所丢弃时，该对象自身也会从缓存中移除
* 如果缓存使用得当，那么应用程序的相应速度就能提高。只有那种“重新计算起来很费事”数据，才值得放入缓存，比如那些需要从网络获取或从磁盘读取的数据。

`NSCache` 在系统资源将要耗尽时，它会自动删减缓存，并且优先删减 “最久未使用的” 对象。还有一点是 `NSCache` 是线程安全的。

```objective-c
- (void)testNSPurgeableData {

    NSCache *cache = [[NSCache alloc] init];
    cache.countLimit = 100;//最大缓存数
    cache.totalCostLimit = 5 * 1024 * 1024;//最大缓存 5M
    
    NSString *key = @"key";
    /// 存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"正在下载一个很大的数据...");
        NSData *data = [NSMutableData dataWithLength:1024 * 512];/// 下载完了
        NSPurgeableData *purgeableData = [NSPurgeableData dataWithData:data]; // 此时引用计数自动加 1
        [cache setObject:purgeableData forKey:key cost:purgeableData.length];
        NSLog(@"使用data搞事情...");
        [purgeableData endContentAccess];//NSPurgeableData 引用计数 -1
    });
    
    /// 取
    NSPurgeableData *purgeableDataInCache = [cache objectForKey:key];
    if (purgeableDataInCache) {
        [purgeableDataInCache beginContentAccess];
        NSLog(@"使用data搞事情...");
        [purgeableDataInCache endContentAccess]; 
    }
    
}
```

#### 🇬🇶 第51条：精简 `initialize` 和 `load` 的实现代码
* 在加载阶段，如果类实现了 `load` 方法，那么系统就会调用它。分类里也可以定义此方法，类的 `load` 方法要比分类中的先调用。与其他方法不同，`load` 方法不参与覆写机制
* 首次使用某个类之前，系统会向其发送 `initialize` 消息。由于此方法遵从普通的覆写规则，所以通常应该在里面判断当前要初始化的是哪个类。
* `load` 与 `initialize` 方法都应该实现的精简一些。这有助于保持应用程序的相应能力，也能减少“依赖环”的几率
* 无法再编译期设定的全局变量，可以放在 `initialize` 方法里初始化

两者均只会调用一次

两者的区别：
1. 当类和分类载入系统时就会调用 `load` 方法，如果某个类和其分类均实现了 `load` 方法，则会先调用类里的再调用分类里的。（⚠️若本类不实现该方法，无论其父类是否实现均不会调用）
2. `initialize` 方法则是初次使用该类时调用。若程序声明周期不使用该类，则不会调用。（⚠️若本类不实现该方法，若其父类实现了就会调用）

![Snip20180912_2](http://p95ytk0ix.bkt.clouddn.com/2018-09-12-Snip20180912_2.png)

要尽量在这两个方法的实现里精简代码，避免出现耗时和加锁的的操作。

#### 🇨🇳 第52条：别忘了 `NSTimer` 会保留其目标对象
* `NSTimer` 对象会保留其目标，直到计时器本身失效为止，调用 `invalidate` 方法可令计时器失效，另外，一次性的计时器在触发完任务之后也会失效
* 反复执行任务的计时器很容易引入保留环，如果这种计时器的目标对象又保留了计时器本身，那肯定会导致保留环。这种环状保留关系，可能是直接发生的，也可能是通过对象图里的其他对象间接发生的。
* 可以扩充 `NSTimer` 的功能, 用 “block” 来打破保留环。不过，除非 `NSTimer` 将来在公共接口里提供此功能，否则必须创建分类，将相关实现代码加入其中。

观察如下代码，侧滑返回后 `SecondViewController` 会不会释放？

```objective-c
@interface SecondViewController () 
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
}

- (void)timerMethod {
    NSLog(@"计时");
}
@end
```
##### 答案是不会！

再观察，若没有属性引用 `NSTimer`, 侧滑返回后 `SecondViewController` 会不会释放？

```objective-c
@interface SecondViewController () 
@end
@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
}

- (void)timerMethod {
    NSLog(@"计时");
}
@end
```
##### 答案也是不会！！因为 `NSTimer` 会强引用其目标对象也就是 `self`

那我声明一个 弱引用 的 `weakSelf` 作为目标对象，侧滑返回后 `SecondViewController` 会不会释放呢？

```objective-c
@interface SecondViewController () 
@end
@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(timerMethod) userInfo:nil repeats:YES];
}

- (void)timerMethod {
    NSLog(@"计时");
}
@end
```
##### 答案还是不会！！！ 原因也是 `NSTimer` 会强引用其目标对象，虽然此时是声明了一个弱引用类型的指针 `weakSelf`, 但是它和 `self` 指向的是同一个对象即当前控制器，所以此时无论传 `weakSelf` 还是 `self` 效果是一样的，`NSTimer` 均会对当前目标对象强引用！

解决 `NSTimer` 循环引用的方法有三种：

##### 1. 在 `NSTimer` 分类中扩展一个，自定义 `Block`， 使用时在 `Block` 内部若需要使用 `self` 需要对其弱引用。

```objective-c
// .h
@interface NSTimer (XW)
+ (NSTimer *)xw_timerTimeInterval:(NSTimeInterval)timeInterval block:(void(^)(void))block repeats:(BOOL)repeats;
@end

// .m
#import "NSTimer+XW.h"
@implementation NSTimer (XW)
+ (NSTimer *)xw_timerTimeInterval:(NSTimeInterval)timeInterval block:(void(^)(void))block repeats:(BOOL)repeats {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerMethod:) userInfo:block repeats:repeats];
    return timer;
}
+ (void)timerMethod:(NSTimer *)timer {
    void(^inBlock)(void) = [timer userInfo];
    if (inBlock) {
        inBlock();
    }
}
@end


//使用
- (void)testBlockTimer {
    __weak typeof(self) weakSelf = self;
    [NSTimer xw_timerTimeInterval:1.0 block:^{
        [weakSelf timerMethod];
    } repeats:YES];
}
```

##### 2.实例化消息转发的基类 `NSProxy` ，此种方式可以优雅的用原生的方式使用 `NSTimer`

```objective-c
// .h
@interface XWWeakProxy : NSProxy
@property (nullable, nonatomic, weak, readonly) id target;
- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;
@end

// .m
@implementation XWWeakProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target {
    return [[XWWeakProxy alloc] initWithTarget:target];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}
@end

// 使用
 [NSTimer scheduledTimerWithTimeInterval:1.0 target:[XWWeakProxy proxyWithTarget:self] selector:@selector(timerMethod) userInfo:nil repeats:YES];
```

按照目前市场对 iOS开发同学的要求，知道上述两种方式当然还是远远不够的，正如

![Xnip2018-09-12_23-21-36](https://user-gold-cdn.xitu.io/2018/9/12/165ce77d4aa899f1?w=1194&h=2264&f=jpeg&s=415688)

鉴于笔者才疏学浅，后续的补充就由读者自由扩展。

🎉🎉🎉

至此，《Effective Objective-C 2.0》读书/实战笔记完结。记录此笔记也是便于之后快速查阅不至于查原书，52 个开发技巧笔者都通过实践进行的演示，可信度较强，也发现精读一本书比懵懂的速读收获的确大得多。后续还会有其他的读书笔记和学习心得分享在笔者的个人博客中 [极客学伟的技术分享社区](https://blog.csdn.net/qxuewei)  ， 除 CSDN 外笔者还搭建了一个较漂亮的 hexo 主题的博客 [qiuxuewei.com](http://qiuxuewei.com/)也会同步输出一些可能质量不是很高但是一定是很用心写的博文。
 



