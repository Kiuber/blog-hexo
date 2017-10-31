---
title: Centos 7.2 安装MySQL及Navicat远程连接
tags:
  - MySql
  - Navicat
categories: Linux
abbrlink: 34edd51d
date: 2016-09-22 20:18:13
---

{% cq %}阿里云ESC一个月10个大洋，是腾讯云的10倍。。但是突然相通了，10个大洋不就是一顿饭钱吗，于是速购一台linux。{% endcq %}

<!--more-->



# 系统版本

```shell
[root@iZm5eg56n6ff2an1422nazZ ~]# cat /etc/redhat-release 
CentOS Linux release 7.2.1511 (Core)
```



# MySQL安装

按照惯例执行以下三句

```shell
yum install mysql
yum install mysql-devel
yum install mysql-server
```

执行最后一句时会报这样错误

```shell
[root@iZm5eg56n6ff2an1422nazZ ~]# yum install mysql-server
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyuncs.com
 * epel: mirrors.aliyuncs.com
 * extras: mirrors.aliyuncs.com
 * updates: mirrors.aliyuncs.com
No package mysql-server available.
Error: Nothing to do
```

查资料之后发现Centos 7将MySQL数据库从默认程序列表中（yum源）移除，用mariadb代替了。

## 方法一 ：安装MariaDB

### 安装

**MariaDB**数据库管理系统是[MySQL](https://zh.wikipedia.org/wiki/MySQL)的一个分支，主要由开源社区在维护，采用[GPL](https://zh.wikipedia.org/wiki/GPL)授权许可。开发这个分支的原因之一是：[甲骨文公司](https://zh.wikipedia.org/wiki/%E7%94%B2%E9%AA%A8%E6%96%87%E5%85%AC%E5%8F%B8)收购了MySQL后，有将MySQL[闭源](https://zh.wikipedia.org/wiki/%E9%97%AD%E6%BA%90)的潜在风险，因此社区采用分支的方式来避开这个风险。

```shell
yum install mariadb-server mariadb
```

MariaDB数据库相关命令是：

systemctl start mariadb #启动MariaDB

systemctl stop mariadb #停止MariaDB

systemctl restart mariadb #重启MariaDB

systemctl enable mariadb #设置开机启动

### 开启

systemctl start mariadb

现在就可以使用了。

### 测试

初次安装MySQL，root账号没有密码。

```shell
[root@iZm5eg56n6ff2an1422nazZ ~]# mysql -uroot -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 3
Server version: 5.5.50-MariaDB MariaDB Server

Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
+--------------------+
4 rows in set (0.00 sec)
```

## 方法二

执行以下三句话，通过链接下载安装。

```shell
wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum install mysql-community-server
```

安装之后重启

```
service mysqld restart
```

##设置MySQL密码



```shell
mysql>set password for 'root'@localhost =password('newpwd');
Query OK, 0 rows affected (0.00 sec)
```

设置MySQL密码，不用重启。

# 远程连接设置

把在所有数据库的所在表的所有权赋值给位于所有IP地址的root用户。

```shell
mysql> grant all privileges on *.* to root@'%'identified by 'password';
```

如果是新用户而不是root，则要先新建用户

```shell
mysql> create user 'username'@'%' identified by 'password'; 
```

要想在Navicat远程，还需要最后一步，关闭防火墙。

```shell
systemctl stop firewalld
```

否则Navicat会提示"2003 - Cant connect to MySQL server on 'IP地址'(10060 "Unknown error")"

此时就可以进行远程连接了。



参考：

[http://www.cnblogs.com/starof/p/4680083.html](http://www.cnblogs.com/starof/p/4680083.html)
