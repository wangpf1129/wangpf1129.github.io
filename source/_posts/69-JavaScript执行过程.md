---
title: JavaScript执行过程
index_img: /img/JavaScript高级.png
date: 2021-11-04 18:22:00
tags: [JavaScript高级]
categories: [JavaScript高级]
---

## JavaScript 执行过程

假设有以下一段代码：

```js
var username = 'wpf'
var num1 = 1
var num2 = 2
var sum = num1 + num2
```

接下来，我们要以 js 引擎和内存的角度来去分析 JavaScript 的执行过程

### setp1:初始化全局对象

首先，我们先认识一下 全局对象： `Global Object`

JavaScript 引擎在执行代码之前，会在堆内存中创建一个全局对象：`Global Object` 简称 **GO**

- 该对象 **所有的作用域** 都可以访问
- 该对象中包含有 **Date、Array、String、Number、setTimerout** 类和函数等
- 其中还有一个 **window** ， 而他是指向的是自己，也就是 **GO** （所以你打印 `console.log(window.window.window)`是会发现依然是自己）

### step2: 执行上下文栈 （调用栈）

JavaScript 引擎内部有一个**执行上下文栈（Execution Context Stack**，简称 ECS），它是用于执行代码的调用栈。

而它执行的就是 全局的代码块

- 全局的代码块为了执行会构建一个 **Global Execution Context** （GEC 全局执行上下文）
- GEC 会 被放入到 ECS 中执行

GEC 被放入到 ECS 中包含俩部分内容：

1. 代码执行前，在 **parse** 转成 **AST** 的过程中， 会将 **全局定义的变量、函数**等加入到 **GO** 中，但是并**不会赋值**
   - 这个过程也称之为 **变量的作用域提示** `hoisting`（ 是不是很熟悉~）
2. 在代码执行中，对变量赋值，或者执行其他的函数

#### 图解分析：

##### 1. GEC 全局执行上下文中有一个 **variable object 简称 VO（变量对象）**，这个 VO 指向的其实就是全局对象 GO，之后编译完毕就会开始执行全局代码了

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/202663526a994d7d984038708a4f02ee~tplv-k3u1fbpfcp-watermark.image?)

##### 2. GEC 开始执行代码

```JS
var username = 'wpf'
var num1 = 1
var num2 = 2
console.log(sum)
var sum = num1 + num2
```

我们都知道 第四行代码 sum 是 undefined ， 也知道因为是作用域提升， 那么为什么会提升呢？ 接下俩就看看这段代码是如何执行的

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4cd32cd5b30745da9649e7efdefbeeb6~tplv-k3u1fbpfcp-watermark.image?)

那接下来真正开始执行了

代码是从上到下一行一行开始执行的，**开始： username 从 undefined => 'wpf'，num1 从 undefined => 1，num2 从 undefined => 2，打印 sum 变量，GO 中有 sum 是 undefined，所以打印出来的 sum 是 undefined，然后 result 被赋值为： 1+2 = 3**

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/187a4ea1ec2c4c19b35e0c9b81cef0e1~tplv-k3u1fbpfcp-watermark.image?)

**Q1: 如果遇到函数怎么办呢？**

在执行的过程中执行到一个函数时，就会根据函数体创建一个**函数执行上下文（Functional Execution Context，**
**简称 FEC）**，并且压入到 EC Stack 中。

FEC 中包含三部分内容：

1. 在解析函数成为 AST 树结构时，会创建一个 Activation Object（AO ）：AO 中包含形参、arguments、函数定义和指向函数对象、定义的变量；
2. 作用域链：由 VO（在函数中就是 AO 对象）和父级 VO 组成，查找时会一层层查找；
3. this 绑定的值：关于这个知识点，后续我再专门写一篇；

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/43de3bc656504186bb053746ac443dd6~tplv-k3u1fbpfcp-watermark.image?)

当我们创建了一个函数的时候，堆内存中就会创建一个函数对象来存储，函数对象中存储着很多东西，这里我就选两个比较重要的

- 一个叫做 parent scope（父级作用域）
- 一个是函数的执行体

执行函数前也会有一个解析：VO 指向的是一个叫做 AO 的活跃对象，那么真正执行函数前会在堆内存就会创建一个叫做当前函数的 AO 对象，然后会解析函数内的代码，

用以下代码为例：

```js
var bar = 111
function foo() {
  var bar = 123
  console.log(age)
}
foo()
```

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f8f7f3b50b0147ad9b1bd53f49e6403b~tplv-k3u1fbpfcp-watermark.image?)

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/92b2ab08e87d4e7e9b4098ef6ac94ad5~tplv-k3u1fbpfcp-watermark.image?)

当执行函数的时候遇到对变量进行操作的时候，这个时候函数 VO 中会有一个作用域链：当前 VO+parent scope 父级作用域进行查找，如果父级作用域也没有找到，就会一层一层往上找，直到在全局 GO 中还没有找到就会报错

当函数执行完毕之后，函数执行上下文 FEC 会弹出栈，也就是销毁了，那么函数的 VO 指向的 AO 这条线是不是也应该没有了

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e05dbc262d204d1491c4f6a44a1bbe93~tplv-k3u1fbpfcp-watermark.image?)

### 经典面试题

> 有句话说得好： 了解真相才能获得真正的自由

**Q1:**

```js
var n = 100
function foo() {
  n = 200
}
foo()
console.log(n)
```

**A1:** 200

**Q2:**

```js
function foo() {
  console.log(n)
  var n = 200
  console.log(n)
}
var n = 100
foo()
```

**A2:** undefined 200

**Q3:**

```js
var n = 100
function foo1() {
  console.log(n) // 100
}

function foo2() {
  var n = 200
  console.log(n) // 200
  foo1()
}
foo2()
console.log(n) // 100
```

**A3:** 200 100 100

**Q4:**

```js
var a = 100
function foo() {
  console.log(a)
  return
  var a = 100
}
foo()
```

**A4:** undefined

**Q5:**

```js
function foo() {
  var a = (b = 100) //  ==>  var a =100; b =100
}
foo()
console.log(a)
console.log(b)
```

**A5:** 报错 （如果把 console.log(a) 注释掉 那么 会打印 100）
