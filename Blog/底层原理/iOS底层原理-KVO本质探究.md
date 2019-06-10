# iOS底层原理-KVO本质探究

### 先说结论，KVO 的本质：
在对一个已知类的某个属性进行 KVO 监听时，系统会在运行时动态创建一个已知类的子类 `NSKVONotifying_某类名`，并在子类实现 `setter` 方法，set方法实现内部会顺序调用`willChangeValueForKey` 方法、原来的 `setter` 方法实现、`didChangeValueForKey` 方法，而 `didChangeValueForKey` 方法内部又会调用监听器的`observeValueForKeyPath:ofObject:change:context:` 监听方法。


## 1. KVO 演示

```objective-c
- (void)testKVO {
    self.person.name = @"Origin Name";
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.person addObserver:self forKeyPath:@"name" options:options context:nil];
    
    [self.person setValue:@"JK" forKey:@"name"];
    
}
```

输出：

```
XWInterviewDemos[38107:525654] KVO -- <XWPerson: 0x60000112fb00> 的 name 属性 发生的变化: {
    kind = 1;
    new = JK;
    old = "Origin Name";
}
```

## 2. 探寻 KVO 实现原理
 重写 `XWPerson` 的 `initialize` 方法
 
```
@implementation XWPerson
+ (void)initialize {
    NSLog(@"%@ %s",self,__func__);
}
@end
```
会发现在运行上述代码时会调用两次，分别打印：

```
2018-10-11 12:55:41.686464+0800 XWInterviewDemos[38372:529858] XWPerson +[XWPerson initialize]
2018-10-11 12:55:45.002630+0800 XWInterviewDemos[38372:529858] NSKVONotifying_XWPerson +[XWPerson initialize]
```
我们知道，类的 `initialize` 方法会在类第一次接收到消息时调用，如果子类没有实现 `+initialize`，会调用父类的`+initialize`（所以父类的`+initialize` 可能会被调用多次），这意味着 `XWPerson` 作为 `NSKVONotifying_XWPerson` 的父类被调用两次。`NSKVONotifying_XWPerson` 即为 Apple 底层 对类进行 KVO 监听所动态生成的原类的子类。

还可在添加 KVO 前后打印当前 `XWPerson` 的 `isa` 指针。
![Xnip2018-10-11_15-20-44](http://p95ytk0ix.bkt.clouddn.com/2018-10-11-Xnip2018-10-11_15-20-44.jpg)

用一幅图表示即：
![Xnip2018-10-11_15-33-13](http://p95ytk0ix.bkt.clouddn.com/2018-10-11-Xnip2018-10-11_15-33-13.jpg)

*原图出自：SEEMYGO*


## 3. KVO 使用注意点

* 多次添加过的监听，都要挨个移除。所以这一点，在cell中使用时候要特别注意。因为cell多次运行， 监听可能就是多次添加
* kvo触发是严格依赖kvc机制的。简单来说就是触发kvo必须是kvc方式给属性赋值。
    * `_name = @"123";` 类似直接为成员变量赋值不会触发 KVO
* 在 `dealloc` 中进行 `removeObserver` 操作
* 父类和子类有可能对同一个属性进行观察，我们知道如果对同一个属性的观察者移除两次会造成崩溃，所以我们每个类应该有唯一的 `Context` 进行区分。

## 4. `KVO` 的注册依赖键

问题描述：一个属性的值是依赖于其它一个或多个其它对象的属性.如果一个属性的值更改，那么派生属性的值也应该被标记为更改.

例如某类有三个属性 

```
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
```

其中 `fullName` 值为 `firstName + lastName`

```
- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@",_firstName,_lastName];
}
```
 
当 `firstName` 或 `lastName` 被改变时,都要通知到那些观察 `fullName` 属性的对象.

##### 一种解决办法是：在添加监听的对象类重写 `keyPathsForValuesAffectingValueForKey:` 指明 `fullName` 属性是依赖于`lastName`和`firstName`属性的.

OC

``` objective-c
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"fullName"]) {
        NSArray *affectingKeys = @[@"lastName", @"firstName"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}
```

Swift

```swift
 override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if key == "fullName" {
            return Set<String>(arrayLiteral: "firstName","lastName")
        } else {
            return super.keyPathsForValuesAffectingValue(forKey: key)
        }
    }
```


或者实现 方法实现相同的目的
OC

```objective-c
+ (NSSet *)keyPathsForValuesAffectingFullName {
    return [NSSet setWithObjects:@"lastName", @"firstName", nil];
}
```

此 KVO 监听 `fullName` 属性时，当 `lastName`和`firstName`属性变化时也会调用

## 5. `KVO` 手动触发


```objc
显式的调用 willChangeValueForKey: 和 didChangeValueForKey: 方法
```

如果想实现手动通知，我们需要借助一个额外的方法

```objc
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
```

这个方法默认返回`YES`,用来标记 `Key` 指定的属性是否支持 `KVO`，如果返回值为 `NO`，则需要我们手动更新。



```objc
@implementation XWPerson

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@"name"]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

@end
```

在需要监听 `XWPerson` 处.

```objc
[person willChangeValueForKey:@"name"];
person.name = @"2";
/// 此时在 任意需要触发kvo的地方调用如下代码即可手动触发 KVO
[person didChangeValueForKey:@"name"];
```

