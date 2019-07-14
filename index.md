
<p align='center'>
<img src='https://raw.githubusercontent.com/qxuewei/XWResources/master/images/background/%E7%A7%91%E6%8A%80%E8%83%8C%E6%99%AF4.jpg'>
</p>

# 👨‍💻 XWInterviewMap (持续更新...) 

> 笔者一直觉得 **面试题** 和 **阅读技术书籍** 是完善个人技术栈最好的两种方式
> 此库是笔者在日常学习生活中持续收集整理的面试题，会结合网上大神们的分享和自己的理解，在每个问题后给出尽可能详尽的回答和参考资料，不在于应付面试，旨在通过解决每一个问题进而提高技术水平，同时查漏补缺！ 
> 鉴于笔者才疏学浅，对梳理的过程中出现的错误敬请斧正！

#### 笔者个人博客 [极客学伟的技术分享社区](https://blog.csdn.net/qxuewei) 将会出现部分问题的全面解析和学习记录。

-------

### [iOS 相关 知识点整理](https://github.com/qxuewei/XWInterviewMap/blob/master/iOS%20%E7%9F%A5%E8%AF%86%E7%82%B9%E6%95%B4%E7%90%86.md)

## 读书笔记


####  1.《Effective Objective-C 2.0 - 编写高质量iOS与OS+X代码的52个有效方法》
* [《Effective Objective-C 2.0》读书/实战笔记 一](https://github.com/qxuewei/XWInterviewMap/blob/master/%E8%AF%BB%E4%B9%A6%E7%AC%94%E8%AE%B0/Effective%20Objective-C%202.0%20-%20%E7%BC%96%E5%86%99%E9%AB%98%E8%B4%A8%E9%87%8FiOS%E4%B8%8EOS%2BX%E4%BB%A3%E7%A0%81%E7%9A%8452%E4%B8%AA%E6%9C%89%E6%95%88%E6%96%B9%E6%B3%95%E3%80%8B/%E3%80%8AEffective%20Objective-C%202.0%E3%80%8B%E8%AF%BB%E4%B9%A6:%E5%AE%9E%E6%88%98%E7%AC%94%E8%AE%B0%E4%B8%80.md) 
* [《Effective Objective-C 2.0》读书/实战笔记 二](https://github.com/qxuewei/XWInterviewMap/blob/master/%E8%AF%BB%E4%B9%A6%E7%AC%94%E8%AE%B0/Effective%20Objective-C%202.0%20-%20%E7%BC%96%E5%86%99%E9%AB%98%E8%B4%A8%E9%87%8FiOS%E4%B8%8EOS%2BX%E4%BB%A3%E7%A0%81%E7%9A%8452%E4%B8%AA%E6%9C%89%E6%95%88%E6%96%B9%E6%B3%95%E3%80%8B/%E3%80%8AEffective%20Objective-C%202.0%E3%80%8B%E8%AF%BB%E4%B9%A6:%E5%AE%9E%E6%88%98%E7%AC%94%E8%AE%B0%E4%BA%8C.md)
* [《Effective Objective-C 2.0》读书/实战笔记 三 - 完结篇](https://github.com/qxuewei/XWInterviewMap/blob/master/%E8%AF%BB%E4%B9%A6%E7%AC%94%E8%AE%B0/Effective%20Objective-C%202.0%20-%20%E7%BC%96%E5%86%99%E9%AB%98%E8%B4%A8%E9%87%8FiOS%E4%B8%8EOS%2BX%E4%BB%A3%E7%A0%81%E7%9A%8452%E4%B8%AA%E6%9C%89%E6%95%88%E6%96%B9%E6%B3%95%E3%80%8B/%E3%80%8AEffective%20Objective-C%202.0%E3%80%8B%E8%AF%BB%E4%B9%A6:%E5%AE%9E%E6%88%98%E7%AC%94%E8%AE%B0%E4%B8%89.md)



## iOS 内存管理

* 1.讲一下 `iOS` 内存管理的理解？(三种方案的结合) -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/1.第一题.md)
* 2.使用自动引用计（`ARC`）数应该遵循的原则? -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/2.第二题.md)
* 3.`ARC` 自动内存管理的原则？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/3.第三题.md)
* 4.访问 `__weak` 修饰的变量，是否已经被注册在了 `@autoreleasePool` 中？为什么？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/4.第四题.md)
* 5.`ARC` 的 `retainCount` 怎么存储的？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/5.第五题.md)
* 6.简要说一下 `@autoreleasePool` 的数据结构？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/6.第六题.md)
* 7.`__weak` 和 `__unsafe_unretained` 的区别？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/7.第七题.md)
* 8.为什么已经有了 `ARC` ,但还是需要 `@AutoreleasePool` 的存在？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/8.第八题.md)
* 9.`__weak` 属性修饰的变量，如何实现在变量没有强引用后自动置为 `nil`？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/9.第九题.md)
* 10.说一下对 `retain`,`copy`,`assign`,`weak`,`__unsafe_unretained` 关键字的理解。 -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/10.第十题.md)
* 11.`ARC` 在编译时做了哪些工作？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/11.第十一题.md)
* 12.`ARC` 在运行时做了哪些工作？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/12.第十二题.md)
* 13.函数返回一个对象时，会对对象 `autorelease` 么？为什么？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/13.第十三题.md)
* 14.说一下什么是 `悬垂指针`？什么是 `野指针`? -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/14.第十四题.md)
* 15.内存管理默认的关键字是什么？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/15.第十五题.md)
* 16.内存中的5大区分别是什么？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/16.第十六题.md)
* 17.是否了解 `深拷贝` 和 `浅拷贝` 的概念，集合类深拷贝如何实现？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/17.第十七题.md)
* 18.`BAD_ACCESS` 在什么情况下出现? -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/18.第十八题.md)
* 19.讲一下 `@dynamic` 关键字？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/19.第十九题.md)
* 20.`@autoreleasrPool` 的释放时机？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/20.第二十题.md)
* 21.`retain`、`release` 的实现机制？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/21.第二十一题.md)
* 22.能不能简述一下 `Dealloc` 的实现机制？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/22.第二十二题.md)
* 23.在 `MRC` 下如何重写属性的 `Setter` 和 `Getter`? -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/23.第二十三题.md)
* 24.在 `ObjC` 中，如何检测内存泄漏？你知道哪些方式？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/24.第二十四题.md)
* 25.在OC中，NSNumber对象 是用什么方式来存储的 -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/25.第二十五题.md)
* 26.CADisplayLink、NSTimer 使用注意？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/26.第二十六题.md)
* 27.为什么代理要用weak？代理的delegate和dataSource有什么区别？block和代理的区别? -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/27.第二十七题.md)
* 28.属性的实质是什么？包括哪几个部分？属性默认的关键字都有哪些？@dynamic关键字和@synthesize关键字是用来做什么的？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/内存管理/28.第二十八题.md)



## Runtime
* 1.实例对象的数据结构？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/1.第一题.md)
* 2.类对象的数据结构？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/2.第二题.md)
* 3.元类对象的数据结构? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/3.第三题.md)
* 4.`Category` 的实现原理？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/4.第四题.md)
* 5.如何给 `Category` 添加属性？关联对象以什么形式进行存储？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/5.第五题.md)
* 6.`Category` 有哪些用途？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/6.第六题.md)
* 7.`Category` 和 `Extension` 有什么区别？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/7.第七题.md)
* 8.说一下 `Method Swizzling`? 说一下在实际开发中你在什么场景下使用过? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/8.第八题.md)
* 9.如何实现动态添加方法和属性？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/9.第九题.md)
* 10.说一下对 `isa` 指针的理解， 对象的`isa` 指针指向哪里？`isa` 指针有哪两种类型？（注意区分不同对象） - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/10.第十题.md)
* 11.`Obj-C` 中的类信息存放在哪里？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/11.第十一题.md)
* 12.一个 `NSObject` 对象占用多少内存空间？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/12.第十二题.md)
* 13.说一下对 `class_rw_t` 的理解？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/13.第十三题.md)
* 14.说一下对 `class_ro_t` 的理解？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/14.第十四题.md)
* 15.说一下 `Runtime` 消息解析。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/15.第十五题.md)
* 16.说一下 `Runtime` 消息转发。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/15.第十五题.md)
* 17.如何运用 `Runtime` 字典转模型？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/17.第十七题.md)
* 18.如何运用 `Runtime` 进行模型的归解档？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/18.第十八题.md)
* 19.在 `Obj-C` 中为什么叫发消息而不叫函数调用？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/19.第十九题.md)
* 20.说一下对 `runtime` 的理解。（主要讲一下消息机制，是对上述的总结）
* 21.说一下 `Runtime` 的方法缓存？存储的形式、数据结构以及查找的过程？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/21.第二十一题.md)
* 22.是否了解 `Type Encoding`? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/22.第二十二题.md)
* 23.`Objective-C` 如何实现多重继承？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/23.第二十三题.md)
* 24.`Category` 可不可以添加实例对象？为什么？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/24.第二十四题.md)
* 25.`Obj-c`对象、类的本质是通过什么数据结构实现的？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/24.第二十四题.md)
* 26.为什么说Objective-C是一门动态的语言？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runtime/26.第二十六题.md)


## Runloop
* 1.`Runloop` 和线程的关系？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/1.第一题.md)
* 2.讲一下 `Runloop` 的 `Mode`?  -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/2.第二题.md)
* 3.讲一下 `Observer` ？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/3.第三题.md)
* 4.讲一下 `Runloop` 的内部实现逻辑？（运行过程） -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/4.第四题.md)
* 5.你所知的哪些三方框架使用了 `Runloop`? -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/5.第五题.md)
* 6.`autoreleasePool` 在何时被释放？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/6.第六题.md)
* 7.解释一下 `事件响应` 的过程？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/7.第七题.md)
* 8.解释一下 `手势识别` 的过程？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/8.第八题.md)
* 9.解释一下 `GCD` 在 `Runloop` 中的使用？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/9.第九题.md)
* 10.解释一下 `NSTimer`，以及 `NSTimer` 的循环引用。 -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/10.第十题.md)
* 11.`AFNetworking` 中如何运用 `Runloop`? -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/11.第十一题.md)
* 12.`PerformSelector` 的实现原理？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/12.第十二题.md)
* 13.利用 `Runloop` 解释一下页面的渲染的过程？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/13.第十三题.md)
* 14.如何使用 `Runloop` 实现一个常驻线程？这种线程一般有什么作用？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/14.第十四题.md)
* 15.为什么 `NSTimer` 有时候不好使？（不同类型的Mode）-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/15.第十五题.md)
* 16.`PerformSelector:afterDelay:`这个方法在子线程中是否起作用？为什么？怎么解决？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/16.第十六题.md)
* 17.什么是异步绘制？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Runloop/17.第十七题.md)
* 18.如何检测 `App` 运行过程中是否卡顿？


## UIKit
* 1.`UIView` 和 `CALayer` 是什么关系？-- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/UIKit/1.第一题.md)
* 2.`Bounds` 和 `Frame` 的区别? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/UIKit/2.第二题.md)
* 3.`TableViewCell` 如何根据 `UILabel` 内容长度自动调整高度?
* 4.`LoadView`方法了解吗？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/UIKit/4.第四题.md)
* 5.`UIButton` 的父类是什么？`UILabel` 的父类又是什么？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/UIKit/5.第五题.md)
* 6.实现一个控件，可以浮在任意界面的上层并支持拖动？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/UIKit/6.第六题.md)
* 7.说一下控制器 `View` 的生命周期，一旦收到内存警告会如何处理？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/UIKit/7.第七题.md)
* 8.如何暂停一个 `UIView` 中正在播放的动画？暂停后如何恢复？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/UIKit/8.第八题.md)
* 9.说一下 `UIView` 的生命周期？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/UIKit/9.第九题.md)
* 10.`UIViewController` 的生命周期？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/UIKit/10.第十题.md)
* 11.如何以通用的方法找到当前显示的`ViewController`? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/UIKit/11.第十一题.md)
* 12.详细描述一下 UIView 与 CALayer 的关系，drawRect 一定会影响性能吗？UI Dynamics 与 UIKit Animation 的最本质区别是什么？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/UIKit/12.第十二题.md)


## Foundation
* 0.1 怎样使用 `performSeletctor` 传入三个以上参数，其中一个为结构体? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/_XWCollection/Foundation/0.1.md)
* 1.`nil`、`NIL`、`NSNULL` 有什么区别？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/1.第一题.md)
* 2.如何实现一个线程安全的 `NSMutableArray`? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/2.第二题.md)
* 3.如何定义一台 `iOS` 设备的唯一性? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/3.第三题.md)
* 4.`atomic` 修饰的属性是绝对安全的吗？为什么？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/4.第四题.md)
* 5.实现 `isEqual` 和 `hash` 方法时要注意什么？
* 6.`id` 和 `instanceType` 有什么区别？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/6.第六题.md)
* 7.简述事件传递、事件响应机制。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/7.第七题.md)
* 8.说一下对 `Super` 关键字的理解。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/8.第八题.md)
* 9.了解 `逆变` 和 `协变` 吗？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/9.第九题.md)
* 10.`@synthesize` 和 `@dynamic` 分别有什么作用？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/10.第十题.md)
* 11.`Obj-C` 中的反射机制了解吗？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/11.第十一题.md)
* 12.`typeof` 和 `__typeof`，`__typeof__` 的区别? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/12.第十二题.md)
* 13.如何判断一个文件在沙盒中是否存在？
* 14.头文件导入的方式？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/14.第十四题.md)
* 15.如何将 `Obj-C` 代码改变为 `C++/C` 的代码？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/15.第十五题.md)
* 16.知不知道在哪里下载苹果的源代码？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Foundation/16.第十六题.md)

## 网络
* 1.`NSUrlConnect` 相关知识。
* 2.`NSUrlSession` 相关知识。
* 3.`Http` 和 `Https` 的区别？为什么更加安全？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/3.第三题.md)
* 4.`Http`的请求方式有哪些？`Http` 有什么特性？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/4.第四题.md)
* 5.解释一下 `三次握手` 和 `四次挥手`？解释一下为什么是`三次握手` 又为什么是 `四次挥手`？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/5.第五题.md)
* 6.`GET` 和 `POST` 请求的区别？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/6.第六题.md)
* 7.`HTTP` 请求报文 和 响应报文的结构？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/7.第七题.md)
* 8.什么是 `Mimetype` ? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/8.第八题.md)
* 9.数据传输的加密过程？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/9.第九题.md)
* 10.说一下 `TCP/IP` 五层模型的协议? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/10.第十题.md)
* 11.说一下 `OSI` 七层模型的协议? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/11.第十一题.md)
* 12.`大文件下载` 的功能有什么注意点？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/12.第十二题.md)
* 13.`断点续传` 功能该怎么实现？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/13.第十三题.md)
* 14.封装一个网络框架有哪些注意点？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/14.第十四题.md)
* 15.`Wireshark`、`Charles`、`Paw` 等工具会使用吗？
* 16.`NSUrlProtocol`用过吗？用在什么地方了？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/16.第十六题.md)
* 17.如何在测试过程中 `MOCK` 各种网络环境？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/17.第十七题.md)
* 18.`DNS` 的解析过程？网络的 `DNS` 优化。 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/18.第十八题.md)
* 19.`Post`请求体有哪些格式？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/19.第十九题.md)
* 20.网络请求的状态码都大致代表什么意思？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/20.第二十题.md)
* 21.抓包软件 `Charles` 的原理是什么？说一下中间人攻击的过程。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/21.第二十一题.md)
* 22.如何判断一个请求是否结束？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/22.第二十二题.md)
* 23.`SSL` 传输协议？说一下 `SSL` 验证过程？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/23.第二十三题.md)
* 24.解释一下 `Http` 的持久连接？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/24.第二十四题.md)
* 25.说一下传输控制协议 - `TCP` ?- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/25.第二十五题.md)
* 26.说一下用户数据报协议 - `UDP` ? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/26.第二十六题.md)
* 27.谈一谈网络中的 `session` 和 `cookie`? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/网络/27.第二十七题.md)

## 多线程
* 0.1.自旋锁和互斥锁的区别? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/_XWCollection/%E5%A4%9A%E7%BA%BF%E7%A8%8B/0.1.md)
* 1.`NSThread`相关知识？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/1.第一题.md)
* 2.`GCD` 相关知识？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/2.第二题.md)
* 3.`NSOperation` 和 `NSOperationQueue`相关知识？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/5.多线程/3.第三题.md)
* 4.如何实现线性编程？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/4.第四题.md)
* 5.说一下 `GCD` 并发队列实现机制？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/5.第五题.md)
* 6.`NSLock`？是否会出现死锁？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/6.第六题.md)
* 7.`NSContion` - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/7.第七题.md)
* 8.条件锁 - `NSContionLock`  - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/8.第八题.md)
* 9.递归锁 - `NSRecursiveLock` - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/9.第九题.md)
* 10.同步锁 - `Synchronized(self) {// code}`  - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/10.第十题.md)
* 11.信号量 - `dispatch_semaphore`。 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/11.第十一题.md)
* 12.自旋锁 - `OSSpinLock` 。 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/12.第十二题.md)
* 13.多功能🔐 - `pthread_mutex` - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/13.第十三题.md)
* 14.分步锁 - `NSDistributedLock`。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/14.第十四题.md)
* 15.如何确保线程安全？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/15.第十五题.md)
* 16.`NSMutableArray`、和 `NSMutableDictionary`是线程安全的吗？`NSCache`呢？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/16.第十六题.md)
* 17.多线程的 `并行` 和 `并发` 有什么区别？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/17.第十七题.md)
* 18.多线程有哪些优缺点？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/18.第十八题.md)
* 19.如何自定义 `NSOperation` ? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/19.第十九题.md)
* 20.`GCD` 与 `NSOperationQueue` 有哪些异同？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/20.第二十题.md)
* 21.解释一下多线程中的死锁？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/多线程/21.第二十一题.md)
* 22.子线程是否会出现死锁？说一下场景？
* 23.多线程技术在使用过程中有哪些注意事项？


## 项目架构
* 1.什么是 `MVC`? -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/项目架构/1.第一题.md)
* 2.什么是 `MVVM`? -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/项目架构/2.第二题.md)
* 3.什么是 `MVP`? -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/项目架构/3.第三题.md)
* 4.什么是 `CDD`?
* 5.项目的组件化？
     - 1.说一下你了解的项目组件化方案？
     - 2.什么样的团队及项目适合采用组件化的形式进行开发？
     - 3.组件之间的通信方式。
     - 4.各组件之间的解耦合。
* 6.还了解哪些项目架构？你之前所在公司的架构是什么样的，简单说一下？
* 7.从宏观上来讲 `App` 可以分为哪些层？
* 8.iOS程序启动过程？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/项目架构/8.第八题.md)

## 消息传递的方式

* 1.说一下 `NSNotification` 的实现机制？发消息是同步还是异步？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/1.第一题.md)
* 2.说一下 `NSNotification` 的特点。 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/2.第二题.md)
* 3.简述 `KVO` 的实现机制。 -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/3.第三题.md)
* 4.`KVO` 在使用过程中有哪些注意点？有没有使用过其他优秀的 `KVO` 三方替代框架？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/4.第四题.md)
* 5.简述 `KVO` 的注册依赖键是什么？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/5.第五题.md)
* 6.如何做到 `KVO` 手动通知？ -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/6.第六题.md)
* 7.在什么情况下会触发 `KVO`?  -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/7.第七题.md)
* 8.给实例变量赋值时，是否会触发 `KVO`?  -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/8.第八题.md)
* 9.`Delegate`通常用什么关键字修饰？为什么？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/9.第九题.md)
* 10.`通知` 和 `代理` 有什么区别？各自适应的场景？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/10.第十题.md)
* 11.`__block` 的解释以及在 `ARC` 和 `MRC` 下有什么不同？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/11.第十一题.md)
* 12.`Block` 的内存管理。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/12.第十二题.md)
* 13.`Block` 自动截取变量。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/13.第十三题.md)
* 14.`Block` 处理循环引用。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/14.第十四题.md)
* 15.`Block` 有几种类型？分别是什么？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/15.第十五题.md)
* 16.`Block` 和 `函数指针` 的区别? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/16.第十六题.md)
* 17.说一下什么是`Block`? - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/消息传递的方式/16.第十六题.md)
* 18.`Dispatch_block_t`这个有没有用过？解释一下？

## 数据存储
* Sqlite3 
    - 1.简单说一下 `Sqlite3` - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/数据存储/1.1-1.md)
    - 2.`Sqlite3` 常用的执行语句
    - 3.`Sqlite3` 在不同版本的APP，数据库结构变化了，如何处理?
* FMDB (`Sqlite3` 的封装) - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/数据存储/2.2-1.md)
* Realm
* NSKeyArchieve - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/数据存储/4.4-1.md)
* Preperfence - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/数据存储/5.5-1.md)
* Plist - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/数据存储/6.6-1.md)
* CoreDate
* Keychain
* UIPasteBoard(感谢 lilingyu0620 同学提醒)
* FoundationDB
* LRU(最少最近使用)缓存

## iOS设计模式

* 1.编程中的六大设计原则？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/设计模式/1.第一题.md)
* 2.如何设计一个图片缓存框架？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/设计模式/2.第二题.md)
* 3.如何设计一个时长统计框架？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/设计模式/3.第三题.md)
* 4.如何实现 `App` 换肤（夜间模式）？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/设计模式/4.第四题.md)
* 5.外观模式
* 6.中介者模式
* 7.访问者模式
* 8.装饰模式 
* 9.观察者模式
* 10.责任链模式
* 11.命令模式
* 12.适配器模式
* 13.桥接模式
* 14.代理委托模式
* 15.单例模式
* 16.类工厂模式


## WebView
* 1.说一下 `JS` 和 `OC` 互相调用的几种方式？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/WebView/1.第一题.md)
* 2.在使用 `WKWedView` 时遇到过哪些问题？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/WebView/2.第二题.md)
* 3.是否了解 `UIWebView` 的插件化？
* 4.是否了解 `SFSafariViewController` ？



## iOS 动画
* 1.简要说一下常用的动画库。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Animation/1.第一题.md)
* 2.请说一下对 `CALayer` 的认识。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Animation/2.第二题.md)
* 3.解释一下 `CALayer.contents` 属性。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/Animation/3.第三题.md)
* 4.在 `iOS` 中，动画有哪几种类型？
* 5.隐式动画
* 6.显式动画


## 代码管理、持续集成、项目托管
*   1.Git
    - 1.`git pull` 和 `git fetch` 的区别？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/代码管理/1.1-1.md)
    - 2.`git merge` 和 `git rebase` 的区别？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/代码管理/1.1-2.md)
    - 3.如何在本地新建一个分支，并 `push` 到远程服务器上？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/代码管理/1.1-3.md)
    - 4.如果 `fork` 了一个别人的仓库，怎样与源仓库保持同步？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/代码管理/1.1-4.md)
    - 5.总结一下 `Git` 常用的命令？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/代码管理/1.1-5.md)
*   2.SVN
*   3.CocoaPods
    - 1.说一下 `CocoaPods` 的原理？
    - 2.如何让自己写的框架支持 `CocoaPods`？
    - 3.`pod update` 和 `pod install` 有什么区别？
    - 4.`Podfile.lock` 文件起什么作用？
    - 5.`CocoaPods` 常用指令？
    - 6.在使用 `CocoaPods` 中遇到过哪些问题？
    - 7.如何使用 `CocoaPods` 集成远程私有库？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/代码管理/3.3-7.md)
    - 8.如果自己写的库需要依赖其他的三方库，该怎么办？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/代码管理/3.3-8.md)
    - 9.`CocoaPods` 中的 `Subspec` 字段有什么用处？
* 4.Carthage
* 5.Fastlane
* 6.Jenkins
* 7.fir.im
* 8.蒲公英
* 9.TestFlight

## 数据安全及加密
* 1.RSA非对称加密 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/数据安全及加密/1.第一题.md)
* 2.AES对称加密
* 3.DES加密
* 4.Base64加密
* 5.MD5加密
* 6.简述 `SSL` 加密的过程用了哪些加密方法，为何这么做？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/数据安全及加密/6.第六题.md)
* 7.是否了解 `iOS` 的签名机制？
* 8.如何对 `APP` 进行重签名？

## 源代码阅读
* 1.YYKit
* 2.SDWebImage  - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/源代码阅读/2.第二题.md)
* 3.AFNetworking
* 4.SVProgressHub 
* 5.Texture（ASDK）

## iOS逆向及安全

## Coretext

## 项目组件化
* 1.说一下你之前项目的组件化方案？
* 2.项目的组件化模块应该如何划分？
* 3.如何集成本地私有库？
* 4.如何集成远程私有库？

## 性能优化
* 1.如何提升 `tableview` 的流畅度？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/性能优化/1.第一题.md)
* 2.如何使用 `Instruments` 进行性能调优？(Time Profiler、Zombies、Allocations、Leaks)
* 3.如何优化 `APP` 的启动时间？
* 4.如何对 `APP` 进行网络流量的优化？
* 5.如何有效降低 `APP` 包的大小？
* 6.日常如何检查内存泄露？
* 7.能不能说一下物理屏幕显示的原理？
* 8.解释一下什么是屏幕卡顿、掉帧？该如何避免？
* 9.什么是 `离屏渲染`？什么情况下会触发？该如何应对？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/性能优化/9.第九题.md)
* 10.如何高性能的画一个圆角？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/性能优化/10.第十题.md)
* 11.如何实现内存的优化？
* 12.如何实现电量的优化？

## 调试技巧 & 软件使用
* 1.`LLDB` 调试。
* 2.断点调试 - `breakPoint`。
* 3.`NSAssert` 的使用。
* 4.`Charles` 的使用。
* 5.`Reveal` 的使用。
* 6.`iOS` 常见的崩溃类型有哪些？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/调试技巧/6.第六题.md)
* 7.当页面 `AutoLayout` 出现了问题，怎样快速调试？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/调试技巧/7.第七题.md)

## 数据结构及算法

#### 数据结构
* 1.数组 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/数据结构/数组.md)
* 2.字典 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/数据结构/字典.md)
* 3.链表 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/数据结构/链表.md)
* 4.树
* 5.栈
* 6.队列
* 7.哈希表

#### 算法



###### 常见的摘要算法：
* HEX编码
* Base64
* MD5
* SHA1
* SHA256
* MAC算法

###### 常见对称加密算法
* AES
* DES
* 3DES
* Blowfish

###### 常见的排序算法
* 快速排序
* 堆排序
* 冒泡排序 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/算法集合/冒泡排序.md)
* 选择排序
* 希尔排序
* 归并排序

###### 常见的字符编码方法
* ASCII
* ISO-8859-1
* GB2312
* GBK
* UTF-8
* UTF-16 
* Unicode
* 推荐一个很好的算法总结 - [链接](https://github.com/CyC2018/Interview-Notebook)

###### 常考算法题
* 1.字符串反转 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/算法集合/1.第一题.md)
* 2.链表反转 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/算法集合/2.第二题.md)
* 3.有序数组合并 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/算法集合/3.第三题.md)
* 4.查找第一个只出现一次的字符 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/算法集合/4.第四题.md)
* 5.查找两个子视图的共同父视图 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/算法集合/5.第五题.md)
* 6.无序数组中的中位数 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/算法集合/6.第六题.md)
* 7.两数之和为特定值 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/算法集合/7.第七题.md)
* 8.求出数组中连续数字的和值 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/算法集合/8.第八题.md)
* 9.白鼠与毒酒的算法问题 - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/算法集合/9.第九题.md)
* 10.在一个数组中找出前四个最大的数字。- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/0.算法集合/10.第十题.md)
* 11.假如有 10亿 条数据，每条数据的大小在 10k-100k 之间，我们有一台内存为 4G 的电脑，如何算出播放次数最多的一条微博？
* 12.如何打印一个矩阵？
* 13.如何验证一个 `IP` 地址的有效性？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/_XWCollection/%E7%AE%97%E6%B3%95%E9%9B%86%E5%90%88/13.md)
* 14.栈中储存着一组无序的数字，不用遍历的方式，如何找出最小值？
* 15.二维数组查找一个值。

## 扩展问题
* 1.无痕埋点
* 2.APM（应用程序性能监测）
* 3.Hot Patch（热修补）
* 4.崩溃的处理

## 其他问题

* 1.`load` 和 `Initialize` 的区别? -- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/其他问题/1.第一题.md)
* 2.`Designated Initializer`的规则？ - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/其他问题/2.第二题.md)
* 3.`App` 编译过程有了解吗？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/其他问题/3.第三题.md)
* 4.说一下对 `APNS` 的认识？- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/其他问题/4.第四题.md)
* 5.`App` 上有一数据列表，客户端和服务端均没有任何缓存，当服务端有数据更新时，该列表在 `wifi` 下能获取到数据，在 4G 下刷新不到，但是在 4g 环境下其他 `App` 都可以正常打开，分析其产生的原因？
* 6.是否了解链式编程？


## 逻辑计算题
- 1.**输出如下的计算结果** （14）

```objc
int a=5,b;
b=(++a)+(++a);
```

- 2.**不使用第三个变量，交换两个变量的值。**- [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/计算题/2.第二题.md)

```objc
int a = 5;
int b = 10;
```
- 3.**给出 `i`值得取值范围？** （大于或等于10000）

```objc
    __block int i = 0;

    while (i<10000) {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        i++;
    });
}
    NSLog(@"i=%d",i);
}
```

- 4.**编码求，给定一个整数，按照十进制的编码计算包含多少个 `0`?**  - [链接](https://github.com/qxuewei/XWInterviewMap/blob/master/计算题/4.第四题.md)

## 开放性问题
* 1.你最近在业余时间研究那些技术点？可不可以分享一下你的心得？
* 2.你对自己未来的职业发展有什么想法？有没有对自己做过职业规划？
* 3.和同事产生矛盾（包括意见分歧），你一般怎么解决？
* 4.能不能说一下你的业余精力都花在什么方面，或者介绍一下你的爱好？
* 5.学习技术知识通常通过哪些途径？
* 6.遇到疑难问题一般怎么解决？能不能说一个你印象颇深的技术难点，后来怎么解决的？

## 开源分享
分享笔者开发过程中封装的几个开源小工具：

* 1. 仿微信浮窗 
* 2. 一行代码集成社区类发布功能  [XWPublish](https://github.com/qxuewei/XWPublish)
* 3. 国家代码/区号 选择器 [XWCountryCode](https://github.com/qxuewei/XWCountryCode)
* 4. 点击查看大图最简单的实现 [XWSacnBigImage](https://github.com/qxuewei/XWSacnBigImage)

## 推荐书籍

* 《Effective Objective-C 2.0 - 编写高质量iOS与OS+X代码的52个有效方法》
* 《Objective-C高级编程+iOS与OSX多线程和内存管理》
* 《高性能iOS应用开发》
* 《禅与Objective-C编程艺术》
* 《编写可读代码的艺术》
* 《Objective-C 编程之道 IOS设计模式解析》
* 《iOS 数据库应用高级编程》
* 《iOS 网络高级编程》
* 《iOS Auto Layout 开发秘籍》
* 《剑指Offer》
* 《程序员的自我修养》
* 《程序员的职业素养》
* 《习惯的力量》
* 《图解HTTP》
* 《算法图解》
* 《算法 第四版》
* 《软技能-代码之外的生存指南》
* 《富爸爸穷爸爸》
* 《深入理解计算机系统（第三版）》
* 《计算机网络自顶向下方法》
* 《代码大全（第二版）》
* 《Pro Git》
* 《大话数据结构》
* 《重构-改善既有代码的设计》

## 推荐视频
* [iOS逆向与安全](http://mooc.study.163.com/course/2001233000?tid=2001319000#/info) - (刘培庆 Alone_Monkey)
* [iOS内存管理详解(美团)](https://v.douyu.com/show/ra2JEMJgnEkWNxml)
* [App 启动流程详解及其优化(美团)](https://v.douyu.com/show/JwLjGvLJ0N2MmO90)
* [infoQ 历届大会演讲视频集锦](http://www.infoq.com/cn/presentations)
* [runtime疯人院](http://v.youku.com/v_show/id_XODIzMzI3NjAw.html)
* [RunLoop](http://v.youku.com/v_show/id_XODgxODkzODI0.html)
* [Swift 语言 iOS 11 开发 斯坦福公开课](https://www.bilibili.com/video/av16339375/)



## 面试题来源：

* [iOS-InterviewQuestion-collection  -  liberalisman](https://github.com/liberalisman/iOS-InterviewQuestion-collection) 目前该库基本框架由此库生成，感谢大神的的开源精神！
* [iOS-Interview-Question-Answer  -  liberalisman](https://github.com/liberalisman/iOS-Interview-Question-Answer)
* [出一套 iOS 高级面试题  -  J_Knight_](https://juejin.im/post/5b56155e6fb9a04f8b78619b)
* [iOSDevNotesAndInterviews - 李夫龙](https://github.com/DevDragonLi/iOSDevNotesAndInterviews)
* [招聘一个靠谱的 iOS](https://github.com/ChenYilong/iOSInterviewQuestions)
* [iOS 中级面试题](http://mrpeak.cn/ios/2016/01/07/push)
* [2018 iOS 社招面试经验：我是如何拿到阿里、滴滴、美团等六家 offer 的？](https://xiaozhuanlan.com/topic/4985160237)


