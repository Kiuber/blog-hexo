---
title: 微信小程序访问httpsAPI
tags:
  - https
categories: Wechat App
date: 2017-03-27 20:51:36
---

{% cq %}微信小程序在用户体验及用户信息安全方面确实做足了工作。{% endcq %}

<!--more-->

微信公众平台官网关于小程序介绍中，有一个单独的板块“设计”，这个板块是
专门统一用户体验的，包含了一些字体大小、图标大小、topbar的信息等。

安全方面微信API中明确说明开发者不能随便获取用户信息或者利用漏洞获取信息。
而且小程序只能请求在公众平台配置的域名。域名不能写子域名、端口号而且必须是https，但是在实际的开发中小程序是能对不同端口号访问的，但是不能对子域名访问可能是申请https证书的时候就是唯一的域名。

### 申请免费https证书
我之前买的一个域名是在阿里云买的，当然腾讯也有免费的证书服务，在阿里云购买证书的话阿里云会自动将证书解析添加到解析面板。

阿里云控制台-->安全（云盾）-->证书服务-->购买证书
选择 免费型DV SSL ，然后去支付0.00元。。
然后去证书服务控制台补全信息就行了~是不是很简单啊。

### 配置证书
证书服务下载证书中详细的不同的应用服务器配置文档。
有一个坑是 官方配置中密钥路径是不完全的，在实际密钥配置中要填写密钥全路径。
配置完成及得重启。
重启后tomcat第一次启动可能会特别慢，浏览器一直处于与服务器连接状态也不会拒绝访问，等第一次请求完成后，以后刷新浏览器直接相应到，本以为是网络原因但是nginx重启后能接着访问，就排除了网络原因。

实际上是tomcat在第一次启动时调用jvm的产生随机数,jvm是调用/dev/random产生随机数，这个/dev/random会返回小雨熵池噪声总数的随机字节，是同步阻塞式方法，假如熵池噪声数为空或者不够，tomcat就会一直卡在产生SessionID地方，自然而然卡住，直到产生足够的随机字节才能正常使用。

> /dev/random是同步阻塞式。
> /dev/urandom或/dev/./urandom是异步非阻塞式

可以通过更改tomcat的catalina.sh中加入这么一行：-Djava.security.egd=file:/dev/./urandom或/dev/urandom，更改java中的random方法，/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.121-0.b13.el7_3.x86_64/jre/lib/security/java.security中的securerandom.source=file:/dev/random改为/dev/./urandom或/dev/urandom，还有一种是增大噪音数。

贴一下自己tomcat的https配置部分。通过yum安装的tomcat的安装路径为/usr/share/tomcat，配置文件路径在/etc/tomcat，server.xml也在其中。
``` 
<Connector port="8443"
protocol="org.apache.coyote.http11.Http11Protocol"
keystoreFile="/etc/tomcat/cert/your-name.jks"
keystorePass="214055589090202"
maxThreads="150"
SSLEnabled="true"
scheme="https"
secure="true"
clientAuth="false"
sslProtocol="TLS" />
```

### 配置完成端口问题
正在学习，直接修改server.xml中配置端口号怎么修改都不行。修改重启完就拒绝访问了。

### 小程序访问服务器
考虑到WEB服务API可能会变化，所以把API地址放到了Bmob云逻辑里，这样小程序先获取BmobAPI地址然后再实现业务逻辑，这样就实现了不用更新小程序就可以发布最新的API地址，也可以做一个固定的API地址来存放其他变化的API地址。
```js
wx.request({
    url: address,
    header: {
        // "Content-Type":"application/json"
    },
    success: function (res) {
        console.log("服务器测试数据：" + res.data)
    },
    fail: function (err) {
        console.log(err)
        }
    })
```