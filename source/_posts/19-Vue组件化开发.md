---
title: Vue组件化开发
date: 2020-09-25 16:10:47
index_img: /img/vue.jpg
tags: vue
categories: vue
---
# 组件化开发 ⭐

## 1. Vue 组件化思想⭐

- 组件化是Vuejs中的重要思想
  - 它提供了一种抽象，让我们可以开发出一个个独立可复用的小组件来构造我们的应用。
  - 任何的应用都会被抽象成一颗组件树

![Component Tree](https://lipengzhou.com/vuejs/base/assets/components.png)

- 组件化思想的应用：
  - 有了组件化的思想，我们在之后的开发中就要充分的利用它。
  - 尽可能的将页面拆分成一个个小的，可复用的组件。
  - 这样让我们的代码更加方便组织和管理，并且扩展性也更强。



## 2.注册组件的基本步骤⭐

- 组件的使用分为三个步骤:
  - 创建组件构造器
  - 注册组件
  - 使用组件

![image-20200920165211013](https://i.loli.net/2020/09/25/FOCykHGvwR6TJns.png)

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>

<body>

  <div id="app">
    <!-- 3. 使用组件 -->
    <cpn></cpn>
    <cpn></cpn>
    <cpn></cpn>
    <cpn></cpn>
  </div>
</body>
<script src="../js/vue.js"></script>
<script>
  // 1. 创建组件构造器对象
  const cpn = Vue.extend({
    template: `    
    <div>
      <h2>注册组件步骤解析</h2>
      <p> 1. Vue.extend():  调用 Vue.extend() 创建的是一个组件构造器  通常在组件构造器时，传入template代表我们自定义组件的模板
     该模板就是在使用组件的地方，要显示的HTML代码</p>
      <p>2.Vue.component(): 调用Vue.component()是将干柴的组件构造器注册为一个组件，并且给它起一个组件的标签名称，所以需要传递俩
      个参数：1、注册组件的标签名，2、组件构造器</p>
      <p>3. 组件必须挂载在某个Vue实例下，否则它不会生效。</p>
    </div>`
  })
  // 2. 注册组件  方法一
  // Vue.component('cpn', cpn)

  const app = new Vue({
    el: '#app',
    data: {
      message: 'hello vue',
    },
    // 2.注册组件 方法二
    components: {
      cpn
    }
  })
</script>

</html>
```





### 2.1 注册组件步骤解析

- **Vue.extend()**:     调用 Vue.extend() 创建的是一个组件构造器  通常在组件构造器时，传入template代表我们自定义组件的模板

  该模板就是在使用组件的地方，要显示的HTML代码

- **Vue.component()**:     调用Vue.component()是将干柴的组件构造器注册为一个组件，并且给它起一个组件的标签名称，所以需要传递俩个参数： 

  - **1、注册组件的标签名，**
  - **2、组件构造器**

  - **组件必须挂载在某个Vue实例下，否则它不会生效**



### 2.2 组件注册方式：全局组件  、局部组件

组件注册有俩种方式：

- 全局组件
  - ​	定义在全局，在任意组件中都可以直接使用
- 局部组件
  - 定义在组件内部，只能在当前组件中使用

建议把通用的组件定义在全局，把不通用的组件定义在局部



#### 全局组件

注册：

```html
Vue.component("my-component", {
  template: "<div>A custom component!</div>"
});

// 创建根实例
new Vue({
  el: "#example"
});
```

在模板中使用组件：

```html
<div id="example">
  <my-component></my-component>
</div>
```

渲染结果：

```html
<div id="example">
  <div>A custom component!</div>
</div>
```



> **总结：** 
>
> - 可以在任何组件中被使用的组件（就好比全局变量）
> - 如果应用中把所有组件都定义成全局组件，名字就不能有冲突
> - 使用场景：多个页面都需要使用的组件建议定义成全局组件





#### 局部组件

你不必把每个组件都注册到全局，你可以通过某个Vue实例/组件的实例选项 `components` 注册仅在其作用域中可用的组件：

注册：

```javascript
new Vue({
  // ...
  components: {
    // <my-component> 将只在父组件模板中可用
    "my-component": {
      template: "<div>A custom component!</div>"
    }
  }
});
```

使用：

```html
<div id="example">
  <div>A custom component!</div>
  <my-component></my-component>
</div>

```



总结：

- 只能在它的父组件（定义所属的组件）中被使用，不会污染全局（就好比函数内部定义的变量）
- 使用组件的时候，会先在自己的 `components` 中找，如果找不到，**直奔全局找**
- 局部组件 **只能** 在父组件中被使用， 爷爷、后代。。都不行
- 使用场景：不需要在其他组件中被使用的组件建议定义成局部



##  3.组件中的模板⭐

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>

<body>
  <div id="app">
    <cpn></cpn>
  </div>

  <!-- 1. 使用 script 标签 ， 类型必须是 text/x-template -->
  <!-- <script type="text/x-template" id="cpn">
    <div>
     <h2>组件模板的分离写法</h2>
     <p>哈哈哈哈</p>
    </div>
</script> -->

  <!-- 2. 使用 template 标签 -->
  <template id="cpn">
    <div>
      <h2>{{title}}</h2>
      <p>哈哈哈哈</p>
    </div>
  </template>
</body>
<script src="../js/vue.js"></script>
<script>
  Vue.component('cpn', {
    template: '#cpn',
    data() {
      return {
        title: '组件模板的分离写法'
      }
    }
  })
  const app = new Vue({
    el: '#app',
    data: {
      message: 'hello vue',
    }
  })
</script>

</html>
```



小结：

- 字符串模板 `template`
  - 优点：合适快速学习测试，方便快捷
  - 缺点：编辑器无法提供高亮显示，智能提示等
- .vue 单文件组件
  - 优点：更好的语法高亮，智能提示等
  - 缺点：需要配合打包工具使用
- script 标签模板（了解，不常用）



## 4.组件中的data为什么必须是一个函数？⭐

- 首先，如果不是一个函数，Vue直接就会报错。
- 其次，原因是在于Vue让每个组件对象都会返回一个新的对象，因为如果是同一个对象的，组件在多次使用后会相互影响。

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>

<body>
  <div id="app">
    <cpn></cpn>
    <cpn></cpn>
    <cpn></cpn>
  </div>
</body>

<template id="cpn">
  <div>
    <h2>当前计数：{{current}}</h2>
    <button @click="add">+</button>
    <button @click="sub">-</button>
    <p>
      如果data是一个函数的话，这样每复用一次组件，就会返回一份新的data，
      类似于给每个组件实例创建一个私有的数据空间，让各个组件实例维护各自的数据。
      而单纯的写成对象形式，就使得所有组件实例共用了一份data，就会造成一个变了全都会变的结果。
    </p>
  </div>
</template>
<script src="../js/vue.js"></script>
<script>
  // const obj = {
  //   current: 0
  // }
  Vue.component('cpn', {
    template: '#cpn',
    data() {
      // return obj
      return {
        current: 0
      }
    },
    methods: {
      add() {
        this.current++
      },
      sub() {
        this.current--
      }
    }
  })
  const app = new Vue({
    el: '#app',
    data: {
      message: 'hello vue',
    }
  })
</script>

</html>
```



### 

## 5.组件通信⭐

组件就像零散的积木，我们需要把这些积木按照一定的规则拼装起来，而且要让它们互相之间能进行通讯，这样才能构成一个有机的完整系统。

在真实的应用中，组件最终会构成树形结构，就像人类社会中的家族树一样：

![891636a0-af23-11e7-b111-4d6e630f480d.png](https://lipengzhou.com/vuejs/base/assets/891636a0-af23-11e7-b111-4d6e630f480d.png)

在树形结构里面，组件之间有几种典型的关系：父子关系、兄弟关系、没有直接关系。

相应地，组件之间有以下几种典型的通讯方案：

- 直接的父子关系 **(访问双方对象里面的一些方法)**
  - 父组件通过 `this.$refs` 访问子组件
  - 子组件通过 `this.$parent` 访问父组件
- 直接父子关系 **（获取双方里面的数据）**
  - 父组件通过Props 给子组件下发数据
  - 子组件通过事件方式给父组件发送消息
- 没有直接关系
  - 简单场景：借助于事件机制进行通讯
  - 复杂场景：使用状态管理容器
- 利用 cookie 和  localstorage 进行通讯
- 利用 session 进行通讯



**无论你使用什么前端框架，组件之间的通讯都离不开以上几种方案，这些方案与具体框架无关**



### 5.1 父传子



组件设计初衷就是要配合使用的，最常见的就是形成父子组件的关系：组件 A 在它的模板中使用了组件 B。它们之间必然需要相互通信：父组件可能要给子组件下发数据，子组件则可能要将它内部发生的事情告知父组件。然而，通过一个良好定义的接口来尽可能将父子组件解耦也是很重要的。这保证了每个组件的代码可以在相对隔离的环境中书写和理解，从而提高了其可维护性和复用性。



在 Vue 中，父子组件的关系可以总结为 prop 向下传递，事件向上传递。父组件通过 prop 给子组件下发数据，子组件通过事件给父组件发送消息。看看它们是怎么工作的。

![image-20200920201644685](https://i.loli.net/2020/09/25/fG3CE72y6FaexDu.png)



#### 5.1.1 props 的基本使用

- **子组件 用 props 来接收 父组件传来的数据**

- 在组件中，使用选项props来声明需要从父级接受到的数据
- props 的值有俩种方式
  - 方式一：字符串数组，数组中的字符串就是传递时的名称
  - 方式二: 对象，对象可以设置传递

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>

<body>
  <div id="app">
    <cpn :cmessage="message" :ccities="cities"></cpn>
  </div>

  <template id="cpn">
    <div>
      <h2>{{ccities}}</h2>
      <h1>{{cmessage}}</h1>
      <P v-for="item in ccities">{{item}}</P>
    </div>
  </template>
</body>
<script src="../js/vue.js"></script>
<script>
  const cpn = {
    template: '#cpn',
    // props: ['ccities', 'cmessage']  // 1. 数组形式来传值
    props: {
      // 2. 对象形式   
      // 2.1 类型限制
      // cmessage: String,
      // ccities: Array

      // 2.2 提供一些默认值， 以及传值
      cmessage: {
        type: String,
        default: '默认值aa',
      },
      // 类型对象如果是一个 数组或者对象时， 默认值必须是一个函数
      ccities: {
        type: Array,
        default () {
          return ['初始1', '初始2', '初始3']
        },
      }
    }
  }
  const app = new Vue({
    el: '#app',
    data: {
      message: 'hello vue',
      cities: ['北京', '上海', '深圳']
    },
    components: {
      cpn
    }
  })
</script>

</html>
```



#### 5.1.2  props数据验证

- 我们可以为组件的 prop 指定验证规则。如果传入的数据不符合要求，Vue 会发出警告。这对于开发给他人使用的组件非常有用。 要指定验证规则，需要用对象的形式来定义 prop，而不能用字符串数组：
- 当需要对props进行类型等验证时，就需要对象写法了
- 验证都支持哪些数据类型呢？
  - String
  - Number
  - Boolean
  - Array
  - Object
  - Date
  - Function
  - Symbol
- 当我们有自定义构造函数时，验证也支持自定义的类型

```javascript
Vue.component("example", {
  props: {
    // 基础类型检测 (`null` 指允许任何类型)
    propA: Number,
    // 可能是多种类型
    propB: [String, Number],
    // 必传且是字符串
    propC: {
      type: String,
      required: true
    },
    // 数值且有默认值
    propD: {
      type: Number,
      default: 100
    },
    // 数组/对象的默认值应当由一个工厂函数返回
    propE: {
      type: Object,
      default: function() {
        return { message: "hello" };
      }
    },
    // 自定义验证函数
    propF: {
      validator: function(value) {
        return value > 10;
      }
    }
  }
});
```



### 5.2  子传父

#### 5.2.1 使用 自定义事件 来完成  $emit

- props 用于父组件向子组件传递数据，还有一种比较常见的是子组件传递数据或事件到父组件中。
- 这个时候，我们需要用 `自定义事件` 来完成
- 什么时候需要自定义事件呢？
  - 当子组件需要向父组件传递数据时，就要用自定义事件了
  - 我们之前学习的 v-on 不仅仅可以用于监听DOM事件，也可以用于组件的自定义事件
- 自定义事件的流程：
  - 在子组件中，通过 $emit() 来触发事件。
  - 在父组件中，通过 v-on 来监听子组件事件。

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>

<body>
  <!-- 父组件模板 -->
  <div id="app">
    <!--  自定义事件 -->
    <cpn @itemclick="cpnClick"></cpn>
  </div>

  <!-- 子组件模板 -->
  <template id="cpn">
    <div>
      <button v-for="item in categories" @click='btnClick(item)'>{{item.name}}</button>
    </div>
  </template>
</body>
<script src="../js/vue.js"></script>
<script>
  // 子组件
  const cpn = {
    template: '#cpn',
    data() {
      return {
        categories: [{
            id: 1,
            name: '热门推荐'
          },
          {
            id: 2,
            name: '数码相机'
          },
          {
            id: 3,
            name: '电脑办公'
          },
          {
            id: 4,
            name: '家用电器'
          },
        ]
      }
    },
    methods: {
      btnClick(item) {
        // 发射事件，自定义事件   ()
        this.$emit('itemclick', item)
      }
    }
  }

  // 父组件
  const app = new Vue({
    el: '#app',
    data: {
      message: 'hello vue',
    },
    components: {
      cpn
    },
    methods: {
      cpnClick(item) {
        console.log('cpnClick', item);
      }
    }
  })
</script>

</html>
```





**子组件： 向 父组件用 $emit 发射一个自定义事件** 

```javascript
methods: {
      btnClick(item) {
        // 发射事件，自定义事件   ()
        this.$emit('itemclick', item)
      }
    }
```

**父组件模板 ：  用v-on来监听子组件**

```html
  <div id="app">
    <!--  自定义事件 -->
    <cpn @itemclick="cpnClick"></cpn>
  </div>
```



**父组件 :  在父组件模板中用 v-on来监听子组件事件 然后 用自定义的事件来获取子组件的数据**

```javascript
 methods: {
      cpnClick(item) {
        console.log('cpnClick', item);
      }
    }
```





### 5.3  父子组件通信-结合双向绑定案例

- 以下案例 实现 子传父 父传子 以及 上边的值 是下边的 100倍

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>

<body>
  <div id="app">
    <cpn v-bind:number1="num1" v-bind:number2="num2" @num1change='num1change' @num2change='num2change'></cpn>
  </div>

  <template id="cpn">
    <div>
      <h1>props:{{number1}}</h1>
      <h1>data:{{dnumber1}}</h1>
      <!-- <input type="text" v-model="dnumber1"> -->
      <input type="text" :vlaue="dnumber1" @input="num1Input">

      <h1>props:{{number2}}</h1>
      <h1>data:{{dnumber2}}</h1>
      <!-- <input type="text" v-model="dnumber2"> -->
      <input type="text" :vlaue="dnumber2" @input="num2Input">

    </div>
  </template>
</body>
<script src="../js/vue.js"></script>
<script>
  const app = new Vue({
    el: '#app',
    data: {
      num1: 0,
      num2: 0
    },
    methods: {
      num1change(value) {
        this.num1 = Number(value)
      },
      num2change(value) {
        this.num2 = Number(value)

      }
    },
    components: {
      cpn: {
        template: '#cpn',
        props: {
          number1: Number,
          number2: Number
        },
        data() {
          return {
            dnumber1: this.number1,
            dnumber2: this.number2
          }
        },
        methods: {
          num1Input(event) {
            // 1.将input中的 value赋值到dnumber中
            this.dnumber1 = event.target.value

            // 2. 为了让父组件可以修改值，发出一个事件
            this.$emit('num1change', this.dnumber1)

            // 3. 影响 dnumber2的值， 
            this.dnumber2 = this.dnumber1 * 100
            this.$emit('num2change', this.dnumber2)

          },
          num2Input(event) {
            this.dnumber2 = event.target.value
            this.$emit('num2change', this.dnumber2)

            this.dnumber1 = this.dnumber2 / 100
            this.$emit('num1change', this.dnumber1)
          }
        }
      }
    }
  })
</script>

</html>
```



### 5.4 父子组件的访问

- 有时候我们需要父组件直接访问子组件，子组件直接访问父组件，或者是子组件访问跟组件。
  - 父组件访问子组件：使用$children或$refs
  - 子组件访问父组件：使用$parent

#### 5.4.1  $children

- this.$children是一个数组类型，它包含所有子组件对象。
- 我们这里通过一个遍历，取出所有子组件的message状态。

![image-20200920230955986](https://i.loli.net/2020/09/25/A7mroRbg8aMWUHf.png)







- **$children的缺陷：**
  - 通过$children访问子组件时，是一个数组类型，访问其中的子组件**必须通过索引值。**
  - 但是当子组件过多，我们需要拿到其中一个时，**往往不能确定它的索引值**，甚至还可能会发生变化。
  - 有时候，我们想明确获取其中一个特定的组件，这个时候就可以使用**$refs**



#### 5.4.2 $refs

- $refs的使用：
  - $refs和ref指令通常是一起使用的。
  - 首先，我们通过ref给某一个子组件绑定一个特定的ID。
  - 其次，通过this.$refs.ID就可以访问到该组件了。

![image-20200920231328554](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20200920231328554.png)

