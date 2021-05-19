---
title: methods中this指向问题
index_img: /img/this.png
date: 2021-05-18 17:05:00
tags: [HTTP]
categories: [HTTP]
---

## 前言

在看Vue文档时，提到了 methdos中的函数是不能使用箭头函数的

这其实在Vue文档中已经给出答案了，因为 箭头函数是没有this 的， 默认this指向是指向上一级作用域。

所有如果我们在methods中的函数使用箭头函数的话，那么this指向将会指向上一级作用域， 则就是 window了。

### 那么Vue是如何将methods中的函数this指向改变的？

我们在Vue源码中可以找到答案，通过对methods中的所有函数进行遍历，并且使用bind方法来绑定this

1. 先对methods对象中的所有函数进行遍历，将函数取出。
2. 并把函数中的this通过bind方法绑定到 publicThis 这个变量上
3. 而这个变量是 实例上的 proxy


![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/57485f5d5993448ea793dab98b8642a9~tplv-k3u1fbpfcp-watermark.image)
