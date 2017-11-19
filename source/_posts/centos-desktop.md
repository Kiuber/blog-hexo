---
title: Centos 7 安装图形化界面并实现远程控制
tags:
  - 远程连接
categories: Linux
date: 2017-03-13 14:40:06
---

{% cq %}使用teamviewer远程服务器{% endcq %}

<!--more-->

### 安装图形化界面

1. 安装环境

   <!-- ```# 先安装MATE Desktop``` -->

   `yum groups install "MATE Desktop"`

   `安装好MATE Desktop后，再安装X Window System,最好等待上一步安装完成后再执行这一步。`

   `yum groups install "X Window System"`

   ​

2. 设置默认通过桌面环境启动服务器

   `systemctl set-default graphical.target`

3. 重启一下服务器然后登陆服务器运营商在线网页就能看到图形化界面了。

   `reboot`

   ​

### 安装teamviewer

1. 下载安装包

   >方法一：从[官网](https://www.teamviewer.com/zhcn/download/linux/)下载安装包rpm安装包，然后传到服务器。
   >
   >方法二：`wget https://download.teamviewer.com/download/teamviewer.i686.rpm

2. 使用yum安装

  `yum install 包路径`
3. 开启teamviewer

   ​  在网页上打开teamviewer，第一次打开会有个协议需要接受，所以在命令行打不开。如果不把图形化界面设置为默认启动方式，关闭网页后teamviewer自动关闭连接。
