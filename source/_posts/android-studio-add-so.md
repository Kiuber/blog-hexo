---
title: Android Studio 添加so库引用
tags:
  - .so
  - Bmob
categories: Android
date: 2016-05-24 09:30:30
---

{% cq %}竟然是还得需要加so库引用。{% endcq %}

<!--more-->
最近打算更新[ShareMy](http://app.mi.com/detail/289957)，然后开源，开源肯定会让自己的代码更加规范、严谨。正在测试上传文件时，发现失败了，上传文件我是用的[Bmob SDK](http://www.bmob.cn/downloads)，去官网看了下发现SDK更新了，遂下载最新SDK–>解压–>导入SDK–>运行，结果发现就是有这样错误
`
java.lang.UnsatisfiedLinkError: Couldn't load bmob from loader dalvik.system.PathClassLoader[DexPathList[[zip file "/data/app/top.kiuber.sharemy-1.apk"],nativeLibraryDirectories=[/data/app-lib/top.kiuber.sharemy-1, /vendor/lib, /system/lib]]]: findLibrary returned null
`
google了下，还是找不到答案，最后突然想到so库需要导入，然后google了下，一种跟简单的方法可以添加so库引用。

* 在src–>main–>新建‘jniLibs’文件夹
* 把so库文件夹及文件夹内文件一同复制到jniLibs文件夹内
* 在MainActivity.java的onCreate方法中加入
  `
  // 库名, 注意没有前缀lib和后缀.so System.
  String libName = "bmob"; 
  loadLibrary( libName );
  `
* 调试看下就没问题了。
