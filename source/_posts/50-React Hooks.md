---
title: React Hooks 学习总结
index_img: /img/hooks.jpg
date: 2021-02-02 13:49:00
tags: [React]
categories: [React]
---


![React Hooks](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c3b4f5a08e744902bf7dada96f605578~tplv-k3u1fbpfcp-watermark.image)


## useState

**基本使用:**
```jsx
// 这里可以任意命名，因为返回的是数组，数组解构
const [state, setState] = useState(initialState);

const [n,setN] = React.useState(0)
const [user,setUser] = React.useState({name:"张三"})
```

### 注意事项：

#### **1. 不可局部更新**

如果state是一个对象，是不可以合并属性的。
```jsx
import React, { useState } from 'react'

function App() {
  const [user, setUser] = useState({ name: "Wangpf", age: 18 })
  const changeState = () => {
    setUser({
      name: "Mark"
    })
  }
  return (
    <div>
      <h2>名字：{user.name}</h2>
      <h2>年龄：{user.age}</h2>
      <button onClick={changeState}>改变</button>
    </div>
  )
}

export default App
```

看代码所示，当我点击按钮时，它会把名字改为 Mark ，**但是 age 会显示不见**， 这就是因为它不会局部更新，不会帮我们合并属性，因此需要我们自己加上。

```jsx
const changeState = () => {
    setUser({
      ...user,
      name: "Mark"
    })
  }
```

#### **2. 地址会变**

setState(obj)，如果**obj**地址不变，那么React就认为数据没有变化。

意思就是，我们不能在原来的数据上进行操作，而是重新写一个新的对象来覆盖之前的。

#### useState 和 setState 都可以接收函数
```jsx
// useState
 const [user, setUser] = useState(() => {
   return { name: "Wangpf", age: 18 }
  })

// setState
  const changeState = () => {
    setUser((user) => {
      return {
        ...user,
        name: "Mark"
      }
    })
  }
```
## useEffect
1. Effect Hook 可以让你在函数组件中执行副作用操作(用于模拟类组件中的生命周期钩子)
2. React中的副作用操作:
        发ajax请求数据获取
        设置订阅 / 启动定时器
        手动更改真实DOM
3. 语法和说明:
	- ```jsx
   		useEffect(() => {
         // 在此可以执行任何带副作用操作
          return () => { // 在组件卸载前执行
            // 在此做一些收尾工作, 比如清除定时器/取消订阅等
          }
        }, [stateValue]) // 如果指定的是[], 回调函数只会在第一次render()后执行
      ```
4. 可以把 useEffect Hook 看做如下三个函数的组合
	- componentDidMount()
	- componentDidUpdate()
	- componentWillUnmount()


```jsx
  useEffect(() => {
    console.log('第一次渲染之后及之后每次都会执行');
  })
  useEffect(() => {   // componentDidMount
    console.log("只执行第一次渲染之后");
  }, [])
  useEffect(() => {   // componentDidUpdate()
    if (count !== 0) {
      console.log('count变化了');
    }
  }, [count])
  useEffect(() => {
  return () => { componentWillUnmount()
  }
  }, [])
```

## useContext

**“上下文”**
- 全局变量 是全局的“上下文”
- “上下文”是局部的全局变量

**使用步骤：**
1. const XxxContext = React.createContext()
2. 渲染子组时，外面包裹xxxContext.Provider, 通过value属性给后代组件传递数据：
	- 	<xxxContext.Provider value={数据}>
		子组件
    	</xxxContext.Provider>
3. 后代组件读取数据
	-  const {数据} = useContext(xxxContext)

适合用于祖孙组件的通信

**使用代码如下：**
```jsx
import React, { createContext, useContext, useState } from 'react'

const Context = createContext(null)
function App() {
  const [count, setCount] = useState(0)
  return (
    <Context.Provider value={{ count, setCount }}>
      <div>
        <A />
      </div>
    </Context.Provider>
  )
}
function A() {
  return (
    <div>
      <h2>我是A组件</h2>
      <B />
    </div>
  )
}
function B() {
  const { count, setCount } = useContext(Context)
  const increment = () => {
    setCount(n => n + 1)
  }
  return (
    <div>
      <h3>我是B组件</h3>
      <div>count:{count}</div>
      <button onClick={increment}>+1</button>
    </div>
  )
}

export default App
```


## useReducer

> 此hooks API 践行了Redux的思想


**逻辑步骤：**
1.  创建初始值 `initialState`

2.  创建所有操作 `reducer = (state, action)=>{}`

3.  传给 `useReducer`，得到读写的API

4.  调用并写 `{{type:'操作类型'}}`


**详细代码如下：**

```jsx
// 初始化状态
const initialState = { count: 0 }
const reducer = (state, action) => {
  const { type, data } = action
  if (type === 'increment') {
    return { count: state.count + data }
  } else if (type === 'decrement') {
    return { count: state.count - data }
  } else {
    throw new Error('unknown type')
  }
}

function A() {
  const [state, dispatch] = useReducer(reducer, initialState)
  const { count } = state

  const increment = () => {
    dispatch({ type: "increment", data: 1 })
  }
  const decrement = () => {
    dispatch({ type: "decrement", data: 2 })
  }

  return (
    <div>
      <h2>我是A组件</h2>
      <h4>count:{count}</h4>
      <button onClick={increment}>加</button>
      <button onClick={decrement}>减</button>
    </div>
  )
}
```

## useMemo
通过一个实例，来理解下 useMemo的用法。

```jsx
import React, { useState } from 'react'
function App() {
  const [n, setN] = useState(0)
  const [m, setM] = useState(0)
  const updateN = () => {
    setN(n => n + 1)
  }
  const updateM = () => {
    setM(m => m + 1)
  }
  return (
    <div>
      <button onClick={updateN}>update n {n}</button>
      <button onClick={updateM}>update m {m}</button>
      <A data={m} />
    </div>
  )
}
function A(props) {
  console.log('A组件执行了');
  return <div>A组件：{props.data}</div>
}
export default App
```
注意打印console.log的位置。

当我们点击APP组件的更新N的按钮时候，A组件会发生改变，但是M是没有改变的啊。

结论：不管我们是否改变了A组件的数据，我们会发现A组件会被重新渲染的。这就意味着性能的损耗。

因此，为了优化这个，React.memo 就派上用场了。
只需把A组件改为：
```jsx
const A = React.memo((props) => {
  console.log('A组件执行了');
  return <div>A组件：{props.data}</div>
})
```
这样，只有APP组件的M数据不发生改变，那么A组件就不会重新渲染。

但是！！这样有个BUG，

当我给A组件绑定一个事件时，
```jsx
import React, { useState, memo } from 'react'

function App() {
  const [n, setN] = useState(0)
  const [m, setM] = useState(0)
  const updateN = () => {
    setN(n => n + 1)
  }
  const updateM = () => {
    setM(m => m + 1)
  }
  const changeA = () => {

  }
  return (
    <div>
      <button onClick={updateN}>update n {n}</button>
      <button onClick={updateM}>update m {m}</button>
      <A data={m} onClick={changeA} />
    </div>
  )
}

const A = memo((props) => {
  console.log('A组件执行了');
  return <div onClick={props.changeA}>A组件：{props.data}</div>
})
export default App
```

这样，即时我不该关于A组件的任何数据，A组件也会随着发生渲染，

问题的原因是因为：当我们重新渲染APP组件时，它会自动调用该changeA事件，那么它就会改变A组件的渲染。

解决该问题的方法就是： 使用 useMemo
```jsx
  const changeA = useMemo(() => {

  },[])
```


### **总结**


**特点**
- 第一个参数是 () => value

- 第二参数是 依赖 [xx]

- 只有当依赖变化时，会计算出新的value

- 如果依赖不变，那么就重用之前的value


是不是 Vue 中的 computed？

**注意项：**
- 如果 ()=> value 中的value 是个函数的话，那么你要写成：useMemo(()=>{(x)=>{xxxxxx}})

- 那么这就是一个返回函数的函数啊。
**因此， useCallback 出来了**


### useCallback

下面俩个是等价的。
```jsx
 const changeA = useMemo(() => {
    return m => console.log(m)
  }, [])

 const changeA = useCallback(m => console.log(m), [])
```



## useRef
useRef返回的是一个可变的ref对象，其 xx.current 属性也就是 useRef(inital)中的inital初始化值。

所以注意  const xxxRef = useRef(0) 中， 此处的 0  实际是个对象为：{current:0}

为什么是对象的原因请看用处二

**用处一： 获取 元素，可以做一些操作元素之类**

通过如下简单实例可以明白
```jsx
import React, { useRef } from 'react'

function App() {
  const inputRef = useRef(null)
  const onclick = () => {
    console.log(inputRef.current);  // 获得到input元素
  }
  return (
    <div>
      <input type="text" ref={inputRef} />
      <button onClick={onclick}>获取input</button>
    </div>
  )
}

export default App
```

**用处二：保持可变变量**

目的： 如果需要一个值，在组件不断render时保持不变

返回的ref对象在组件的整个生命周期内保持不变

举个常见的场景: 对定时器的清除操作。

我们需要确保 setInterval 的执行结果timer的引用，才能准确的清除对应的定时器。
```jsx
import React, { useEffect, useRef } from 'react'

function App() {
  const timerRef = useRef()
  useEffect(() => {
    timerRef.current = setInterval(() => {
      console.log('timerRef');
    }, 1000);
    return () => {
      timerRef.current && clearInterval(timerRef.current)
    }
  }, [])

  return (
    <div>
      App....
    </div>
  )
}
export default App
```
### forwardRef
```jsx
import React, { useRef, forwardRef, useEffect } from 'react'
function App() {
  const btnRef = useRef(null)
  useEffect(() => {
    console.log(btnRef.current);
  }, [])

  return (
    <div>
      <Button ref={btnRef} />
    </div>
  )
}
const Button = forwardRef((props, ref) => {
  return (
    <div>
      <button ref={ref} {...props}>按钮</button>
    </div>
  )
})
export default App
```

React 会将  `<Button ref={ref} />`元素的 ref 作为第二个参数传递给 React.forwardRef 函数中的渲染函数。

该渲染函数会将 ref 传递给 `<button ref={ref} /> ` 元素。

因此，当 React 附加了 ref 属性之后，inputRef.current 将直接指向 `button `DOM 元素实例。


### useImperativeHandle
如果想要给给该组件的属性改个名字，或者返回其他额外的属性或者方法，我们可以使用useImperativeHandle。

这个API具体我没去深入了解。



## 自定义 Hook

做一个hooks来实现渲染列表以及删除列表

**组件：**
```jsx
// App组件
import React from 'react'
import useList from './hooks/useList'
function App() {
  const { list, deleteIndex } = useList()
  return (
    <div>
      <h2>小说列表</h2>
      {
        list ?
          (<ul>
            {list.map((item, index) => (
              <li key={item.id}>{item.name}
                <button onClick={() => { deleteIndex(index) }}>删除</button>
              </li>
            )
            )}
          </ul>) :
          (<span>加载中....</span>)
      }
    </div>
  )
}
export default App
```

**自定义hook：**
```jsx
import { useState, useEffect } from 'react'
import {nanoid } from 'nanoid'

const useList = () => {
  const [list, setList] = useState(null)
  useEffect(() => {
    ajax().then(list => {
      setList(list)
    })
  }, [])
  return {
    list: list,
    setList: setList,
    deleteIndex: index => {
      setList(list.slice(0,index).concat(list.slice(index+1)))
    }
  }
}
export default useList
function ajax() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve([
        {id: nanoid(),name:"小王子"},
        {id: nanoid(),name:"明朝那些事儿"},
        {id: nanoid(),name:"三体"},
      ])
    },2000)
  })
}
```

