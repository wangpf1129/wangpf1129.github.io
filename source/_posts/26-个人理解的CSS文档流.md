---
title: 个人理解的CSS文档流
date: 2020-11-19 14:24:38
tags: css
index_img: /img/css.png
---
## css文档流
文档流，文档流，**`流`就是它最大的特点：`自适应`**。

那什么是文档流呢？ 顾名思义就是：像水流一样，倒入一个容器时，会自动充满容器。而css文档流的特性就是如此。

文档流有俩个比较重要的概念元素：`inline元素、block元素`，与之相对应的标签就是`span、div`。（还有一个是 inline-block 是前面俩个的结合）

那这俩个元素的区别在哪？  `inline元素`默认是水平排列。 而`block元素`默认会充满整个屏幕。你可以理解为`inline元素`就像是装着水的袋子（这个袋子的宽度会随着水的多少而发生变化）。`block元素`则像是一个装着水的瓶子（这个瓶子的宽度默认是整个屏幕。不管你瓶子中的水有多少，都会占满整个屏幕。）。

所以**要记住的是这种代表文档流的元素默认宽度不是100%，而是width：auto，它们的margin、border、padding可以自动分配空间**

因此建议不要写width：100%。为什么不建议呢？那是因为一旦你给元素添加了宽度属性，它就会失去文档流。即使是width:100% ，也是会失去的。

一旦，我们设置了固定的宽度，它就会根据CSS的盒模型进行计算，便失去了文档流的特点：自动分配空间的流动性。

根据上段的理解，你可以知道它们的宽度是这样规定的：
- inline元素的宽度为内部inline元素和（不能有block元素），不能用width指定
- block默认自动计算宽度，可用width指定
- inline-block元素结合前两者的特点，可用width

而高度的话，水就比较深了，这里不做过多的介绍，你可以直接记住下面的规则：
- inline 高度是由 line-height 间接确定，跟height无关
- block 高度是由**内部文档流元素决定**（因为脱离文档流的元素不算），可以设置height
- inline-block 跟 block 类似，可以设置height


## "变态"情况：
 **1.写一个span 、div ，里面不写内容会出现什么情况？**

结果如下：
![结果](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d1123ef6cacb4eaf81e0dcfd685ffc74~tplv-k3u1fbpfcp-watermark.image)

由上图可见，span元素（inline元素）是有高度的！，所以可以证明的是它的高度是由line-height决定的。


**2.overflow 溢出问题**

当我给div（block元素）设置固定高度，但是内容却超出这个高度，就会出现如下情况

![overflow 溢出问题](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8906035f86144d26b47595eb111b6a12~tplv-k3u1fbpfcp-watermark.image)

那么该怎么解决呢？ **用overflow**
- `overflow:hidden ` 干脆就直接让超出的内容隐藏了
- `overflow:auto `    不超出时，正常显示，超出时，就出现滚动条
- `overflow:scroll `   不建议使用，有auto好吗？ 它有的功能auto都有。
- 其他属性就不一一试了。


## 脱离文档流
> 先让我们回忆一下上文说到的文档流，block的高度是由内部文档流决定的，可以设置height，那么意思就是说有些元素是不在文档流中的。

哪些元素可以脱离文档流呢？
- 设置了 float
- 设置了 position:absolute/fixed
