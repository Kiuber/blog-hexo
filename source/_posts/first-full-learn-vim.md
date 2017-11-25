---
title: 初次比较完整地学习 vim
tags:
  - vim
date: 2017-11-19 12:29:17
categories: Linux
---

{% cq %}![vim](http://www.runoob.com/wp-content/uploads/2015/10/vi-vim-cheat-sheet-sch.gif){% endcq %}

<!-- more -->

> http://blog.ihipop.info/2011/01/2026.html
> http://www2.geog.ucl.ac.uk/~plewis/teaching/unix/vimtutor
> https://github.com/wjp2013/the_room_of_exercises/blob/master/%E8%AF%BB%E4%B9%A6%E7%AC%94%E8%AE%B0/vimtutor/30%E5%88%86%E9%92%9F%E5%AD%A6%E4%BC%9Avim%E4%B9%8Bvimtutor(%E5%8F%8C%E8%AF%AD%E7%89%88).txt
> https://blogs.gnome.org/raywang/2007/01/29/%E9%AB%98%E6%95%88%E7%8E%87%E7%BC%96%E8%BE%91%E5%99%A8-vim%EF%BC%8D%E6%93%8D%E4%BD%9C%E7%AF%87%EF%BC%8C%E9%9D%9E%E5%B8%B8%E9%80%82%E5%90%88-vim-%E6%96%B0%E6%89%8B/

我认为 vim 的强大之处在于拥有多个命令，并且将命令组合起来使用，效率贼高。
查看帮助 :help command ，下面是我在通过 vimtutor 学习过程中在其基础上根据命令分类的。

### 游标移动
* 向左、向右移动 n  h、l ([number] motion)
* 向上、向下移动 n  k、j ([number] motion)
* 向左上 h、k
* 到行首包含空格0
* 到行首不包含空格 ^
* 到行尾 $
* 到 n 个单词首 nw ([number] motion)
* 到游标所在单词尾 e
* 到文本首 gg
* 到最后一行首 G


### 进入插入模式
* 在游标前面添加 i
* 在游标后面添加 a
* 在游标所在行的前一行插入 O
* 在游标所在行的后一行 o


### 删除
* 删除游标所在字符 x 或 delete


#### 删除跟游标移动相结合
* 只列举几个，触类旁通
* 删除左边 dh 删除右边 dl
* 删除到行首 d0
* 删除 x 个单词 dnw 或 ndw (d [number] motion)


### 恢复
* 一步一步恢复 u
* 直接恢复到初始 U
* 撤销恢复，与 u 产生的影响相对 ctrl + r


### 粘贴
p


### 当前游标替换
r


### 变更操作码
类似删除命令，删除后并进入到插入模式
* 删除 n 个单词并定位到插入模式 cne (e [number] motion)


### 文件位置及状态
ctrl + g


### 搜索文本
* 忽略大小写 :set ic
* 禁止忽略大小写 :set noic
* 最简单的搜索(文本首开始) / + 文本内容
* 最简单的搜索(文本末开始) ? + 文本内容
* 搜索结果下一个、上一个 n 、 N
* 返回到之前的位置 ctrl + o
* 继续到下一个 ctrl + i
* 括号匹配 %


### 替换
* 全局将 old 替换成 new :/old/new/g


### 执行外部命令
* 在当前窗口显示 pwd 目录文件下内容 :!ls
* 另存为 :w new_file.txt
* 删除另存为 :!rm new_file.txt

### 选择文本
* 选择文本存入新文件 按下 v ，调整游标，选择完成后按 : 出现 :'<,'> ，在其后输入w new_file1.txt

### 将外部文件或外部命令结果插入到当前文件
* :r filename
* :r !ls

### 复制
* 选择文本复制 v -> y
* 复制 n 单词 ynw (y [number] motion)