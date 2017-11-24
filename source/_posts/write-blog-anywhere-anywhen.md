---
title: 我的博客同步方案
tags:
  - hexo
date: 2017-11-24 14:17:16
categories: hexo
---

{% cq %}![solution](http://iss.kiuber.me/blog/hexo/my_blog_sync_solution.png){% endcq %}

<!-- more -->
下面介绍下自己博客多设备同步方案。

### 自己的方案
无论是自己的电脑还是公司的电脑还是其他电脑，通过 `github` 仓库来控制博客的源文件，然后多台电脑通过 `pull` or `push` 进行同步。

选择 github 作为版本控制原因如下
+ 保存源文件，再也不用通过各种存储设备拷过来拷过去了；
+ 可追溯以及自己的服务器不稳定；
+ 增加文章曝光度。

写完文章后，在服务器本地仓库通过 `hexo g` 生成文件，将 `public` 文件下内容拷贝到 `nginx` 对应路径。

在一台空空如也的电脑上，需要安装 `git` 、 `nodejs` 、 `hexo` 。

#### 安装 git
可以通过 [git 官网](https://git-scm.com/) 提供的安装包进行下载安装，不多说。

#### 安装 nodejs
有很多方法，可以直接安装包安装也可以通过 `nvm` 下载管理 `nodejs` 版本，当然也有很多代理 `npm` 工具，eg: `cnpm` 、 `yarn` 。
个人推荐 `nvm` 来安装 `nodejs` 。
+ 直接从网站下载，[中文网站](http://nodejs.cn/) ，[英文网站](https://nodejs.org/en/)
+ 通过 `nvm` 安装任意 `nodejs` ，方便切换任意 nodejs 版本 ，[开源地址](https://github.com/creationix/nvm) ，Linux 安装教程可参考 [在 Ubuntu 通过 nvm 安装 nodejs](http://blog.kiuber.me/2017/10/30/install-nodejs-on-ubuntu-by-nvm/) ，Windows 可下载 [nvm-windows](https://github.com/coreybutler/nvm-windows/releases)发布版本下载安装，可参考 [nodejs在windows下的安装配置(使用NVM的方式)](http://blog.csdn.net/tyro_java/article/details/51232458) 教程安装。

下载 nvm 源码本地编译可阅读这篇文章[快速搭建 Node.js 开发环境以及加速 npm](https://cnodejs.org/topic/5338c5db7cbade005b023c98)

#### 安装 hexo
1. 任意路径 `npm install hexo-cli -g`
2. 克隆的博客项目 `npm install`
3. 验证一下 `hexo server`

### 可以搞一搞
程序员不甘于进行重复工作，于是就想办法解（tou）决（lan）。
写个 `bash` 脚本，每天某个时间定时 `git pull` ，文件发生更改后 `hexo g` ，并将文件复制到 `nginx` 对应文件夹内。
这样写好文章只 push 就 OK 了，爽歪歪。