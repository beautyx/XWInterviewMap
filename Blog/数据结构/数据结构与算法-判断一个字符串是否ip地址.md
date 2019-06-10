
---
title: 数据结构与算法-判断一个字符串是否ip地址
date: 2018-07-16 
categories: 数据结构 
tags: 数据结构
photos:  
---

## 算法-判断一个字符串是否是ip地址?
如何判断一个IP是否是合法的IP，如输入：192.168.1.0，输出：合法；输入192.168.1.1222，输出：非法。
<!-- more -->
首先明确IP的格式：(1~255).(0~255).(0~255).(0~255)

下面使用两种不同的方式进行验证：方案一为字符串处理，方案二为正则表达式处理

### 方案一：使用字符串判断

```
- (BOOL)ipIsValidity1:(NSString *)ip {
//    (1~255).(0~255).(0~255).(0~255)
    if (!ip || ip.length < 7 || ip.length > 15) {
        return NO;
    }

    //首末字符判断，如果是"."则是非法IP
    if ([[ip substringToIndex:1] isEqualToString:@"."]) {
        return NO;
    }
    if ([[ip substringFromIndex:ip.length - 1] isEqualToString:@"."]) {
        return NO;
    }

    NSArray <NSString *> *subIPArray = [ip componentsSeparatedByString:@"."];
    if (subIPArray.count != 4) {
        return NO;
    }

    for (NSInteger i = 0; i < 4; i++) {
        NSString *subIP = subIPArray[i];

        if (subIP.length > 1 && [[subIP substringToIndex:1] isEqualToString:@"0"]) {
            //避免出现 01.  011.
            return NO;
        }
        for (NSInteger j = 0; j < subIP.length; j ++) {
            char temp = [subIP characterAtIndex:j];
            if (temp < '0' || temp > '9') {
                //避免出现 11a.19b.s.s
                return NO;
            }
        }

        NSInteger subIPInteger = subIP.integerValue;
        if (i == 0) {
            if (subIPInteger < 1 || subIPInteger > 255) {
                return NO;
            }
        }else{
            if (subIPInteger < 0 || subIPInteger > 255) {
                return NO;
            }
        }
    }
    return YES;
}
```

### 方案二：使用正则表达式
验证IP是否合法的正则表达式：

* //String ipRegEx = "^([1-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))(\\.([0-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))){3}$"
* //String ipRegEx = "^([1-9]|([1-9]\\d)|(1\\d{2})|(2[0-4]\\d)|(25[0-5]))(\\.(\\d|([1-9]\\d)|(1\\d{2})|(2[0-4]\\d)|(25[0-5]))){3}$"
* //String ipRegEx = "^(([1-9]\\d?)|(1\\d{2})|(2[0-4]\\d)|(25[0-5]))(\\.(0|([1-9]\\d?)|(1\\d{2})|(2[0-4]\\d)|(25[0-5]))){3}$"


```
- (BOOL)ipIsValidity2:(NSString *)ip {
    NSString  *isIP = @"^([1-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))(\\.([0-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))){3}$";
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:isIP options:0 error:nil];
    NSArray *results = [regular matchesInString:ip options:0 range:NSMakeRange(0, ip.length)];
    return results.count > 0;
}
```

