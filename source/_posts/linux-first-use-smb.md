---
title: Samba的简单使用
tags:
  - Samba
categories: Linux
date: 2017-05-10 14:37:40
---

{% cq %}Samba是在Linux和UNIX系统上实现的SMB协议的一个免费软件，由服务器和客户端程序构成，简称smb。{% endcq %}

<!-- more --> 

跟FTP差不多，smb也是实现文件传输的。

### 环境

Red Hat Enterprise Linux 5 

### 安装

#### 检查是否安装

```bash
[root@localhost ~]# rpm -qa|grep samba
samba-common-3.0.33-3.14.el5
samba-3.0.33-3.14.el5
samba-swat-3.0.33-3.14.el5
samba-client-3.0.33-3.14.el5
```

如果显示为上面内容，代表samba已经安装。

#### 安装

rpm下载对应的安装包，然后安装。。平时一般都是用的centos，有空研究下red hat 的，只是学校机房电脑已经安装好了，所以我就省事了。

### 运行控制

开始、停止、重启、重新加载，smb.conf更改后要重启smb。

在windows文件管理器地址输入"\\\Linux ip地址"，若果访问不到的话，看一下防火墙及SeLinux。

```shell
service smb start|stop|restart|reload
```

开机自启动

```shell
chkconfig --leave 345 smb on|off
```

### 匿名文件共享

```shell
[public]
	comment = Public share directory
	path = /user/share/mydoc
	public = yes
	writable = yes
	guest ok = yes
```

### 非匿名文件共享

1. 创建Linux用户
   `useradd smb1`

2. 设置Linux密码
   `passwd kiuber`

3. 把Linux用户添加到smb用户
   `smbpasswd -a smb1`

4. 配置smb.conf
   ```shell
   [user]
   	comment = Public share directory
   	path = /user/share/mydoc
   	valid user = smb1
   	public = no
   	writable = yes
   	guest ok = no
   ```

5. 验证smb并重启smb

   ```shell
   testparm -v
   service smb restart
   ```

   ​

   ​

