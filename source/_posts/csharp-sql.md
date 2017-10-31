---
title: 'c#+sql'
tags:
  - SQL
categories: CSharp
abbrlink: ea671271
date: 2016-04-28 22:05:37
---

{% cq %}简单的C#连接数据库，并进行增删改查。{% endcq %}

<!--more-->
本文全部手打，目的是记录和复习下。
### 连接
```
string strConn = "data source = 127.0.0.1;initial catalog = 数据库名uid = sa;password = sa ";
SqlConncetion conn = new SqlConnection(conn);
conn.Open();
```
### 增删改查

#### 增加
```
string strSQL = "insert into 表名(列名1,列名2) values('value1','value2')";
```
#### 删除
```
string strSQL = "delete from 表名 where 列名 = 'value'"
```
#### 改变
```
string strSQL = "update 表名 set 列名 = 'new_value' where = 'old_value'";
```
#### 查询
```
string strSQL = "select * from 表名";
```
### 执行
`增删改`
```
SqlCommand cmd = new SqlCommand(strSQL,conn);
cmd.ExecuteNonQuery();

conn.Close();
```
