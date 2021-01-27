---
title: React学习总结（二）: 生命周期
index_img: /img/react.jpg
date: 2021-01-26 18:44:00
tags: [React]
categories: [React]
---
## React 生命周期（旧）

先来看图

![生命周期（旧）](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/186a79477d02438d9bc5349b6a0ce7d1~tplv-k3u1fbpfcp-watermark.image)


### React组件初始化阶段:

初始化阶段：由ReactDOM.render()触发 --- 初次渲染

#### 第一步 constructor()
 用来初始化属性状态
 ```jsx
   constructor() {
    super()
    console.log('constructor--count组件构造器');
    this.state = {
      count: 0,
      message: '我想要吃的'
    }
 ```
#### 第二步 componentWillMount()
组件将要被挂载阶段 （在组件挂载之前触发）
```jsx
  componentWillMount() {
    console.log('componentWillMount--count组件将要被挂载');
  }
```
#### 第三步 - render()
组件渲染在页面上 
```jsx
  
  render() {
    console.log('render--count组件渲染');
    const { count } = this.state
    return (
      <div className="count">
        <h2>{count}</h2>
        <button onClick={this.add}>+1</button>
        <button onClick={this.force}>强制更新，不改变任何数据状态</button>
        <br />
        <div>
          <h3>我是Count组件</h3>
          <button onClick={this.changeMessage}>更换子组件信息</button>
          <CountSon message={this.state.message} />
        </div>
      </div>
    )
  }
```
#### 第四步  componentDidMount()
组件挂载完毕后 （在组件挂载之后，只会执行一次）
```jsx
  componentDidMount() {
    console.log('componentDidMount--count组件挂载完毕后');
  }
```
这个钩子很常用，我们经常会在这个钩子中做一些初始化的操作，比如：开启定时器，发送网络请求，订阅消息等。


### React组件更新阶段：
**由组件内部的this.setState()或者父组件的render触发**
#### 第一步 	componentWillReceiveProps()
**组件将要接收参数**

组件收到新的属性对象时调用，首次渲染不会触发

一般是父组件向子组件传props时，当子组件更新了props中的数据，就会触发（第一次传过去时，不会触发）

```jsx
  componentWillReceiveProps(props) {
    // 注意， 第一渲染不算， 第二次才触发
    console.log('componentWillReceiveProps--Count的子组件', props);
  }
```

#### 第二步：  shouldComponentUpdate() 
组件是否应该被更新----控制组件更新的“阀门”

如果为true就会按照图中所示往下走，如果为false，则将“阀门”关闭，不能往下走了。
```jsx
  shouldComponentUpdate() {
    console.log('shouldComponentUpdate--count组件是否应该被更新');
    return true
  **}**
```

#### 第三步： componentWillUpdate()

 组件将要更新
```jsx
  componentWillUpdate() {
    console.log('componentWillUpdate--count组件将要更新');
  }
```

#### 第四步：render()

会跟新新的属性对象重新渲染组件

#### 第五步:    componentDidUpdate() 
 组件更新完毕后触发
 
 它接收参数（1.props更新前的，2.state更新前的，3.快照值，（在新的生命周期中会提到））
 
```jsx
 componentDidUpdate(preProps, preState, snapShotValue) {
    console.log('componentDidUpdate--count组件更新完毕后', preProps, preState, snapShotValue);
  }
```


### 卸载组件阶段

由ReactDOM.unmountComponentAtNode()触发

#### componentWillUnmount()
组件将要被卸载时触发,

一般经常在这个钩子中做一些收尾的操作：比如：关闭定时器，取消订阅消息等。

### （旧）生命周期代码测试
```jsx
import React, { Component } from 'react';

class Count extends Component {
  constructor() {
    super()
    console.log('constructor--count组件构造器');
    this.state = {
      count: 0,
      message: '我想要吃的'
    }
  }

  //组件将要被挂载
  componentWillMount() {
    console.log('componentWillMount--count组件将要被挂载');
  }

  //组件挂载完毕后
  componentDidMount() {
    console.log('componentDidMount--count组件挂载完毕后');
  }

  // 控制组件更新的“阀门”
  shouldComponentUpdate() {
    console.log('shouldComponentUpdate--count组件是否应该被更新');
    return true
  }

  // 组件将要更新
  componentWillUpdate() {
    console.log('componentWillUpdate--count组件将要更新');
  }

  //组件更新完毕后
  componentDidUpdate() {
    console.log('componentDidUpdate--count组件更新完毕后');
  }

  
  render() {
    console.log('render--count组件渲染');
    const { count } = this.state
    return (
      <div className="count">
        <h2>{count}</h2>
        <button onClick={this.add}>+1</button>
        <button onClick={this.force}>强制更新，不改变任何数据状态</button>
        <br />
        <div>
          <h3>我是Count组件</h3>
          <button onClick={this.changeMessage}>更换子组件信息</button>
          <CountSon message={this.state.message} />
        </div>
      </div>
    )
  }

  add = () => {
    const { count } = this.state
    this.setState({
      count: count + 1
    })
  }

  force = () => {
    this.forceUpdate()
  }

  changeMessage = () => {
    // const { message } = this.state
    this.setState({
      message: "我想要喝的"
    })
  }

}


class CountSon extends Component {

  // 组件将要接收参数 
  componentWillReceiveProps(props) {
    // 注意， 第一渲染不算， 第二次才触发
    console.log('componentWillReceiveProps--Count的子组件', props);
  }
  render() {
    return (
      <div>
        <h3>我是Count的子组件</h3>
        <span>我收到父组件的信息：{this.props.message}</span>
      </div>
    )
  }
}

export default Count
```


## 生命周期（新）

先看图

![生命周期（新）](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/97418c38332b4b61b21847bf700547cb~tplv-k3u1fbpfcp-watermark.image)

### 对比 （旧）生命周期

对比俩张图发现，旧版的废弃了三个"will",引来了俩个"get"

**废弃：**
- componentWillMount
- componentWillReceiveProps
- componentWillUpdate

**新增：**
- getDerivedStateFromProps
- getSnapshotbeforeUpdate


### getDerivedStateFromProps
1. 是个静态方法，需要在前面加个`static`，否则会报错，如下：

`Lifecycle method should be static: getDerivedStateFromProps`

2. 必须返回属性对象或者null，否则报错，如下：

` A valid state object (or null) must be returned. You have returned undefined.`

3. 可以传参数
`参数：新的属性对象(内部数据state)，旧的状态对象（外部数据props）`

官网也提出了，这个钩子不建议使用， 因为 派生状态会导致代码冗余，并使组件难以维护。在这里不过多学习它了。


### getDerivedStateFromProps
在更新之前获取快照

1. 有这个钩子必须也要有 componentDidUpdate 这个钩子，需要和它搭配使用
2. 必须有返回值，返回值 可以是 值，也可以是`null`

```jsx
  getSnapshotBeforeUpdate() {
    console.log('getSnapshotBeforeUpdate--count')
    return 'Wangpf'
  }
  
  
  componentDidUpdate(preProps, preState, snapShotValue) {
    console.log('componentDidUpdate--count组件更新完毕后', preProps, preState, snapShotValue);
    // preProps 外部数据更新前的值
    // preState 内部数据更新前的值
    // snapShotValue 是在getDerivedStateFromProps钩子函数中所返回的值
  }
```


### getSnapshotBeforeUpdate
获取更新前的快照值，

举个例子：
```jsx
import React, { Component } from 'react';

import './News.css'

class News extends Component {

  state = {
    newsArr: []
  }

  componentDidMount() {
    setInterval(() => {
      const { newsArr } = this.state
      const news = `新闻${newsArr.length + 1}`

      this.setState({
        newsArr: [news, ...newsArr]
      })
    }, 1000)
  }

  getSnapshotBeforeUpdate() {
    return this.listHeight.scrollHeight
  }

  componentDidUpdate(preProps, preState, height) {
    // 用更新之后的高度 减去 更新之前的高度 再 += 给 更新之后的所在的值 
    // 这样旧能一直处于最底下了
    this.listHeight.scrollTop += this.listHeight.scrollHeight - height
  }

  render() {
    const { newsArr } = this.state
    return (
      <div className="list" ref={c => this.listHeight = c}>
        {newsArr.map((item, index) => {
          return <div key={index} className='news'>{item}</div>
        })}
      </div>
    )
  }
}

export default News
```

上述例子描述的是 ， 可以使用 该钩子来获取更新之前的 scroll 高度， 然后到它一直在滚动时，我希望它一直显示某个位置，而不是随之滚动，一直显示顶部。
![getSnapshotBeforeUpdate](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e452b039392a4c89aa66c8d79c09cd82~tplv-k3u1fbpfcp-watermark.image)


## 总结

**记住较为重要的几个钩子**
1. render : 初始化渲染或者更新渲染时调用的
2. componentDidMount：组件挂载完毕后调用，用途如： 开启监听，发送ajax请求
3. componentWillUnmount： 组件将要卸载时调用， 用途如： 做一些收尾的工作，如清理定时器，取消订阅等。


**废弃的钩子**
1. componentWillMount
2. componentWillReceiveProps
3. componentWillUpdate

目前版本17.0.1，目前使用的话，会出现警告，需要加上 前缀 UNSAFE_ 才行， 但官方说了在未来18版本之后很可能彻底废弃，因此不建议使用。
 