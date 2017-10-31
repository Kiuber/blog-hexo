---
title: 在 Ubuntu 通过 nvm 安装 nodejs
tags:
  - Linux
  - Ubuntu
  - nodejs
date: 2017-10-30 22:10:00
categories: Linux
---

{% cq %}通过 nvm 管理 nodejs 贼鸡儿爽{% endcq %}

<!-- more -->
### 安装 nvm
nvm 是一个开源的 Node 版本管理器，通过简单的 bash 脚本来管理、切换多个 Node.js 版本,使用 nvm 可以安装官网最新版本之前的任意版本,可以任意切换不同版本，十分方便。

#### 下载并安装
`wget https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash insatll.sh`

#### 查看版本
`nvm -v`

### 更改 nvm 镜像
设置 `export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node`
查询结果 `echo $NVM_NODEJS_ORG_MIRROR`

### 安装 nodejs
可以通过 `nvm ls-remote` 查看可安装版本
执行 `nvm install 6.0.0` 安装会出现下面内容，也可以验证淘宝镜像是否配置正确
```bash
Downloading and installing node v6.0.0...
Downloading https://npm.taobao.org/mirrors/node/v6.0.0/node-v6.0.0-linux-x64.tar.xz...
```

### 使用 node
通过 `nvm install 6.0.0` 完成安装后默认就能用 node 啦，不过在下载了多个版本时可以用 `nvm use 版本号` 来随意切换版本。

### 配置 npm 镜像
在安装模块时，可以通过下面两种方式配置。
#### 临时使用
`npm --registry https://registry.npm.taobao.org install express`

#### 永久使用
`npm config set registry https://registry.npm.taobao.org`

尽情使用吧

