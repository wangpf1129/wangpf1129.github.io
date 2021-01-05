---
title: Vue 里 computed  和 watch 的区别
index_img: /img/vuejs.jpg
date: 2020-12-20 20:48:28
tags: [vue]
categories: [vue]
---
​
​
## computed
>  计算属性 ， computed 是用来计算出一个值，这个值在调用的时候会根据依赖的数据显示新的计算结果并自动缓存。 如果依赖不变，computed中的值就不会重新计算。 注意 ：不需要加(),
### 什么是计算属性，为什么要使用它

**模板内的表达式非常便利，但是设计它们的初衷是用于简单运算的。在模板中放入太多的逻辑会让模板过重且难以维护,例如：**

```html
<div id="example">
  {{ message.split('').reverse().join('') }}
</div>
```
**在这个地方，模板不再是简单的声明式逻辑，你必须看一段时间才能意识到，这里是想要显示变量 `message` 的翻转字符串，当你想要在模板中多次引用此处的翻转字符串时，就会更加难以处理。**

- 使用 方法 methods
- 使用 计算属性 compute

###  计算属性和方法的区别

- 计算属性是基于他们的响应式依赖进行缓存的，只在相关响应式依赖发生改变时，才会重新求值（也就是说，计算属性会把数据进行缓存）
- 而方法不会把数据进行缓存， 所以用计算属性效率会更高点

**所以，对于任何复杂逻辑，都应该使用计算属性**

- 在某些情况，我们可能需要对数据进行一些转化后再显示，或者需要将多个数据结合起来进行显示
	- 比如我们有firstName和lastName两个变量，我们需要显示完整的名称。
	- 但是如果多个地方都需要显示完整的名称，我们就需要写多个{{firstName}} {{lastName}}
    
 ```js
 <body>
  <div id="app">
    <h2>{{firstName + ' ' + lastName}}</h2>
    <h2>{{firstName}} {{lastName}}</h2>
    <h2>{{getFullName()}}</h2>
    <h2>{{fullName}}</h2>

  </div>
</body>
<script src="../js/vue.js"></script>
<script>
  const app = new Vue({
    el: '#app',
    data: {
      firstName: 'Lron',
      lastName: 'Man'
    },
    // 推荐使用计算属性来操作，因为它会将这些数据进行缓存， 无论打印多少次，它只会调用一次
    computed: {
    //  计算属性   注意 : 计算的是 属性, 
    // 所以这里面的属性 看成一个 对象(用名词形式来表达), 调用时候不用加小括号
      fullName: function () {
        return this.firstName + ' ' + this.lastName

      }
    },
    methods: {
      //  不会缓存， 所以有多少次就调用多少次，  没有 computed 划算
      getFullName: function () {
        return this.firstName + ' ' + this.lastName
      }
    }
  })
</script>
```

## watch
参考文档：[vue官方文档：watch](https://cn.vuejs.org/v2/api/#watch)
> 监听， 如果某个属性依赖变化了就执行回调。  它有俩个属性 1. immediate  表示数据是否在第一次渲染的时候立即执行该函数。    2. deep , 如果我们监听一个对象（不包括数组），是否要看对象里面的属性的变化。

### 什么是watch 为什么要使用它

watch监听的**数据**可以是一个 **字符串、函数、数组、对象**


一个对象，键是需要观察的表达式（**data内的数据**），值是对应回调函数。值也可以是方法名，或者包含选项的对象。

当数据发生改变时，会执行一个回调，它有俩个参数， newVal 和 oldVal

wtach有俩个属性：
- immediate 是否在第一次渲染时执行这个函数，会在监听开始之后就立即本调用。
- deep 是否要看这个对象里面的属性变化。


**this.$watch 和 watch 用法一致，只不过写法有些不同，这里不详细说明**

案例：
```js
new Vue({
  data: {
    n: 0,
    obj: {
      a: "a"
    }
  },
  template: `
    <div>
      <button @click="n += 1">n+1</button>
      <button @click="obj.a += 'hi'">obj.a + 'hi'</button>
      <button @click="obj = {a:'a'}">obj = 新对象</button>
    </div>
  `,
  watch: {
    n() {
      console.log("n 变了");
    },
    obj:{
      handler: function (val, oldVal) { 
      console.log("obj 变了")
    },
      deep: true // 该属性设定在任何被侦听的对象的 property 改变时都要执行 handler 的回调，不论其被嵌套多深
    },
    "obj.a":{
      handler: function (val, oldVal) { 
      console.log("obj.a 变了")
    },
      immediate: true // 该属性设定该回调将会在侦听开始之后被立即调用
    }
  }
}).$mount("#app");
```

## 总结
1. 如果一个数据需要经过复杂计算就用 computed
2. 如果一个数据需要在发生变化时做一些操作就用 watch