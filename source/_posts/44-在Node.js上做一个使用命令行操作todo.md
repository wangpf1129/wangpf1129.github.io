---
title: 在Node.js上做一个使用命令行操作todo
index_img: /img/node.jpg
date: 2021-01-05 09:18:00
tags: [Nodejs]
categories: [JavaScript,Nodejs]
---

> 源代码链接：https://github.com/wangpf1129/pf-node-todo
## 下载
下载npm包：
```bash
npm install -g pf-node-todo
// 或者
yarn global add pf-node-todo
```
下载后可查看版本：
```bash
todo --version 
```
## 如何使用
1. todo   查看所有任务列表
    - 能够操作所有增删改查
2. todo add <taskName> 添加一个任务
3. todo clear 清空所有任务


## 单元测试 
用来测试 读文件 和  写文件
```bash
yarn test 
// 或者
npm run test
```

### 项目效果演示

**查看版本号：**

![查看版本号](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/bab9bb41e5204dd4b9ed6fa2c7bd76c2~tplv-k3u1fbpfcp-watermark.image)

**添加任务：**

![添加任务](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/780644345fff4376a24a2f5593346e22~tplv-k3u1fbpfcp-watermark.image)

**查看所有任务以及其他操作：**

![查看所有任务以及其他操作](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/733c3370922943fa93a209d7d7ea37fe~tplv-k3u1fbpfcp-watermark.image)

**清除所有任务：**

![清除所有任务](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a95f298a56ad4452a95faff64507d472~tplv-k3u1fbpfcp-watermark.image)

