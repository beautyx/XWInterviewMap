# iOS进阶 - 包大小：如何从资源和代码层面实现全方位瘦身

#### 官方 App Thinning

App Thinning 是由苹果公司推出的一项可以改善 App 下载进程的新技术，主要为了解决用户下载 App 耗费过高流量的问题，同时还可以节省用户 iOS 设备的存储空间。

App Thinning 会专门针对不同的设备来选择只适用于当前设备的内容以供下载。比如，iPhone 6 只会下载 @2x 分辨率的图片资源，iPhone 6Plus 则只会下载 @3x 分辨率的图片资源。

在苹果公司使用 App Thinning 之前，每个App都包含多个芯片的指令集架构文件。使用 App Thinning 之后，用户下载时就只会下载一个适合自己设备的芯片指令集架构文件。

App Thinning 包含三种方式，包括：App Slicing、Bitcode、On-Demand Resources。

* App Slicing 会在你想 iTunes Connect 上传 App 后，对 App 做切割，创建不同的变体，这样就可以适用到不同的设备
* On-Demand Resources 主要视为游戏多关卡场景服务的，它会根据用户的关卡金服下载随后几个关卡的资源，并且已经过关的资源也会被删掉，这样就可以减少初装 App 的包的大小。
* Bitcode 是针对特定设备进行包大小优化，优化不明显

其实，这里的大部分工作都是由 Xcode 和 App Store 来帮你完成的，你只需要通过 Xcode 添加 scassets 目录，然后将图片添加进来即可。所添加的 @2x 分辨率的图片和 @3x 分辨率的图片会在上传到 App Store 后被创建成不同的变体以减小 App 安装包的大小。而芯片指令集架构文件只需要按照默认的设置，App Store 就会根据设备创建不同的变体，每个变体里只有当前设备需要的那个芯片指令集架构文件。

#### 其他无用图片资源

图片资源的优化空间主要体现在删除无用图片和图片资源压缩两个方面。而删除无用图片，又是其中最容易的、最应该先做的。

##### 删除无用图片

三方库 [LSUnusedResources](https://github.com/tinymind/LSUnusedResources) 可以帮助我们定位到项目中无用的图片

##### 图片资源压缩

目前比较好的压缩方案是将图片转成 WebP, WebP 压缩率高，而且肉眼看不出差异，同时支持有损和无损压缩模式，比如将 Gif 图片转成 Animated WebP, 有损压缩模式可减少 64% 大小，无损压缩模式可减少 19% 大小。
WebP 支持 Alpha 透明和 24-bit 颜色数，不会像 PNG8 那样因为色彩不够而出现毛边。
谷歌提供了一个图片压缩工具 [cwebp](https://developers.google.com/speed/webp/docs/precompiled) 来将其他图片转成 WebP. cwebp 使用起来也很简单，只要根据图片情况设置好参数就行。

cwebp 语法：

```
cwebp [options] input_file -o output_file.webp
```

比如将 original.png 进行无损压缩，可以使用如下命令：


```
cwebp -lossless original.png -o new.webp
```

其中 `-lossless` 表示的是，要对输入的 png 图像进行无损编码，转成 WebP 图片，不使用 `-lossless` 则表示有损压缩。

在 cwebp 语法中，还有一个比较关键的参数  -q float

图片色值在不同情况下，可以选择用 -q 参数来进行设置，在不损失图片质量情况下进行最大化压缩。

* 小于 256 色适合无损压缩，压缩率高，参数使用 -lossless -q 100; 
* 大于 256 色使用 75% 有损压缩，参数使用 -q 75;
* 远大于 256 色使用 75% 以下压缩率，参数 -q 50 -m 6。

除 cwebp 以外，也可以使用 [iSparta](http://isparta.github.io/) 实现 PNG 格式转 WebP ，如果是其他格式图片则可先将其转成 PNG 再转成 WebP 。

压缩完图片我们还需要使用 libwebp 进行解析。这里有一个iOS工程使用 libwebp 的范例 [WebP-iOS-example](https://github.com/carsonmcdonald/WebP-iOS-example)

**不过，WebP 在 CPU 消耗和解码时间上会比 PNG 高两倍。所以，我们有时候还需要在性能和体积上做取舍**

#### 代码瘦身

App 安装包主要有资源文件和可执行文件组成，所以我们在掌握了对图片资源的处理方法后，还需要对可执行性文件进行瘦身。

可执行文件就是 Mach-O 文件，其大小是由代码量决定的，通常情况下，对可执行文件进行瘦身，就是 **找到并删除无用代码的过程** 。查找无用代码思路同查找无用图片

* 找出方法和类的全集
* 找到使用过的方法和类
* 取二者的差集得到无用代码
* 最后人工确定无用代码可删除后，进行删除即可。

##### 使用[machoview](https://sourceforge.net/projects/machoview/)

可以使用 [machoview](https://sourceforge.net/projects/machoview/) 这个软件查看 Mach-O 文件里的信息，如何使用：

* 首先，我们需要编译一个 App。在这里，我 clone 了一个 GitHub 上的示例 [GCDFetchFeed](https://github.com/ming1016/GCDFetchFeed) 下来编译。 
* 然后，将生成的 GCDFetchFeed.app 包解开，取出 GCDFetchFeed。 
* 最后，我们就可以使用 MachOView 来查看 Mach-O 里的信息了。

我们可以看到 **__objc_selrefs (一定是被调用了的)**、**__objc_classrefs (被调用过的类)** 和、**__objc_superrefs (调用过 super 的类)** 这三个 section。

但是这种查看方法并不完美，原因在于 Objective-C 是一门动态语言，方法钓鱼可以写成在运行时动态调用，这样就无法收集全所有调用的方法和类。所以，通过此种方法找到的无用的方法和类还需要进行手动二次确认。

##### 通过 AppCode 查找无用代码

AppCode 里选择 Code->Inspect Code 就可以进 行静态分析。静态分析完以后，我们可以在 Unused code 里看到所有的无用代码，

AppCode 静态检查的问题:

* JSONModel 里定义了未使用的协议会被判定为无用协议;
*  如果子类使用了父类的方法，父类的这个方法不会被认为使用了;
*  通过点的方式使用属性，该属性会被认为没有使用;
* 使用 performSelector 方式调用的方法也检查不出来，比如 self performSelector:@selector(arrivalRefreshTime);
* 运行时声明类的情况检查不出来。比如通过 NSClassFromString 方式调用的类会被查出为没 有使用的类，比如 layerClass = NSClassFromString(@“SMFloatLayer”)。还有以 [[self class] accessToken] 这样不指定类名的方式使用的类，会被认为该类没有被使用。像 UITableView 的自定义的 Cell 使用 registerClass，这样的情况也会认为这个 Cell 没有被使用。

基于以上种种原因，使用 AppCode 检查出来的无用代码，还需要人工二次确认才能够安全删除掉。 


