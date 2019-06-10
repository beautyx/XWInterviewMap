---
title: 《效率 - Mac 高效开发》
date: 2018-09-07 00:00
categories: [效率]
tags: [开发工具,效率]
---

# 效率 - Mac 高效开发
## 1.安装 Mac 包管理工具 `HomeBrew`

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

```
brew install wget # 安装 wget 工具
brew cask install wechat # 安装微信
```

<!-- more -->

## 2.系统配置
#### 2.1 输入大写字母时按住 shift + 相应字母，而不是 Caps Lock 
#### 2.2 交换 Caps Lock 和 Ctrl 位置

```
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0},{"HIDKeyboardModifierMappingSrc":0x7000000E0,"HIDKeyboardModifierMappingDst":0x700000039}]}'
```
上命令会立即生效，若想使程序启动即生效可创建名为 `com.jkxw.onlogin.plist` 的文件将其拷贝至 `~/Library/LaunchAgents` 下，文件内容如下：

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>LaunchOnlyOnce</key>
    <true/>
    <key>Label</key>
    <string>com.jkxw.onlogin</string>
    <key>ProgramArguments</key>
    <array>
        <string>zsh</string>
        <string>-c</string>
        <string>"$HOME/.macbootstrap/onlogin.sh"</string>
    </array>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
```
 然后执行如下命令使其对当前用户生效：
 
```
sudo launchctl load ~/Library/LaunchAgents/com.jkxw.onlogin.plist
```

#### 2.3 用好F1-F12
##### 例如 Xcode 断点调试指令：
* F6 执行下一行代码
* F7 跳到艾玛内部执行，比如当前停在一个函数上，F6会直接执行这个函数，F7则会跳到函数内部的第一行执行
* F8 跳出当前代码块，作用和F7相反

上述若在Mac自带键盘上点击需同时按 fn 和对应 F 键才能触发，若在外接键盘上直接点击 F 键可直接触发，如笔者的 ikbc 廉价机械键盘。若希望 Mac 自带键盘也直接点击 F 键直接触发，需在系统偏好设置 - 键盘 - 键盘 中设置 将 F 键作为标准按键，如图：
![20180907123241](http://p95ytk0ix.bkt.clouddn.com/2018-09-07-20180907123241.png)


更高效的使用命令行设置：

```
defaults write -globalDomain com.apple.keyboard.fnState -int 1
```

#### 2.4 关闭三方程序验证
若安装某些破解软件可能会报错 **无法打开已损坏的安装包** ， 可使用如下命令关闭这一保护

```
sudo spctl --master-disable  #允许安装所有软件
```

#### 2.5 显示/隐藏 系统隐藏文件
##### 显示
```
defaults write com.apple.finder AppleShowAllFiles -bool true
```

##### 隐藏
```
defaults write com.apple.finder AppleShowAllFiles -bool false 
```
运行命令行之后，`command + alt + esc` 重新启动 Finder（访达） 使其生效

#### 2.6 显示 Mac 开关机时间，有时需要知道什么时候可以打卡下班，这时输出电脑开机时间 + 法定工作时间就可以了
##### MacBook 上次开机时间

```
last | grep reboot
```
##### MacBook 上次关机时间

```
last | grep shutdown
```

#### 2.7 关闭镜像验证
打开 `.dmg` 默认会先验证镜像，如果文件很大需验证很长时间，如下命令可关闭验证:

```
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
``` 

#### 2.8 完全键盘控制
开启之后在弹出系统弹窗时可点击 Tab 键在多按钮直接切换，点击空格选中当前选项

```
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
```

#### 2.9 常用系统快捷键

* Ctrl + A：移动到行首
* Ctrl + E：移动到行尾
* Ctrl + K：删除到行尾
* Ctrl + N：移动到下一行
* Ctrl + P：移动到上一行
* Ctrl + F：向右（Forward）移动一个字母，等价于方向键 →
* Ctrl + B：向左（Backward）移动一个字母，等价于方向键 ←
* Ctrl + D：向右删除一个字母，等价于 → + Delete这个快捷键也很常用
* Ctrl + H：向左删除一个字母，等价于 Delete
* Option + ←：光标向左移动一个单词
* Option + →：光标向右移动一个单词
* Option + Delete：删除一个单词

#### 2.10 扩展预览程序

```
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize webpquicklook qlvideo provisionql quicklookapk

```
运行如上指令之后 再点击空格预览文件会有一些经验的效果，自行尝试

#### 2.11 自动隐藏 Dock

```
defaults write com.apple.dock autohide -bool true
```
手动显示/隐藏 Dock 快捷键：

```
command+option+d
```

## 3. Mac 工作流
#### 3.1 使用 iTerm2 代替终端
安装 iTerm2

```
brew cask install iterm2
```

配置
[
Mac终端配置，DIY你的Terminal （iTerm 2 + Oh My Zsh）](https://segmentfault.com/a/1190000012786464)
[配置iTerm2](https://laoshuterry.gitbooks.io/mac_os_setup_guide/content/4_ZshConfig.html)

#### 3.2 Alfred 利器
[Alfred 教程](https://www.jianshu.com/p/cf16b2c973e9)
 


