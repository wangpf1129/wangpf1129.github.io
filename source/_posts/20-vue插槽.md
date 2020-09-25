---
title: vue插槽
date: 2020-09-25 16:11:36
index_img: /img/vue.jpg
tags: vue
categories: vue
---
# 编译作用域⭐

![image-20200922160708539](https://i.loli.net/2020/09/25/9Zuw71bqsycSd8H.png)



**根据以上图片代码， 可知 最后渲染出来的是 使用Vue实例的属性**

结论： 

- 官方给出了一条准则：**父组件模板的所有东西都会在父级作用域内编译**， **子组件模板的所有东西都会在子级作用域内编译**
- 而我们在使用<my-cpn v-show="isShow"></my-cpn>的时候，整个组件的使用过程是相当于在父组件中出现的。
- 那么他的作用域就是父组件，使用的属性也是属于父组件的属性。
- 因此，isShow使用的是Vue实例中的属性，而不是子组件的属性。



# solt插槽的基本使用⭐

![image-20200922161624398](https://i.loli.net/2020/09/25/miSdjr5DNvCsH2O.png)



## 1 具名插槽

- 当子组件的功能复杂时，子组件的插槽可能并非是一个。
  - 比如我们封装一个导航栏的子组件，可能就需要三个插槽，分别代表左边、中间、右边。
  - 那么，外面在给插槽插入内容时，如何区分插入的是哪一个呢？
  - 这个时候，我们就需要给插槽起一个名字
- 如何使用具名插槽呢？
  - 非常简单，只要给slot元素一个name属性即可
  - <slot name='myslot'></slot>

![image-20200922161821227](https://i.loli.net/2020/09/25/R12MJtQkvG5TErA.png)



## 2 作用域插槽

> 因为编译作用域的关系， 各个组件只能使用自己组件内的数据， 如果 父组件 使用插槽 想把子组件数据一并一起拿过来用怎么办？ 这时候就需要用 作用域插槽了

**简单一句话：作用域插槽就是：父组件替换插槽的标签，但是内容（数据）是由子组件来提供。**



-  **1.子组件 插槽 slot 动态绑定  把data中的 `数据`** 

![image-20200922163245338](https://i.loli.net/2020/09/25/EUPKAL7rYBFXZve.png)





- 2.**父组件使用我们的子组件时，从子组件中拿到数据：**
  - **我们通过<template slot-scope="slotProps">获取到slotProps属性**
  - **在通过slotProps.data就可以获取到刚才我们传入的data了**



![image-20200922163259955](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20200922163259955.png)

