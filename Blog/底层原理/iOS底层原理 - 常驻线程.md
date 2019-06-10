# iOS底层原理 - 常驻线程

在 AFN 2.0 时代，会经常看到 AFN 创建一个常驻线程的方式：

#### 0️⃣ AFN 2.0 时代的常驻线程

```objc
+ (NSThread *)networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });

    return _networkRequestThread;
}

+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"AFNetworking"];

        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}
```
我们知道 RunLoop 是App运行的基础，并且每个线程都有其对应的唯一的 RunLoop 保证其正常运行，而且我们还知道 RunLoop 必须在特定模式下才能保持活跃状态，更多关于 RunLoop 底层的问题可参阅 [iOS - Runloop 详解](https://blog.csdn.net/qxuewei/article/details/80257001) 

#### 1️⃣ 新时代常驻线程初试

在项目中我们也会有类似创建一个常驻线程进行某些耗时操作的需求，若每次均创建一个新的异步线程效率很低，作为优化我们需要一个常驻的异步线程。
 如下代码可满足我们创建一个常驻线程的需求：
 
##### 1. 声明常驻线程属性并对其强引用

    ```objc
    @property (nonatomic, weak) NSThread *p_thread;
    ```
 
##### 2. 实例化常驻线程，且获取当前 RunLoop 设置一个 source 使其保活

    ```objc
    + (void)p_creatThreadMethod {
    
        void (^creatThreadBlock)(void) = ^ {
            NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
            [currentRunLoop addPort:[NSPort new] forMode:NSDefaultRunLoopMode];
            [currentRunLoop run];
        };
        
        if (@available(iOS 10.0, *)) {
            self.p_thread = [[NSThread alloc] initWithBlock:creatThreadBlock];
        } else {
            self.p_thread = [[NSThread alloc] initWithTarget:self selector:@selector(class_creatThreadMethod:) object:creatThreadBlock];
        }
    }
    
    + (void)class_creatThreadMethod:(void (^)(void))block {
        block();
    }
    ```
##### 3. 使用：在需要常驻线程执行某操作时：

    ```objc
    - (void)threakTaskMethod:(void (^)(void))task {
        [self performSelector:@selector(taskMethod:) onThread:self.p_thread withObject:task waitUntilDone:NO];
     }
    ```

##### 弊端：此时我们创建的常驻线程无法跟随当前对象的释放而释放：因为

Apple 对 `[[NSRunLoop currentRunLoop] run];` 的解释：

*If no input sources or timers are attached to the run loop, this method exits immediately; otherwise, it runs the receiver in the NSDefaultRunLoopMode by repeatedly invoking runMode:beforeDate:. In other words, this method effectively begins an infinite loop that processes data from the run loop’s input sources and timers.
Manually removing all known input sources and timers from the run loop is not a guarantee that the run loop will exit. macOS can install and remove additional input sources as needed to process requests targeted at the receiver’s thread. Those sources could therefore prevent the run loop from exiting.
If you want the run loop to terminate, you shouldn't use this method. Instead, use one of the other run methods and also check other arbitrary conditions of your own, in a loop. A simple example would be:*


大概意思就是：
如果 `RunLoop` 没有定时器或输入源，这个方法会立即结束。否则他会反复调用 `runMode:beforeDate:` 方法，换句话说就是这个方法实际上是开启了一个无限循环用以处理 runloop 的输入源和定时器。
手动移除所有输入源和定时器并不能保证 `RunLoop` 会退出。MacOS 可以安装和移除额外的输入源以处理接收者线程的请求。所以这种方式可组织 `RunLoop` 退出。
如果你想终结 `RunLoop` ，你不能使用这种方式。相反，使用其他的运行方法在 `RunLoop` 中检测他们的状态，一个简单的🌰：

这时 Apple 为我们提供了一个控制 `RunLoop` 声明周期的例子：

```objc
BOOL shouldKeepRunning = YES; // global
NSRunLoop *theRL = [NSRunLoop currentRunLoop];
while (shouldKeepRunning && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);

```

所以我们可以对以上代码进行改进！

#### 2️⃣ 控制常驻线程的生命周期

##### 1. 声明常驻线程属性和保活状态变量

```objc
@property (nonatomic, strong) XWThread *p_thread;
@property (nonatomic, assign, getter=isShouldKeepRunning) BOOL shouldKeepRunning;
```

##### 2. 在管理类中创建常驻线程

```objc
- (NSThread *)thread {
    NSThread *thread = nil;
    __weak typeof(self) weakSelf = self;
    void (^creatThreadBlock)(void) = ^ {
        NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
        [currentRunLoop addPort:[NSPort new] forMode:NSDefaultRunLoopMode];
        while (weakSelf && weakSelf.isShouldKeepRunning) {
            // runloop 只有在外部标识 shouldKeepRunning 为 YES 时才继续 run
            [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    };
    
    self.shouldKeepRunning = YES;
    if (@available(iOS 10.0, *)) {
        thread = [[NSThread alloc] initWithBlock:creatThreadBlock];
    } else {
        thread = [[NSThread alloc] initWithTarget:weakSelf selector:@selector(creatThreadMethod:) object:creatThreadBlock];
    }
    [thread start];
    return thread;
}

- (void)creatThreadMethod:(void (^)(void))creatThreadBlock {
    creatThreadBlock();
}
```

##### 3. 在使用常驻线程执行某些操作时

```objc
/**
 在默认常驻线程中执行操作 (线程需随当前对象创建或销毁)
 
 @param task 操作
 */
- (void)executeTask:(XWLivingThreadTask)task {
    if (!task || !self.p_thread) return;
    [self performSelector:@selector(threakTaskMethod:) onThread:self.p_thread withObject:task waitUntilDone:NO];
}

- (void)threakTaskMethod:(void (^)(void))task {
    task ? task() : nil;
}
```

##### 4. 在对象销毁时手动销毁常驻线程

```objc
- (void)dealloc {
    [self performSelector:@selector(clearThreadMethod) onThread:self.p_thread withObject:nil waitUntilDone:YES];
}

- (void)clearThreadMethod {
    self.shouldKeepRunning = NO; // runloop 结束标记
    CFRunLoopStop(CFRunLoopGetCurrent());
}
```


至此，我们就封装了一个可控制其生命周期的常驻线程。美滋滋。


其中 `RunLoop` 保活部分代码也可使用底层 `CoreFoundation` 的代码实现：

```objc
    void (^creatThreadBlock)(void) = ^ {
        CFRunLoopSourceContext content = {0};
        CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &content);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
        CFRelease(source);
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
    };
```

#### 3️⃣ 开源

你若问我有没有演示 Demo, 答案是有的，封装了一个小工具类用以快速创建全局常驻线程和局部常驻线程的方法。
这是代码 ↓
#### [XWLivingThread](https://github.com/qxuewei/XWLivingThread)


