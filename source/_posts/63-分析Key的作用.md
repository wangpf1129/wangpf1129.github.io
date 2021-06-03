---
title: 从Vue3源码中分析key的作用
index_img: /img/vue-key.jpg
date: 2021-06-03 09:34:00
tags: [Vue3]
categories: [Vue.js]
---

在文档中说到：

- key 的特殊 attribute 主要用在 Vue 的`虚拟 DOM 算法`，在新旧 nodes 对比时辨识 `VNodes`。
- 如果不使用 key，Vue 会使用一种最大限度减少动态元素并且尽可能的尝试就地`修改/复用相同类型元素`的算法。
- 而使用 key 时，它会基于 key 的变化`重新排列元素顺序`，并且会`移除/销毁 key` 不存在的元素。

> 在分析之前需要简单了解俩个概念 **Vnode** 和 **虚拟 DOM**

## 需要了解的俩个概念

### Vnode

Vnode 全称为 Virtual Node， 即 虚拟节点 ，而它的本质就是一个 JS 对象

**以代码为例：**

```html
<div class="text" style="font-size: 26px;color: pink">这是一段文本内容</div>
```

**// vue 会把 模板中的内容 转换为 vNode（对象）**

```js
const vNode = {
  type: 'div',
  props: {
    class: 'text',
    style: {
      'font-size': '26px',
      color: 'pink',
    },
  },
  children: '这是一段文本内容',
}
```

### 虚拟 DOM

文档中说到：

- 虚拟 DOM 是轻量级的 JavaScript 对象，由渲染函数创建。
- 它包含三个参数：元素，具有数据、prop、attr 等的对象，以及一个数组。
- 数组是我们传递子级的地方，子级也具有所有这些参数，然后它们也可以具有子级，依此类推，直到我们构建完整的元素树为止。

**以代码为例：**

```html
<div>
  <h1>标题</h1>
  这是一段文本内容
  <!-- 这是注释 -->
</div>
```

**// 转换为虚拟 DOM**

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a2ec882cf7824853b38a317ae69758e0~tplv-k3u1fbpfcp-watermark.image)

## 插入内容的案例

先看一个案例：当我们点击按钮时会插入一个数字 5 进去：

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/afda7036eeda4c90a34bd734d15de71e~tplv-k3u1fbpfcp-watermark.image)

在整个过程中，我们可以确定的是 vue 在内部这次更新对于 ul 和 button 是不需要进行更新，需要更新的是 li 的列表。

在 Vue 中，对于相同父元素的子元素节点并不会重新渲染整个列表；因为对于列表中 1、2、3、4 它们都是没有变化的。在操作真实 DOM 的时候，我们只需要在中间插入一个 5 的 li 即可。

**那么 Vue 中对于列表的更新究竟是如何操作的呢？**

Vue 事实上会对于有 key 和没有 key 会调用两个不同的方法：

1. 有 key，那么就使用 `patchKeyedChildren` 方法；
2. 没有 key，那么久使用 `patchUnkeyedChildren` 方法；

## Vue3 源码对于 Key 的判断

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/10466024631c43e495bc0bf239466572~tplv-k3u1fbpfcp-watermark.image)

### 没有 key 的操作情况下，vue 源码的做法

在没有 key 的情况下，vue3 源码是通过 `patchUnkeyedChildren` 方法来实现的

具体实现如图下：

**第一步：遍历循环通过 patch 方法来做比较**
![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0072b096b1fc4ac9aaeebef2e603d462~tplv-k3u1fbpfcp-watermark.image)
**第二步和第三步:判断新旧 nodes 的长度来进行对节点的删除或者新增**
![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a8262272a56e49abb884d604e660fd9d~tplv-k3u1fbpfcp-watermark.image)

### 在有 key 的情况下，vue 源码的做法

有 key 的情况下，vue 对其操作有点复杂，可分为 5 个步骤。

具体如下图所示：

**第一步：**

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5cea5c68dfac4cec884335ab5f590db8~tplv-k3u1fbpfcp-watermark.image)

**第二步：**

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c7646dd0b51846b5afb0a4edd939e00f~tplv-k3u1fbpfcp-watermark.image)

**第三步：**

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2c8fb09995b9488d89d77f6787b5d3a9~tplv-k3u1fbpfcp-watermark.image)

**第四步：**

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a236d9245719426d99acd4918feb2bb3~tplv-k3u1fbpfcp-watermark.image)

**第五步：**

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/faf29156e94843ee9ecd2bc39e5370e7~tplv-k3u1fbpfcp-watermark.image)

## 总结

我们可以发现，Vue 在进行 diff 算法的时候，会尽量利用我们的 key 来进行优化操作，所有在没有 key 的情况下我们的效率是非常低的。 在进行插入或者重置排序的时候，保持相同的 key 可以让 diff 算法更加高效。
