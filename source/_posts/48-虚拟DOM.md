---
title: 虚拟DOM和diff算法以及关于key的问题（学习总结）
index_img: /img/domAnddiff.jpg
date: 2021-01-26 21:14:00
tags: [React,Vuejs]
categories: [React,Vuejs]
---


## 前言
我为了了解虚拟DOM，是为了更好的学习React和Vue。
## 虚拟DOM

**先说说虚拟DOM的优点：**
1. 减少DOM操作次数

虚拟DOM可以把多次操作DOM合并为一次操作， 比如：你需要添加100个元素节点，原生操作的话只能一个一个的添加， 但使用虚拟DOM，它可以把这些操作合并为一个操作，最后一次性的添加到DOM中。

2. 减少DOM操作范围

虚拟 DOM 借助 DOM diff 可以把多余的操作省掉，比如你添加 100 个元素节点，其实只有 10 个是新增的，如果用原生来操作，你还是需要一个一个添加进去，而虚拟DOM会根据diff算法来判断只需要添加那些改变的元素节点添加进去即可。


## 如何创建虚拟DOM

### 1. 用React举例：(用React.createElement)
```js
React.createElement('div',{className:'red',onClick:()=> {}},[
    React.createElement('span', {}, 'span1'),
    React.createElement('span', {}, 'span2')
  ]
)
```

简写即：（React JSX    ）
```jsx
<div className="red" onClick="{()=> {}}">
    <span>span1</span>
    <span>span2</span>
</div>
```

**简写方法最后会通过 babel 转为 createElement 形式**



### 2. 用Vue举例：(只能在 render 函数里得到 h)
```js
h('div', {
  class: 'red',
  on: {
    click: () => { }
  },
}, [h('span',{},'span1'), h('span', {}, 'span2'])
```

简写即： (Vue Template)
```Vue
<div class="red" @click="fn">
  <span>span1</span>
  <span>span2</span>
</div>
```

**简写方法最后会通过 vue-loader 转为 h 形式**


### 虚拟DOM到底是什么
把真实DOM树，变成js对象树，将之前的和新的作比较，通过diff算法，按照不同的地方进行渲染。

其实刚刚用React，Vue写的就是虚拟DOM

它是一个能代表DOM树的对象， 一般会含有 `标签名 、 标签属性 、 事件监听 、 子元素以及其他属性等`


### 虚拟DOM的缺点

1. 需要额外的创建函数，如 createElement 或 h，但可以通过 JSX 来简化成 XML 写法
2. 严重依赖打包工具、需要添加额外的构建过程。


## diff算法
使用传统的diff算法进行节点的循环遍历，复杂度是 O(n^3)。(不多说它)


### DOM diff 是什么？
- 就是一个函数，被称之为 `patch`
- patches = patch(oldVNode,newVnode)
- patches 就是要运行的DOM操作，


通俗说就是：给我俩个虚拟节点，我给你对应的DOM操作，（这个DOM操作目前不会去立马执行，等到全部虚拟节点都更新完毕后，我再去把该操作一次的执行。）

### DOM diff 的大概逻辑思路：

- **Tree diff**
	- 将新旧两棵DOM树逐层对比，找出哪些节点需要更新
	- 如果节点是`组件`就看 Component diff
	- 如果节点是`标签或文本`就看 Element diff
- **Component diff**
	- 如果节点是组件，就先看组件类型
	- 类型不同直接替换（删除旧的）
	- **类型相同则只更新属性**
	- 然后深入组件做 Tree diff（递归）
- **Element diff**
	- 如果节点是原生标签，则看标签名
	- 标签名不同直接替换，**相同则只更新属性**
	- 然后进入标签后代做 Tree diff（递归）
    
    

但是，它有个缺点：同级节点对比存在 bug （关于key 的问题）
    
   
## key的问题

### 面试题： react/vue（虚拟DOM）中的key有什么作用？ （key的内部实现原理是什么？）

1. 简单说： key是虚拟DOM对象的标识，在更新显示时key起着重要的作用

2. 详细说： 当状态中的数据发生改变时，react/vuew 会根据`新数据`生成`新的虚拟DOM`，随后react/vue会进行`新虚拟DOM`与`旧虚拟DOM`的diff比较， 比较规则如下：
	- ` 新虚拟DOM` 中找到了与 `旧虚拟DOM` 相同`key`
    	1. 若虚拟DOM中内容没变，直接使用之前的真实DOM
        2. 若虚拟DOM中内容发送改变了，则生成新的真实的DOM，随后替换掉页面中之前的真实DOM
    - ` 新虚拟DOM` 中没有找到了与 `旧虚拟DOM` 相同`key`
    	1. 跟新数据创建新的真实DOM，随后替换到页面
        


### 面试题： 为什么遍历列表时，key最好不要用index（索引值）？

用index（索引值）作为key可能会引发的问题：



1. 若数据进行：**逆序添加、逆序删除等破坏顺序操作**
	- 会产生没有必要的真实DOM更新 ==> 页面效果虽然没有问题，但是效率低。
    
2. 如果结构中还包含输入类的DOM：
	- 会产生错误DOM更新 ==> 页面渲染会有问题
    
    
3. 当然如果只是为了 渲染列表，只展示而已， 那用 index 作为key 是没问题的。



（我这里没有解释，只是给出了结论，如果想看到底为什么，可看推荐文章）

 关于key问题的文章推荐：[Vue2.0 v-for 中 :key 到底有什么用？](https://www.zhihu.com/question/61064119/answer/766607894)


