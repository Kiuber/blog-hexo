---
title: JAVA-WEB之Servlet
tags:
  - Servlet
categories: JAVA WEB
abbrlink: 884af78a
date: 2017-03-21 17:39:00
---

{% cq %}Java Servlet，是用Java编写的服务器端程序。 其主要功能在于交互式地浏览和修改数据，生成动态Web内容。{% endcq %}


<!--more-->

再学Servlet之前先了解基础的服务器相关。。

### Tomcat目录结构
/bin 存放各种平台下用于启动和停止服务器命令文件 （startup.bat开启服务器，shutdown.bat关闭）
/config 存放各种配置文件
/lib 存放服务器所需的JAR文件
/logs 没啥好说的
/temp 临时文件
/webapps 要发布的应用文件夹
/work 存放根据Servlet生成的字节码文件。

### WEB-INF目录
1.客户端无法访问其内部文件
2.web.xml为项目配置文件
3.classes文件夹用于放置*.class文件
4.lib文件夹用户存放jar包

### Tomcat容器等级
Tomcat的容器分为四个等级，Servlet的容器管理Context容器，一个Context对应一个Web工程。
                                                    -->Context
Tomcat-->Container容器-->Engine-->HOST-->Servlet容器
                                                    -->Context
### Servlet
Servlet（Server Applet），全称Java Servlet，是用Java编写的服务器端程序。 其主要功能在于交互式地浏览和修改数据，生成动态Web内容。

Servlet生命周期
Servlet 通过调用 init () 方法进行初始化。
Servlet 调用 service() 方法来处理客户端的请求。
Servlet 通过调用 destroy() 方法终止（结束）。
最后，Servlet 是由 JVM 的垃圾回收器进行垃圾回收的。

### Servlet简单使用
1.新建一个HelloServlet类继承HttpServlet
2.重写doGet()或者doPost()方法
3.在web.xml中注册Servlet
4.在jsp中写一个访问servlet的超链接

在一个请求当中，实际流程是 网页servlet别名-->web.xml中<servlet-mapping>的<url-pattern>--><servlet-name>访问<servlet>中的<servlet-name>中的<servlet-class>
也就是说假如前端是POST请求，查看网页源码可以看到ACTION的路径，但是这个路径一般不与类名相同，可以避免一些安全问题。

当然在工程右键直接新建一个Servlet，像MyEclipse这样的工具直接帮你写好web.xml的配置。


### Tomcat装载Servlet的三种情况

1.在web.xml中注册的。
	在<servlet></servlet>节点下添加<loadon-startup>1</loadon-startup>，中间数字越小优先级别越高。
2.在Servlet容器启动后，客户端首次向其发送请求。
3.Servlet类文件被更新后，将重新装载Servlet。

注：当Servlet容器把Servlet实例加载后将创建Servlet实例并调用init()方法，在整个Servlet整个生命周期内，init()方法只被调用一次且Servlet实例是常驻于内存的。

当第一次请求Servlet时：
Servlet容器实例化Servlet之后是-->构造方法-->init()-->doGet()或doPsost() 当服务器停止工作时执行onDestroy()方法。

当在web.xml中配置loadon-startup时
先执行数字小的Servlet，并且也是先执行构造方法然后执行初始化方法。

当项目已经部署到服务器且服务器正常工作时
修改源码会自动编译并且自动装载Servlet。

### JSP九大内置对象与Servlet

| JSP对象       | Servlet               |
| ----------- | --------------------- |
| out         | resp.getWrite         |
| request     | service方法中的req参数      |
| response    | service方法中的resp参数     |
| session     | req.getSession()方法    |
| application | getServletContext()方法 |
| exception   | Throwable             |
| page        | this                  |
| pageContext | PageContext           |
| Config      | getServletConfig()方法  |

### Servlet路径跳转
绝对路径：放之四海而皆准的路径
相对路径：相对于当前资源的路径

#### 1.jsp跳转到Servlet
相对路径：
下面第一个斜线是指服务器根目录，但是在<url-pattern>必须以斜线开头
<a href="/servlet/HelloServlet">访问HelloServlet</a>
绝对路径：
path变量代表的是项目的根目录
<a href="<%=path%>/servlet/HelloServlet"></a>
#### 2.Servlet跳转到JSP
请求重定向方式跳转到test.jsp，当前路径是ServletPathDirection/servlet
response.sendRedirect(resquest.getContextPath() + "/test.jsp");
服务器内部跳转,斜线代表项目根目录
request.getRequestDispatcher("/test.jsp").forward(request,response);