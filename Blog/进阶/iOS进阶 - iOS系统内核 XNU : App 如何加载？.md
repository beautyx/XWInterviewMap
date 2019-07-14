# iOS进阶 - iOS系统内核 XNU : App 如何加载？

### iOS 系统架构

##### iOS系统是基于 ARM 架构的，大致可以分为四层：

* 最上层是用户体验层，主要是提供用户界面。这一层包含了 `SpringBoard`、 `Spotlight`、 `Accessibility`。
* 第二层是应用框架层，是开发者会用到的。这一层包含了开发框架 `Cocoa Touch`.
* 第三层是核心框架层，是系统核心功能的框架层。这一层包含了各种图形和媒体核心框架、`Metal` 等
* 第四层是 Darwin 层，是操作系统的核心，属于操作系统的内核态。这一层包含了系统内核、XNU、驱动等

![iOS 系统架构](http://blog.image.jkxuewei.com/mweb/2019.07.14.Xnip2019-07-14_11-14-46-6.jpg)

其中，用户体验层、应用框架层和核心框架层，属于用户态，是上层App的活动空间。Darwin 是用户态的下层支撑，是iOS系统的核心。

Darwin 的内核是 XNU, 而 XNU 是在 UNIX 的基础上做了很多改进以及创新。了解 XNU 的内部是怎么样的，将有助于我们解决系统层面的问题。

### XNU

XNU 内部有 Mach、BSD、驱动 API IOKit 组成。其中 Mach 是作为 UNIX 内核的替代，主要解决 UNIX 一切皆文件导致抽象机制不足的问题，为现代操作系统做了进一步的抽象工作。Mach 负责操作系统最基本的工作, 包括进程和线程抽象、处理器调度、进程间通讯、消息机制、虚拟内存管理、内存保护等。

进程对应到 Mach 是 Mach Task, Mach Task 可以看做是线程执行环境的抽象，包含虚拟地址空间，IPC空间，处理器资源、调度控制、线程容器。

Mach 的模块包括进程和线程都是对象，对象之间不能直接调用，只能通过 Mach Msg 进行通信，也就是 `mach_msg()` 函数。在用户态的那三层中，也就是在用户体验层、应用框架层和核心框架层中，你可以通过 mach_msg_trap() 函数触发陷阱，从而切至 Mach ，由 Mach 里的 mach_msg() 函数完成实际通信。

每个 Mach Thread 表示一个线程，是 Mach 里的最小执行单位。Mach Thread 有自己的状态，包括机器状态、线程栈、调度优先级（有128个，数字越大表示优先级越高）、调度策略、内核 Port 、异常 Port。

### XNU 怎么加载 App ?

iOS 的可执行文件和动态库都是 Mach-O 格式，所以加载 App 实际上就是加载 Macg-O 文件。

##### Mach-O header 信息结构代码如下：
```
struct mach_header_64 {
    uint32_t        magic;      // 64 位还是 32 位
    cpu_type_t      cputype;    // CPU 类型，比如 arm 或 X86
    cpu_subtype_t   cpusubtype; // CPU 子类型，比如 armv8
    uint32_t        filetype;   // 文件类型
    uint32_t        ncmds;      // load commands 的数量
    uint32_t        sizeofcmds; // load commands 大小
    uint32_t        flags;      // 标签
    uint32_t        reserved;   // 保留字段
};
```

包含了是 64 位还是 32 位的magic、CPU 类型 cputype、CPU 子类型 cpusubtype、文件类型 filetype、描述文件在虚拟内存中逻辑结构和布局的 load commands 数量和大小等信息。

其中 filetype 表示了当前 Mach-O 属于哪种类型。Mach-O 包括以下几种类型：

* OBJECT, 指的是 .o 文件或者 .a 文件
* EXECUTE, 指的是 IPA 拆包后的文件
* DYLIB, 指的是 .dylib 或 .framework 文件
* DYLINKER, 指的是动态链接器
* DSYM, 指的是保存有符号信息用于分析闪退信息的文件

加载 Mach-O 文件，内核会 fork 进程，并对进程进行一些基本设置，比如进程分配虚拟内存，为进程创建主线程、代码签名等。用户态 dyld 会对 Mach-O 文件做库加载和符号解析。

流程可以概括为：

1. fork 新进程
2. 为 Mach-O 分配内存
3. 解析 Mach-O 
4. 读取 Mach-O 头信息
5. 遍历 load command 信息，将 Mach-O 映射到内存
6. 启动 dyld