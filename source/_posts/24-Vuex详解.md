---
title: Vuex详解
date: 2020-09-26 15:15:40
index_img: /img/Vuex.jpg
tags: vue
categories: vue
---
#  Vuex⭐

> Vuex是一个专为Vue开发的应用程序的状态管理模式，它采用集中式存储管理应用的所有组件的状态，并以相应的规则保证状态以一种可预测的方式发生变化。

简而言之，Vuex采用**类似全局对象**的形式来管理所有组件的公用数据，如果想修改这个全局对象的数据，得按照Vuex提供的方式来修改（不能自己随意用自己的方式来修改）


## 1 安装和使用

**1.安装Vuex**

```js
npm install vuex --save
```

**2.引用Vuex**

```js
import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)
123
```

**3.创建仓库Store**

要使用Vuex，我们要创建一个实例 `store`，我们称之为仓库，利用这个仓库 `store` 来对我们的状态进行管理。

```js
 //创建一个 store
 const store = new Vuex.Store({});
```



## 2 单界面的状态管理



![单界面的状态管理](https://img-blog.csdnimg.cn/20200926145610255.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Bmenp6eno=,size_16,color_FFFFFF,t_70#pic_center)





- **State**：不用多说，就是我们的状态。（你姑且可以当做就是data中的属性）
- **View**：视图层，可以针对State的变化，显示不同的信息。
- **Actions**：这里的Actions主要是用户的各种操作：点击、输入等等，会导致状态的改变。



## 3 单界面的状态管理的代码实现

```html
<template>
	<div class=test>
    	<div>当前计数：{{counter}}</div>
        <button @click="counter+=1">+1</button>
        <button @click="counter-=1">-1</button>
    </div>
</template>

<script>
	export default {
        name:'HelloWorld',
        data(){
            return { 
            	counter: 0
            }
        }
    }
</script>

<style>
</style>
```



1. **在这个案例中， 我们有个 counter 需要管理**
2. **counter 需要被某种方式被记录下来，也就是我们的** `State`
3. **counter 目前的值会显示在界面上， 也就是我们的 `View` 部分**
4. **界面发送某些操作时， 比如我们这里使用的是 点击事件 ， 需要去更新状态， 也就是我们的** `Actions`







## 4 Vuex的核心概念和API

>  主要理解实例中下面这些对象是如何运作的。



**流程：View -> Actions -> Mutations -> State -> View**



![Vuex的核心概念](https://img-blog.csdnimg.cn/20200926145610303.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Bmenp6eno=,size_16,color_FFFFFF,t_70#pic_center)

### 1、 state

1) vuex 管理的状态对象

2) 它应该是唯一的
        const state = {
          xxx: initValue
         }

### 2、 mutations

​         1) 包含多个直接更新 state 的方法(回调函数)的对象
​         2) 谁来触发: **action 中的 commit('mutation 名称')**
​         3) **只能包含同步的代码, 不能写异步代码**
​           const mutations = {
​              yyy (state, {data1}) {
​                // 更新 state 的某个属性
​             }
​           }

### 3、 actions

1) 包含多个事件回调函数的

2) 通过执行: commit()来触发 mutation 的调用, 间接更新 state

3) 谁来触发: 组件中: **$store.dispatch('action 名称', data1) // 'zzz**

4) **可以包含异步代码(axios)**

const actions ={

   zzz ({commit, state}, data1)

​        commit('yyy', {data1})

  }

}

### 4、 getters

1) **包含多个计算属性(get)的对象**（也就是说，getters是用来放state里面的变量的计算属性的）

2) 谁来读取: 组件中: **$store.getters.xxx**

   const getters ={

   xxx(state) {

​         return ...

​    }

}

### 5、 modules

1) 包含多个 module

2) 一个 module 是一个 store 的配置对象

3) 与一个组件(包含有共享数据)对应



## 5 Vuex的运作流程

### Vuex的运作流程

![Vuex的运作流程](https://img-blog.csdnimg.cn/20181227125005140.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNjQ3OTk5,size_16,color_FFFFFF,t_70)

### 流程详解

① 在组件（页面）中，通过dispatch()或mapActions()这个函数分发给actions的函数去处理。

② actions的函数可以与后台交互，也可以通过 commit() 提交给mutations去处理。

③ mutations 可以直接与devtool（如本地存储工具 → 在实例代码中的utils里的storageUtils.js）交互与直接更新state（数据状态）。

④ 如果有计算属性（get函数写在getters里面），则状态通过getters的$store.getters()或**mapGetters()**来更新组件；反之就通过$store.state()或者**mapState()**的方式来更新组件。