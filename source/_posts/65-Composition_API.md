---
title: Vue3|Composition_API （全）总结
index_img: /img/Composition_API.jpg
date: 2021-08-07 18:48:00
tags: [Vue3]
categories: [Vue.js]
---

为了能够使用Composition API, 我们需要有一个可以实际使用它的地方。在vue组件中，我们将此位置称为setup

## setup函数

> setup函数是在组件创建之前执行的，setup函数中的props一旦被解析，就将作为Composition API 的入口



需要注意的是： 我们不能在setup函数中使用this， 因为它不会找到组件实例。 原因是 虽然组件实例是在执行setup之前就会被创建出来了，但是
setup函数被调用之前，data,computed,methods等都没有被解析，所以它们无法在setup中被获取。

### setup接收俩个参数(props,context)

#### props

> 作为setup函数中的第一个参数，props是响应式的，当传入新的prop时，它将会被更新
>
> 其实就是父组件传递过来的属性会被放到props对象中

- 对于定义props的类型，和Vue2一样，在props选项对象中定义
- 在template中的写法依然是不变的
- 因为props有直接作为参数传递到setup函数中，所以我们可以直接通过参数来使用。

```js
export default {
  props: {
    message: {
      type: String,
      default: "hello"
    }
  },
  setup(props) {
    consloe.log(props.message)
  }
}
```

**！！ 由于 `props` 是响应式的， 所以我们不能用 解构，它会消除props的响应性。**

如果需要结构props，那么需要用到 `toRefs`函数来完成操作。

```js
import { toRefs } from 'vue'

setup(props)
{
  const message = toRefs(props, 'message')
  console.log(message.value)
}
```

#### context

> 作为setup函数的第二个参数， context是一个普通的JavaScript对象，它暴露组件的三个property

- **attrs ** ：所有的非prop的attribute
- **slots**  ：父组件传递过来的插槽
- **emit**  ： 当我们组件内部需要发出事件时用到emit， 和vue2中 this.$emit用法一致

**！！由于context只是一个普通的JavaScript对象，所以它不是响应式的，这就意味着我们可以安全地对 `context` 使用 解构**

```js
export default {
  setup(props, { attrs, slots, emit }) {
  ...
  }
}
```

### setup函数的返回值

> 由于setup是一个函数，那么它就会有返回值



如果**setup**的返回值是一个对象，那么该对象的property就可以在模板中访问到。

注意的是：从setup中返回的 `refs`在模板中是会自动浅解包的，所以不必在模板中用 `.value`

## 有关响应性的API

### reactive

> 返回对象的响应式副本



如果想在setup中定义的数据是具有响应式的，那么就可以使用 `reactive`

```js
const state = reactive({ name: 'wangpf', age: 18 })
```

为什么会通过 `reactive` 就可以变成响应式的呢？

- 因为当我们使用**reactvie函数处理我们的数据之后，数据再次被使用时会进行以依赖收集**
- 当数据发生变化时，所有收集到的依赖都是进行对象的响应式的操作
- 事实上，在vue2中，我们编写的 data选项，也是在内部交给了 `reactive`函数将其变成了响应式对象的

注意的俩点：

- `reactive` 将解包所有深层的 refs，同时维持着 ref 的响应性

  ```js
  const count = ref(0)
  const obj = reactive({ count })
  
  // ref 会被解包
  console.log(count.value === obj.value) // true
  
  // 会更新到 'obj.count'
  count.value++ 
  console.log(count.value) // 1
  console.log(obj.count) // 1
  
  // 也会更新到 ref 'count'
  obj.count++
  console.log(count.value) // 2
  console.log(obj,value) // 2
  ```


- 当把 `ref` 分配给 `reactive` 时，将会自动解包

  ```js
  const count = ref(1)
  const obj = reactive({ })
  obj.count = count
  console.log(obj.count) // 1
  console.log(obj.count === count.value) // true
  ```

但是由于 `reactive` 对传入的类型是有限制的，它要求我们必须传入的是一个对象或者数组

如果我们传入的是一个基本的数据类型（String,Number,Boolean）则会报警告.

![reactive的限制.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/87dc49efe45d49cf9a43ead801bb38a4~tplv-k3u1fbpfcp-watermark.image)
这时，我们可以使用另一个API， **ref**

### ref

> 接受一个内部值并返回一个响应式且可变的 ref 对象。 ref对象具有指向内部值的单个property （.vlaue）



ref 会返回一个可变的响应式对象，该对象作为一个响应式的引用（reference） 维护着它内部的值。

内部的值是在 ref的 vlaue属性中被维护的

### readonly

> 我们通过 `reactive` 或者 `ref` 可以获取到一个响应式的对象，但是某些情况下， 我们传入给其他地方（组件） 的这个响应式对象希望在另外一个地方（组件）被使用，**但是不能被修改**，这个时候就可以用 readonly 了



readnoly 会返回原生对象的只读代理 原理在于： 利用 proxy 中的set，在set方法中将其劫持，并且设置该值不能修改

### 关于reactive 判断 的API

#### isProxy

> 检查对象是否由 `reactive` 或 `readonly` 创建的 proxy

```js
const state = reactive({ count: 0 })
const count = 0
isProxy(state) // true
isProxy(readonly(state)) // true
isProxy(count) // false
```

#### isReactive

> 检查对象是否由 `reactive` 创建处理的相应手机代理

但如果代理是由 `readonly`创建的，但包裹了由 `reactive`创建 另一个代理，也会返回 true

```js
const state = reactive({ count: 0 })
isReactive(state) // true
isReactive(readonly(state)) // true
```

#### isReadOnly

> 检查对象是否由 `readonly`创建的只读代理

#### toRaw

> 返回 `reactive 或 readonly 代理的原始对象`  （不建议保留对原始对象的持久化引用，谨慎使用）

#### shallowReactive

shallow（浅层）

> 创建一个响应式代理，他跟踪其自身property的响应性，但不执行嵌套对象的深层响应式转换 （深层还是原生对象）
>
> 类似于浅拷贝，只把第一层转为响应式了，深层还是原始对象

#### shallowReadonly

> 创建一个 proxy ， 使其自身的 property 为只读， 但不执行嵌套对象的深度只读转换
>
> 就是说第一层是只读的，但是深层还是可读，可写的

### toRefs

由于我们使用ES6的解构语法对 reactive 返回的对象进行解构赋值，那么解构后的数据是不具有响应式的

而使用 toRefs 可以将 reative 返回的对象中的属性都转成 ref 这样我们再次解构出来的数据都是 ref的。

```js
const state = reactive({ name: 'wangpf', age: 18 });
const { name, age } = state; // 这样解构出来的数据是没有响应式的

const { name, age } = toRefs(state) // 这样的解构出来的数据转换成了ref的，是响应式的
// 上述的做法， 相当于在 state.name 和 name.value 之间建立了连接， 修改任何一个都会引起另外一个变化
```

### toRef

如果我们希望转换一个 reactive 对象中的属性为 ref ，那么可以使用 toRef 的方法

```js
const state = reactive({ name: 'wangpf', age: 18 });
const name = toRef(state, "name"); // 该 name 是ref的，  
// 同样的， name.value 和 state.name 之间建立了连接， 修改会互相影响
```

### ref其他的API

#### unref

如果想要获取一个ref引用中的value，可以通过 unref 方法：

- 如果参数是一个 ref， 则返回内部值，否则返回参数本事

- 其实是一个语法糖：

    - ```js
  val = isRef(val) ? val.value : val
    ```

```ts
function useFoo(x: number | Ref<number>) {
  const unwrapped = unref(x) // unwrapped 现在一定是数字类型
}
```

#### isRef

> 判断值是否是一个ref对象

### shallowRef

> 创建一个浅层的ref对象

```js
const info = shallowRef({ name: "wangpf" })

const changeInfo = () => {
  info.value.name = 'wpf'  // 此时的修改是不能够实现响应式的
}
```

#### triggerRef

> 手动触发和 shallowRef 相关联的副作用

```js
const info = shallowRef({ name: "wangpf" })

const changeInfo = () => {
  info.value.name = 'wpf'  // 此时的修改是不能够实现响应式的
  // 使用 triggerRef 可以触发
  triggerRef(info)
}
```

#### customRef

> 创建一个自定义的 ref ，并对其依赖项跟踪和更新触发进行显示控制

- 它需要一个工厂函数，该函数接受 track 和 trigger 函数 作为参数
- 应该返回一个带有 get 和 set 的对象

###### 用 customRef 做的一个防抖案例

```js
import { customRef } from "vue";

export default function(value, delay = 300) {
  let timer = null;
  return customRef((track, trigger) => {
    return {
      get() {
        track();
        return value;
      },
      set(newValue) {
        clearTimeout(timer);
        timer = setTimeout(() => {
          value = newValue;
          trigger();
        }, delay);
      },
    };
  });
}

```

```vue

<template>
  <input type="text" v-model="message"/>
  <p>{{ message }}</p>
</template>

<script>
import useDebounceRef from "../hooks/useDebounceRef";

export default {
  name: "Demo2",
  setup() {
    const message = useDebounceRef("hello", 300);
    return {
      message,
    };
  },
};
</script>
```

### computed

> 该API 的方法 和 vue2 的一样， 只不过写的地方是在setup函数中了， 但还需注意的点是 computed 返回的值是一个 ref

- 方式一： 接收一个 getter 函数，并为 getter 函数返回的值，返回一个不变的 ref 对象

```js
    const firstName = ref("wangpf");
const lastName = ref("ok");
const fullName = computed(() => `${firstName.value} ${lastName.value}`)
```

- 方式二 ： 接收一个具有 get 和 set 的对象，返回一个可变的（可读写的）ref对象

```js
    const firstName = ref("wangpf");
const lastName = ref("ok");
const fullName = computed({
  get() {
    return `${firstName.value} ${lastName.value}`;
  },
  set(newValue) {
    const names = newValue.split(" ");
    firstName.value = names[0];
    lastName.value = names[1];
  },
});
const changeName = () => {
  fullName.value = "wpf err";
  console.log(fullName.value);
};
```

### 侦听数据的变化 （watch  watchEffect）

> 在 Composition API 中， 我们可以使用 watchEffect 和 watch 来完成响应式数据的侦听

- watch 需要手动指定侦听的数据源
- watchEffect 用于自动收集响应式数据的依赖

#### watchEffect

[响应式计算和侦听 | Vue.js (vuejs.org)](https://v3.cn.vuejs.org/guide/reactivity-computed-watchers.html#watcheffect)

> 当侦听到某些响应式数据变化时，我们希望执行某些操作，这个时候就可以用 watchEffect



来看一个案例：

```js
const name = ref('wangpf')
const age = ref(18)

watchEffect(() => {
  console.log('watchEffect执行了', name.value, age.value)
})
```

- 通过以上代码，首先 watchEffect 传入的函数会立即被执行一次，并且在执行的过程中会收集依赖
    - （为什么需要立即执行一次的原因就是需要去收集依赖）
- 其次，只有收集的依赖发生变化时，watchEffect 传入的函数才会被执行

##### watchEffect 的停止侦听

- 如果在发生某些情况下，我们希望停止侦听，这个时候我们可以获取 **watchEffect 的返回值函数**， 调用它即可

看一个案例:

```js
const stopWatch = watchEffect(() => {
  console.log('watchEffect执行了', name.value, age.value)
})
const changeAge = () => {
  age.value++;
  if (age.value > 20) {
    stopWatch() // 掉用 watchEffect 的返回值就可以停止侦听了
  }
}
```

##### watchEffect 清除副作用

> 用途： 比如在开发中我们需要在侦听函数中执行网络请求，但是在网络请求还没有达到的时候，我们停止了侦听器，或者侦听器侦听函数被再次执行了，这时我们需要把上一次的网络请求 取消掉， 就可以用到该方法了



看了一个案例：

```js
watchEffect((onInvalidate) => {
  console.log('watchEffect执行了', name.value, age.value)
  const timer = setTimeout(() => {
    console.log('1s后执行的操作')
  }, 1000)
  onInvalidate(() => {
    // 在这里操作一些清除工作
    clearTimeour(timer)
  })
})
```

在上述代码中，我们给 watchEffect 传入的函数被回调时，可以获取到一个参数：**onInvalidate** （该参数是一个函数），可以在这个参数中，执行一些清除工作。

##### watchEffect 的执行时间（刷新时机）

在默认情况下 ， 组件的更新会在 watchEffect （副作用函数） 之前执行

```js
  const title = ref(null);  // 该title 已和 div 标签绑定了
watchEffect(() => {
  console.log(title.value);
});
return { title };
```

![watchEffect 的执行时间.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8596249c110242bdaee05621fb1679e9~tplv-k3u1fbpfcp-watermark.image)
那么，当我们在 watchEffect （副作用函数) 获取元素时， 第一次执行是肯定是个null， 是不可以的。只有当DOM挂载完毕后，才会给 title 赋新的值，watchEffect （副作用函数）才会再次执行， 打印出对应的元素

我们希望第一次就打印出该元素的话，这时候需要给 watchEffect 传入第二个参数， 该参数是一个 对象，对象中的 flush 可取三个值 ：` 'pre' (默认的) ,  'post' , 'async' (不建议使用)`

```js

// 在组件更新后触发，这样你就可以访问更新的 DOM。
// 注意：这也将推迟副作用的初始运行，直到组件的首次渲染完成。
watchEffect(
  () => {
    /* ... */
  },
  {
    flush: 'post' // 在 DOM元素挂载或更新之后执行，  "pre" 立即执行 （默认的）
  }
)
```

#### watch

> watch API 的功能和 vue 2 的 option API 中的 watch 功能一样， 默认情况下， watch 只有当被侦听的源发送改变时才会去回调



与 watchEffect 比较，不同的是：

- watch 是 懒执行副作用
- 更具体地说明了什么状态下应该触发侦听器重新运行
- 可以访问到侦听状态变化前后的值

##### 侦听单个数据源

想要侦听**单个**数据源的话， 有俩种方法： **传入 getter 函数 或 ref 对象**

```js
//  侦听  getter 
const state = reactive({ name: 'wangpf' })
watch(() => state.name, (newVal, oldVal) => {
  /* ... */
})

// 侦听 ref
const name = ref('wamgpf')
watch(name, (newVal, oldVal) => {
  /* ... */
  // 这里的 newVal,oldVal 的值是 是返回的 ref.value 的值
})
```

##### 侦听多个数据源

方法： 传入数组

```js
    const firstName = ref("AAA");
const lastName = ref("bbb");
const changeName = () => {
  firstName.value = "A";
  lastName.value = "b";
};
watch([firstName, lastName], (newVal, oldVal) => {
  console.log("newVal:", newVal, "oldVal:", oldVal);
});
// newVal:  ["A", "b"] oldVal:  ["AAA", "bbb"]
```

##### 侦听响应式对象

就是侦听 reactive 对象

```js
const numbers = reactive([1, 2, 3, 4])

watch(
  () => [...numbers],
  (numbers, prevNumbers) => {
    console.log(numbers, prevNumbers)
  }
)

numbers.push(5) // logs: [1,2,3,4,5] [1,2,3,4]
```

想要深度侦听嵌套对象或数组时，**需要 deep 设为 true**,

```js
const state = reactive({
  id: 1,
  attributes: {
    name: '',
  }
})

watch(
  () => state,
  (state, prevState) => {
    console.log(
      'not deep',
      state.attributes.name,
      prevState.attributes.name
    )
  }
)

watch(
  () => state,
  (state, prevState) => {
    console.log(
      'deep',
      state.attributes.name,
      prevState.attributes.name
    )
  },
  { deep: true }
)

state.attributes.name = 'Alex' // 日志: "deep" "Alex" "Alex"
```

但是会发现 新的值和旧的值是一样的。这时候为了完全侦听，需要使用深拷贝了

## 其他API

### 生命周期函数

em.... 去看文档吧，

[生命周期钩子 | Vue.js (vuejs.org)](https://v3.cn.vuejs.org/guide/composition-api-lifecycle-hooks.html)

### Provide / Inject

> 功能和之前一样，

我们可以通过 provide 来提供数据

- 通过 provide 方法来定义每个 property
- 传入俩个参数： name（提供的属性名称）， value（提供的属性值）

我们可以通过 jnject 来注入需要的内容

- 要 inject 的 property 的 name
- 默认值 (**可选**)

```js
let count = ref(100)
let info = { name: "wangpf", age: 18 }
provide("count", readonly(count))
provide("info", readonly(info))   // 这里建议使用 readonly 对值进行包裹，防止传递的数据不会被 inject 的组件更改

// 在后代组件中 通过 inject 来获取
const count = inject("count")
const info = inject("info")
```

### h函数

> vue在生成真实DOM之前，会将我们的节点转换成VNode，而VNode组合起来会形成一颗树结构，即 **虚拟DOM**
>
> 在 template 中的 html 是使用渲染函数生成的对应的VNode
>
> 如果我们想要利用 JavaScript 来编写 createVNode 函数，生成对应的VNode 那么就可以使用 **h() 函数**



h() 函数是一个用于常见 VNode 的一个函数， 其实更准确的命名是 createVNode() 函数，但为了简便 vue 将其简化为 h() 函数

h() 函数接收三个参数: (标签，属性，后代)

```js
h(
  // {String | Object | Function} tag
  // 一个 HTML 标签名、一个组件、一个异步组件、或
  // 一个函数式组件。
  //
  // 必需的。
  'div',

  // {Object} props
  // 与 attribute、prop 和事件相对应的对象。
  // 我们会在模板中使用。
  //
  // 可选的。
  {},

  // {String | Array | Object} children
  // 子 VNodes, 使用 `h()` 构建,
  // 或使用字符串获取 "文本 Vnode" 或者
  // 有插槽的对象。
  //
  // 可选的。
  [
    'Some text comes first.',
    h('h1', 'A headline'),
    h(MyComponent, {
      someProp: 'foobar'
    })
  ]
)
```

注意：如果没有props，可以将 children 作为第二个参数传入， 但是会产生歧义，所以一般会将 null 作为第二个参数传入，将 children 作为第三个参数传入

#### h函数的基本使用

- 可以在 render 函数选项中使用
- 可以在 setup 函数选项中使用

```js
export default {
  render() {
    return h('div', { class: 'app' }, 'hello app')
  }
}

export default {
  setup() {
    return () => h('div', { class: 'app' }, 'hello app')
  }
}
```

这样写代码，不仅慢而且阅读性一般， 所以 推荐使用 jsx， 语法和 react一样， 这里不细说了。可看文档

[jsx | Vue.js (vuejs.org)](https://v3.cn.vuejs.org/guide/render-function.html#jsx)

### 自定义指令

[自定义指令 | Vue.js (vuejs.org)](https://v3.cn.vuejs.org/guide/custom-directive.html#简介)

> 在 Vue 中，代码复用和抽象的主要形式是组件。然而，有的情况下，你仍然需要对普通 DOM 元素进行底层操作，这时候就会用到自定义指令。



自定义指令分为俩种：

- 自定义局部指令： 组件中通过 directives 选项，只能在当前组件中使用。
- 自定义全局指令： app的 directive 方法， 可以在任意组件中被使用。

#### 指令的生命周期

一个指令定义的对象，Vue提供了如下的几个钩子函数：

- created：在绑定元素的 attribute 或事件监听器被应用之前调用；
- beforeMount：当指令第一次绑定到元素并且在挂载父组件之前调用；
- mounted：在绑定元素的父组件被挂载后调用；
- beforeUpdate：在更新包含组件的 VNode 之前调用；
- updated：在包含组件的 VNode 及其子组件的 VNode 更新后调用；
- beforeUnmount：在卸载绑定元素的父组件之前调用；
- unmounted：当指令与元素解除绑定且父组件已卸载时，只调用一次

这几个钩子函数中可传入四个参数：`el`、`binding`、`vnode` 和 `prevNnode`

#### 案例：时间格式化的指令

![时间格式化的指令.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dcce4da1d46a42638efad0e8ea7bf3ea~tplv-k3u1fbpfcp-watermark.image)

### Teleport

[Teleport | Vue.js (vuejs.org)](https://v3.cn.vuejs.org/guide/teleport.html)

> 瞬移组件， 可以将该组件转移到其他dom元素上。
>
> 通常用于 封装模态框、土司之类的，将它放在Body元素上和 div#app 元素平级

#### 俩个属性

1. **to：**  指定将其中的内容移动到的目标元素，可以使用选择器
2. **disabled：** 是否禁用 teleport 的功能

```js
<
teleport :to = '#demo' >
  < h2 > hello < /h2>
</teleport>

// 该元素就会被转移到 id 为 demo 元素上
```

### Vue插件

[插件 | Vue.js (vuejs.org)](https://v3.cn.vuejs.org/guide/plugins.html#插件)



> 通常情况下，我们向Vue全局去添加一些功能时，会采用插件的模式

#### 俩种编写方式

1. 对象类型
    - 一个 **对象**，但是必须包含一个 `install` 的函数，**该函数会在安装插件时执行**
2. 函数类型
    - 一个 **function**，这个函数会在 **安装插件时自动执行**

```js
// plugin_obect.js
export default {
  install(app) {
    app.config.globalProperties.$name = "wangpf";
  },
};

// main.js
import plugin_object from "./plugins/plugin_object";

app.use(plugin_object);

// app.vue 
import { getCurrentInstance } from "vue";

setup()
{
  const Instance = getCurrentInstance();
  console.log("Instance", Instance.appContext.config.globalProperties.$name);
}
```


