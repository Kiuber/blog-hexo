---
title: 扒拉扒拉爱壁纸的图片资源
tags:
  - 爱壁纸
  - 抓包
categories: 瞎搞
date: 2016-12-18 09:27:10
---

{% cq %}是时候表演真正的技术了 =……={% endcq %}


<!--more-->

> 站点背景图是用的国外的unsplash，有的时候显示比较慢，所以想搞一个国内的。



去网上搜了下高清壁纸的，基本都是国外的，对比了下觉得这个[](https://alpha.wallhaven.cc/)觉得还可以，主要是图片质量与访问速度还算可以接受，于是用php写了对应的正则，爬取图片直链，在服务器上试了试下载时间，不怎么稳定，有的时候下载时间大概在15s左右！我接受不了！贴下php代码（新手）。

```php
<?php

$filename="https://alpha.wallhaven.cc/wallpaper/200000";
$subject=file_get_contents($filename);
$pattern = '<img id="wallpaper" src="(.*)" alt=".*"/>';

if (preg_match_all($pattern,$subject,$matches)) {
	$img_url = "http:".$matches[1][0];
	echo $img_url;
	$data = file_get_contents($img_url);
	date_default_timezone_set("UTC");
	$time = date('Y-m-d H:i:s',time());
	$pic_num = strrpos($img_url, "/");
	$filename = "wallhaven.cc".$time.substr($img_url, $pic_num+1);
	file_put_contents($filename, $data);
}
?>
```



最开始用爱壁纸的时候是高中，平时装系统也比较多，突然闲情雅致才会装个爱壁纸，不得不说爱壁纸里面图确实可以，图片质量与图片种类都还可以。



高中的时候弄过电脑截包，记得还得安装这个安装那个的，比较麻烦，碰到这种情况，想实现一个功能在一个平台需要弄很多东西可以换个平台试试，我确实喜欢Linux安装软件姿势，大部分软件依赖都有，没有的自己加上依赖就可以（不过我还没试），像Centos直接`yum install xxx`就可以，很快速的打几个字母的事情，软件就安装好了。

爱壁纸确实有Linux版的，不过高中的时候在手机上用过一个很好用的截包软件，想不起来叫什么名字了，网盘肯定也有，不过找的话肯定是有难度。然后去谷歌了下，很简单就找了[Packet Capture](http://www.coolapk.com/apk/app.greyshirts.sslcapture)下面也有汉化版的。



下面开始干活，昨晚这个时候已经是晚上1点了，对象刚回到家不一会，截包的时候对象也在给我发消息，列表中的包刷刷的过 = . =，截取之后停止截包就不会刷新了。



最终是要的高清图片直链，所以在停止截包之前我就下载了几张图片，一会分析的时候可以根据包的大小来确定下载是哪个包，当然也可以根据时间线确定。

先来几张截包图（不经常上qq，传文件也比较麻烦，等买个树莓派搭建个常年开机的本地磁盘）

{% img http://7xt9yd.com2.z0.glb.clouddn.com/image/Screenshot_2016-12-18-10-12-37-750_app.greyshirts.sslcapture.jpg 200 600%}{% img http://7xt9yd.com2.z0.glb.clouddn.com/image/Screenshot_2016-12-18-10-13-34-538_app.greyshirts.sslcapture.jpg 200 600%}{% img http://7xt9yd.com2.z0.glb.clouddn.com/image/Screenshot_2016-12-18-10-13-50-079_app.greyshirts.sslcapture.jpg 200 600 %}

从第一张图上可以根据包的大小或者时间来确定刚才下载图片的操作。

从二、三张图片上可以看到包的详情，将GET后的链接放到HOST上组起来就是新的网址，也可以看到响应头中的Content_Type确定哪种是我们需要的。刚才组起来的新网址就是我需要的，可以猜到第一长串数字是图片对应的编号，第二三长串就是图片的宽高。



至此爱壁纸的图片直链就搞到手了。截取到的包分析分析也挺有意思的，也可以看到CDN是用的哪家的，看看大公司他们对CDN的选取，对应CDN的ip是多少等等。