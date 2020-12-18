---
title: DOM事件&事件委托
date: 2020-12-11 17:45:00
index_img: /img/DOM.png
tags: JavaScript
categories: DOM
---

## 什么是DOM
> 文档对象模型（Document Object Model，简称**DOM**），是W3C组织推荐的处理可扩展标记语言（HTML 或者 XML ）的标准**编程接口**

**简言之，它会将web页面和脚本或程序语言连接起来。**


## DOM事件流
**事件流**描述的是从页面中接收事件的顺序

**事件**发送时会在元素节点之间按照特定的顺序传播，这个传播过程即**DOM事件流**

比如我们给一个div注册了点击事件：
1. 捕获阶段
2. 当前目标阶段
3. 冒泡阶段

![DOM事件流](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0a7520f235ca4f7bbd57a98f024ce46c~tplv-k3u1fbpfcp-watermark.image)


- **事件捕获：** IE最早提出的，事件开始由最具体的元素接受，然后逐级向上传播到DOM最顶层节点的过程。 
	- **即：从外向内找监听函数**
- **事件捕获：**  网景公司最早提出的，由DOM最顶层节点开始，然后逐级向下传播到最具体的元素的过程。 
	- **即：从内向外找监听函数**
    
 
 **举个栗子:**
 
我们向水里扔个石头，首先它会有个下降的过程、这个过程可以理解为捕获过程；之后会产生泡泡，然后漂流在水面上，这个过程相当于事件冒泡。

**代码验证:**

![代码验证](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7dec9eb77df04f08ad1659637ebbdfc5~tplv-k3u1fbpfcp-watermark.image)


### 特例

如果只有一个div被监听了， fn函数分别在捕获节点和冒泡节点监听click事件。
```js
div.addEventListener('click',f1)   // 冒泡
div.addEventListener('click',f2,true)   // 捕获
```
请问，谁先执行？
答案： 谁先监听谁先执行。

## 事件对象

```js
eventTarget.onclick = funciton(event){
	// 这个 evnet 就是事件对象，我比较喜欢缩写成 e 
}
eventTarget.addEventListener('click',function(event){
	// 这个 evnet 就是事件对象，我比较喜欢缩写成 e 
})
```
这个 event 是个形参，系统会自动帮我们设定改为事件对象，不需要传递实参过去。

当我们注册事件时，event对象就会被系统自动创建，并依次传递给事件监听器（事件处理函数）


### e.target  和 e.currentTarget 的区别

- **e.target：** 返回触发事件的对象。 **即用户操作的对象**。（假设：你点击了谁就是谁）

- **e.currentTarget :**  程序员监听的元素， **即你绑定了谁就是谁**

- **this就是e.currentTarget**



**打印一下就知道咯：**

![ e.target  和 e.currentTarget 的区别](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/451d59bd14e3404daa3756da8d2bd884~tplv-k3u1fbpfcp-watermark.image)


### 事件对象阻止默认行为

捕获是不可以阻止，取消的， 冒泡可以。

- `e.stopPropagation()`  可取消冒泡，浏览器就不再向上走了。
- `e.preventDefault()`可以取消默认事件


## 事件委托
**原理**：
`不是每个子节点单独设置事件监听器，而是事件监听器设置在其父节点上，然后利用冒泡原理影响设置每个子节点。`

**举个场景：**
比如给ul列表注册点击事件，然后利用事件对象的target来找到当前点击的li，因为点击了li，事件就会冒泡到ul身上，又因为ul有注册事件，就会触发事件监听器。

**作用：** 这样我们只操作了一次DOM， `省内存、可以监听动态元素`


### 如何监听一个不存在的元素？
可以利用事件委托，监听的父元素即可。

**代码展示：**
![事件委托](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ccd5af8ac2434fbc98fb6549bcd0dfb9~tplv-k3u1fbpfcp-watermark.image)


## 封装事件委托
**要求：**
写出一个函数 `on('click','#div1','button',fn)`   当用户点击`#div1`的button元素时，调用fn函数。要求用事件委托。

**代码展示：**
![](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e552062e345a44c69bcaa5a2774c1710~tplv-k3u1fbpfcp-watermark.image)
