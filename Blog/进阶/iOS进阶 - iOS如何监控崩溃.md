# iOS进阶 - iOS如何监控崩溃

#### 几种常见的崩溃

* 数组越界；给数组添加 nil；
* 多线程问题: 在子线程更新UI, 不同线程操作同一个数据。
* 主线程无响应：主线程超过系统规定时间无响应就会被 Watchdog 杀掉。
* 野指针：指针指向一个已删除的内存区域会出现野指针崩溃。
* KVO 问题
* 后台任务超时


#### iOS 后台保活的五种方式

##### 1. Background Mode
App 审核时会提高对 App 的要求。通常情况下只有那些 地图、音乐播放、VoIP类的App 才能通过审核

##### 2. Background Fetch
唤醒时间不稳定，而且用户可以在系统设置关闭这种方式，导致它的使用场景很少

##### 3. Silent Push
推送的一种，会在后台唤起 App 30秒。它的优先级很低，会调用 `application:didReceiveRemoteNotifiacation:fetchCompletionHandler: ` 这个 Delegate, 和普通的 remote push notification 推送调用的 delegate 是一样的

##### 4. PushKit
后台唤醒 App 后能够保活 30 秒。主要用于提升 VoIP 应用的体验

##### 5. Background Task 方式
是使用最多的，App 退后台后，默认都会使用这种方式

通常，程序在退到后台以后，只有几秒钟的时间可以执行代码，接下来就会被系统挂起。进程挂起后所有线程都会暂停，不管这个线程是文件读写还是内存读写都会被暂停，但是，数据读写过程无法暂停只能被中断，中断时数据读写异常而且容易损坏文件，所以系统会选择主动杀掉 App 进程。

而 Background Task 方式就是系统提供了 `beginBackgroundTaskWithExpirationHandler` 方法来延长后台执行时间，可以解决退后台还需要一段时间处理一些任务的诉求。

Background Task 方式的使用方法，如下代码所示：

```
- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void) {
        [self yourTask];
    }];
}
```

这段代码中，yourTask 任务最多执行 3 分钟，3 分钟内 yourTask 运行完成，你的App就会挂起。如果3分钟内没有执行完成的话，系统会强制杀掉进程，从而造成崩溃，这就是为什么 App 退后台容易出现崩溃的原因。

#### 如何避免后台崩溃

App 退后台后，如果执行时间过长就会导致被系统杀掉，那么我们就不能让程序进入后台后执行复杂的任务。如严格控制后台数据的读写操作。在需要处理数据时先判断其大小，如果数据过大可以考虑程序下次启动或后台唤醒时再进行处理。

#### 分析并解决崩溃问题

采集到的崩溃日志主要包括:

* 进程信息：崩溃进城相关信息，比如崩溃报告唯一标示符、唯一键值、设备标识；
* 基本信息：崩溃发生的日期，iOS版本
* 异常信息：异常类型，异常编码，异常的线程；
* 线程回溯：崩溃时的方法调用栈

通常情况下，我们分析崩溃日志时最先看的是异常信息，分析出问题的是哪个线程，在线程回溯
里找到那个线程;然后，分析方法调用栈，符号化后的方法调用栈可以完整地看到方法调用的过
程，从而知道问题发生在哪个方法的调用上。

方法调用栈顶，就是最后导致崩溃的方法的调用。完整的崩溃日志里，除了线程方法调用栈还有异常编码，就在异常信息里。在 [完整的异常编码](https://en.wikipedia.org/wiki/Hexspeak) 里可以看到44种异常编码。常见的三种如下：

* 0x8badf00d，表示 App 在一定时间内无响应而被 watchdog 杀掉的情况。 
* 0xdeadfa11，表示 App 被用户强制退出。
* 0xc00010ff，表示 App 因为运行造成设备温度太高而被杀掉。


