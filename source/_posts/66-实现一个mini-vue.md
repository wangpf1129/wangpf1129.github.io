---
title: 实现一个简洁版的Mini-Vue 
index_img: /img/mini-vue.jpg
date: 2021-08-13 16:08:00
tags: [Vue3]
categories: [Vue.js]
---

实现一个简洁版 Mini-Vue

## Vue 三大核心系统

Vue源码包含三大核心：

1. Compiler模块： 编译模板系统
2. Runtime模块： 也可以称为Renderer模块，真正渲染的模块
3. Reactivity模块： 响应式系统

![三大模块系统.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/142c2d19851a4e9aa327bfd3d7d8978d~tplv-k3u1fbpfcp-watermark.image)

## Mini-Vue

实现一个简洁版的 Mini-Vue， 包含三个模块：

- 渲染系统模块
- 可响应式系统模块
- 应用程序入口模块

### 渲染系统模块

#### 虚拟DOM的优势

在传统的前端开发中，我们编写自己的HTML，最终被渲染到浏览器上。

而目前框架都会引入虚拟DOM来对真实的DOM进行抽象，这样做有很多的好处

1. 首先是可以对真实的元素节点进行抽象，抽象成VNode（虚拟节点），这样方便后续对其进行操作
    1. 因为对于直接操作DOM来说是有很多限制的，比如diff、clone等等，但是使用js来操作这些就会变得简单
    2. 可以使用js来表达非常多的逻辑，而对于DOM本身来说是非常不方便的
2. 其次是方便实现跨平台，包括你可以将VNode节点渲染成任意你想要的节点
    1. 比如渲染在WebGL，SSR，Native（ios，Android）上等等
    2. 并且Vue允许你开发属于自己的渲染器（renderer），在其他的平台上渲染

## 渲染系统的实现

该模块主要包含三个功能：

1. **h 函数：**用于返回一个VNode对象

2. **mount函数：** 用于将VNode挂载在DOM上
3. **patch函数：** 用于俩个VNode进行对比，判断如何处理新的VNode

### h 函数的实现

> h函数的作用就是 生成VNode， 而vnode本质上是一个JavaScript对象



实现一个**h 函数**很简单，直接返回一个VNode对象即可

```js
const h = (tag, props, children) => {

  return {
    tag,
    props,
    children
  }
}
```

### mount 函数的实现

> mount 函数的作用就是 挂载VNode， 将vnode挂载DOM元素上并显示在浏览器上

实现思路：

1. 根据 tag ， 创建HTML元素，并且存到 vnode的el中 （目前只考虑 标签 ，不考虑组件）
2. 处理 props 属性 （目前只考虑俩种情况）
    1. 如果以 on 开头，那么就是监听事件
    2. 如果是普通属性直接通过 setAttribute 添加即可

3. 处理子节点（只考虑俩种情况：字符串和数组）
    1. 如果是 字符串， 那么就直接设置 textContent
    2. 如果数组，那么就遍历中调用 mount 函数

代码如下：

```js
const h = (tag, props, children) => {

  return {
    tag,
    props,
    children
  }
}


const mount = (vnode, container) => {
  // 1. 创建 html 元素
  const el = vnode.el = document.createElement(vnode.tag)

  // 2. 处理 props属性
  if (vnode.props) {
    for (const key in vnode.props) {
      if (!vnode.props.hasOwnProperty(key)) {return}
      const value = vnode.props[key]

      if (key.startsWith('on')) {
        el.addEventListener(key.slice(2).toLowerCase(), value)
      } else {
        el.setAttribute(key, value)
      }
    }
  }

  // 3. 处理子节点
  if (vnode.children) {
    if (typeof vnode.children === 'string') {
      el.textContent = vnode.children
    } else {
      vnode.children.forEach(item => {
        mount(item, el)
      })
    }
  }

  container.appendChild(el)
}

```

这样就能实现简单的渲染啦~

```html

<body>
<div id="app"></div>
<script src="renderer.js"></script>
<script>
  const vnode = h('div', { class: 'wangpf' }, [
    h('h2', { class: 'title' }, 'hello,I am wangpf'),
    h('div', null, '当前计数：100'),
    h('button', { class: 'btn' }, '+1')
  ])
  
  mount(vnode, document.querySelector('#app'))
</script>
</body>
```

![test](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8566def27dbf48908cf54d3acc0773c9~tplv-k3u1fbpfcp-watermark.image)

### patch 函数

> patch 函数作用就是 对比俩个新旧vnode，将不同的给替换掉，运用到了 diff 。

对 patch 函数的实现，分为俩种情况 （n1为旧的vnode，n2为新的vnode）

- n1 和 n2 是不同类型的节点 （删除n1，挂载n2）
    - 找到 n1 的 el 父节点，删除原来 n1 节点的el
    - 挂载 n2 节点 到 n1的el父节点上
- n1 和 n2 是相同的节点
    - 处理 props 的情况
        - 先将新节点的 props 全部挂载到 el 上
        - 判断旧节点的 props 是否不需要在新节点上， 如果不需要，那么删除对应的属性
    - 处理 children 的情况
        - 如果新阶段是一个字符串类型，那么直接替换
        - 如果新节点是不同一个字符串类型
            - 旧节点是一个字符串类型
                - 将el 内容 设为 空字符串
                - 遍历新节点，挂载到el上
            - 旧节点是一个数组类型
                - 取出数组最小长度
                - 遍历所有节点，新节点和旧节点进行 patch 操作
                - 如果新节点长度大于旧节点，那么剩余的新节点就挂载
                - 如果旧节点长度大于新节点，那么剩余的旧节点就卸载

代码实现：

```js
const patch = (n1, n2) => {
  if (n1.tag !== n2.tag) {
    const n1ElParent = n1.el.parentElement
    n1ElParent.removeChild(n1.el)
    mount(n2, n1ElParent)
  } else {
    // 1.取出 element对象，并且在 n2中进行保存
    const el = n2.el = n1.el

    // 2. 处理 props
    const oldProps = n1.props || {}
    const newProps = n2.props || {}

    // 2.1 获取所有的 newProps 添加到 el
    for (const key in newProps) {
      if (!newProps.hasOwnProperty(key)) {return}
      const oldValue = oldProps[key]
      const newValue = newProps[key]
      if (oldValue !== newValue) {
        if (key.startsWith('on')) {
          el.addEventListener(key.slice(2).toLowerCase(), newValue)
        } else {
          el.setAttribute(key, newValue)
        }
      }
    }

    // 2.2 删除旧的props
    for (const key in oldProps) {
      if (!newProps.hasOwnProperty(key)) {return}
      if (key.startsWith('on')) {
        el.removeEventListener(key.slice(2).toLowerCase())
      }
      if (!(key in newProps)) {
        el.removeAttribute(key)
      }
    }

    // 3. 处理 children
    const oldChildren = n1.children || []
    const newChildren = n2.children || []
    if (typeof newChildren === 'string') { // 情况一
      if (typeof oldChildren === 'string') {
        if (newChildren !== oldChildren) {
          el.textContent = newChildren
        }
      } else {
        el.innerHTML = newChildren
      }
    } else {  // 情况二：newChildren是个数组
      if (typeof oldChildren === 'string') {
        el.innerHTML = ''
        newChildren.forEach(item => {
          mount(item, el)
        })
      } else {
        // 如果都是数组
        // oldChildren : [v1,v2,v3]
        // newChildren : [v1,v5,v7,v8,v9]
        const commonLength = Math.min(newChildren.length, oldChildren.length)
        for (let i = 0; i < commonLength; i++) {
          patch(oldChildren[i], newChildren[i])
        }

        if (newChildren.length > oldChildren.length) {
          newChildren.slice(oldChildren.length).forEach(item => {
            mount(item, el)
          })
        }

        if (newChildren.length < oldChildren.length) {
          oldChildren.slice(newChildren.length).forEach(item => {
            el.removeChild(item.el)
          })
        }
      }
    }
  }
}
```

```html

<body>
<div id="app"></div>
<script src="renderer.js"></script>
<script>
  // 1.通过 h 函数创建一个 vnode
  const vnode = h('div', { class: 'wangpf', id: 'aaa' }, [
    h('h2', { class: 'title' }, 'hello,I am wangpf'),
    h('div', null, '当前计数：100'),
    h('button', { class: 'btn' }, '+1')
  ])
  
  // 2. 通过 mount 函数， 将 vnode 挂载在div#app上
  mount(vnode, document.querySelector('#app'))
  
  // 3. 创建新的 vnode
  setTimeout(() => {
    const newVnode = h('div', { class: 'pf', id: 'aaa' }, [
      h('h2', { class: 'title' }, 'hello,I am wangpf'),
      h('div', null, '当前计数：0'),
      h('button', { class: 'btn222' }, '-1')
    ])
    patch(vnode, newVnode)
  }, 2000)

</script>
</body>
```

当定时器达到2s后, 新的vnode 会替换掉旧的vnode，通过 ptach 函数来diff出不同的地方进行替换。

大致上这就这样简单的实现一下渲染系统模块，分别有 h函数（返回vnode对象）、mount函数（用于挂载到页面上）、patch函数（对比新旧vnode，更新为最新的）

## 响应式系统模块的实现

响应式模块是vue的重中之重，vue2版本是通过 `Object.defineProperty ` 来进行对数据进行依赖收集劫持的 ， vue3版本是通过 `proxy` 来实现的

#### 为什么使用proxy的原因

[深入响应式原理 — Vue.js (vuejs.org)](https://cn.vuejs.org/v2/guide/reactivity.html#如何追踪变化)

换为 `proxy` 原因在于 `defineProperty ` 这个API虽然兼容性好，但是不能检测到对象和数组的变化，比如对对象的新增属性，我们需要去手动的给该属性收集依赖（通过**$set**）,才能实现响应式。
对于 `proxy`来说, Proxy 是劫持的整个对象，不需要做特殊处理 （我觉得这个为什么换为 proxy 的根本原因）

#### 代码实现思路

雏形的响应式系统： 发布订阅的思想

```js
// 响应式系统模块
class Dep {
  constructor() {
    this.subscribers = new Set()
  }

  addEffect(effect) {
    this.subscribers.add(effect)
  }

  notify() {
    this.subscribers.forEach(effect => {
      effect()
    })
  }
}


const info = { counter: 100 }
const doubleCounter = () => {
  console.log(info.counter * 2)
}

const multiplyCounter = () => {
  console.log(info.counter * info.counter)
}

const dep = new Dep()
dep.addEffect(doubleCounter)
dep.addEffect(multiplyCounter)


setInterval(() => {
  info.counter++
  dep.notify()
}, 2000)
```

上述代码有很多不足之处，只要数据发生变化就得手动去调用。

我们希望数据只要一发生变化，那么就自动的去收集依赖并执行

所以改进了如下：

```js
const dep = new Dep()

const watchEffect = (effect) => {
  dep.addEffect(effect)
}

const info = { counter: 100 }

watchEffect(() => {
  console.log(info.counter * 2)
})
watchEffect(() => {
  console.log(info.counter * info.counter)
})


setInterval(() => {
  info.counter++
  dep.notify()
}, 2000)
```

我就用 watchEffect 来统一管理它， 只不过需要在 watchEffect 函数中执行逻辑。

但这还是有些不足，比如不知道是谁的逻辑，而且并不是自动收集依赖

因此，再次进行改进，如下：

```js
// 响应式系统模块
class Dep {
  constructor() {
    this.subscribers = new Set()
  }

  depend() {
    if (activeEffect) {
      this.subscribers.add(activeEffect)
    }
  }

  notify() {
    this.subscribers.forEach(effect => {
      effect()
    })
  }
}

const dep = new Dep()
let activeEffect = null
const watchEffect = (effect) => {
  activeEffect = effect
  dep.depend()
  activeEffect = null
}

const info = { counter: 100 }

watchEffect(() => {
  console.log(info.counter * 2)
})
watchEffect(() => {
  console.log(info.counter * info.counter)
})


setInterval(() => {
  info.counter++
  dep.notify()
}, 2000)
```

用 depend 来取代替 addEffect ， 这样做的目的是 不需要去知道 subscribers 添加的具体是什么

但是呢， 这样做会使得对 info 整个有依赖， 如果我想监听 info 的某一个属性，所有我们需要有一个数据劫持的方法来实现。

这时候就可以用vue2响应式原理的思想来实现了， 通过 `Object.defineProperty` (Vue2响应式原理的核心)

#### 使用 Object.defineProperty 来实现

```js
// 响应式系统模块
class Dep {
  constructor() {
    this.subscribers = new Set()
  }

  depend() {
    if (activeEffect) {
      this.subscribers.add(activeEffect)
    }
  }

  notify() {
    this.subscribers.forEach(effect => {
      effect()
    })
  }
}

let activeEffect = null
const watchEffect = (effect) => {
  activeEffect = effect
  effect()  //  vue3 中 watchEffect 就会默认执行一次
  activeEffect = null
}


const targetMap = new WeakMap()

const getDep = (target, key) => {
  let depsMap = targetMap.get(target)
  if (!depsMap) {
    depsMap = new Map()
    targetMap.set(target, depsMap)
  }

  let dep = depsMap.get(key)
  if (!dep) {
    dep = new Dep()
    depsMap.set(key, dep)
  }
  return dep
}


// vue2 数据劫持原理
const reactive = (raw) => {
  Object.keys(raw).forEach(key => {
    const dep = getDep(raw, key)
    let value = raw[key];

    Object.defineProperty(raw, key, {
      get() {
        dep.depend()
        return value
      },
      set(newValue) {
        if (value !== newValue) {
          value = newValue
          dep.notify()
        }
      }
    })
  })
  return raw
}
```

实现效果：

```js
const info = reactive({ counter: 100 })

watchEffect(() => {
  console.log(info.counter * 2)
})
watchEffect(() => {
  console.log(info.counter * info.counter)
})

info.counter++

// 70 10000
// 67 202
// 70 10201
```

`defineProperty` 已经说过了，所以我们可以使用`proxy` 对 **reactive 函数**进行重构

#### 使用 Proxy 来实现

```js
// vue3 proxy 数据劫持
const reactive = (raw) => {
  return new Proxy(raw, {
    get(target, p, receiver) {
      const dep = getDep(target, p)
      dep.depend()
      return target[p]
    },
    set(target, p, newValue, receiver) {
      const dep = getDep(target, p)
      target[p] = newValue
      dep.notify()
    }
  })
}
```

### 应用程序入口模块的实现

> 上述已经实现了 渲染系统模块和响应式系统模块，接下来我们就差最后一步了，模仿一下vue3 使用 createApp函数 作为入口 以及mount函数将其挂载到页面上



从框架的层面来说，我们需要有俩部分内容：

- createApp 用于创建一个app对象
- 该app对象有一个 mount 方法，可以将根组件挂载到某一个dom元素上。

```js
const createApp = (rootComponent) => {
  return {
    mount(selector) {
      let isMounted = false
      let preVnode = null

      watchEffect(() => {
        // 首次需要挂载， 后边就 patch
        if (!isMounted) {
          preVnode = rootComponent.render()
          mount(preVnode, document.querySelector(selector))
          isMounted = true
        } else {
          const newVnode = rootComponent.render()
          patch(preVnode, newVnode)
          preVnode = newVnode
        }
      })
    }
  }
}
```

#### 实现效果

```js
  // 1. 创建根组件
const App = {
  data: reactive({
    counter: 0
  }),
  render() {
    return h('div', null, [
      h('h2', null, `计数:${this.data.counter}`),
      h('button', {
        onClick: () => {this.data.counter++}
      }, '+1')
    ])
  }
}

// 2. 挂载根组件
createApp(App).mount('#app')
```

![test1](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/21be39e02a714a96b2f4841610cc8b71~tplv-k3u1fbpfcp-watermark.image)

点击即可完成加一操作！



