---
title: Android Studio插件之ADB WIFI
tags:
  - ADB WIFI
  - Android Studio
categories: Android
abbrlink: 4c454898
date: 2016-06-11 12:12:44
---

{% cq %}甩掉数据线吧！前提手机需要Root{% endcq %}

<!--more-->
## 为Android Studio安装ADB WIFI插件
### 下载并安装
File-->Settings-->Plugins-->搜索“ADB WIFI”-->Reset Android Studio
{% img http://7xt9yd.com2.z0.glb.clouddn.com/image/QQ%E5%9B%BE%E7%89%8720160611135316.png 271 517 1 %}
{% img http://7xt9yd.com2.z0.glb.clouddn.com/image/QQ%E6%88%AA%E5%9B%BE20160611135513.png 887 276 2 %}
### 查看安装
Tools-->Android-->ADB WIFI
## 为真机安装ADB WIFI并开启端口
{% img http://7xt9yd.com2.z0.glb.clouddn.com/image/Screenshot_2016-06-11-13-55-45_com.youzi.adbwifi.png 450 800 3%}
### 安卓版ADB WIFI下载
[直接下载链接传送门](http://7xt9yd.com2.z0.glb.clouddn.com/apk/ADB%20WiFi_1.5.apk)
## 连接（手机电脑必须在同一局域网）
在Android Studio命令行输入手机ADB WIFI显示的IP地址，我手机的IP地址是192.168.31.231，所以输入`adb connect 192.168.31.231`
连接成功会有`connected to 192.168.31.231:5555`提示
再次输入`adb connect 192.168.31.231`会有`already connected to 192.168.31.231:5555`提示
{% img http://7xt9yd.com2.z0.glb.clouddn.com/image/QQ%E5%9B%BE%E7%89%8720160611135817.png 614 342 4%}