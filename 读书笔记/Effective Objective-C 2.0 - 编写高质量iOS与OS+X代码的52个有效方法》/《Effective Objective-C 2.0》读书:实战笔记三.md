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


