---
title: 微信小程序开发小记
tags:
  - 山东微拼
categories: Wechat App
date: 2017-03-12 10:50:20
---

{% cq %}微信小程序开发小记{% endcq %}

<!--more-->

小程序从注册到上线确实是很严格，感觉小程序并不是很火，可能是相比小程序App用的比较多，小程序的出发点是发展线下推广，即扫即用，所以就目前API来说 不能分享到微信朋友圈，而且打开小程序不能通过长按二维码图片进入，比较好的线上宣传方式就是小程序右上角的分享了，分享到朋友或微信群其他人就可以直接点击进入。

这里就不说基本的东西，基本的语法什么的可以去看公众平台，大部分是js跟css的东西。

下面就说下遇到的坑还有一些经验吧。

1. 写好的页面要在app.json中注册，app.json就相当于Android中的Manifest.xml文件，管着整个应用的。
2. 某文件父文件夹有几个就写几个"../"可以退到对应文件夹。
3. 在外层声明var that = this;可以在内层间接获取到this的数据。
4. 页面中控件位置可以用css来控制，所以css要学好。
5. 适当运用data-key这个属性，可以在wx.perview时用到。 
6. 小程序不能分享到朋友圈也不能长按二维码图片进入。
7. 小程序不支持http访问，而且访问公网的网站必须要在小程序官网配置上。
8. 小程序审核时间在两天左右，周六周天不审核，感觉审核门槛还不算特别高。

待补充~
