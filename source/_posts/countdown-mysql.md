---
title: 物品竞拍流程
tags:
  - 拍卖
categories: Android
date: 2016-09-01 23:51:20
---

{% cq %}最近这一个月一直在做齐鲁软件设计大赛的项目，参赛题目是智能手机程序设计，今晚终于有时间有心情静下来写写物品竞拍流程所遇到的坑。其实用了三天空闲时间写完的。=.={% endcq %}

其实用了三天空闲时间写完的。=.=

<!--more-->


## 具体的业务流程

A用户发起物品 -->倒计时开始-->其他用户交保证金-->开始竞拍出价-->五分钟内不能出价-->倒计时结束-->价高者胜出-->生成订单-->胜出者支付-->A用户发快递-->胜出者接收快递-->胜出者确认收货



## 具体分析

其中有7部分是主要的，看似复杂其实理清思路之后就是敲代码了。由于我们项目的数据是用的Bmob的，但是对于较大型的项目用第三方的平台确实是省了些硬件上的成本，但是从反面来说肯定也会增加代码的行数，毕竟用第三方的数据库不会由我们完全自定义。就这样数据分为两部分，文件数据及大部分数据保存在Bmob，一部分保存在自己的服务器。



> 为什么要自己搭服务器？

原因就是在业务流程上，当倒计时结束后既要将保证金退回，而且还要生成新的订单，用第三方的肯定实现不了服务器主动定时做一件事。

> 服务器系统怎样实现定时主动做一件事？（三种方式整理于网络）

+ ###### 在WebService中开启线程

+ ###### 利用服务器系统计划任务

+ ###### 利用数据库事件实现



## 三种方式

### 1.在WebService中开启线程

#### 在查找众多关于C#线程资料之后，有三种方法。#

+ Thread
+ Timer
+ Thread包下的Timer

三种方式中最后一种方式比较稳定，然后我将写好的WebService发布到服务器进行时间稳定性测试，结果发现最后一种5分钟内可以实现，40分钟将不能实现功能，因为业务需求中时间段最小还是6h，所以就没测试别的时间段。（PS：服务器系统参数 1G运内，1核，50G硬盘，只说参数不打广告 ): ）



### 2.利用操作系统（Windows）计划任务

计划任务程序位置： 控制面板-->系统和安全-->管理工具-->计划任务程序

桌面操作系统中有三种功能，分别是启动程序、~~发送电子邮件~~及~~显示消息~~。



### 3.利用数据库事件实现

#### 准备： mysql5.5（5.1之前无事件功能）VS xxxx Navicat11

Navicat这个软件是数据库可视化工具，对于SQL语句基础不怎么好的，软件中的SQL预览可以帮助你。

#### 思路

WebService	-->	Mysql Event	-->	Mysql Produce	-->	SQL Execute

#### 连接数据库

```c#
public class DBHelper{
	public static MySqlConnection ConnDB()
        {
            String mysqlStr = "Database=Commonweal;Data Source=127.0.0.1;User Id=root;Password=root;pooling=false;CharSet=utf8;port=3306;Allow User Variables=True;";
            MySqlConnection conn = new MySqlConnection(mysqlStr);
            conn.Open();
            return conn;
        }
}
```

其中，当你写的要执行的SQL语句中包含"@"会被C#当为参数化进行SQL语句组装，防止SQL语句注入。`Data Source=127.0.0.1`值也可以填服务器运营商提供的外网IP，还需要在Mysql新建一个用户，设置用户名、密码，为了安全最好设置访问服务器的具体IP。这样的话WebService在本地测试就行，测试完成之后发布到服务器就行了，很方便的。

#### 执行SQL语句

```C#
  string sql = @"insert into Good(G_ID, G_StartTime, G_EndTime, G_Status) values('" + ObjectId + @"', '" + NowTime + @"', '" + EndTime + @"', '1');
                CREATE EVENT `A_" + NowTime + r.Next(10, 100) + @"`
                ON SCHEDULE AT '" + EndTime + @"'
                ON COMPLETION NOT PRESERVE
                ENABLE
                DO
                CALL Pro_EndTime('" + ObjectId + @"');

                CREATE EVENT `B_" + NowTime + r.Next(10, 100) + @"`
                ON SCHEDULE AT '" + EndTime2Hours + @"'
                ON COMPLETION NOT PRESERVE
                ENABLE
                DO
                CALL Pro_EndTime2Hours('" + ObjectId + @"');;
                ";
                DBHelper.ExecuteSqlNoQuery(sql);

```
```C#
	public class DBHelper{      
 		 public static void ExecuteSqlNoQuery(string sql)
        	{
              MySqlConnection conn = ConnDB();
              MySqlCommand cmd = new MySqlCommand(sql, conn);
              cmd.ExecuteNonQuery();
              conn.Close();
       		}
    }
```

其中sql中@是转义不报错。

#### SQL中创建事件

##### 先说下刚开始的一种思路所带来的坑

**思路**  WebService-->Mysql事件-->事件中的多条Sql语句-->复杂的功能实现

用这种方法，在事件下要写很多sql语句，如下代码块，在查找众多国内外网站之后想要在事件里执行多条语句需要在多条sql语句最前面和最后面分别加**BEGIN和END**，而且还要在事件最前端和最后端加入delimiter $$和$$ 作为界限符，这样看来既像存储过程然而也不完全是存储过程。但是在Navicat中不会报错，然后我就天真的以为完成了，但是将代码完全复制到WebService，将一些参数拼接起来，执行后，报代码错误。。。。

```mysql
 				delimiter $$
				CREATE EVENT `事件名`
                ON SCHEDULE AT '时间点'
                ON COMPLETION NOT PRESERVE
                ENABLE
                DO
				BEGIN
                sql1;
                sql2
                sql3;
                ...;
				END;
				$$
```

##### 另辟蹊径

WebService-->Mysql事件-->事件调用存储过程-->复杂的功能实现

###### 坑1：

新建存储过程-->添加存储过程参数，参数类型长度不会自动指定，而且也没有要填写参数长度的"()"，然后就一直报错。

###### 坑2:

执行存储过程，当有varchar类型一定要加单引号！！



###### WebService

```c#
string sql = @"CREATE EVENT `A_" + NowTime + r.Next(10, 100) + @"`
                ON SCHEDULE AT '" + EndTime + @"'
                ON COMPLETION NOT PRESERVE
                ENABLE
                DO
                CALL Pro_Test('" + ObjectId + @"');
				";
```

###### Mysql

+ 事件

```mysql
CALL Pro_Test('IltR111A113')
```

+ 存储过程

```mysql
CREATE DEFINER = CURRENT_USER PROCEDURE `NewProc`(IN `id` varchar(20))
BEGIN
	UPDATE good_order
SET O_Status = '0'
WHERE
	O_ID = Good_ID;
END;
```



##### 小知识

###### Mysql

+ 查看当前是否已开启事件调度器


```mysql
SHOW VARIABLES LIKE 'event_scheduler'
```

+ 开启事件

```mysql
SET GLOBAL event_scheduler = 1; 
```

