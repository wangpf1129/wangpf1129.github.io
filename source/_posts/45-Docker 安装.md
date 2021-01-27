---
title: node.js中使用nodemailer插件发送邮件 (学习总结)
index_img: /img/docker.jpg
date: 2021-01-09 10:33:00
tags: [Docker]
categories: [Docker]
---

## 前言
**我使用是的window10系统**

由于学Node.js ，刚刚接触到数据库， 需要Docker来搭配。 

## 安装
1. 首先要去Docker官网注册一个账号->[注册地址](https://hub.docker.com/)
2. 下载 Docker Desktop for Windows -> [下载地址](https://hub.docker.com/editions/community/docker-ce-desktop-windows/)
3. 傻瓜式安装即可


## 坑1 
下载完成后必须要重启， 可我重启后点开时，发现报错
忘记截图了， 就找到响应的错误报告：

`Docker for Windows error: “Hardware assisted virtualization and data execution protection must be enabled in the BIOS”`

找了半天解决方法，

原因在于

**在确保hyper-v组件已经开启情况下，我没有开启 虚拟化**

![虚拟化](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c7bb4253daed4a6288c1348c0ff03bc4~tplv-k3u1fbpfcp-watermark.image)

开启虚拟化链接 -> [在BOIS开启虚拟化方法](https://jingyan.baidu.com/article/ab0b56305f2882c15afa7dda.html)

## 坑2

终于解决掉坑一了， 可是当我启动 docker desktop 但是小鲸鱼图标红色，显示启动失败。
哎，怎么又报错啊。

报错如下（网上找到报错图，但和我报错一样）：
![WSL](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e622853cb5d3439591259cb7075385aa~tplv-k3u1fbpfcp-watermark.image)

又经过一段时间的查找资料，**意思就是说 WSL 版本低，需要去重新更新一下**。

于是 我又去 微软官网下载最新版的wsl2 安装后发现，终于可以打开了！


## 配置国内镜像

我用的是阿里云的镜像服务

**可去阿里云注册一个账号，然后搜索容器镜像服务，找到镜像加速器**，有自己的加速器地址，下边也有相关的文档。
![容器镜像服务](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/09786d85f1ed403cabee8d1cd2c42010~tplv-k3u1fbpfcp-watermark.image)


**复制完地址后，在Docker设置中添上属于你的地址即可**

![配置国内镜像](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dcb14fea69ac4ecb8e2b6c9c4f9afa50~tplv-k3u1fbpfcp-watermark.image)


### 试一试是否成功

打开命令行输入 docker --version 可查看版本号

输入 docker run hello-world 会使用刚刚配置的国内镜像去下载一个包，然后并返回 Hello from Docker!

![docker run hello-world](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/90510e399dab42a68be7553894e44562~tplv-k3u1fbpfcp-watermark.image)


## 总结
以上是我安装Docker时踩过的坑， 记录一下，防止以后重新安装时又手忙脚乱的。


