---
title: Redux 学习总结
index_img: /img/redux.jpg
date: 2021-01-31 9:52:00
tags: [React,Redux]
categories: [React,Redux]
---

## redux 是什么
1. rduex是一个专门用于做状态管理的JS库（注意:不是React插件库）
2. 它可以在任何框架里使用，也可以在原生JS中使用，但基本与react搭配使用
3. 作用:集中式管理 多个组件共享的状态

## redux原理
![redux原理图](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/894ca0cbc1f349af965aaa07bb97386b~tplv-k3u1fbpfcp-watermark.image)

看图很抽象，需要用一个生活中的例子来形象表达出来，估计会理解的更深。


比如： 我饿了，去餐馆吃饭，我给服务员说我要一份蛋炒饭，然后服务员把菜单传给餐馆老板，老板通知厨师要求做一份蛋炒饭，厨师做完蛋炒饭后再交给老板，然后我自己去取餐。

现在，我就是：React Components ， 服务员就是 Action Creators ， 餐馆老板就是: Store, 后厨就是：Reducers 。

瞧，redux就是这样一个工作流程，是不是感觉很生活？

即：action 定义状态，dispatch派发状态，store执行，reducers执行，reducers返回一个新的状态，然后getstate更新视图

## redux 三个核心概念

### 1. action

1. 动作的对象
2. 包含 俩个属性
	- type: 标识属性，值为字符串，唯一，必要属性
    - data: 数据属性，值类型任意，可选属性
3. 例子： {type:"ADD_USER",data:{name:"Wangpf",age:"18"}}


### 2. reducer
1. 用于初始化状态，加工状态。
2. 加工时，根据 旧的 state 和 action ，产生新的 state 的**纯函数**

### 3. store
将 state 、 action 、 reducer 联系在一起的对象


## 先通过一个小案例来体现简单版的redux

redux使用步骤
1. **创建 reducer.js**
	- renducer 的本质是一个函数，接收 preState,action， 返回加工后的状态
    - renducer 有俩个作用： 初始化状态，加工状态
    - 注意：renducer 被第一次调用时，是store自动触发的
    	- 传递的 preState是 undefined
        - 传递的 action 是：{type:"@@REDUX/INIT_d.5.f.4"} 类似于这种形式的
	- 通过**dispatc（aciton）**，把state（{type,data}）放入reducer函数中加工，并返回新的state。

2. **创建 store.js**
	- 引入 redux 中的 `createStore`方法，创建一个store
    - `createStore`调用时要传入一个为其服务的 reducer
	- 即在此文件中 使用 `createStore` API
3. **在组件中引入 store**
	- 使用 **getState，dispatch，subscribe**等API来实现状态更新。


小试牛刀，按照上面步骤，相应代码如下：
```jsx
// count_reducer JS文件
function countReducer(preState =0, action) {
  const { type, data } = action
  const typeMap = {
    "increment": preState + data,
    "decrement": preState - data
  }
  if (type in typeMap) {
    return typeMap[type]
  } else {
    return preState
  }
}
export default countReducer
```

```jsx
// store js文件
import { createStore } from 'redux'

import countReducer from './count_reducer'

export default createStore(countReducer)
```

```jsx
// 组件 方法代码

// render 方法中的  <h2>当前求和为：{store.getState()}</h2>

  componentDidMount() {
    store.subscribe(() => {
      this.setState({})
    })
  }

  // 加法
  increment = () => {
    const { value } = this.currentNum
    store.dispatch({ type: "increment", data: value * 1 })
  }

  // 减法
  decrement = () => {
    const { value } = this.currentNum
    store.dispatch({ type: "decrement", data: value * 1 })
  }

```

目前我们还没有用上 action 这个概念， 所以把代码优化一下：

优化步骤：
1. 创建 action.js
	- 用来记录用户发生的动作
    - 专门用于创建action对象
2. 创建 constant.js
	- 使用变量控制action中的type，统一管理并防止单词出错

代码如下(我放在一起了)：
```js
// constant.js
// 该模块是用于 定义action对象中的type类型的常量值，目的只有一个：便于管理的同时防止单词写错
export const INCREMENT = 'increment'
export const DECREMENT = 'decrement'


// action.js
import { INCREMENT,DECREMENT} from './constant'

export const createIncrementAction = data => ({ type: INCREMENT, data})
export const createDecrementAction = data => ({ type: DECREMENT, data})


// reducer.js 代码部分优化
// 把原来的字符串改为变量名
 const typeMap = {
    [INCREMENT]: preState + data,
    [DECREMENT]: preState - data
  }

// 组件  实现方法代码优化
  increment = () => {
    const { value } = this.currentNum
    store.dispatch(createIncrementAction(value * 1))
  }
  decrement = () => {
    const { value } = this.currentNum
    store.dispatch(createDecrementAction(value * 1))
  }

```


以上就 过了一遍如何使用**redux**的一个简单流程。


## 异步 action

**使用前提：** 如果我们不想把 延迟的动作交给组件自身（也就是异步操作不想在组件内上实现），而想交给action来处理。

**什么时候需要异步action：** 想要对状态进行操作，但是具体的数据需要靠异步任务返回。


具体步骤：
1. npm install redux-thunk， 并在store中配置它
```jsx
import { createStore,applyMiddleware } from 'redux'
// 用于支持异步action
import thunk from 'redux-thunk'
export default createStore(countReducer,applyMiddleware(thunk))
```
2. 创建action的函数不再返回一般对象，而是一个函数，因为函数可以写异步任务。
3. 异步任务有结果后，发布一个同步的action去真正操作数据

案例代码如下：
```jsx
// action.js
// 处理 异步    它必须返回的是一个 函数
export const createIncrementAsyncAction = (data,time) => {
  return (dispatch) => {
    setTimeout(() => {
      dispatch({ type: DECREMENT, data })
     },time)
   }
}

// 组件内的
  incrementAsync = () => {
    const { value } = this.currentNum
    store.dispatch(createIncrementAsyncAction(value * 1, 500))
  }
```


**总结:** 其实我们完全可以自己等待异步任务的结果后再去发布同步action，所以感觉这个 异步action不太重要，了解即可。


## react-redux

### 需要明确俩个概念：
1. **UI组件：** 不能使用任何 render 的api，只负责页面的呈现，交互等，状态完全由外部控制。
2. **容器组件：**  负责和redux通信，将结果交给UI组件。

### 需要明确俩个核心：
**Provider 和 connect**

#### Provider
**Provider** 的目的是让所有组件都能够访问到redux中的数据。
```jsx
ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById("root")
)
```
#### connect
首先，它的使用是这样子的：
```js
connect(mapStateToProps, mapDispatchToProps)(component)
```

**mapStateToProps:**
- 中文意思: 把state映射到props中。
- 映射状态，返回值是一个对象

```jsx
// 容器组件：
function mapStateToProps(state) {
  // 比如 state = { a:123 }
  return { foo: state.a }
}

//  UI组件：
render(){
 return (
  <div>{ this.props.foo }</div>  // 123
 )
}
```

**mapDispatchToProps：**
- 中文意思:把各种dispatch也映射到props中的供你使用
- 映射操作状态的方法，返回值是一个对象

```jsx
// 容器组件：
function mapDispatchToProps(dispatch) {
  return {
     add: number => dispatch({type:"increment"},number),
  }
}

//  UI组件：
<button onClick={this.props.add(1)}> + </button>
```
