---
title: hexo -g Killed
tags:
  - hexo
  - centos
  - linux
categories: hexo
date: 2017-11-01 20:55:04
---

{% cq %}hexo 生成静态文件时内存不足被杀死{% endcq %}

<!-- more -->

### 交换分区
交换分区（swap）是 Linux 虚拟内存分区，作用是在物理内存到达峰值时，将磁盘空间（swap）分区虚拟成内存分区使用，对用户看不可见。
在内存小于 2G 时，交换分区为内存的 2 倍，超过 2G 时，交换分区为物理内存加上 2G ，当然也可以适当增大。
交换分区为内存的 2 倍是一种以讹传讹的说法。如果交换分区的使用都超过 4GB 以上了，可想而知服务器的性能应该差很多了。
创建分区两种方式，一种是交换分区，一种是交换文件。前者适用于一般装系统时选择交换分区，有空的硬盘分区，后者适用于已装完系统，没有空的硬盘分区。

### 问题
hexo 生成的网站资源近 300 个，每次上传到服务器都很难受，并且多设备复制 hexo 文件贼麻烦，所以想通过 github 同步，然后各设备只需要安装 hexo ，尤其是通过 nvm 管理 nodejs 贼爽。
将 hexo 资源下载到 vps ，不幸的是执行 `hexo -g` 会出现错误，如下
```bash
INFO Start processing
INFO Files loaded in 1.2 s
Killed
```
没有出现想想中的一长串的文件名，猜想内存不够执行被中断。
查看 Killed 日志
`dmesg | egrep -i -B100 'killed process'`

或:
`egrep -i 'killed process' /var/log/messages`
`egrep -i -r 'killed process' /var/log`

或:
`journalctl -xb | egrep -i 'killed process'`

### 解决方案
> 内存不足，创建交互空间即可。
> https://cloud.tencent.com/document/product/362/3597

1. 查看系统当前的分区情况 `free -m` 或 `swapon -s`
2. 创建用于交换分区的文件，bs=4096 为一块区域字节数是 4096 ，count 为区域数 `dd if=/dev/zero of=/swap bs=4096 count=1572864`
3. 调整交换分区文件权限 `chmod 600 /swapfile`
4. 设置交换分区文件 `mkswap /swap`
5. 启用交换分区文件 `swapon /swap`
6. 若要想使开机时自启用，则需修改文件 `/etc/fstab` 中的 swap 行 `echo “LABEL=SWAP-sda /swap swap swap defaults 0 0” >> /etc/fstab`
7. 删除swap `swapoff /swap ; rm -f /Application/swap`

执行 `dd if=/dev/zero of=/swap bs=4096 count=1572864` 时需稍等一会，等待完成即可。
执行完上面就会在根目录建立 swap 文件作为交换分区，然后就能开开心心在 vps 用 `hexo -g` 了。
对于云服务器重装可能不会保留分区文件，所以到时还需重新配置。

---
参考
http://www.cnblogs.com/owenyang/p/4282283.html
https://www.oyohyee.com/post/Note/VPS_gengrator.html
http://blog.csdn.net/sunstars2009918/article/details/7274602
https://my.oschina.net/sukai/blog/654712