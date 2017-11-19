---
title: 搭建本博客所看的网站及知识
tags:
  - 搭建博客
categories: Hexo
date: 2016-04-24 11:30:53
---

{% cq %}汇总一下，希望对以后自己动手搭建博客的伙伴们有帮助。{% endcq %}

<!--more-->
http://ibruce.info/2013/11/22/hexo-your-blog/
https://xuanwo.org/2015/03/26/hexo-intor/
http://blog.fens.me/hexo-blog-github/
http://www.v2ex.com/t/175940
http://www.jianshu.com/p/465830080ea9
http://www.jianshu.com/p/2640561e96f8
http://www.jianshu.com/p/739bf1305e66
http://www.liuhaihua.cn/archives/180154.html
http://www.jianshu.com/p/7ad9d3cd4d6e
http://chitanda.me/2015/06/11/tips-for-setup-hexo

http://qjzhixing.com/tools/
http://zipperary.com/about/
http://sconfield.github.io/

https://github.com/chuangwailinjie/chuangwailinjie.github.io/blob/master/404.html
https://github.com/MOxFIVE/hexo-theme-yelee
http://www.tuicool.com/articles/AfQnQjy/

http://www.tuicool.com/articles/Nnuyu2A
http://blog.fens.me/hexo-blog-github/

详细语法
http://wowubuntu.com/markdown/
在线markdown
http://markdown.xiaoshujiang.com/
http://dillinger.io/
https://www.zybuluo.com/mdeditor

下面是自己搭建博客的主要代码
创建公钥
`ssh-keygen -t rsa -C "your_email@youremail.com" `
安装Hexo
`npm install hexo-cli -g`（速度慢的话 用`npm install -g cnpm --registry=https://registry.npm.taobao.org`下面的`npm`都用`cnpm`）

`npm install hexo --save`

`hexo -v`

初始化Hexo
`hexo init`

`npm install`

首次体验Hexo（http://localhost:4000/）

`hexo s`

`hexo g`


配置Deployment
`git config --global user.name "yourname"`
`git config --global user.email "youremail"`

`hexo d`(如果报错，`npm install hexo-deployer-git --save`)



设计
http://www.zcool.com.cn/
http://www.uimaker.com/