<p align='center'>
<img src='http://p95ytk0ix.bkt.clouddn.com/2018-07-31-8726ab1532ca52746711381b07cc9971.jpg'>
</p>


##《Effective Objective-C 2.0》读书/实战笔记 三

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

