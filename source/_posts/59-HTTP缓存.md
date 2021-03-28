---
title: 一次弄懂HTTP缓存
index_img: /img/HTTP缓存.png
date: 2021-03-27 22:46:00
tags: [HTTP]
categories: [HTTP]
---

## 情况一:  **Cache-Control:max-age = 60 时**

![情况一.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0dbc063671b041349511e3beac85d0fe~tplv-k3u1fbpfcp-watermark.image)

##  情况二: **Cache-Control:max-age = 0 or no-cache 时**

![情况二.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1a9114f6864f4e73b3e2b5e1c6f47405~tplv-k3u1fbpfcp-watermark.image)


## HTTP缓存流程图


![HTTP缓存流程图.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/694ffc8bfd0743a98980b18510c57521~tplv-k3u1fbpfcp-watermark.image)


## HTTP缓存相关面试题

### 1.说一下浏览器的缓存机制（HTTP如何控制缓存的）
- 浏览器第一次向服务器发请求资源，服务器响应报文的状态是200，响应头会带上**Cache-Control、Etag**字段 。 浏览器收到响应后会把资源存到本地。
- 当浏览器再次发送请求获取该资源时，浏览器会先检查该资源是否过期（通过**Cache-Control:max-age = 时间**）。如果在时间内，就直接使用该资源。
- 如果时间过期，则发送请求询问该资源是否可以用。 请求头包含 **If-None-Match**，也就是之前响应报文中的 **Etag**。
- 服务器收到请求后通过  **If-None-Match**里的Etag和新计算的Etag做对比，**如果匹配，则直接返回一个状态码 304 ，不包含任何响应体报文**，告诉浏览器该资源可以用。 **如果不匹配，则返回一个状态码为200再带上 Cache-Control、Etag和原始资源的新报文**
- 如果不存在Etag，则用 Last-Modified 和 if-Modified-Since 做类似的判断。

### 2.Last-Modified、If-Modified-Since字段有什么作用？

俩个都表示资源的最后修改时间

Last-Modified 则是 是由服务器发送给客户端的HTTP请求头标签

If-Modified-Since 则是由客户端发送给服务器的HTTP请求头标签

**服务器可根据请求的文件修改时间和真实的文件修改时间做比较，来判断资源是否过期。**

### 3.Etag和If-None-Match字段有什么作用？

Etag相当于给资源生成了一个独一无二的标识，当资源被修改了，Etag就会改变。 作用和 Last-Modified 类似。

### 4.Last-Modified和Etag哪个更好？
二者的作用一样，但还有一些细微的差异
1. Last-Modified的单位是秒，如果一秒内对文件进行修改了，那么使用Last-Modified不变，而Etag一般会发生改变。
2. 语义上有差别， 一个是 文件的修改时间，一个是文件的唯一标识。
3. 使用 Last-Modified，浏览器会直接看到文件的修改时间，这个信息的暴露是不好的。


### 5.Expires字段是什么意思？
Expires是HTTP1.0版本的报文字段，代表资源的过期时间，如果设置了Cache-control: max-age=过期秒数，Expires会被忽略。

现在大多数使用Cache-Control替代

### 6.Expires和Cache-Control有什么区别？
1. **Expires的值代表一个GMT的时间点**，表示到什么时间点过期；
2. **Cache-control:max-age = value** ,这个value是以秒为单位的时间段，代表有效期是多少秒。
3. Cache-control可以设置更复杂的场景，比如：**Cache-control：no-cahce 、 no-store 、private**

最重要的一点，如果使用Expires，那么服务器告诉所有浏览器某资源在2021年11月11日到期，到了该时间点时，则需要该资源的每一个浏览器都会在同一时间发送请求。而用Cache-control，那么服务器告诉所有浏览器某资源各自存储365天，由于每一个浏览器请求的时间不一样，所以需要该资源的浏览器不会同时发请求。

### 7.Cache-Control: max-age=3600是什么意思？

就是服务器告诉浏览器，这个资源在本地缓存下来，如果再次需要该资源并且是在3600秒内，那么就不要发请求而直接使用该资源，如果超过3600秒，则发送请求向服务器询问是否能够继续使用。

### 8.Cache-Control: no-cache是什么意思？

相当于 max-age = 0, 就是告诉浏览器，收到这个资源先缓存下来，下次需要该资源时先向服务器确认该资源的有效性，再使用。


### 9.Cache-Control: no-store是什么意思？

告诉浏览器，不要缓存该资源。需要该资源时请求服务器，服务器会直接给新的。

### 10.Cache-Control: private、public分别是什么意思？
private是告诉中间的代理服务器不要缓存资源，只让目标浏览器缓存。

public表示任何情况下都能缓存。

### 11.Cache-Control: no-cache 和 Cache-Control: no-store 有什么区别？
一个是先缓存下来但不直接使用， 另一个是完全不缓存。

