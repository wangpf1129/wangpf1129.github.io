---
title: React学习总结（一）：组件
index_img: /img/react.jpg
date: 2021-01-24 16:30:00
tags: [React]
categories: [React]
---

 ## 前言，
好久没学习了，现在正式开始学习React啦~

之前有大概了解过React，了解过React的实现原理，所以我打算直接从 `组件` 来开始我的React学习之旅
##  元素与组件
**React元素：**
```jsx
const div = React.createElement("div",...)
```
**React组件：**
```jsx
const Div = () => React.createElement("div",...)
```

元素和组件的区别就在于 组件必须返回的是一个函数，并且命名首字母要大写！

## 什么是组件
- 用生活中的例子就是：能和其他物件组合在一起的物件就是组件，
- 比如Vue中，一个构造选项就可以表示一个组件。
- 在React官方中说到，组件的本质就是JavaScript函数


## React的俩种组件：函数组件与 class 组件
### 函数组件
```jsx
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}
```
使用方法：
```jsx
<Welcome name="Wangpf"/>
```

### class组件
```jsx
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>;
  }
}
```

使用方法：
```jsx
<Welcome name="Wangpf"/>
```

上述两个组件在 React 里是等效的。


## 那么 ` <Welcome /> ` 会被翻译为 React.createElement(....)

我用 [babel online]() 来演示一下

![div](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6d2403f697f743368bb78407ca93aeea~tplv-k3u1fbpfcp-watermark.image)


![<Welcome />](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/07c31ac5fbe244b6af0067981296c440~tplv-k3u1fbpfcp-watermark.image)


![<Welcome />](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d1b77403eae0408ea6cb176db8a0adbc~tplv-k3u1fbpfcp-watermark.image)

![<Welcome />](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/47683cc38e314d7fb7717ff5ebe1e423~tplv-k3u1fbpfcp-watermark.image)

总结：
1. 如果传入的是一个`字符串`：比如 "div"，则会去创建一个div
2. 如果传入的是一个`函数`，则会去调用该函数，`获取其返回值`
3. 如果传入的是一个`类`，则会在类前面加个 new（这会导致执行constructor），获取一个组件对象，然后调用对象的render方法，`获取其返回值`




## 小试牛刀
**分别用俩种组件方式来写props(外部数据，传参)、state（内部数据）：**
```jsx
import React from 'react';
import "./style.css";

function App() {
  return (
    <div className="App">
      父组件
      <Son messageForSon="我是你的老大" />
    </div>
  );
}

class Son extends React.Component {
  constructor() {
    super()
    this.state = {
      n: 0
    }
  }

  render() {
    return (
      <div className="Son">
        子组件
        <span> n: {this.state.n} </span>
        <button onClick={() => { this.add() }}> +1</button>
        <p>我是子组件，父组件对我说：{this.props.messageForSon}</p>
        <Grandson messageForGrandson="我是你的老大,你是我老大的孙子" />
      </div>
    )
  }

  add() {
    // this.setState({
    //   n: this.state.n + 1
    // })

    this.setState(state => {
      const n = state.n + 1
      // console.log(n);
      return { n }
    })
  }
 }

const Grandson = (props) => {
  const [n, setN] = React.useState(0)
  return (
    <div className="Grandson">
      孙组件
      <span> n : {n} </span>
      <button onClick={() => { setN(n + 1) }}> +1</button>
      <p>我是孙组件，子组件对我说：{props.messageForGrandson}</p>
    </div>
  )
}

export default App
```
![俩种组件的书写方式](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/edfe90e98e6d482baad5706cf115978e~tplv-k3u1fbpfcp-watermark.image)


### 总结：
**使用props（外部数据）**
- 类组件 会直接读取`属性` this.props.xxx
- 函数组件 会直接读取`参数` props.xxx

**使用state（内部数据）**
- 类组件 用 this.state 读，  this.setState 写
- 函数组件 用 useState 返回数组，第一项是读， 第二项是写
	- const [n, setN] = React.useState(0) 
