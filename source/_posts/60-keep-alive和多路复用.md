---
title: keep-alive与多路复用
index_img: /img/http.jpg
date: 2021-03-28 17:29:00
tags: [HTTP]
categories: [HTTP]
---

## HTTP 1.0
在HTTP1.0版本，存在一个问题：建立的一次连接，只有包含一个请求响应(也就是对应一个资源)。

如果有多个请求，那么效率就会很低。



![http1.0.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4c6190da97624831b3345130f2a98e0c~tplv-k3u1fbpfcp-watermark.image)


## HTTP 1.1
在HTTP 1.1 中 **connection: keep-alive** 是默认开启的
### 改进一：**连接复用**

一次连接，可以有多个请求响应（对应多个资源）。

![连接复用.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2348d9bf29144a04baf5e62a90cf3849~tplv-k3u1fbpfcp-watermark.image)




### 改进二：**增加流水线（pipeline）**

下一次的请求不需要等待上一个响应来之后再发送。

但响应的顺序是不变的，FIFO（先进先出）


![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cbc27b1a983e4f8d9ae43dbb35c5352f~tplv-k3u1fbpfcp-watermark.image)


依旧存在的问题：
- 请求是按次序的，后来者需要排队等待。
- 请求头大多类似，重复传输浪费资源。
- 同一域名的浏览器有最大并行请求限制。


## HTTP 2.0

### 多路复用

由于 HTTP 1.X 是基于文本的，因为是文本，就导致了它必须是个整体，在传输是不可切割的，只能整体去传。

但 HTTP 2.0 是基于二进制流的。有两个非常重要的概念，分别是**帧（frame）和流（stream）**

- 帧代表着最小的数据单位，每个帧会标识出该帧属于哪个流。
- 流就是多个帧组成的数据流。

将 HTTP 消息分解为独立的帧，交错发送，然后在另一端重新组装。
- 并行交错地发送多个请求，请求之间互不影响。
- 并行交错地发送多个响应，响应之间互不干扰。
- 使用一个连接并行发送多个请求和响应。

**简单的来说： 在同一个TCP连接中，同一时刻可以发送多个请求和响应，且不用按照顺序一一对应。**

之前是同一个连接只能用一次， 如果开启了keep-alive，虽然可以用多次，但是同一时刻只能有一个HTTP请求。


![多路复用.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d638d0ea6d734699b31ef18cf3e882b2~tplv-k3u1fbpfcp-watermark.image)

