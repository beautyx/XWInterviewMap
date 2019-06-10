# iOS进阶 -  `AutoLayout`  是如何自动布局的，性能如何？

 `AutoLayout` 是iOS6引入到系统中的，在 WWDC2018 中苹果介绍 iOS 12 将大幅提高  `AutoLayout` 的性能。

###  `AutoLayout` 的生命周期

  `AutoLayout` 不只有布局算法 `Cassoway`，还包含了布局在运行时的生命周期等一整套布局引擎系统，用于统一管理布局的创建、更新和销毁。这一整套布局引擎叫做 `Layout Engine`，是  `AutoLayout`  的核心，主导者整个界面布局。
 
 每个视图在得到自己的布局之前，`Layout Engine` 会将视图、约束、优先级、固定大小通过计算转换成最终的大小和位置，在 `Layout Engine` 里，每当约束发生变化，就会触发 `Deffered Layout Pass`, 完成后进入监听约束变化的状态。当再次监听到约束变化，即进入下一轮循环中。
 设置约束的 `Constant` 和 `Priority` 时也会触发约束变化。`Layout Engine` 在碰到约束变化后会重新计算布局，获取到布局后调用 `superView.setNeedLayout()` 然后进入 `Deffered Layout Pass`,  `Deffered Layout Pass` 的作用主要是容错处理，如果有些视图在更新约束时没有确定或缺失布局声明会在此做容错处理。接下来，`Layout Engine` 会从上到下调用 `layoutSubViews()` , 通过 `Cassoway` 算法计算各个子视图的位置，算出来将子视图的 frame 从 `Layout Engine` 拷贝出来。
 
### `AutoLayout` 的 的性能问题
 
`Auto Layout` 在 iOS 12 中优化后的性能，已经基本和手写布局一样可以达到性能随着视图嵌套的数量呈线性增长 了。而在此之前的 Auto Layout，视图嵌套的数量对性能的影响是呈指数级增长的。

为什么 iOS 12 以前性能不好呢？ 原因是：iOS 12以前，当有约束变化时都会重新创建一个计算引擎 `NSISEngier` 将约束关系重新加起来，重新计算。涉及到约束关系变多时，新的计算引擎需要重新计算，最终导致计算量指数级增加！

 `Cassoway` 算法本身没有问题，问题是iOS 12之前在某些情况下没有用好这个算法。

iOS 12 以后的 `AutoLayout` 更多的利用了 `Cassoway` 算法的界面更新策略，使其真正完成了高效的界面线性策略计算，使其和手写布局有了几乎相同的高性能！

 [极客时间-iOS开发高手课](https://time.geekbang.org/column/intro/161) 学习笔记


