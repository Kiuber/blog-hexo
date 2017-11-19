---
title: 正则复习
tags:
  - 正则
categories: Java
date: 2017-04-12 17:34:30
---

{% cq %}JAVA-pattern{% endcq %}

<!-- more -->

### 正则表达式实例

java.util.regex常用的三个类：

Pattern：pattern是正则表达式的表示，Pattern没有公共构造方法，要想创建一个Pattern对象需要调用其公共静态编译方法。

`Pattern pattern = Pattern.comoile(String regex)`

Matcher：Matcher是对输入的字符串进行解释及匹配，与Pattern类一样没有公共构造方法，需要调用Pattern对象的matcher方法来获得一个Matcher对象，参数为待匹配字符。

PatternSyntaxException：PatternSyntaxException是一个非强制异常类，表示正则表达式的语法错误。

```java
public static void main(String[] args) {
        String regex = ".*Kiuber.*";
        Pattern pattern = Pattern.compile(regex);
        String input = "i am Kiuber hello";
        Matcher matcher = pattern.matcher(input);
        System.out.println("是否匹配：" + matcher.matches());
        boolean matches = Pattern.matches(regex, input);
        System.out.println("是否匹配：" + matches);
    }
```



### 捕获组（分组）

捕获组是把多个字符当一个单独的单元处理，通过括号分别分组。

例如，正则表达式(dog)创建了一个单一分组，这个分组包含"d","o","g"。

捕获组是通过从左到右计算器开括号来编号的。

例如（（A）（B（C））），共分为四个组。

* （（A）（B（C）））
* （A）
* （B（C））
* （C）

可以调用matcher对象的groupCount方法查看表达式共有多少个分组

特殊：group(0)，代表整个表达式，该组不在groupCount返回值中。

```java
public static void main(String[] args) {
  		// A零次或一次 B零次或多次 C一次或多次
        String regex = "(A?(B*(C+)))";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern1.matcher("");
        int i = matcher.groupCount();
        System.out.println("组个数：" + i);
    }
```

输出"组个数：3"



### 正则表达式语法

|      字符       |         | 说明                                       |
| :-----------: | :-----: | ---------------------------------------- |
|       \       |         | 将其后字符标记为特殊字符，如"\n"匹配换行符，"\\\"匹配"\"，"\\("匹配"("。 |
|       ^       | shift+6 | 标记字符串起始。                                 |
|       $       | shift+4 | 标记字符串结束。                                 |
|       *       | shift+8 | 零次或多次匹配前面的字符或子表达式，如"zo*"匹配"z"和"zoo"，\*等于{0,} |
|       +       | shift+= | 一次或多次匹配前面的字符或子表达式，如"zo+"匹配"zo"和"zoo"，但是与"z"不匹配，+等于{1,} |
|       ?       | shift+/ | 零次或一次匹配前面的字符或子表达式，如"do(es)"匹配"do"和"does"，?等于{0,1} |
|      {n}      |         | n是非负整数，表示其前面的字符或子表达式正好匹配n次，如"o{2}"与"Bob"不匹配，但与"food"匹配 |
|     {n,}      |         | n是非负整数，表示至少匹配n次，如"o{2}"与"Bob"不匹配，但与"fooooood"匹配，当n=0时相当于"*"，n=1时相当于"+" |
|     {n,m}     |         | n和m都为非负整数，其中n<=m，至少匹配n次，至多匹配m次           |
|       ?       |         | 当此字符紧随任何其他限定符（\*、+、?、{\*n\*}、{*n*,}、{*n*,*m*}）之后时，匹配模式是"非贪心的"。"非贪心的"模式匹配搜索到的、尽可能短的字符串，而默认的"贪心的"模式匹配搜索到的、尽可能长的字符串。例如，在字符串"oooo"中，"o+?"只匹配单个"o"，而"o+"匹配所有"o"。 |
|       .       |         | 匹配除"\r\n"之外的任何单个字符，若要匹配的包括"\r\n"，使用[\s\S]。 |
|   (pattern)   |         |                                          |
| (?:*pattern*) |         |                                          |
| (?=*pattern*) |         |                                          |
| (?!*pattern*) |         |                                          |
|     x\|y      |         | 匹配x或y，"z\|food"匹配"z"或"food"，"(z\|f)ood"匹配"zood"或"food" |
|     [xyz]     |         | 字符集。匹配中括号中的任一字符，如"[abr]"匹配"Kiuber"中的"r"  |
|    [^xyz]     |         | 反向字符集。匹配未包含的任何字符，如"\[^abr\]"匹配"Kiuber"中的"K"，"i"，"u"，"b"，"e" |
|     [a-z]     |         | 字符范围                                     |