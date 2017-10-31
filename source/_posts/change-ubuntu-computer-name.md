---
title: 修改 Ubuntu 计算机名
tags:
  - Linux
  - Ubuntu
  - hostname
date: 2017-10-30 20:39:35
categories: Linux
---

{% cq %}sudo vi /etc/hostname{% endcq %}

<!-- more -->

### 查看计算机名称
* windows ctrl + alt + t 打开终端，"@"后为主机名
* 终端输入 `hostname` 或 `uname -n` ，查看主机名

### 修改临时计算机名
终端下输入 `sudo hostname Ubuntu-Temp`
终端"@"后不会立即显示，但是用 `hostname` 查看或重新打开一个终端会生效，这种方法只能临时修改计算机名，重启计算机将恢复，但是登出用户不会失效。

### 修改永久计算机名
计算机名存放在 `/etc/hostname` 通过 `sudo vi /etc/hostname` 编辑器修改完保存即可，Ubuntu 自带的 vi 是不完整的，可能一直是输入命令模式，可以通过 `sudo apt-get install vim` 更新 vim 。


### 修改完名的坑
执行 `sudo` 命令时，可能会提示 `sudo: 无法解析主机：Kiuber-Ubuntu` 
原因是 `sudo` 其实是访问 `/etc/hosts` 127.0.0.1 的值，平时一般省略了，查看 hosts 文件发现还是之前计算机名，但是 hosts 文件修改需要用到 `sudo` ，果断查看 `sudo` 用法，果真有带 host 参数的命令。
执行 `sudo -h 原计算机名 vim /etc/hosts` 改为新计算机名，保存之后以后再用 `sudo` 又可以开心的省略 `host` 了。

